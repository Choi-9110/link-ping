import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/verification_video.dart';
import '../services/firestore_service.dart';
import '../services/verification_video_service.dart';
import 'links_provider.dart';

/// 인증 "안 읽음" 상태가 바뀔 때(폴더 열람) 뱃지를 다시 그리게 하는 리비전.
/// [VerificationSeenService.markSeen] 직후 값을 올려 폴더/카드 뱃지를 갱신한다.
final verificationSeenRevProvider = StateProvider<int>((ref) => 0);

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

/// 링크(알람) 1개의 인증 갤러리 — **연결 모드를 따른다.**
/// - 다같이 링('all'): 그 공유 문서의 인증 전부
/// - 릴레이 링('chain'): 같은 체인에서 **내 이웃**(나에게 준 고리 + 내가 준 고리의
///   참여자들)의 인증만 — "내 인증이 누구에게 보이느냐"의 약속을 그대로 구현
/// 파라미터는 로컬 LinkReminder.id
final linkVerificationsProvider =
    FutureProvider.family<List<VerificationVideo>, String>((ref, localLinkId) async {
  final links = ref.watch(linksProvider);
  final link = links.where((l) => l.id == localLinkId).firstOrNull;
  if (link == null || link.sharedLinkId == null) return [];

  // 노출 범위는 프라이버시 약속이므로 로컬 필드가 비어있으면(레거시/복원 등)
  // 공유 문서의 원본 모드를 다시 확인한다 — 릴레이를 다같이로 오판하면 안 됨.
  var mode = link.shareVisibility;
  if (mode == null) {
    final doc =
        await FirestoreService.instance.getSharedLink(link.sharedLinkId!);
    mode = doc?.visibility ?? 'all';
  }

  if (mode == 'chain') {
    final rootId = link.rootShareId ?? link.sharedLinkId!;

    // 내 이웃 = 받은 고리 + 내가 뿌린 고리의 참여자 합집합
    final docIds = <String>{
      link.sharedLinkId!,
      if (link.outgoingShareId != null) link.outgoingShareId!,
    };
    final docs = await Future.wait(
        docIds.map((id) => FirestoreService.instance.getSharedLink(id)));
    final peers = <String>{};
    for (final d in docs) {
      if (d == null) continue;
      peers.addAll(d.savedByUids);
      peers.add(d.creatorUid);
    }

    return VerificationVideoService.instance.getVideosForChain(
      rootShareId: rootId,
      peerUids: peers,
    );
  }

  // 다같이 링 (레거시 포함): 한 문서에 전원
  return VerificationVideoService.instance
      .getVideosForSharedLink(link.sharedLinkId!);
});
