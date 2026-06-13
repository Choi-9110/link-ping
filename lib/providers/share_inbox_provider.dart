import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/share_inbox_service.dart';

/// 공유받은 링크 대기함 상태.
/// 알림 화면의 "공유받은 링크" 섹션과 딥링크 수락 흐름이 함께 사용한다.
final shareInboxProvider =
    StateNotifierProvider<ShareInboxNotifier, List<PendingShare>>(
        (ref) => ShareInboxNotifier());

class ShareInboxNotifier extends StateNotifier<List<PendingShare>> {
  ShareInboxNotifier() : super(ShareInboxService.getAll());

  Future<void> add(PendingShare share) async {
    await ShareInboxService.add(share);
    state = ShareInboxService.getAll();
  }

  Future<void> remove(String shareId) async {
    await ShareInboxService.remove(shareId);
    state = ShareInboxService.getAll();
  }

  void refresh() => state = ShareInboxService.getAll();
}
