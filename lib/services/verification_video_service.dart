import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../data/models/verification_video.dart';

/// 인증 영상 관련 Firestore + Storage 로직.
class VerificationVideoService {
  static final VerificationVideoService instance =
      VerificationVideoService._();
  VerificationVideoService._();

  static const Duration retention = Duration(days: 7);

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('verificationVideos');

  CollectionReference<Map<String, dynamic>> _userBlocksCollection(
          String uid) =>
      _firestore.collection('users').doc(uid).collection('blockedUsers');

  /// 영상 업로드 + 메타데이터 저장.
  /// 반환: 저장된 VerificationVideo
  Future<VerificationVideo> uploadVerification({
    required File videoFile,
    File? thumbnailFile,
    required String uploaderNickname,
    required String uploaderProfileEmoji,
    required int resolution,
    String? sharedLinkId,
    int durationSeconds = 3,
    void Function(double progress)? onProgress,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('Not signed in');
    }

    final id = _uuid.v4();
    final storagePath = 'verifications/$uid/$id.mp4';

    // 1. Storage 업로드
    final storageRef = _storage.ref().child(storagePath);
    final metadata = SettableMetadata(
      contentType: 'video/mp4',
      customMetadata: {
        'uploaderUid': uid,
        if (sharedLinkId != null) 'sharedLinkId': sharedLinkId,
      },
    );
    final uploadTask = storageRef.putFile(videoFile, metadata);
    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((snapshot) {
        if (snapshot.totalBytes > 0) {
          onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
        }
      });
    }
    final snapshot = await uploadTask;
    final videoUrl = await snapshot.ref.getDownloadURL();

    // 2. 썸네일 업로드 (선택)
    String? thumbnailUrl;
    if (thumbnailFile != null && await thumbnailFile.exists()) {
      try {
        final thumbRef = _storage.ref().child(
              'verifications/$uid/${id}_thumb.jpg',
            );
        final thumbSnap = await thumbRef.putFile(
          thumbnailFile,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        thumbnailUrl = await thumbSnap.ref.getDownloadURL();
      } catch (e) {
        debugPrint('Thumbnail upload failed (continuing): $e');
      }
    }

    // 2-1. 릴레이 링 노출 범위 계산용 rootShareId 파생
    //      (공유 문서에서 읽음 — 호출부 5곳에 일일이 흘려보내지 않기 위함)
    String? rootShareId;
    if (sharedLinkId != null) {
      try {
        final shareDoc =
            await _firestore.collection('sharedLinks').doc(sharedLinkId).get();
        rootShareId =
            shareDoc.data()?['rootShareId'] as String? ?? sharedLinkId;
      } catch (_) {
        rootShareId = sharedLinkId;
      }
    }

    // 3. Firestore 메타데이터 저장
    final now = DateTime.now();
    final video = VerificationVideo(
      id: id,
      uploaderUid: uid,
      uploaderNickname: uploaderNickname,
      uploaderProfileEmoji: uploaderProfileEmoji,
      sharedLinkId: sharedLinkId,
      rootShareId: rootShareId,
      storagePath: storagePath,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      durationSeconds: durationSeconds,
      resolution: resolution,
      createdAt: now,
      expiresAt: now.add(retention),
    );
    await _collection.doc(id).set(video.toFirestore());

    // 같은 링크에 내가 올린 이전 인증은 정리 (재인증 = 최신 1개로 교체, 중복 누적 방지).
    // 새 영상 저장이 끝난 뒤에 지워서, 실패해도 기존 영상이 사라지지 않게 함.
    if (sharedLinkId != null) {
      await _deleteMyPreviousVerifications(
        uid: uid,
        sharedLinkId: sharedLinkId,
        exceptId: id,
      );
    }
    return video;
  }

  /// 같은 sharedLinkId 에 내가 올린 다른(이전) 인증 영상을 모두 삭제.
  /// 재인증 시 "내 인증은 항상 최신 1개"를 보장한다.
  Future<void> _deleteMyPreviousVerifications({
    required String uid,
    required String sharedLinkId,
    required String exceptId,
  }) async {
    try {
      // equality 두 개라 별도 복합 인덱스 없이 동작 (orderBy 미사용).
      final snapshot = await _collection
          .where('uploaderUid', isEqualTo: uid)
          .where('sharedLinkId', isEqualTo: sharedLinkId)
          .get();
      for (final doc in snapshot.docs) {
        if (doc.id == exceptId) continue;
        final old = VerificationVideo.fromFirestore(doc);
        try {
          await _storage.ref().child(old.storagePath).delete();
        } catch (_) {}
        if (old.thumbnailUrl != null) {
          try {
            await _storage
                .ref()
                .child(old.storagePath.replaceFirst('.mp4', '_thumb.jpg'))
                .delete();
          } catch (_) {}
        }
        try {
          await doc.reference.delete();
        } catch (_) {}
      }
    } catch (e) {
      // 정리 실패는 치명적이지 않음 (새 영상은 이미 저장됨).
      debugPrint('Failed to clean previous verifications: $e');
    }
  }

