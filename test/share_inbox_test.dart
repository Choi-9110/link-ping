// 공유받은 링크 대기함 — 실제 Hive 박스로 저장/중복방지/제거 검증.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:linkping/services/share_inbox_service.dart';

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('linkku_hive_test');
    Hive.init(dir.path);
    await Hive.openBox('settings');
  });

  tearDown(() async => Hive.box('settings').clear());

  PendingShare make(String shareId, String rootId) => PendingShare(
        shareId: shareId,
        rootShareId: rootId,
        title: '아침 홈트 15분',
        sharedBy: '아빠곰',
        timeText: '오전 7:00 · 매일',
        receivedAt: DateTime(2026, 6, 13, 9, 0),
      );

  test('추가 → 조회 라운드트립 (필드 보존)', () async {
    await ShareInboxService.add(make('s1', 'r1'));
    final all = ShareInboxService.getAll();
    expect(all.length, 1);
    expect(all.first.shareId, 's1');
    expect(all.first.rootShareId, 'r1');
    expect(all.first.title, '아침 홈트 15분');
    expect(all.first.sharedBy, '아빠곰');
    expect(all.first.timeText, '오전 7:00 · 매일');
  });

  test('같은 체인(rootShareId)은 중복 보관 안 됨 — 릴레이 다단계 URL 대비', () async {
    await ShareInboxService.add(make('s1', 'r1'));
    await ShareInboxService.add(make('s2', 'r1')); // 같은 체인, 다른 문서
    expect(ShareInboxService.getAll().length, 1);

    await ShareInboxService.add(make('s3', 'r2')); // 다른 체인
    expect(ShareInboxService.getAll().length, 2);
  });

  test('제거 후 목록에서 사라짐', () async {
    await ShareInboxService.add(make('s1', 'r1'));
    await ShareInboxService.add(make('s3', 'r2'));
    await ShareInboxService.remove('s1');
    final all = ShareInboxService.getAll();
    expect(all.length, 1);
    expect(all.any((e) => e.shareId == 's1'), false);
  });

  test('깨진 저장 데이터여도 크래시 없이 빈 목록', () async {
    await Hive.box('settings').put('pendingSharedLinks', '{{{not json');
    expect(ShareInboxService.getAll(), isEmpty);
  });
}
