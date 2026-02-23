# LinkPing - Developer 개발 현황

> **작성자**: Developer (Flutter)
> **작성일**: Day 3-10
> **상태**: v1.0 개발 완료
> **업데이트**: 전체 기능 구현 완료, 출시 준비 단계

---

## 1. 개발 환경

### 기술 스택
```yaml
Flutter: 3.x
Dart: 3.x
State Management: Riverpod 2.x
Local Storage: Hive
Backend: Firebase (Auth, Firestore)
Ads: Google Mobile Ads (AdMob)
```

### 주요 패키지
```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  hive_flutter: ^1.1.0
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  google_mobile_ads: ^4.0.0
  flutter_local_notifications: ^16.0.0
  url_launcher: ^6.2.0
  share_plus: ^7.2.0
  uuid: ^4.2.0
```

---

## 2. 구현 완료 기능

### 2.1 인증 시스템
| 기능 | 파일 | 상태 |
|------|------|------|
| Google 로그인 | `auth_service.dart` | ✅ |
| Apple 로그인 | `auth_service.dart` | ✅ |
| 익명 로그인 (게스트) | `auth_service.dart` | ✅ |
| 회원 전환 | `auth_service.dart` | ✅ |
| 로그아웃 | `auth_service.dart` | ✅ |

### 2.2 링크 관리
| 기능 | 파일 | 상태 |
|------|------|------|
| 링크 추가 | `add_link_screen.dart` | ✅ |
| 링크 수정 | `edit_link_screen.dart` | ✅ |
| 링크 삭제 | `links_provider.dart` | ✅ |
| 링크 토글 (ON/OFF) | `links_provider.dart` | ✅ |
| 추가 알림 시간 | `link_reminder.dart` | ✅ |
| 종료일 설정 | `link_reminder.dart` | ✅ |
| 고정 알람 | `link_reminder.dart` | ✅ |

### 2.3 알림 시스템
| 기능 | 파일 | 상태 |
|------|------|------|
| 로컬 푸시 알림 | `notification_service.dart` | ✅ |
| 알림 스케줄링 | `notification_service.dart` | ✅ |
| 알림 취소 | `notification_service.dart` | ✅ |
| 알림 탭 → URL 열기 | `notification_service.dart` | ✅ |

### 2.4 소셜 기능
| 기능 | 파일 | 상태 |
|------|------|------|
| 링크 공유 | `home_screen.dart` | ✅ |
| 저장 인원 표시 | `link_card.dart` | ✅ |
| 저장한 사람 목록 | `saved_users_bottom_sheet.dart` | ✅ |
| 응원/약올리기 핑 | `firestore_service.dart` | ✅ |
| 웹 랜딩 페이지 | `share_landing_screen.dart` | ✅ |

### 2.5 이모지 아바타
| 기능 | 파일 | 상태 |
|------|------|------|
| 이모지 선택 UI | `emoji_picker_dialog.dart` | ✅ |
| 프로필 이모지 저장 | `edit_profile_screen.dart` | ✅ |
| 게스트 이모지 저장 | `auth_service.dart` | ✅ |
| 이모지 동기화 | `firestore_service.dart` | ✅ |

### 2.6 고정 알람 투표 시스템
| 기능 | 파일 | 상태 |
|------|------|------|
| 수정 요청 생성 | `firestore_service.dart` | ✅ |
| 투표 (승인/거절) | `firestore_service.dart` | ✅ |
| 투표 결과 처리 | `firestore_service.dart` | ✅ |
| 24시간 만료 처리 | `firestore_service.dart` | ✅ |
| 삭제 알림 발송 | `links_provider.dart` | ✅ |
| 투표 UI | `notifications_screen.dart` | ✅ |

### 2.7 알림 센터
| 기능 | 파일 | 상태 |
|------|------|------|
| 알림 목록 | `notifications_screen.dart` | ✅ |
| 알림 읽음 처리 | `firestore_service.dart` | ✅ |
| 모두 읽음 | `firestore_service.dart` | ✅ |
| 알림 타입별 UI | `notifications_screen.dart` | ✅ |

### 2.8 기타 기능
| 기능 | 파일 | 상태 |
|------|------|------|
| 프리미엄 결제 | `settings_screen.dart` | ✅ |
| 배너 광고 | `banner_ad_widget.dart` | ✅ |
| 문의하기 | `inquiry_screen.dart` | ✅ |
| 다국어 (한/영) | `l10n/` | ✅ |
| 뱃지 시스템 | `badge_service.dart` | ✅ |

---

## 3. 주요 파일 구조

```
lib/
├── main.dart                    # 앱 진입점 + 24시간 만료 체크
├── core/
│   ├── theme/app_theme.dart     # 다크 테마
│   └── constants/app_constants.dart
│
├── data/models/
│   ├── link_reminder.dart       # HiveField 0-14
│   ├── link_reminder.g.dart     # Hive 어댑터 (자동생성)
│   ├── user_profile.dart        # profileEmoji 포함
│   ├── shared_link.dart         # savedByUids, savedByUsers
│   ├── ping_notification.dart   # PingType enum (8종)
│   ├── modification_request.dart # 투표 시스템
│   └── saved_by_user.dart       # uid, nickname, profileEmoji
│
├── services/
│   ├── auth_service.dart        # getGuestEmoji(), saveGuestEmoji()
│   ├── firestore_service.dart   # 투표, 알림, 이모지 동기화
│   ├── notification_service.dart
│   ├── ad_service.dart
│   └── badge_service.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── user_provider.dart       # myNotificationsProvider
│   └── links_provider.dart      # sharedLinkId, creatorUid 지원
│
└── presentation/
    ├── screens/
    │   ├── home/home_screen.dart
    │   ├── add_link/add_link_screen.dart
    │   ├── edit_link/edit_link_screen.dart
    │   ├── notifications/notifications_screen.dart  # 투표 UI
    │   ├── settings/
    │   │   ├── settings_screen.dart
    │   │   └── edit_profile_screen.dart  # 이모지 선택
    │   └── share_landing/share_landing_screen.dart
    └── widgets/
        ├── emoji_picker_dialog.dart     # 64종 이모지
        ├── saved_users_bottom_sheet.dart
        └── banner_ad_widget.dart
```

