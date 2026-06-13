# LinkPing Firestore Database Schema

> 운영/관리용 데이터베이스 구조 문서
> 최종 수정: 2026-04-01

---

## 1. `users` - 사용자 정보

**문서 ID:** Firebase Auth UID

| 필드 | 타입 | 설명 |
|------|------|------|
| nickname | String | 닉네임 |
| country | String | 국가 코드 (KR, US, JP 등) |
| isPremium | Boolean | **프리미엄 여부 (운영에서 직접 변경 가능)** |
| profileEmoji | String | 프로필 이모지 키 (예: animal_tiger, face_cool) |
| phoneNumber | String? | 전화번호 (전화 알림용, 선택) |
| bonusLinks | Integer | 추천으로 받은 보너스 링크 수 (최대 1) |
| referredBy | String? | 추천한 사람 UID |
| pendingPoringReward | Integer | 미수령 포링 보상 |
| isAdmin | Boolean | **관리자 권한 (운영에서 직접 변경)** |
| premiumProductId | String? | 인앱결제 상품 ID |
| premiumPurchaseToken | String? | 인앱결제 토큰 |
| premiumUpdatedAt | Timestamp | 프리미엄 상태 변경일 |
| selectedSoundId | String | 선택한 알람 소리 ID |
| selectedSoundCategory | String | 소리 카테고리 (alarm/notify) |
| soundSelectedAt | Timestamp | 소리 선택 시각 |
| createdAt | Timestamp | 가입일 |
| updatedAt | Timestamp | 프로필 수정일 |

### 자주 쓰는 운영 작업
- **프리미엄 부여:** `isPremium` → `true`
- **관리자 설정:** `isAdmin` → `true`
- **닉네임 변경:** `nickname` 직접 수정

---

### 1-1. `users/{uid}/stats/dashboard` - 사용자 통계

| 필드 | 타입 | 설명 |
|------|------|------|
| categoryCount | Map<String, int> | 카테고리별 링크 수 (exercise, study, contact, selfDev, other) |
| hourlyClickCount | Map<String, int> | 시간대별 알림 클릭 수 (0~23) |
| soundUsageCount | Map<String, int> | 소리별 사용 횟수 |
| weekdayCount | Map<String, int> | 요일별 클릭 수 (0=일, 6=토) |
| totalLinksCreated | Integer | 총 생성 링크 수 |
| totalNotificationsClicked | Integer | 총 알림 클릭 수 |
| totalNotificationsSent | Integer | 총 알림 발송 수 |
| lastActiveAt | Timestamp | 마지막 활동 시각 |

---

### 1-2. `users/{uid}/notifications` - 알림 목록

| 필드 | 타입 | 설명 |
|------|------|------|
| type | String | 알림 타입 (아래 표 참조) |
| fromUid | String | 보낸 사람 UID |
| fromNickname | String | 보낸 사람 닉네임 |
| urlTitle | String | 관련 링크 제목 |
| message | String | 알림 메시지 |
| isRead | Boolean | 읽음 여부 |
| createdAt | Timestamp | 생성 시각 |
| sharedLinkId | String? | 관련 공유 링크 ID |
| inquiryId | String? | 관련 문의 ID |
| modificationRequestId | String? | 관련 수정 요청 ID |
| messageIndex | Integer? | 다국어 메시지 인덱스 |

**알림 타입 종류:**
| type | 설명 |
|------|------|
| cheer | 응원 받음 |
| tease | 찌르기 받음 |
| inquiry_reply | 문의 답변 |
| link_deleted | 공유 링크 삭제됨 |
| modification_request | 시간 수정 요청 |
| modification_approved | 수정 요청 승인 |
| modification_rejected | 수정 요청 거절 |
| modification_applied | 수정 적용됨 |
| referral_accepted | 추천 수락됨 |

---

## 2. `sharedLinks` - 공유 링크

**문서 ID:** 자동 생성

