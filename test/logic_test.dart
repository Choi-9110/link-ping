// 순수 로직 단위 테스트 — 기기 없이 검증 가능한 영역.
// (보안 픽스 회귀 방지 테스트 포함: UserProfile.toFirestore 민감필드 제외)
import 'package:flutter_test/flutter_test.dart';
import 'package:linkping/core/constants/app_constants.dart';
import 'package:linkping/data/models/link_reminder.dart';
import 'package:linkping/data/models/shared_link.dart';
import 'package:linkping/data/models/user_profile.dart';
import 'package:linkping/services/url_launcher_service.dart';

void main() {
  group('LinkReminder 반복/시간 문자열', () {
    LinkReminder make(List<int> days, {int hour = 7, int minute = 0}) =>
        LinkReminder(
          id: 't1',
          url: 'https://youtube.com',
          urlHash: 'h',
          title: '테스트',
          hour: hour,
          minute: minute,
          repeatDays: days,
        );

    test('매일/평일/주말 요약', () {
      expect(make([0, 1, 2, 3, 4, 5, 6]).getRepeatString(true), '매일');
      expect(make([1, 2, 3, 4, 5]).getRepeatString(true), '평일');
      expect(make([0, 6]).getRepeatString(true), '주말');
      expect(make([0, 1, 2, 3, 4, 5, 6]).getRepeatString(false), 'Daily');
    });

    test('개별 요일은 0=일 규칙으로 표기된다', () {
      expect(make([1]).getRepeatString(true), '월');
      expect(make([0]).getRepeatString(true), '일');
      expect(make([5, 6]).getRepeatString(true), '금, 토');
    });

    test('toMap/fromMap 라운드트립에 공유 필드가 보존된다', () {
      final link = LinkReminder(
        id: 'rt',
        url: 'https://a.com',
        urlHash: 'h',
        title: 'rt',
        hour: 9,
        minute: 30,
        repeatDays: const [1, 3],
        sharedBy: '아빠곰',
        sharedLinkId: 'share123',
        creatorUid: 'creator1',
        isLocked: true,
      );
      final restored = LinkReminder.fromMap(link.toMap());
      expect(restored.sharedLinkId, 'share123');
      expect(restored.sharedBy, '아빠곰');
      expect(restored.creatorUid, 'creator1');
      expect(restored.isLocked, true);
      expect(restored.repeatDays, [1, 3]);
    });

    test('릴레이 링 필드(outgoing/root/visibility) 라운드트립 보존', () {
      final link = LinkReminder(
        id: 'chain1',
        url: 'https://a.com',
        urlHash: 'h',
        title: 'chain',
        hour: 7,
        minute: 0,
        repeatDays: const [1],
        sharedLinkId: 'parentDoc',
        outgoingShareId: 'myDoc',
        rootShareId: 'rootDoc',
        shareVisibility: 'chain',
      );
      final restored = LinkReminder.fromMap(link.toMap());
      expect(restored.outgoingShareId, 'myDoc');
      expect(restored.rootShareId, 'rootDoc');
      expect(restored.shareVisibility, 'chain');
    });
  });

  group('SharedLink', () {
    test('timeString 오전/오후 처리', () {
      SharedLink make(int h, int m) => SharedLink(
            id: 's',
            url: 'u',
            title: 't',
            hour: h,
            minute: m,
            repeatDays: const [1],
            sharedBy: 'nick',
            creatorUid: 'c',
            createdAt: DateTime(2026, 1, 1),
          );
      expect(make(0, 5).getTimeString(true), '오전 12:05');
      expect(make(9, 30).getTimeString(true), '오전 9:30');
      expect(make(12, 0).getTimeString(true), '오후 12:00');
      expect(make(21, 0).getTimeString(false), 'PM 9:00');
    });

    test('연결 모드: 기본값=다같이(all), rootShareId 기본=자기 자신', () {
      final root = SharedLink(
        id: 'rootDoc',
        url: 'u',
        title: 't',
        hour: 7,
        minute: 0,
        repeatDays: const [1],
        sharedBy: 'A',
        creatorUid: 'a',
        createdAt: DateTime(2026, 1, 1),
      );
      expect(root.visibility, 'all');
      expect(root.rootShareId, 'rootDoc'); // 뿌리는 자기 자신

      // 릴레이 자식 문서 직렬화 라운드트립
      final child = SharedLink(
        id: 'childDoc',
        url: 'u',
        title: 't',
        hour: 7,
        minute: 0,
        repeatDays: const [1],
        sharedBy: 'C',
        creatorUid: 'c',
        createdAt: DateTime(2026, 1, 1),
        visibility: 'chain',
        rootShareId: 'rootDoc',
      );
      final restored = SharedLink.fromJson(child.toJson());
      expect(restored.visibility, 'chain');
      expect(restored.rootShareId, 'rootDoc');

      // 레거시 문서(필드 없음) → 다같이 + 자기 자신 뿌리
      final legacyJson = root.toJson()
        ..remove('visibility')
        ..remove('rootShareId');
      final legacy = SharedLink.fromJson(legacyJson);
      expect(legacy.visibility, 'all');
      expect(legacy.rootShareId, 'rootDoc');
    });
  });

  group('공유 URL / 딥링크 파싱 규약', () {
    test('buildShareUrl 형식', () {
      final url = AppConstants.buildShareUrl('abc123');
      expect(url, endsWith('/s/abc123'));
      expect(url, startsWith('https://'));
    });

    test('웹 공유 URL 에서 shareId 추출 (랜딩 → 앱 규약)', () {
      final uri = Uri.parse(AppConstants.buildShareUrl('ApNat4edOQ'));
      expect(uri.pathSegments.first, 's');
      expect(uri.pathSegments[1], 'ApNat4edOQ');
    });

    test('커스텀 스킴 linkping://share/{id} 파싱 (MainShell 수신 규약)', () {
      final uri = Uri.parse('linkping://share/ApNat4edOQ');
      expect(uri.scheme, 'linkping');
      expect(uri.host, 'share');
      expect(uri.pathSegments.first, 'ApNat4edOQ');
    });
  });

  group('UrlLauncherService', () {
    test('스킴 보정', () {
      expect(UrlLauncherService.ensureScheme('naver.com'),
          'https://naver.com');
      expect(UrlLauncherService.ensureScheme('https://a.com'),
          'https://a.com');
    });

    test('URL 유효성', () {
      expect(UrlLauncherService.isValidUrl('https://youtube.com'), true);
      expect(UrlLauncherService.isValidUrl(''), false);
      expect(UrlLauncherService.isValidUrl(null), false);
    });

    test('전화번호 URL 판별/표시', () {
      expect(UrlLauncherService.isPhoneUrl('tel:01012345678'), true);
      expect(UrlLauncherService.isPhoneUrl('https://a.com'), false);
    });
  });

  group('★ 보안 회귀 방지: UserProfile.toFirestore', () {
    test('전화번호는 공개 프로필 문서에 절대 포함되지 않는다', () {
      final p = UserProfile(
        uid: 'u1',
        country: 'KR',
        nickname: 'nick',
        createdAt: DateTime(2026, 1, 1),
        phoneNumber: '01012345678',
      );
      expect(p.toFirestore().containsKey('phoneNumber'), false,
          reason: '전화번호는 users/{uid}/private 에만 저장 — 공개 문서에 들어가면 전체 유저에게 노출됨');
    });

    test('pendingPoringReward 를 통째로 다시 쓰지 않는다 (lost update 방지)', () {
      final p = UserProfile(
        uid: 'u1',
        country: 'KR',
        nickname: 'nick',
        createdAt: DateTime(2026, 1, 1),
        pendingPoringReward: 0,
      );
      expect(p.toFirestore().containsKey('pendingPoringReward'), false,
          reason: '프로필 저장이 적립된 추천 보상을 0으로 덮어쓰면 안 됨');
    });

    test('isAdmin 자가 부여 불가 (필드 자체가 안 나감)', () {
      final p = UserProfile(
        uid: 'u1',
        country: 'KR',
        nickname: 'nick',
        createdAt: DateTime(2026, 1, 1),
      );
      expect(p.toFirestore().containsKey('isAdmin'), false);
    });
  });
}