---

## 4. Hive 모델 필드 (LinkReminder)

```dart
@HiveField(0)  final String id;
@HiveField(1)  final String url;
@HiveField(2)  final String urlHash;
@HiveField(3)  final String title;
@HiveField(4)  final int hour;
@HiveField(5)  final int minute;
@HiveField(6)  final List<int> repeatDays;
@HiveField(7)  final bool isEnabled;
@HiveField(8)  final DateTime createdAt;
@HiveField(9)  final List<ReminderTime>? additionalTimes;
@HiveField(10) final DateTime? endDate;
@HiveField(11) final bool isLocked;
@HiveField(12) final String? sharedBy;
@HiveField(13) final String? sharedLinkId;    // 공유 링크 추적
@HiveField(14) final String? creatorUid;      // 원본 생성자 추적
```

**주의**: 필드 추가 후 `build_runner` 실행 필요
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## 5. 주요 API (FirestoreService)

### 5.1 고정 알람 투표 관련
```dart
// 수정 요청 생성
Future<String> createModificationRequest({
  required String sharedLinkId,
  required int newHour,
  required int newMinute,
  required List<int> newRepeatDays,
}) async;

// 투표
Future<void> voteOnModificationRequest({
  required String requestId,
  required bool approve,
}) async;

// 만료 처리 (앱 시작 시)
Future<void> processExpiredModificationRequests() async;

// 삭제 알림 발송
Future<void> sendLockedLinkDeletedNotification({
  required String sharedLinkId,
  required String linkTitle,
}) async;
```

### 5.2 이모지 관련
```dart
// 이모지 업데이트 (savedByUsers 동기화)
Future<void> updateUserProfileInSavedBy({
  required String nickname,
  required String emoji,
}) async;
```

---

## 6. 24시간 만료 처리

### 현재 구현 (앱 시작 시 처리)
```dart
// main.dart - AuthWrapper
class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _checkedExpiredRequests = false;

  Future<void> _checkExpiredModificationRequests() async {
    if (_checkedExpiredRequests) return;
    _checkedExpiredRequests = true;
    await FirestoreService.instance.processExpiredModificationRequests();
  }

  @override
  Widget build(BuildContext context) {
    return authState.when(
      data: (user) {
        if (user != null) {
          _checkExpiredModificationRequests();  // 로그인 시 1회 실행
          return const HomeScreen();
        }
        return const OnboardingScreen();
      },
      ...
    );
  }
}
```

### 향후 계획 (Cloud Functions)
- 유저 5,000명 이상 시 도입
- 1시간마다 자동 실행
- 월 720회 호출 = 무료 한도 내

---

## 7. 테스트 체크리스트

### 인증
- [ ] Google 로그인
- [ ] Apple 로그인 (iOS)
- [ ] 게스트 모드
- [ ] 게스트 → 회원 전환

### 링크 관리
- [ ] 링크 추가 (시간, 요일)
- [ ] 추가 시간 설정
- [ ] 종료일 설정
- [ ] 링크 수정
- [ ] 링크 삭제
- [ ] 토글 ON/OFF

### 알림
- [ ] 지정 시간 알림
- [ ] 알림 탭 → URL 열기
- [ ] 종료일 지난 링크 자동 OFF

### 소셜
- [ ] 링크 공유 (일반)
- [ ] 링크 공유 (고정 알람)
- [ ] 저장한 사람 목록
- [ ] 응원/약올리기 핑

### 고정 알람 투표
- [ ] 수정 요청 생성
- [ ] 투표 알림 수신
- [ ] 승인 투표
- [ ] 거절 투표
- [ ] 50% 이상 승인 → 수정 적용
- [ ] 50% 미만 승인 → 거부
- [ ] 거절했지만 전체 승인 → 알람 OFF
- [ ] 24시간 무응답 → 알람 OFF

### 이모지
- [ ] 이모지 선택
- [ ] 프로필 이모지 표시
- [ ] 저장한 사람 목록에서 이모지 표시

---

## 8. 빌드 및 배포

### Android
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ipa --release
```

### 코드 생성
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## 9. 개발 완료 요약

### v1.0 완료 기능 (22개)
1. Google/Apple 소셜 로그인
2. 익명 로그인 (게스트)
3. 이모지 아바타 (64종)
4. 링크 등록/수정/삭제
5. 추가 알림 시간
6. 종료일 설정
7. 로컬 푸시 알림
8. 링크 공유
9. 저장 인원 표시
10. 저장한 사람 목록
11. 응원/약올리기 핑
12. 고정 알람
13. 고정 알람 수정 투표
14. 고정 알람 삭제 알림
15. 알림 센터
16. 프리미엄 결제
17. 배너 광고
18. 문의하기
19. 다국어 (한/영)
20. 웹 랜딩 페이지
21. 뱃지 시스템
22. 24시간 만료 처리

### 다음 단계
- [ ] iOS/Android 실기기 테스트
- [ ] 스토어 스크린샷 준비
- [ ] 베타 테스트
- [ ] 정식 출시