| 필드 | 타입 | 설명 |
|------|------|------|
| id | String | 문서 ID (= 공유 링크 ID) |
| url | String | 링크 URL |
| title | String | 링크 제목 |
| hour | Integer | 알람 시 (0~23) |
| minute | Integer | 알람 분 (0~59) |
| repeatDays | List<int> | 반복 요일 (0=월 ~ 6=일) |
| sharedBy | String | 공유한 사람 닉네임 |
| creatorUid | String | 공유한 사람 UID |
| isLocked | Boolean | 시간 잠금 여부 (true=수정 불가) |
| languageCode | String | 공유자 언어 (en, ko, ja, zh, es) |
| viewCount | Integer | 조회수 |
| saveCount | Integer | **저장한 사람 수 (Saved by 숫자)** |
| savedBy | List<Map> | 저장한 유저 목록 [{uid, nickname, profileEmoji, country}] |
| savedByUids | List<String> | 저장한 유저 UID 목록 |
| soundId | String? | 알람 소리 ID |
| createdAt | Timestamp | 생성일 |

### 자주 쓰는 운영 작업
- **Saved by 더미 데이터:** `saveCount` 숫자 변경, `savedBy` 배열에 유저 추가
- **공유 링크 삭제:** 문서 직접 삭제
- **조회수 확인:** `viewCount` 확인

---

## 3. `modificationRequests` - 시간 수정 요청

**문서 ID:** 자동 생성

| 필드 | 타입 | 설명 |
|------|------|------|
| id | String | 요청 ID |
| sharedLinkId | String | 대상 공유 링크 ID |
| creatorUid | String | 요청자 UID |
| creatorNickname | String | 요청자 닉네임 |
| linkTitle | String | 링크 제목 |
| originalHour | Integer | 기존 시 |
| originalMinute | Integer | 기존 분 |
| originalRepeatDays | List<int> | 기존 요일 |
| newHour | Integer | 변경 요청 시 |
| newMinute | Integer | 변경 요청 분 |
| newRepeatDays | List<int> | 변경 요청 요일 |
| status | String | 상태 (pending/approved/rejected/expired) |
| votes | Map<String, String> | 투표 현황 {uid: "approved"/"rejected"/"pending"} |
| voterUids | List<String> | 투표 대상 UID 목록 |
| createdAt | Timestamp | 생성일 |
| expiresAt | Timestamp | 만료일 (생성 후 24시간) |

---

## 4. `inquiries` - 문의하기

**문서 ID:** 자동 생성

| 필드 | 타입 | 설명 |
|------|------|------|
| id | String | 문의 ID |
| userId | String | 문의자 UID |
| userNickname | String | 문의자 닉네임 |
| title | String | 문의 제목 |
| content | String | 문의 내용 |
| status | String | 상태 (pending/answered) |
| adminReply | String? | **관리자 답변 (운영에서 직접 입력)** |
| repliedAt | Timestamp? | 답변 시각 |
| createdAt | Timestamp | 문의 시각 |

### 자주 쓰는 운영 작업
- **문의 답변:** `adminReply`에 답변 입력, `status` → "answered", `repliedAt` 설정

---

## 5. `announcements` - 공지사항

**문서 ID:** 자동 생성

| 필드 | 타입 | 설명 |
|------|------|------|
| id | String | 공지 ID |
| titleKo | String | 한국어 제목 |
| titleEn | String | 영어 제목 |
| bodyKo | String | 한국어 내용 |
| bodyEn | String | 영어 내용 |
| type | String | 타입 (notice/event/update) |
| isActive | Boolean | **노출 여부 (false로 비활성화 가능)** |
| createdAt | Timestamp | 생성일 |

### 자주 쓰는 운영 작업
- **공지 추가:** 새 문서 생성, `isActive: true`
- **공지 숨김:** `isActive` → `false`

---

## 6. `recommendedLinks` - 추천 링크

**문서 ID:** 자동 생성