  /// 특정 공유 링크의 인증 영상 목록 (만료/숨김/차단된 영상은 제외).
  Future<List<VerificationVideo>> getVideosForSharedLink(
      String sharedLinkId) async {
    try {
      final snapshot = await _collection
          .where('sharedLinkId', isEqualTo: sharedLinkId)
          .where('isHidden', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      final blockedUids = await _getBlockedUids();
      final now = DateTime.now();

      return snapshot.docs
          .map(VerificationVideo.fromFirestore)
          .where((v) => !v.isExpired || v.expiresAt.isAfter(now))
          .where((v) => !blockedUids.contains(v.uploaderUid))
          .toList();
    } catch (e) {
      debugPrint('Failed to fetch verification videos: $e');
      return [];
    }
  }

  /// 릴레이 링: 같은 체인(rootShareId)의 인증 중 **내 이웃(peer)** 것만.
  /// peer = 나에게 공유해준 고리 + 내가 공유한 고리의 참여자들.
  Future<List<VerificationVideo>> getVideosForChain({
    required String rootShareId,
    required Set<String> peerUids,
  }) async {
    try {
      final snapshot = await _collection
          .where('rootShareId', isEqualTo: rootShareId)
          .where('isHidden', isEqualTo: false)
          .limit(100)
          .get();

      final blockedUids = await _getBlockedUids();
      final now = DateTime.now();

      final list = snapshot.docs
          .map(VerificationVideo.fromFirestore)
          .where((v) => peerUids.contains(v.uploaderUid))
          .where((v) => v.expiresAt.isAfter(now))
          .where((v) => !blockedUids.contains(v.uploaderUid))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      debugPrint('Failed to fetch chain verification videos: $e');
      return [];
    }
  }

  /// 내 인증 영상 목록 (본인 화면용).
  Future<List<VerificationVideo>> getMyVideos() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final snapshot = await _collection
        .where('uploaderUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();
    return snapshot.docs.map(VerificationVideo.fromFirestore).toList();
  }

  /// 단일 영상 가져오기.
  Future<VerificationVideo?> getVideo(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return VerificationVideo.fromFirestore(doc);
  }

  /// 시청 기록 (본인이면 카운트만 올리고 viewedBy에는 안 넣음).
  Future<void> recordView(VerificationVideo video) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    if (uid == video.uploaderUid) return; // 본인 영상은 카운트 안 함
    if (video.viewedByUids.contains(uid)) return; // 이미 시청

    await _collection.doc(video.id).update({
      'viewCount': FieldValue.increment(1),
      'viewedByUids': FieldValue.arrayUnion([uid]),
    });
  }

  /// 영상 삭제 (본인만 가능). Storage 파일 + Firestore 메타데이터.
  Future<void> deleteVideo(VerificationVideo video) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid != video.uploaderUid) {
      throw StateError('Not the uploader');
    }
    try {
      await _storage.ref().child(video.storagePath).delete();
    } catch (e) {
      // 이미 삭제된 경우 무시
      debugPrint('Storage delete skipped: $e');
    }
    if (video.thumbnailUrl != null) {
      try {
        await _storage
            .ref()
            .child(video.storagePath.replaceFirst('.mp4', '_thumb.jpg'))
            .delete();
      } catch (_) {}
    }
    await _collection.doc(video.id).delete();
  }

  /// 영상 신고. 신고 누적이 임계치(5)에 도달하면 자동 숨김.
  static const int autoHideThreshold = 5;

  Future<void> reportVideo({
    required VerificationVideo video,
    required VerificationReportReason reason,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('Not signed in');
    if (uid == video.uploaderUid) return; // 본인 영상은 신고 불가
    if (video.reportedByUids.contains(uid)) return; // 중복 신고 방지

    final newReportedBy = [...video.reportedByUids, uid];
    final shouldHide = newReportedBy.length >= autoHideThreshold;

    // 별도 reports 컬렉션에 사유 기록 (관리자 검토용)
    await _firestore
        .collection('verificationVideos')
        .doc(video.id)
        .collection('reports')
        .add({
      'reporterUid': uid,
      'reason': reason.firestoreKey,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _collection.doc(video.id).update({
      'reportedByUids': FieldValue.arrayUnion([uid]),
      if (shouldHide) 'isHidden': true,
    });
  }

  /// 유저 차단 (해당 유저 영상이 내 피드에서 안 보이게 됨).
  Future<void> blockUser({
    required String targetUid,
    String targetNickname = '',
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('Not signed in');
    if (uid == targetUid) return;

    await _userBlocksCollection(uid).doc(targetUid).set({
      'blockedAt': FieldValue.serverTimestamp(),
      if (targetNickname.isNotEmpty) 'nickname': targetNickname,
    });
  }

  /// 차단 해제.
  Future<void> unblockUser(String targetUid) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _userBlocksCollection(uid).doc(targetUid).delete();
  }

  /// 차단한 유저 목록.
  Future<List<BlockedUser>> getBlockedUsers() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final snapshot = await _userBlocksCollection(uid).get();
    return snapshot.docs
        .map((doc) => BlockedUser(
              uid: doc.id,
              nickname: doc.data()['nickname'] as String? ?? '',
              blockedAt:
                  (doc.data()['blockedAt'] as Timestamp?)?.toDate() ??
                      DateTime.now(),
            ))
        .toList();
  }

  Future<Set<String>> _getBlockedUids() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const {};
    final snapshot = await _userBlocksCollection(uid).get();
    return snapshot.docs.map((d) => d.id).toSet();
  }
}

class BlockedUser {
  final String uid;
  final String nickname;
  final DateTime blockedAt;

  BlockedUser({
    required this.uid,
    required this.nickname,
    required this.blockedAt,
  });
}
