# LinkPing - Architect 아키텍처 설계서

> **작성자**: Architect (시스템 설계)
> **작성일**: Day 2
> **상태**: v1.0 설계 완료
> **업데이트**: 고정 알람 투표 시스템, 이모지 아바타, 알림 시스템 추가

---

## 1. 기술 스택

| 영역 | 기술 | 선택 이유 |
|------|------|-----------|
| **Framework** | Flutter 3.x | 크로스 플랫폼 |
| **상태관리** | Riverpod 2.x | 타입 안전, 간결함 |
| **로컬 저장** | Hive | 빠름, NoSQL |
| **백엔드** | Firebase | 서버리스 |
| **인증** | Firebase Auth | Google/Apple 소셜 로그인 |
| **DB** | Cloud Firestore | 실시간, NoSQL |
| **알림** | flutter_local_notifications | 로컬 푸시 |
| **광고** | google_mobile_ads | AdMob |
| **인앱결제** | in_app_purchase | 공식 패키지 |

---

## 2. 시스템 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                        Flutter App                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │  UI Layer   │  │  Provider   │  │  Service    │        │
│  │  (Screens)  │──│  (State)    │──│  (Logic)    │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│                                           │                 │
│                    ┌──────────────────────┼───────────┐    │
│                    │                      │           │    │
│              ┌─────▼─────┐         ┌──────▼─────┐    │    │
│              │   Hive    │         │  Firebase  │    │    │
│              │  (Local)  │         │  (Remote)  │    │    │
│              └───────────┘         └────────────┘    │    │
│                    │                      │           │    │
└────────────────────┼──────────────────────┼───────────┼────┘
                     │                      │           │
              ┌──────▼──────┐        ┌──────▼──────┐   │
              │ 링크 데이터  │        │  Firestore  │   │
              │ 알림 설정    │        │  - users    │   │
              │ 앱 설정      │        │  - sharedLinks│  │
              └─────────────┘        │  - notifications│ │
                                     │  - modificationRequests│
                                     └─────────────┘   │
                                                       │
                                     ┌─────────────────▼─┐
                                     │  Firebase Auth    │
                                     │  - Google/Apple   │
                                     │  - Anonymous      │
                                     └───────────────────┘
```

---

## 3. Firestore 스키마

### 3.1 컬렉션 구조

```
firestore/
├── users/                           # 사용자 프로필
│   └── {uid}/
│       ├── nickname: string
│       ├── profileEmoji: string     # 이모지 아바타 (기본: 😀)
│       ├── country: string
│       ├── createdAt: timestamp
│       └── isPremium: boolean
│
├── urlStats/                        # URL별 저장 통계
│   └── {urlHash}/
│       ├── saveCount: number
│       └── lastUpdated: timestamp
│
├── sharedLinks/                     # 공유 링크
│   └── {shareId}/
│       ├── url: string
│       ├── title: string
│       ├── hour: number
│       ├── minute: number
│       ├── repeatDays: array<number>
│       ├── sharedBy: string         # 공유자 닉네임
│       ├── creatorUid: string       # 공유자 UID
│       ├── isLocked: boolean        # 고정 알람 여부
│       ├── viewCount: number
│       ├── savedByUids: array<string>  # 저장한 사람들 UID
│       ├── savedByUsers: array       # 저장한 사람들 정보
│       │   └── { uid, nickname, profileEmoji }
│       └── createdAt: timestamp
│
├── notifications/                   # 알림 (핑, 수정 요청 등)
│   └── {notificationId}/
│       ├── toUid: string            # 받는 사람
│       ├── fromUid: string          # 보내는 사람
│       ├── fromNickname: string
│       ├── type: string             # cheer|tease|inquiryReply|linkDeleted|
│       │                            # modificationRequest|modificationApproved|
│       │                            # modificationRejected|modificationApplied
│       ├── message: string
│       ├── urlTitle: string
│       ├── isRead: boolean
│       ├── modificationRequestId: string?  # 수정 요청 ID (투표용)
│       ├── sharedLinkId: string?    # 공유 링크 ID
│       ├── linkId: string?          # 로컬 링크 ID
│       ├── inquiryId: string?       # 문의 ID
│       ├── inquiryTitle: string?    # 문의 제목
│       └── createdAt: timestamp
│
├── modificationRequests/            # 고정 알람 수정 요청
│   └── {requestId}/
│       ├── sharedLinkId: string     # 대상 공유 링크
│       ├── creatorUid: string       # 요청자 UID
│       ├── creatorNickname: string
│       ├── linkTitle: string
│       ├── originalHour: number
│       ├── originalMinute: number
│       ├── originalRepeatDays: array<number>
│       ├── newHour: number
│       ├── newMinute: number
│       ├── newRepeatDays: array<number>
│       ├── status: string           # pending|approved|rejected|expired
│       ├── voterUids: array<string> # 투표 대상 UID들
│       ├── votes: map<string, string>  # uid -> approved|rejected|pending
│       ├── createdAt: timestamp
│       └── expiresAt: timestamp     # 24시간 후
│
└── inquiries/                       # 문의
    └── {inquiryId}/
        ├── uid: string
        ├── nickname: string
        ├── title: string
        ├── content: string
        ├── reply: string?
        ├── repliedAt: timestamp?
        └── createdAt: timestamp