| 필드 | 타입 | 설명 |
|------|------|------|
| id | String | 추천 링크 ID |
| titleKo | String | 한국어 제목 |
| titleEn | String | 영어 제목 |
| url | String | 링크 URL |
| emoji | String | 이모지 |
| descriptionKo | String | 한국어 설명 |
| descriptionEn | String | 영어 설명 |
| category | String | 카테고리 (exercise, health, mindset 등) |
| order | Integer | 정렬 순서 (낮을수록 위) |
| isActive | Boolean | **노출 여부** |
| createdAt | Timestamp | 생성일 |

### 자주 쓰는 운영 작업
- **추천 링크 추가:** 새 문서 생성
- **순서 변경:** `order` 값 수정
- **숨김:** `isActive` → `false`

---

## 7. `analytics` - 분석 데이터

### 7-1. `analytics/soundStats/sounds/{soundId}`

| 필드 | 타입 | 설명 |
|------|------|------|
| soundId | String | 소리 ID |
| category | String | 카테고리 (alarm/notify) |
| isPremium | Boolean | 프리미엄 소리 여부 |
| selectCount | Integer | 총 선택 횟수 |
| createdAt | Timestamp | 최초 선택일 |
| lastSelectedAt | Timestamp | 마지막 선택일 |

### 7-2. `analytics/soundStats/daily/{YYYY-MM-DD}/sounds/{soundId}`

| 필드 | 타입 | 설명 |
|------|------|------|
| soundId | String | 소리 ID |
| category | String | 카테고리 |
| isPremium | Boolean | 프리미엄 여부 |
| count | Integer | 일일 선택 횟수 |

> ※ 알람 사운드 기능 제거로 현재 미사용(레거시). 보안 규칙상 admin 전용.

---

## 8. `users/{uid}/private/profile` - 민감정보 (본인 전용)

| 필드 | 타입 | 설명 |
|------|------|------|
| phoneNumber | String | 전화번호 (tel: 알람용) — 공개 프로필에 두면 노출되므로 분리 |
| updatedAt | Timestamp | 수정일 |

---

## 9. `verificationVideos` - 인증 영상 (UGC)

자세한 필드/규칙은 [VERIFICATION_VIDEO_SETUP.md](./VERIFICATION_VIDEO_SETUP.md) 참조.
핵심: uploaderUid/storagePath/videoUrl/expiresAt(+TTL), reports 서브컬렉션(신고).

---

## 10. `iapVerifications` - 인앱결제 검증 로그 (Cloud Functions 기록)

`functions/src/index.ts` 의 `/iap/verify` 가 기록. 계약은 [IAP_VERIFY_API_CONTRACT.md](./IAP_VERIFY_API_CONTRACT.md) 참조.

---

## 회원 탈퇴 시 삭제 범위

`FirestoreService.deleteAllUserData()` (Auth 삭제 전 호출):
users/{uid} 문서 + 서브컬렉션(notifications/blockedUsers/stats/links/private),
userStats/{uid}, 본인 verificationVideos(+Storage verifications/{uid}/*), 본인 inquiries.
sharedLinks 는 공유받은 상대의 알람 보존을 위해 유지.

---

## 이모지 키 목록 (profileEmoji 값)

**얼굴:** face_angel, face_cool, face_giggling, face_grinning, face_hugging, face_love, face_monocle, face_nerd, face_party, face_relieved, face_sleeping, face_smiling, face_smirk, face_starstruck, face_thinking, face_upsidedown

**동물:** animal_bear, animal_cat, animal_chicken, animal_cow, animal_dog, animal_fox, animal_frog, animal_koala, animal_lion, animal_monkey, animal_panda, animal_penguin, animal_pig, animal_rabbit, animal_tiger, animal_unicorn

**음식:** food_apple, food_boba, food_coffee, food_cupcake, food_donut, food_icecream, food_peach, food_pizza, food_popcorn, food_strawberry

**자연:** nature_cactus, nature_cherry_blossom, nature_clover, nature_hibiscus, nature_sunflower, nature_tulip

**아이템:** item_basketball, item_books, item_diamond, item_fire, item_gamepad, item_gift, item_guitar, item_laptop, item_muscle, item_palette, item_rocket, item_soccer, item_star, item_target, item_tennis, item_trophy
