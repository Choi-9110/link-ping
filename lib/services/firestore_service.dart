import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../data/models/user_profile.dart';
import '../data/models/user_stats.dart';
import '../data/models/ping_notification.dart';
import '../data/models/saved_by_user.dart';
import '../data/models/shared_link.dart';
import '../data/models/inquiry.dart';
import '../data/models/modification_request.dart';
import '../data/models/announcement.dart';
import '../data/models/recommended_link.dart';
import '../data/models/link_reminder.dart';
import 'auth_service.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._();
  FirestoreService._();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// 컬렉션 참조
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // urlStats 컬렉션 제거 - sharedLinks 기반으로 변경됨

  CollectionReference<Map<String, dynamic>> get _notificationsCollection =>
      _firestore.collection('notifications');

  CollectionReference<Map<String, dynamic>> get _sharedLinksCollection =>
      _firestore.collection('sharedLinks');

  CollectionReference<Map<String, dynamic>> get _inquiriesCollection =>
      _firestore.collection('inquiries');

  CollectionReference<Map<String, dynamic>>
  get _modificationRequestsCollection =>
      _firestore.collection('modificationRequests');

  CollectionReference<Map<String, dynamic>> get _analyticsCollection =>
      _firestore.collection('analytics');

  CollectionReference<Map<String, dynamic>> get _recommendedLinksCollection =>
      _firestore.collection('recommendedLinks');

  CollectionReference<Map<String, dynamic>> get _announcementsCollection =>
      _firestore.collection('announcements');

  // ==================== 공지사항 ====================

  /// 활성화된 공지사항 가져오기 (최신순)
  Future<List<Announcement>> getAnnouncements() async {
    try {
      final snapshot = await _announcementsCollection
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Announcement.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Failed to fetch announcements: $e');
      return [];
    }
  }

  // ==================== 추천 링크 ====================

  /// 활성화된 추천 링크 가져오기
  Future<List<RecommendedLink>> getRecommendedLinks() async {
    try {
      final snapshot = await _recommendedLinksCollection
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => RecommendedLink.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Failed to fetch recommended links: $e');
      return [];
    }
  }

  // ==================== 사용자 프로필 ====================

  /// 사용자 프로필 저장/업데이트
  Future<void> saveUserProfile(UserProfile profile) async {
    await _usersCollection
        .doc(profile.uid)
        .set(profile.toFirestore(), SetOptions(merge: true));
  }

  /// 사용자 프로필 가져오기
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromFirestore(doc);
  }

  /// 사용자 프로필 스트림 (실시간 업데이트)
  Stream<UserProfile?> userProfileStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc);
    });
  }

  // ==================== 링크 클라우드 백업 (프리미엄 전용) ====================
  // users/{uid}/links/{linkId} 에 사용자 링크를 백업한다.
  // 호출 측(LinksNotifier)에서 프리미엄 여부를 먼저 거른다.

  CollectionReference<Map<String, dynamic>>? _userLinksCollection() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _usersCollection.doc(uid).collection('links');
  }

  /// 링크 1건 백업(업서트)
  Future<void> backupLink(LinkReminder link) async {
    final col = _userLinksCollection();
    if (col == null) return;
    await col.doc(link.id).set(link.toMap(), SetOptions(merge: true));
  }

  /// 백업된 링크 1건 삭제
  Future<void> deleteBackupLink(String linkId) async {
    final col = _userLinksCollection();
    if (col == null) return;
    await col.doc(linkId).delete();
  }

  /// 여러 링크 일괄 백업 (구독 직후 초기 업로드 등)
  Future<void> backupAllLinks(List<LinkReminder> links) async {
    final col = _userLinksCollection();
    if (col == null || links.isEmpty) return;
    final batch = _firestore.batch();
    for (final link in links) {
      batch.set(col.doc(link.id), link.toMap(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  /// 클라우드에 백업된 링크 전체 가져오기 (새 기기 복원용)
  Future<List<LinkReminder>> fetchBackupLinks() async {
    final col = _userLinksCollection();
    if (col == null) return [];
    final snapshot = await col.get();
    return snapshot.docs
        .map((doc) {
          try {
            return LinkReminder.fromMap(doc.data());
          } catch (_) {
            return null;
          }
        })
        .whereType<LinkReminder>()
        .toList();
  }

  /// 현재 로그인 사용자의 관리자 권한 확인
  Future<bool> isCurrentUserAdmin() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    try {
      final doc = await _usersCollection.doc(uid).get();
      if (!doc.exists) return false;
      return doc.data()?['isAdmin'] == true;
    } catch (_) {
      return false;
    }
  }

  /// 닉네임 중복 검사
  Future<bool> isNicknameDuplicate(String nickname) async {
    try {
      final query = await _usersCollection
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      debugPrint('닉네임 중복 검사 에러: $e');
      return false; // 에러 시 중복 아님으로 처리
    }
  }

  /// 프리미엄 상태 토글 (개발자용)
  Future<void> togglePremium(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) return;

    final currentPremium = doc.data()?['isPremium'] ?? false;
    await _usersCollection.doc(uid).update({
      'isPremium': !currentPremium,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 프리미엄 상태 설정 (인앱 결제용)
  Future<void> setPremiumStatus({
    required bool isPremium,
    String? productId,
    String? purchaseToken,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _usersCollection.doc(uid).update({
      'isPremium': isPremium,
      'premiumProductId': productId,
      'premiumPurchaseToken': purchaseToken,
      'premiumUpdatedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== URL 통계 (소셜 기능) ====================

  /// 현재 유저 닉네임 가져오기 (게스트/회원 모두 지원)
  Future<String> _getCurrentNickname() async {
    final user = _auth.currentUser;
    if (user == null) return '익명';

    // 게스트인 경우 로컬에서 닉네임 가져오기
    if (user.isAnonymous) {
      return AuthService.instance.getGuestNickname();
    }

    // 회원인 경우 Firestore에서 가져오기
    final profile = await getUserProfile(user.uid);
    return profile?.nickname ?? '익명';
  }

  /// 현재 유저 이모지 가져오기 (게스트/회원 모두 지원)
  Future<String> _getCurrentEmoji() async {
    final user = _auth.currentUser;
    if (user == null) return 'face_grinning';

    // 게스트인 경우 로컬에서 이모지 가져오기
    if (user.isAnonymous) {
      return AuthService.instance.getGuestEmoji();
    }

    // 회원인 경우 Firestore에서 가져오기
    final profile = await getUserProfile(user.uid);
    return profile?.profileEmoji ?? 'face_grinning';
  }

  /// 현재 유저 국가 가져오기 (게스트/회원 모두 지원)
  Future<String?> _getCurrentCountry() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    // 게스트인 경우 국가 정보 없음
    if (user.isAnonymous) {
      return null;
    }

    // 회원인 경우 Firestore에서 가져오기
    final profile = await getUserProfile(user.uid);
    return profile?.country;
  }

  /// 공유 링크 저장 시 카운트 증가 + 유저 정보 추가 (sharedLinkId 기반)
  Future<void> incrementSharedLinkSaveCount(String sharedLinkId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final nickname = await _getCurrentNickname();
    final emoji = await _getCurrentEmoji();
    final country = await _getCurrentCountry();

    final docRef = _sharedLinksCollection.doc(sharedLinkId);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) return;

      final savedByUser = {
        'uid': user.uid,
        'nickname': nickname,
        'profileEmoji': emoji,
        if (country != null) 'country': country,
      };

      final currentCount = doc.data()?['saveCount'] ?? 0;
      final savedBy = List<Map<String, dynamic>>.from(
        doc.data()?['savedBy'] ?? [],
      );

      final alreadySaved = savedBy.any((u) => u['uid'] == user.uid);
      if (!alreadySaved) {
        savedBy.add(savedByUser);
        transaction.update(docRef, {
          'saveCount': currentCount + 1,
          'savedBy': savedBy,
          'savedByUids': FieldValue.arrayUnion([user.uid]),
        });
      }
    });
  }

  /// 공유 링크 삭제 시 카운트 감소 + 유저 정보 제거 (sharedLinkId 기반)
  Future<void> decrementSharedLinkSaveCount(String sharedLinkId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _sharedLinksCollection.doc(sharedLinkId);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) return;

      final currentCount = doc.data()?['saveCount'] ?? 0;
      final savedBy = List<Map<String, dynamic>>.from(
        doc.data()?['savedBy'] ?? [],
      );

      savedBy.removeWhere((u) => u['uid'] == user.uid);

      transaction.update(docRef, {
        'saveCount': currentCount > 0 ? currentCount - 1 : 0,
        'savedBy': savedBy,
        'savedByUids': FieldValue.arrayRemove([user.uid]),
      });
    });
  }

  /// 공유 링크 저장 수 스트림 (실시간, sharedLinkId 기반)
  Stream<int> sharedLinkSaveCountStream(String sharedLinkId) {
    return _sharedLinksCollection.doc(sharedLinkId).snapshots().map((doc) {
      if (!doc.exists) return 0;
      return doc.data()?['saveCount'] ?? 0;
    });
  }

  /// 공유 링크를 저장한 유저 목록 스트림 (실시간, sharedLinkId 기반)
  Stream<List<SavedByUser>> sharedLinkSavedByUsersStream(String sharedLinkId) {
    return _sharedLinksCollection.doc(sharedLinkId).snapshots().map((doc) {
      if (!doc.exists) return [];
      final savedBy = List<Map<String, dynamic>>.from(
        doc.data()?['savedBy'] ?? [],
      );
      return savedBy.map((data) => SavedByUser.fromMap(data)).toList();
    });
  }

  /// 유저 프로필 정보 업데이트 (닉네임/이모지/국가 변경 시 모든 savedBy에 반영)
  Future<void> updateUserProfileInSavedBy({
    required String nickname,
    required String emoji,
    String? country,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 이 유저가 저장한 모든 공유 링크 찾기
      final querySnapshot = await _sharedLinksCollection
          .where('savedByUids', arrayContains: user.uid)
          .get();

      final docsToUpdate = <({DocumentReference ref, List<Map<String, dynamic>> savedBy})>[];

      for (final doc in querySnapshot.docs) {
        final savedBy = List<Map<String, dynamic>>.from(
          doc.data()['savedBy'] ?? [],
        );
        final userIndex = savedBy.indexWhere((u) => u['uid'] == user.uid);

        if (userIndex != -1) {
          savedBy[userIndex] = {
            'uid': user.uid,
            'nickname': nickname,
            'profileEmoji': emoji,
            if (country != null) 'country': country,
          };
          docsToUpdate.add((ref: doc.reference, savedBy: savedBy));
        }
      }

      const batchLimit = 450;
      for (var i = 0; i < docsToUpdate.length; i += batchLimit) {
        final chunk = docsToUpdate.skip(i).take(batchLimit);
        final batch = _firestore.batch();
        for (final item in chunk) {
          batch.update(item.ref, {'savedBy': item.savedBy});
        }
        await batch.commit();
      }
    } catch (e) {
      // 에러 무시 (프로필 저장은 성공, savedBy 업데이트만 실패)
    }
  }

  // ==================== 알림 (응원/약올리기) ====================

  /// 알림 보내기
  Future<void> sendPing({
    required String toUid,
    required PingType type,
    required String urlTitle,
    String? customMessage,
    int? messageIndex,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final fromNickname = await _getCurrentNickname();

    // 메시지 선택
    final message =
        customMessage ??
        (type == PingType.cheer
            ? PingMessages.getRandomCheerMessage()
            : PingMessages.getRandomTeaseMessage());

    final notification = PingNotification(
      id: '', // Firestore가 자동 생성
      type: type,
      fromUid: user.uid,
      fromNickname: fromNickname,
      urlTitle: urlTitle,
      message: message,
      createdAt: DateTime.now(),
      messageIndex: messageIndex,
    );

    await _notificationsCollection
        .doc(toUid)
        .collection('items')
        .add(notification.toFirestore());

    // 받는 사람의 통계 업데이트 (Social Butterfly 배지용)
    final statsField = type == PingType.cheer
        ? 'cheersReceived'
        : 'pokesReceived';
    await _firestore.collection('userStats').doc(toUid).set({
      statsField: FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  /// 내 알림 목록 스트림
  Stream<List<PingNotification>> myNotificationsStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _notificationsCollection
        .doc(user.uid)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => PingNotification.fromFirestore(doc))
              .toList();
        });
  }

  /// 읽지 않은 알림 수 스트림
  Stream<int> unreadNotificationCountStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(0);

    return _notificationsCollection
        .doc(user.uid)
        .collection('items')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// 알림 읽음 처리
  Future<void> markNotificationAsRead(String notificationId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _notificationsCollection
        .doc(user.uid)
        .collection('items')
        .doc(notificationId)
        .update({'isRead': true});
  }

  /// 모든 알림 읽음 처리
  Future<void> markAllNotificationsAsRead() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final batch = _firestore.batch();
    final snapshots = await _notificationsCollection
        .doc(user.uid)
        .collection('items')
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in snapshots.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  // ==================== 공유 링크 ====================

  /// 공유 링크 생성
  Future<String> createSharedLink({
    required String url,
    required String title,
    required int hour,
    required int minute,
    required List<int> repeatDays,
    bool isLocked = false,
    String languageCode = 'en', // 공유자의 언어 코드
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('로그인이 필요합니다');

    final nickname = await _getCurrentNickname();

    final docRef = _sharedLinksCollection.doc();
    final sharedLink = SharedLink(
      id: docRef.id,
      url: url,
      title: title,
      hour: hour,
      minute: minute,
      repeatDays: repeatDays,
      sharedBy: nickname,
      creatorUid: user.uid,
      createdAt: DateTime.now(),
      isLocked: isLocked,
      languageCode: languageCode,
    );

    await docRef.set(sharedLink.toJson());

    return docRef.id;
  }

  /// 공유 링크 저장 기록 (누가 저장했는지 추적)
  Future<void> recordSharedLinkSave(String sharedLinkId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _sharedLinksCollection.doc(sharedLinkId).update({
        'savedByUids': FieldValue.arrayUnion([user.uid]),
      });
    } catch (e) {
      // 문서가 없으면 무시
    }
  }

  /// 고정 알람 삭제 알림 보내기
  Future<void> sendLockedLinkDeletedNotification({
    required String sharedLinkId,
    required String linkTitle,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final nickname = await _getCurrentNickname();

    // 공유 링크 정보 가져오기
    final sharedLink = await getSharedLink(sharedLinkId);
    if (sharedLink == null) return;

    // 저장한 사람들에게 알림 보내기
    for (final uid in sharedLink.savedByUids) {
      if (uid == user.uid) continue; // 자기 자신 제외

      final notificationRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc();

      await notificationRef.set({
        'type': 'link_deleted',
        'fromUid': user.uid,
        'fromNickname': nickname,
        'urlTitle': linkTitle,
        'message': '$nickname deleted the shared alarm.\n"$linkTitle" has been removed.',
        'sharedLinkId': sharedLinkId,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    }
  }

  /// 공유 링크 가져오기
  Future<SharedLink?> getSharedLink(String shareId) async {
    try {
      final doc = await _sharedLinksCollection.doc(shareId).get();
      if (!doc.exists) return null;
      return SharedLink.fromJson(doc.data()!);
    } catch (e) {
      debugPrint('공유 링크 조회 에러: $e');
      return null;
    }
  }

  /// 공유 링크 조회수 증가
  Future<void> incrementShareViewCount(String shareId) async {
    try {
      await _sharedLinksCollection.doc(shareId).update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('조회수 증가 에러: $e');
    }
  }

  // ==================== 수정 요청 (투표 시스템) ====================

  /// 고정 알람 수정 요청 생성
  Future<String> createModificationRequest({
    required String sharedLinkId,
    required String linkTitle,
    required int originalHour,
    required int originalMinute,
    required List<int> originalRepeatDays,
    required int newHour,
    required int newMinute,
    required List<int> newRepeatDays,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('로그인이 필요합니다');

    final nickname = await _getCurrentNickname();

    // 공유 링크 정보 가져오기
    final sharedLink = await getSharedLink(sharedLinkId);
    if (sharedLink == null) throw Exception('공유 링크를 찾을 수 없습니다');

    // 투표 대상자 = 저장한 사람들 (자기 자신 제외)
    final voterUids = sharedLink.savedByUids
        .where((uid) => uid != user.uid)
        .toList();
    if (voterUids.isEmpty) throw Exception('수정 요청을 보낼 대상이 없습니다');

    // 투표 초기화 (모두 pending)
    final votes = <String, String>{};
    for (final uid in voterUids) {
      votes[uid] = 'pending';
    }

    final now = DateTime.now();
    final docRef = _modificationRequestsCollection.doc();

    final request = ModificationRequest(
      id: docRef.id,
      sharedLinkId: sharedLinkId,
      creatorUid: user.uid,
      creatorNickname: nickname,
      linkTitle: linkTitle,
      originalHour: originalHour,
      originalMinute: originalMinute,
      originalRepeatDays: originalRepeatDays,
      newHour: newHour,
      newMinute: newMinute,
      newRepeatDays: newRepeatDays,
      createdAt: now,
      expiresAt: now.add(const Duration(hours: 24)),
      votes: votes,
      voterUids: voterUids,
    );

    await docRef.set(request.toFirestore());

    // 투표 대상자들에게 알림 보내기
    for (final uid in voterUids) {
      final notificationRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc();

      await notificationRef.set({
        'type': 'modification_request',
        'fromUid': user.uid,
        'fromNickname': nickname,
        'urlTitle': linkTitle,
        'message':
            '$nickname requested a time change for "$linkTitle".\n${request.timeChangeString}',
        'modificationRequestId': docRef.id,
        'sharedLinkId': sharedLinkId,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    }

    return docRef.id;
  }

  /// 수정 요청 가져오기
  Future<ModificationRequest?> getModificationRequest(String requestId) async {
    try {
      final doc = await _modificationRequestsCollection.doc(requestId).get();
      if (!doc.exists) return null;
      return ModificationRequest.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  /// 수정 요청에 투표하기
  Future<void> voteOnModificationRequest({
    required String requestId,
    required bool approve,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final request = await getModificationRequest(requestId);
    if (request == null) return;

    // 이미 만료됐으면 투표 불가
    if (request.isExpired) return;

    // 투표 대상자인지 확인
    if (!request.voterUids.contains(user.uid)) return;

    // 투표 업데이트
    await _modificationRequestsCollection.doc(requestId).update({
      'votes.${user.uid}': approve ? 'approved' : 'rejected',
    });

    // 투표 완료 여부 확인 및 처리
    await _checkAndProcessModificationRequest(requestId);
  }

  /// 수정 요청 결과 확인 및 처리
  Future<void> _checkAndProcessModificationRequest(String requestId) async {
    final request = await getModificationRequest(requestId);
    if (request == null) return;
    if (request.status != ModificationStatus.pending) return;

    // 모든 투표가 완료되었거나 만료됐는지 확인
    final allVoted = request.pendingCount == 0;
    final isExpired = request.isExpired;

    if (!allVoted && !isExpired) return;

    // 결과 판정
    final isApproved = request.isApprovalReached;
    final newStatus = isExpired && !allVoted
        ? ModificationStatus.expired
        : (isApproved
              ? ModificationStatus.approved
              : ModificationStatus.rejected);

    // 상태 업데이트
    await _modificationRequestsCollection.doc(requestId).update({
      'status': newStatus == ModificationStatus.approved
          ? 'approved'
          : (newStatus == ModificationStatus.rejected ? 'rejected' : 'expired'),
    });

    // 결과에 따른 알림 전송
    await _sendModificationResultNotifications(request, newStatus);
  }

  /// 수정 요청 결과 알림 전송
  Future<void> _sendModificationResultNotifications(
    ModificationRequest request,
    ModificationStatus status,
  ) async {
    final creatorNickname = request.creatorNickname;
    final linkTitle = request.linkTitle;

    if (status == ModificationStatus.approved) {
      // 승인됨 - 만든 사람에게 알림
      await _sendNotificationToUser(
        toUid: request.creatorUid,
        type: 'modification_approved',
        fromNickname: 'Linkku',
        urlTitle: linkTitle,
        message:
            '"$linkTitle" 수정 요청이 승인되었어요! (${request.approvedCount}/${request.respondedCount} 승인)',
        sharedLinkId: request.sharedLinkId,
      );

      // 거절한 사람들 - 알람 OFF 알림
      for (final entry in request.votes.entries) {
        if (entry.value == 'rejected') {
          await _sendNotificationToUser(
            toUid: entry.key,
            type: 'modification_applied',
            fromNickname: creatorNickname,
            urlTitle: linkTitle,
            message: '"$linkTitle" time has been changed.\nYou rejected, so the alarm is turned OFF.',
            sharedLinkId: request.sharedLinkId,
          );
        }
      }

      // 무응답자 처리 (만료 시)
      if (request.status == ModificationStatus.expired) {
        for (final entry in request.votes.entries) {
          if (entry.value == 'pending') {
            await _sendNotificationToUser(
              toUid: entry.key,
              type: 'modification_applied',
              fromNickname: creatorNickname,
              urlTitle: linkTitle,
              message: '"$linkTitle" time has been changed.\nNo response, so the alarm is turned OFF.',
              sharedLinkId: request.sharedLinkId,
            );
          }
        }
      }

      // SharedLink 업데이트
      await _sharedLinksCollection.doc(request.sharedLinkId).update({
        'hour': request.newHour,
        'minute': request.newMinute,
        'repeatDays': request.newRepeatDays,
      });
    } else {
      // 거부됨 - 만든 사람에게 알림
      await _sendNotificationToUser(
        toUid: request.creatorUid,
        type: 'modification_rejected',
        fromNickname: 'Linkku',
        urlTitle: linkTitle,
        message:
            '"$linkTitle" 수정 요청이 거부되었어요. (${request.approvedCount}/${request.respondedCount} 승인)',
        sharedLinkId: request.sharedLinkId,
      );
    }
  }

  /// 특정 사용자에게 알림 보내기 (내부용)
  Future<void> _sendNotificationToUser({
    required String toUid,
    required String type,
    required String fromNickname,
    required String urlTitle,
    required String message,
    String? sharedLinkId,
    String? modificationRequestId,
  }) async {
    final notificationRef = _firestore
        .collection('users')
        .doc(toUid)
        .collection('notifications')
        .doc();

    await notificationRef.set({
      'type': type,
      'fromUid': _auth.currentUser?.uid ?? '',
      'fromNickname': fromNickname,
      'urlTitle': urlTitle,
      'message': message,
      if (sharedLinkId != null) 'sharedLinkId': sharedLinkId,
      if (modificationRequestId != null)
        'modificationRequestId': modificationRequestId,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  /// 만료된 수정 요청 처리 (앱 시작 시 호출)
  Future<void> processExpiredModificationRequests() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 내가 투표 대상인 만료된 요청 찾기
      final querySnapshot = await _modificationRequestsCollection
          .where('status', isEqualTo: 'pending')
          .get();

      for (final doc in querySnapshot.docs) {
        final request = ModificationRequest.fromFirestore(doc);

        // 만료됐고 내가 관련된 경우 처리
        if (request.isExpired &&
            (request.voterUids.contains(user.uid) ||
                request.creatorUid == user.uid)) {
          await _checkAndProcessModificationRequest(doc.id);
        }
      }
    } catch (e) {
      // 오류 무시
    }
  }

  // ==================== 문의하기 ====================

  /// 문의 생성
  Future<String> createInquiry({
    required String title,
    required String content,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('로그인이 필요합니다');

    final nickname = await _getCurrentNickname();

    final docRef = await _inquiriesCollection.add({
      'userId': user.uid,
      'userNickname': nickname,
      'title': title,
      'content': content,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'adminReply': null,
      'repliedAt': null,
    });

    return docRef.id;
  }

  /// 내 문의 목록 가져오기
  Stream<List<Inquiry>> myInquiriesStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _inquiriesCollection
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => Inquiry.fromFirestore(doc))
              .toList();
          // 클라이언트에서 정렬 (인덱스 없이도 동작)
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  /// 문의 상세 가져오기
  Future<Inquiry?> getInquiry(String inquiryId) async {
    try {
      final doc = await _inquiriesCollection.doc(inquiryId).get();
      if (!doc.exists) return null;
      return Inquiry.fromFirestore(doc);
    } catch (e) {
      debugPrint('문의 조회 에러: $e');
      return null;
    }
  }

  /// 문의 상세 스트림 (실시간)
  Stream<Inquiry?> inquiryStream(String inquiryId) {
    return _inquiriesCollection.doc(inquiryId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Inquiry.fromFirestore(doc);
    });
  }

  // ==================== 관리자 기능 ====================

  /// [관리자] 모든 문의 목록 가져오기
  Stream<List<Inquiry>> allInquiriesStream({String? statusFilter}) {
    Query<Map<String, dynamic>> query = _inquiriesCollection.orderBy(
      'createdAt',
      descending: true,
    );

    if (statusFilter != null) {
      query = query.where('status', isEqualTo: statusFilter);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Inquiry.fromFirestore(doc)).toList();
    });
  }

  /// [관리자] 문의 답변하기
  Future<void> replyToInquiry({
    required String inquiryId,
    required String reply,
  }) async {
    await _inquiriesCollection.doc(inquiryId).update({
      'adminReply': reply,
      'status': 'answered',
      'repliedAt': FieldValue.serverTimestamp(),
    });

    // 사용자에게 알림 보내기
    final inquiry = await getInquiry(inquiryId);
    if (inquiry != null) {
      await _notificationsCollection
          .doc(inquiry.userId)
          .collection('items')
          .add({
            'type': 'inquiry_reply',
            'inquiryId': inquiryId,
            'inquiryTitle': inquiry.title,
            'message': 'Your inquiry has been answered.',
            'createdAt': FieldValue.serverTimestamp(),
            'isRead': false,
          });
    }
  }

  // ==================== 추천(Referral) 시스템 ====================

  /// 사용자의 추천 코드 생성/가져오기
  /// 추천 코드는 uid의 앞 8자리를 사용
  String generateReferralCode(String uid) {
    return uid.substring(0, 8).toUpperCase();
  }

  /// 추천 코드로 추천인 UID 찾기
  Future<String?> findReferrerByCode(String referralCode) async {
    try {
      // uid가 해당 코드로 시작하는 유저 찾기
      final querySnapshot = await _usersCollection.get();

      for (final doc in querySnapshot.docs) {
        final uid = doc.id;
        if (generateReferralCode(uid) == referralCode.toUpperCase()) {
          return uid;
        }
      }
      return null;
    } catch (e) {
      debugPrint('추천인 찾기 에러: $e');
      return null;
    }
  }

  /// 추천인에게 보너스 링크 지급
  /// 최대 1개까지만 지급
  Future<bool> grantBonusLinkToReferrer(String referrerUid) async {
    try {
      final docRef = _usersCollection.doc(referrerUid);

      return await _firestore.runTransaction<bool>((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) return false;

        final currentBonus = doc.data()?['bonusLinks'] ?? 0;
        const maxBonus = 1; // AppConstants.maxBonusLinks

        if (currentBonus >= maxBonus) {
          return false; // 이미 최대 보너스 획득
        }

        transaction.update(docRef, {
          'bonusLinks': currentBonus + 1,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        return true;
      });
    } catch (e) {
      debugPrint('보너스 지급 에러: $e');
      return false;
    }
  }

  /// 새 유저 가입 시 추천인 처리
  /// 1번째 추천 → 보너스 링크 +1, 2번째+ → 포링 +5
  Future<void> processReferral({
    required String newUserUid,
    required String referralCode,
  }) async {
    final referrerUid = await findReferrerByCode(referralCode);
    if (referrerUid == null) return;

    // 자기 자신 추천 방지
    if (referrerUid == newUserUid) return;

    // 새 유저에게 추천인 정보 저장 + 추천 횟수를 원자적으로 확인
    await _usersCollection.doc(newUserUid).update({'referredBy': referrerUid});

    // 추천 횟수를 조회 (update 후이므로 이 유저 포함)
    final referralCount = await getReferralCount(referrerUid);

    final nickname = await _getCurrentNickname();

    if (referralCount <= 1) {
      // 첫 추천 → 보너스 링크 +1
      final granted = await grantBonusLinkToReferrer(referrerUid);
      if (granted) {
        await _notificationsCollection
            .doc(referrerUid)
            .collection('items')
            .add({
              'type': 'referral_accepted',
              'fromUid': newUserUid,
              'fromNickname': nickname,
              'urlTitle': '',
              'message': '$nickname accepted your invite! Bonus link +1',
              'createdAt': FieldValue.serverTimestamp(),
              'isRead': false,
            });
      }
    } else {
      // 2번째+ 추천 → 포링 +5
      await addPendingPoringReward(referrerUid, 5);
      await _notificationsCollection.doc(referrerUid).collection('items').add({
        'type': 'referral_accepted',
        'fromUid': newUserUid,
        'fromNickname': nickname,
        'urlTitle': '',
        'message': '$nickname accepted your invite! Poring +5',
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    }
  }

  /// 추천 보상 포링 추가 (Firestore에 임시 저장)
  Future<void> addPendingPoringReward(String uid, int amount) async {
    await _usersCollection.doc(uid).update({
      'pendingPoringReward': FieldValue.increment(amount),
    });
  }

  /// 대기 중인 포링 보상 수령 (Firestore → 로컬)
  /// 반환: 수령한 포링 수 (0이면 대기 없음)
  Future<int> claimPendingPoringReward() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 0;

    try {
      final doc = await _usersCollection.doc(uid).get();
      if (!doc.exists) return 0;

      final pending = doc.data()?['pendingPoringReward'] ?? 0;
      if (pending <= 0) return 0;

      // Firestore에서 0으로 리셋
      await _usersCollection.doc(uid).update({'pendingPoringReward': 0});

      return pending as int;
    } catch (e) {
      return 0;
    }
  }

  /// 사용자의 추천 통계 가져오기
  Future<int> getReferralCount(String uid) async {
    try {
      final querySnapshot = await _usersCollection
          .where('referredBy', isEqualTo: uid)
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  // ==================== 사운드 선택 통계 ====================

  /// 사운드 선택 기록
  /// soundId: 선택된 사운드 ID
  /// category: 'alarm' 또는 'notify'
  /// isPremium: 프리미엄 사운드 여부
  Future<void> logSoundSelection({
    required String soundId,
    required String category,
    required bool isPremium,
  }) async {
    final user = _auth.currentUser;

    try {
      // 1. 전체 통계 업데이트 (soundStats/{soundId})
      final soundStatsRef = _analyticsCollection
          .doc('soundStats')
          .collection('sounds')
          .doc(soundId);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(soundStatsRef);

        if (doc.exists) {
          transaction.update(soundStatsRef, {
            'selectCount': FieldValue.increment(1),
            'lastSelectedAt': FieldValue.serverTimestamp(),
          });
        } else {
          transaction.set(soundStatsRef, {
            'soundId': soundId,
            'category': category,
            'isPremium': isPremium,
            'selectCount': 1,
            'createdAt': FieldValue.serverTimestamp(),
            'lastSelectedAt': FieldValue.serverTimestamp(),
          });
        }
      });

      // 2. 일별 통계 기록 (soundStats/daily/{date}/{soundId})
      final today = DateTime.now();
      final dateStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final dailyStatsRef = _analyticsCollection
          .doc('soundStats')
          .collection('daily')
          .doc(dateStr)
          .collection('sounds')
          .doc(soundId);

      await dailyStatsRef.set({
        'soundId': soundId,
        'category': category,
        'isPremium': isPremium,
        'count': FieldValue.increment(1),
      }, SetOptions(merge: true));

      // 3. 사용자별 선택 기록 (선택사항 - 로그인 유저만)
      if (user != null && !user.isAnonymous) {
        await _usersCollection.doc(user.uid).update({
          'selectedSoundId': soundId,
          'selectedSoundCategory': category,
          'soundSelectedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // 통계 기록 실패는 무시 (앱 기능에 영향 없음)
    }
  }

  /// 사운드 통계 가져오기 (관리자용)
  Future<List<Map<String, dynamic>>> getSoundStats() async {
    try {
      final snapshot = await _analyticsCollection
          .doc('soundStats')
          .collection('sounds')
          .orderBy('selectCount', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => {'soundId': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 특정 기간 사운드 통계 가져오기 (관리자용)
  Future<Map<String, int>> getSoundStatsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final stats = <String, int>{};

      // 날짜 범위 내 모든 일별 데이터 조회
      DateTime current = startDate;
      while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
        final dateStr =
            '${current.year}-${current.month.toString().padLeft(2, '0')}-${current.day.toString().padLeft(2, '0')}';

        final snapshot = await _analyticsCollection
            .doc('soundStats')
            .collection('daily')
            .doc(dateStr)
            .collection('sounds')
            .get();

        for (final doc in snapshot.docs) {
          final soundId = doc.id;
          final count = doc.data()['count'] as int? ?? 0;
          stats[soundId] = (stats[soundId] ?? 0) + count;
        }

        current = current.add(const Duration(days: 1));
      }

      return stats;
    } catch (e) {
      return {};
    }
  }

  /// 사용률 낮은 사운드 목록 (관리자용 - 삭제 후보)
  Future<List<String>> getLowUsageSounds({int threshold = 10}) async {
    try {
      final snapshot = await _analyticsCollection
          .doc('soundStats')
          .collection('sounds')
          .where('selectCount', isLessThan: threshold)
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      return [];
    }
  }

  /// 카테고리별 사운드 사용 비율 (관리자용)
  Future<Map<String, int>> getSoundUsageByCategory() async {
    try {
      final stats = await getSoundStats();

      final categoryUsage = <String, int>{'alarm': 0, 'notify': 0};

      for (final stat in stats) {
        final category = stat['category'] as String? ?? 'alarm';
        final count = stat['selectCount'] as int? ?? 0;
        categoryUsage[category] = (categoryUsage[category] ?? 0) + count;
      }

      return categoryUsage;
    } catch (e) {
      return {'alarm': 0, 'notify': 0};
    }
  }

  // ==================== 사용자 통계 대시보드 ====================

  /// 사용자 통계 문서 참조
  DocumentReference<Map<String, dynamic>> _userStatsDoc(String uid) =>
      _usersCollection.doc(uid).collection('stats').doc('dashboard');

  /// 사용자 통계 가져오기
  Future<UserStats> getUserStats(String uid) async {
    try {
      final doc = await _userStatsDoc(uid).get();
      return UserStats.fromFirestore(doc);
    } catch (e) {
      return const UserStats();
    }
  }

  /// 사용자 통계 스트림
  Stream<UserStats> userStatsStream(String uid) {
    return _userStatsDoc(uid).snapshots().map((doc) {
      return UserStats.fromFirestore(doc);
    });
  }

  /// 링크 생성 시 통계 업데이트
  /// [category] 카테고리 (exercise, study, contact, selfDev, other)
  /// [soundId] 선택한 소리 ID
  /// [hour] 알림 시간 (0-23)
  /// [weekdays] 반복 요일 리스트 (0=일, 1=월, ..., 6=토)
  Future<void> trackLinkCreated({
    required String? category,
    required String? soundId,
    required int hour,
    required List<int> weekdays,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final updates = <String, dynamic>{
        'totalLinksCreated': FieldValue.increment(1),
        'lastActiveAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // 카테고리 카운트
      if (category != null) {
        updates['categoryCount.$category'] = FieldValue.increment(1);
      }

      // 소리 사용 카운트
      if (soundId != null) {
        updates['soundUsageCount.$soundId'] = FieldValue.increment(1);
      }

      // 요일별 카운트
      for (final day in weekdays) {
        updates['weekdayCount.$day'] = FieldValue.increment(1);
      }

      await _userStatsDoc(uid).set(updates, SetOptions(merge: true));
    } catch (e) {
      // 통계 실패는 무시 (핵심 기능 아님)
    }
  }

  /// 알림 클릭 시 통계 업데이트
  /// [hour] 클릭한 시간 (0-23)
  Future<void> trackNotificationClicked({required int hour}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _userStatsDoc(uid).set({
        'totalNotificationsClicked': FieldValue.increment(1),
        'hourlyClickCount.$hour': FieldValue.increment(1),
        'lastActiveAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // 통계 실패는 무시
    }
  }

  /// 알림 발송 시 통계 업데이트 (백그라운드에서 호출)
  Future<void> trackNotificationSent() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _userStatsDoc(uid).set({
        'totalNotificationsSent': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // 통계 실패는 무시
    }
  }

  /// 소리 변경 시 통계 업데이트
  Future<void> trackSoundChanged({required String soundId}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _userStatsDoc(uid).set({
        'soundUsageCount.$soundId': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // 통계 실패는 무시
    }
  }
}