```

### 3.2 보안 규칙

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // 사용자 프로필
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }

    // URL 통계
    match /urlStats/{urlHash} {
      allow read: if request.auth != null;
      allow update: if request.auth != null;
    }

    // 공유 링크
    match /sharedLinks/{shareId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
    }

    // 알림
    match /notifications/{notificationId} {
      allow read: if request.auth != null
        && resource.data.toUid == request.auth.uid;
      allow create: if request.auth != null;
      allow update: if request.auth != null
        && resource.data.toUid == request.auth.uid;
    }

    // 수정 요청
    match /modificationRequests/{requestId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
    }

    // 문의
    match /inquiries/{inquiryId} {
      allow read: if request.auth != null
        && resource.data.uid == request.auth.uid;
      allow create: if request.auth != null;
    }
  }
}
```

---

## 4. 데이터 모델 (Dart)

### 4.1 LinkReminder (로컬 - Hive)

```dart
@HiveType(typeId: 0)
class LinkReminder extends HiveObject {
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
  @HiveField(13) final String? sharedLinkId;    // 공유 링크 ID
  @HiveField(14) final String? creatorUid;      // 원본 만든 사람 UID
}
```

### 4.2 UserProfile (Firestore)

```dart
class UserProfile {
  final String uid;
  final String nickname;
  final String profileEmoji;   // 이모지 아바타
  final String country;
  final DateTime createdAt;
  final bool isPremium;
}
```

### 4.3 PingNotification (Firestore)

```dart
enum PingType {
  cheer,                  // 응원
  tease,                  // 약올리기
  inquiryReply,           // 문의 답변
  linkDeleted,            // 고정 알람 삭제됨
  modificationRequest,    // 수정 요청 (투표)
  modificationApproved,   // 수정 승인됨
  modificationRejected,   // 수정 거부됨
  modificationApplied,    // 알람 OFF됨 (거절했지만 전체 승인)
}

class PingNotification {
  final String id;
  final String toUid;
  final String fromUid;
  final String fromNickname;
  final PingType type;
  final String message;
  final String urlTitle;
  final bool isRead;
  final DateTime createdAt;
  final String? modificationRequestId;
  final String? sharedLinkId;
  final String? linkId;
  final String? inquiryId;
  final String? inquiryTitle;
}
```

### 4.4 ModificationRequest (Firestore)

```dart
enum ModificationStatus { pending, approved, rejected, expired }

class ModificationRequest {
  final String id;
  final String sharedLinkId;
  final String creatorUid;
  final String creatorNickname;
  final String linkTitle;
  final int originalHour, originalMinute;
  final int newHour, newMinute;
  final List<int> originalRepeatDays;
  final List<int> newRepeatDays;
  final DateTime createdAt;
  final DateTime expiresAt;
  final ModificationStatus status;
  final List<String> voterUids;
  final Map<String, String> votes;  // uid -> approved|rejected|pending

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  double get approvalRate => approvedCount / (approvedCount + rejectedCount);
  bool get isApprovalReached => approvalRate >= 0.5;
}
```

### 4.5 SavedByUser

```dart
class SavedByUser {
  final String uid;
  final String nickname;
  final String profileEmoji;
}
```

