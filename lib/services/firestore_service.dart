import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/models/user_profile.dart';
import '../data/models/ping_notification.dart';
import '../data/models/saved_by_user.dart';
import '../data/models/shared_link.dart';
import 'auth_service.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._();
  FirestoreService._();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// 컬렉션 참조
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _urlStatsCollection =>
      _firestore.collection('urlStats');

  CollectionReference<Map<String, dynamic>> get _notificationsCollection =>
      _firestore.collection('notifications');

  CollectionReference<Map<String, dynamic>> get _sharedLinksCollection =>
      _firestore.collection('sharedLinks');

  // ==================== 사용자 프로필 ====================

  /// 사용자 프로필 저장/업데이트
  Future<void> saveUserProfile(UserProfile profile) async {
    await _usersCollection.doc(profile.uid).set(
          profile.toFirestore(),
          SetOptions(merge: true),
        );
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

  /// 닉네임 중복 검사
  Future<bool> isNicknameDuplicate(String nickname) async {
    try {
      final query = await _usersCollection
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      print('닉네임 중복 검사 에러: $e');
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

  /// URL 저장 시 카운트 증가 + 유저 정보 추가
  Future<void> incrementUrlSaveCount(String urlHash) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // 현재 유저 닉네임 가져오기
    final nickname = await _getCurrentNickname();

    final docRef = _urlStatsCollection.doc(urlHash);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);

      final savedByUser = {'uid': user.uid, 'nickname': nickname};

      if (doc.exists) {
        final currentCount = doc.data()?['saveCount'] ?? 0;
        final savedBy = List<Map<String, dynamic>>.from(doc.data()?['savedBy'] ?? []);

        // 이미 저장한 유저인지 확인
        final alreadySaved = savedBy.any((u) => u['uid'] == user.uid);
        if (!alreadySaved) {
          savedBy.add(savedByUser);
          transaction.update(docRef, {
            'saveCount': currentCount + 1,
            'savedBy': savedBy,
          });
        }
      } else {
        transaction.set(docRef, {
          'saveCount': 1,
          'savedBy': [savedByUser],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  /// URL 삭제 시 카운트 감소 + 유저 정보 제거
  Future<void> decrementUrlSaveCount(String urlHash) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _urlStatsCollection.doc(urlHash);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);

      if (doc.exists) {
        final currentCount = doc.data()?['saveCount'] ?? 0;
        final savedBy = List<Map<String, dynamic>>.from(doc.data()?['savedBy'] ?? []);

        // 해당 유저 제거
        savedBy.removeWhere((u) => u['uid'] == user.uid);

        if (currentCount > 1) {
          transaction.update(docRef, {
            'saveCount': currentCount - 1,
            'savedBy': savedBy,
          });
        } else {
          transaction.delete(docRef);
        }
      }
    });
  }

  /// URL 저장 수 가져오기
  Future<int> getUrlSaveCount(String urlHash) async {
    final doc = await _urlStatsCollection.doc(urlHash).get();
    if (!doc.exists) return 0;
    return doc.data()?['saveCount'] ?? 0;
  }

  /// URL 저장 수 스트림 (실시간)
  Stream<int> urlSaveCountStream(String urlHash) {
    return _urlStatsCollection.doc(urlHash).snapshots().map((doc) {
      if (!doc.exists) return 0;
      return doc.data()?['saveCount'] ?? 0;
    });
  }

  /// URL을 저장한 유저 목록 가져오기
  Future<List<SavedByUser>> getSavedByUsers(String urlHash) async {
    final doc = await _urlStatsCollection.doc(urlHash).get();
    if (!doc.exists) return [];

    final savedBy = List<Map<String, dynamic>>.from(doc.data()?['savedBy'] ?? []);
    return savedBy.map((data) => SavedByUser.fromMap(data)).toList();
  }

  /// URL을 저장한 유저 목록 스트림 (실시간)
  Stream<List<SavedByUser>> savedByUsersStream(String urlHash) {
    return _urlStatsCollection.doc(urlHash).snapshots().map((doc) {
      if (!doc.exists) return [];
      final savedBy = List<Map<String, dynamic>>.from(doc.data()?['savedBy'] ?? []);
      return savedBy.map((data) => SavedByUser.fromMap(data)).toList();
    });
  }

  // ==================== 알림 (응원/약올리기) ====================

  /// 알림 보내기
  Future<void> sendPing({
    required String toUid,
    required PingType type,
    required String urlTitle,
    String? customMessage,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final fromNickname = await _getCurrentNickname();

    // 메시지 선택
    final message = customMessage ??
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
    );

    await _notificationsCollection
        .doc(toUid)
        .collection('items')
        .add(notification.toFirestore());

    // 받는 사람의 통계 업데이트 (Social Butterfly 배지용)
    final statsField = type == PingType.cheer ? 'cheersReceived' : 'pokesReceived';
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
  }) async {
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
      createdAt: DateTime.now(),
    );

    await docRef.set(sharedLink.toJson());

    return docRef.id;
  }

  /// 공유 링크 가져오기
  Future<SharedLink?> getSharedLink(String shareId) async {
    try {
      final doc = await _sharedLinksCollection.doc(shareId).get();
      if (!doc.exists) return null;
      return SharedLink.fromJson(doc.data()!);
    } catch (e) {
      print('공유 링크 조회 에러: $e');
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
      print('조회수 증가 에러: $e');
    }
  }
}
