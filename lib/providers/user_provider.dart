import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/user_profile.dart';
import '../data/models/ping_notification.dart';
import '../data/models/saved_by_user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

/// 게스트 프로필 Provider (닉네임, 이모지)
/// invalidate 시 다시 로드됨
final guestProfileProvider = Provider<({String nickname, String emoji})>((ref) {
  return (
    nickname: AuthService.instance.getGuestNickname(),
    emoji: AuthService.instance.getGuestEmoji(),
  );
});

/// FirestoreService Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService.instance;
});

/// 현재 사용자 프로필 Provider
final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;

  if (user == null) {
    return Stream.value(null);
  }

  return ref.watch(firestoreServiceProvider).userProfileStream(user.uid);
});

/// 프로필 저장 함수 Provider
final saveUserProfileProvider = Provider<Future<void> Function(UserProfile)>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return (profile) => firestoreService.saveUserProfile(profile);
});

/// 공유 링크 저장 수 Provider (sharedLinkId로 조회)
final sharedLinkSaveCountProvider = StreamProvider.family<int, String>((ref, sharedLinkId) {
  return ref.watch(firestoreServiceProvider).sharedLinkSaveCountStream(sharedLinkId);
});

/// 공유 링크를 저장한 유저 목록 Provider (sharedLinkId로 조회)
final sharedLinkSavedByUsersProvider = StreamProvider.family<List<SavedByUser>, String>((ref, sharedLinkId) {
  return ref.watch(firestoreServiceProvider).sharedLinkSavedByUsersStream(sharedLinkId);
});

/// 내 알림 목록 Provider
final myNotificationsProvider = StreamProvider<List<PingNotification>>((ref) {
  return ref.watch(firestoreServiceProvider).myNotificationsStream();
});

/// 읽지 않은 알림 수 Provider
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  return ref.watch(firestoreServiceProvider).unreadNotificationCountStream();
});