---

## 5. 주요 시스템 플로우

### 5.1 고정 알람 수정 투표 플로우

```
1. 생성자가 시간 수정 요청
   ↓
2. ModificationRequest 생성 (status: pending, expiresAt: +24h)
   ↓
3. 저장한 모든 사용자에게 알림 발송 (type: modificationRequest)
   ↓
4. 사용자들이 투표 (approve/reject)
   ↓
5. 투표 완료 또는 24시간 경과
   ↓
6. 결과 처리:
   ├─ 50% 이상 승인
   │   ├─ 전체 수정 적용
   │   ├─ 승인자에게 알림 (modificationApproved)
   │   └─ 거절자에게 알림 (modificationApplied) + 알람 OFF
   │
   └─ 50% 미만 승인
       ├─ 수정 거부
       └─ 생성자에게 알림 (modificationRejected)

24시간 무응답자:
   └─ 알람 OFF + 알림 (modificationApplied)
```

### 5.2 24시간 만료 처리

```dart
// main.dart - AuthWrapper에서 앱 시작 시 호출
Future<void> _checkExpiredModificationRequests() async {
  await FirestoreService.instance.processExpiredModificationRequests();
}
```

현재는 앱 시작 시 클라이언트에서 처리 (Lazy Evaluation)
→ 유저 5천명 이상 시 Cloud Functions로 전환 예정

### 5.3 이모지 업데이트 플로우

```
1. 사용자가 프로필에서 이모지 변경
   ↓
2. Firestore users/{uid}/profileEmoji 업데이트
   ↓
3. sharedLinks에서 savedByUsers 업데이트
   ↓
4. 다른 사용자가 볼 때 최신 이모지 표시
```

---

## 6. 프로젝트 구조

```
linkping/
├── lib/
│   ├── main.dart
│   │
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── spacing.dart
│   │   └── constants/
│   │       └── app_constants.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── link_reminder.dart
│   │   │   ├── user_profile.dart
│   │   │   ├── shared_link.dart
│   │   │   ├── ping_notification.dart
│   │   │   ├── modification_request.dart
│   │   │   └── saved_by_user.dart
│   │   └── repositories/
│   │       └── link_repository.dart
│   │
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   ├── notification_service.dart
│   │   ├── ad_service.dart
│   │   └── badge_service.dart
│   │
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── user_provider.dart
│   │   └── links_provider.dart
│   │
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── home/
│   │   │   ├── add_link/
│   │   │   ├── edit_link/
│   │   │   ├── notifications/
│   │   │   ├── settings/
│   │   │   ├── share_landing/
│   │   │   └── inquiry/
│   │   └── widgets/
│   │       ├── link_card.dart
│   │       ├── emoji_picker_dialog.dart
│   │       ├── saved_users_bottom_sheet.dart
│   │       └── banner_ad_widget.dart
│   │
│   └── l10n/
│       ├── app_en.arb
│       └── app_ko.arb
│
├── firebase_options.dart
└── pubspec.yaml
```

---

## 7. Firebase 비용 분석

### 현재 (Spark 플랜)
- 무료 한도 내 운영

### 유저 10,000명 시 (Blaze 플랜)

| 항목 | 월 예상 |
|------|---------|
| Firestore 읽기 | ~$1-3 |
| Firestore 쓰기 | ~$0.5-1 |
| Authentication | 무료 |
| **합계** | **$2-5/월** |

### Cloud Functions 도입 시 (유저 5,000명+)

```
24시간 만료 자동 처리:
- 1시간마다 1회 실행
- 월 720회 호출
- 무료 한도(200만회) 내 = $0
```

---

## 8. 체크리스트

### 완료 항목
- [x] 기술 스택 결정
- [x] Firestore 스키마 설계
- [x] 데이터 모델 정의
- [x] 인증 흐름 설계
- [x] 알림 시스템 설계
- [x] 고정 알람 투표 시스템 설계
- [x] 이모지 아바타 시스템 설계
- [x] 24시간 만료 처리 설계

### 향후 계획
- [ ] Cloud Functions 도입 (유저 5,000명 이상 시)
- [ ] FCM 푸시 알림 도입
- [ ] Analytics 대시보드 구축
