import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/verification_video.dart';
import '../services/verification_video_service.dart';

/// 특정 sharedLinkId의 인증 영상 목록.
/// autoDispose 제거 — 탭 전환 시 캐시 유지로 재쿼리 방지.
/// 변경 발생 시 [ref.invalidate] 로 명시적 새로고침.
final verificationsBySharedLinkProvider =
    FutureProvider.family<List<VerificationVideo>, String>(
        (ref, sharedLinkId) async {
  return VerificationVideoService.instance.getVideosForSharedLink(sharedLinkId);
});

/// 내가 업로드한 인증 영상 목록.
final myVerificationsProvider =
    FutureProvider<List<VerificationVideo>>((ref) async {
  return VerificationVideoService.instance.getMyVideos();
});

/// 차단된 유저 목록.
final blockedUsersProvider = FutureProvider<List<BlockedUser>>((ref) async {
  return VerificationVideoService.instance.getBlockedUsers();
});
