import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/user_profile.dart';
import '../data/models/ping_notification.dart';
import '../data/models/saved_by_user.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

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

/// URL 저장 수 Provider (urlHash로 조회)
final urlSaveCountProvider = StreamProvider.family<int, String>((ref, urlHash) {
  return ref.watch(firestoreServiceProvider).urlSaveCountStream(urlHash);
});

/// URL을 저장한 유저 목록 Provider
final savedByUsersProvider = StreamProvider.family<List<SavedByUser>, String>((ref, urlHash) {
  return ref.watch(firestoreServiceProvider).savedByUsersStream(urlHash);
});

/// 내 알림 목록 Provider
final myNotificationsProvider = StreamProvider<List<PingNotification>>((ref) {
  return ref.watch(firestoreServiceProvider).myNotificationsStream();
});

/// 읽지 않은 알림 수 Provider
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  return ref.watch(firestoreServiceProvider).unreadNotificationCountStream();
});
