# LinkPing - Architect 아키텍처 설계서

> **작성자**: Architect (시스템 설계)
> **작성일**: Day 2
> **상태**: 설계 완료 (v1.1 - Firebase 추가)
> **업데이트**: 소셜 기능을 위한 Firebase 백엔드 추가

---

## 1. 기술 스택 결정

### 선택된 스택

| 영역 | 기술 | 선택 이유 |
|------|------|-----------|
| **Framework** | Flutter 3.x | 크로스 플랫폼, 빠른 개발 |
| **상태관리** | Riverpod 2.x | 심플, 타입 안전 |
| **로컬 저장** | Hive | 빠름, NoSQL, 간단 |
| **백엔드** | **Firebase** | 무료 한도 넉넉, 빠른 개발 |
| **인증** | Firebase Auth | 소셜 로그인 간편 |
| **DB** | Cloud Firestore | 실시간, NoSQL |
| **알림** | flutter_local_notifications | 로컬 알림 |
| **URL 실행** | url_launcher | 공식 패키지 |
| **공유 받기** | receive_sharing_intent | 외부 앱에서 공유 |
| **딥링크** | Firebase Dynamic Links | 친구 초대 |
| **광고** | google_mobile_ads | AdMob 공식 |
| **인앱결제** | in_app_purchase | 공식 패키지 |

### 백엔드 구조 (업데이트)

```
✅ Firebase 사용 (서버리스 백엔드)

🔥 핵심: 별도 서버 구축 불필요!
- Firebase = Google이 관리하는 클라우드 서비스
- Flutter 앱에서 직접 Firebase SDK로 접근
- Express, Django, Spring Boot 같은 서버 프레임워크 불필요

Firebase 서비스:
├── Authentication: 소셜 로그인 (Google, Apple)
├── Firestore: 사용자 프로필, URL 저장 수 카운트
├── Dynamic Links: 친구 초대 딥링크
└── Analytics: 이벤트 추적

로컬 저장 (Hive):
├── 링크 목록 (민감 데이터 = 로컬)
├── 알림 설정
└── 앱 설정

원칙:
- URL 원본은 서버에 저장 X (개인정보)
- URL 해시만 저장 (저장 수 카운트용)
- 링크 데이터는 로컬 우선
```

### 🔍 Firebase vs 전통적인 백엔드 서버

| 구분 | Firebase (서버리스) | 전통적인 서버 (Express/Django) |
|------|---------------------|-------------------------------|
| **서버 구축** | ❌ 불필요 | ✅ 필요 (AWS EC2, Heroku 등) |
| **프레임워크** | ❌ 불필요 | ✅ Express.js, Django, Spring 등 |
| **데이터베이스** | Firestore (자동 관리) | MySQL, PostgreSQL (별도 설정) |
| **인증** | Firebase Auth (내장) | JWT, Passport.js 등 직접 구현 |
| **배포** | 자동 (Google 관리) | 서버에 직접 배포 필요 |
| **비용** | 사용량 기반 (무료 한도) | 서버 비용 + 관리 비용 |
| **확장성** | 자동 확장 | 수동 확장 필요 |

### 📱 LinkPing의 아키텍처

```
┌─────────────────────────────────────────┐
│         Flutter 앱 (클라이언트)          │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  Firebase SDK (SDK만 설치)      │   │
│  │  - firebase_auth                │   │
│  │  - cloud_firestore              │   │
│  │  - firebase_dynamic_links       │   │
│  └─────────────────────────────────┘   │
└──────────────┬──────────────────────────┘
               │ HTTPS (인터넷)
               ▼
┌─────────────────────────────────────────┐
│      Firebase (Google 클라우드)          │
│  ┌──────────┐  ┌──────────┐  ┌──────┐ │
│  │  Auth    │  │ Firestore │  │Links │ │
│  │ (서버)   │  │  (DB)     │  │(서버)│ │
│  └──────────┘  └──────────┘  └──────┘ │
│                                         │
│  ⚡ 자동 관리, 자동 확장, 자동 백업     │
└─────────────────────────────────────────┘

❌ 이런 건 없음:
- Express.js 서버
- Django 서버  
- Node.js 서버
- AWS EC2 인스턴스
- 서버 배포 작업
```

### 💡 왜 Firebase를 선택했나?

```
✅ 장점:
1. 빠른 개발: 서버 구축 시간 절약 (2주 일정에 적합)
2. 무료 한도: MAU 10K까지 충분히 무료
3. 자동 확장: 사용자 증가해도 자동 처리
4. 보안: Google이 관리하는 보안
5. 실시간: Firestore 실시간 동기화

⚠️ 단점:
1. 벤더 종속: Google에 의존
2. 복잡한 쿼리 제한: SQL보다 제한적
3. 비용 증가 시: 사용량 많아지면 비용 증가

📊 LinkPing에 적합한 이유:
- 가벼운 소셜 기능만 필요
- 복잡한 비즈니스 로직 없음
- 빠른 MVP 개발 필요
- 무료로 시작 가능
```

---

## 2. 백엔드 아키텍처 이해하기

### 🔥 핵심 개념: Firebase = 서버리스 백엔드

**중요: 별도 서버 구축 불필요!**

```
❌ 이런 건 안 해도 됨:
- Express.js 서버 만들기
- Django 서버 만들기
- Node.js 서버 만들기
- AWS EC2 인스턴스 구축
- 서버 배포 작업
- 데이터베이스 서버 설정

✅ 이렇게 하면 됨:
1. Firebase 프로젝트 생성 (웹 콘솔에서)
2. Flutter 앱에 Firebase SDK 추가
3. 코드에서 Firebase API 호출
끝!
```

### 📊 Firebase vs 전통적인 백엔드

| 구분 | Firebase (서버리스) | 전통적인 서버 (Express/Django) |
|------|---------------------|-------------------------------|
| **서버 구축** | ❌ 불필요 | ✅ 필요 (AWS EC2, Heroku 등) |
| **프레임워크** | ❌ 불필요 | ✅ Express.js, Django, Spring 등 |
| **데이터베이스** | Firestore (자동 관리) | MySQL, PostgreSQL (별도 설정) |
| **인증** | Firebase Auth (내장) | JWT, Passport.js 등 직접 구현 |
| **배포** | 자동 (Google 관리) | 서버에 직접 배포 필요 |
| **비용** | 사용량 기반 (무료 한도) | 서버 비용 + 관리 비용 |
| **확장성** | 자동 확장 | 수동 확장 필요 |

### 🏗️ LinkPing의 실제 구조

```
┌─────────────────────────────────────────┐
│      Flutter 앱 (당신이 만드는 것)       │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  Firebase SDK (패키지만 설치)   │   │
│  │  - firebase_auth                │   │
│  │  - cloud_firestore              │   │
│  │  - firebase_dynamic_links       │   │
│  └─────────────────────────────────┘   │
│                                         │
│  코드 예시:                             │
│  await FirebaseAuth.instance           │
│    .signInWithGoogle();                │
│                                         │
│  await FirebaseFirestore.instance      │
│    .collection('users')                │
│    .doc(uid)                           │
│    .set({nickname: '민수'});           │
└──────────────┬──────────────────────────┘
               │ HTTPS (인터넷)
               ▼
┌─────────────────────────────────────────┐
│   Firebase (Google이 관리하는 클라우드) │
│                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────┐ │
│  │  Auth    │  │ Firestore│  │Links │ │
│  │ (서버)   │  │  (DB)     │  │(서버)│ │
│  └──────────┘  └──────────┘  └──────┘ │
│                                         │
│  ⚡ 자동 관리, 자동 확장, 자동 백업     │
│  💰 무료 한도: MAU 10K까지 충분         │
└─────────────────────────────────────────┘

❌ 이런 건 없음:
- Express.js 서버 코드
- Django 서버 코드
- Node.js 서버 코드
- AWS EC2 인스턴스
- 서버 배포 작업
```

### 💡 왜 Firebase를 선택했나?

```
✅ 장점:
1. 빠른 개발: 서버 구축 시간 절약 (2주 일정에 적합)
2. 무료 한도: MAU 10K까지 충분히 무료
3. 자동 확장: 사용자 증가해도 자동 처리
4. 보안: Google이 관리하는 보안
5. 실시간: Firestore 실시간 동기화

⚠️ 단점:
1. 벤더 종속: Google에 의존
2. 복잡한 쿼리 제한: SQL보다 제한적
3. 비용 증가 시: 사용량 많아지면 비용 증가

📊 LinkPing에 적합한 이유:
- 가벼운 소셜 기능만 필요
- 복잡한 비즈니스 로직 없음
- 빠른 MVP 개발 필요
- 무료로 시작 가능
```

### 🔄 실제 동작 흐름

```
1. 사용자가 "Google로 로그인" 버튼 클릭
   ↓
2. Flutter 앱에서 Firebase SDK 호출
   await FirebaseAuth.instance.signInWithGoogle()
   ↓
3. Firebase가 Google과 통신 (당신의 서버 없음!)
   ↓
4. 인증 완료, 사용자 정보 반환
   ↓
5. Flutter 앱에서 Firestore에 프로필 저장
   await FirebaseFirestore.instance
     .collection('users')
     .doc(uid)
     .set({nickname: '민수'})
   ↓
6. Firebase가 자동으로 저장 (당신의 DB 없음!)
```

---

## 3. 시스템 아키텍처

### 전체 구조

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
              │ 앱 설정      │        │  - urlStats │   │
              └─────────────┘        └─────────────┘   │
                                                       │
                                     ┌─────────────────▼─┐
                                     │  Firebase Auth    │
                                     │  - Google         │
                                     │  - Apple          │
                                     └───────────────────┘
```

---

## 3. 프로젝트 구조 (업데이트)

```
linkping/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── spacing.dart
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   └── utils/
│   │       ├── url_validator.dart
│   │       └── url_hash.dart          # URL 해시 생성
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── link_reminder.dart     # 로컬 링크 모델
│   │   │   ├── user_profile.dart      # 사용자 프로필 (신규)
│   │   │   └── url_stats.dart         # URL 통계 (신규)
│   │   └── repositories/
│   │       ├── link_repository.dart   # 로컬 저장소
│   │       ├── auth_repository.dart   # 인증 (신규)
│   │       └── stats_repository.dart  # URL 통계 (신규)
│   │
│   ├── services/
│   │   ├── notification_service.dart
│   │   ├── url_launcher_service.dart
│   │   ├── auth_service.dart          # Firebase 인증 (신규)
│   │   ├── sharing_service.dart       # 공유 받기 (신규)
│   │   ├── deeplink_service.dart      # 딥링크 (신규)
│   │   └── purchase_service.dart
│   │
│   ├── providers/
│   │   ├── links_provider.dart
│   │   ├── auth_provider.dart         # 인증 상태 (신규)
│   │   ├── user_provider.dart         # 사용자 정보 (신규)
│   │   ├── stats_provider.dart        # URL 통계 (신규)
│   │   ├── settings_provider.dart
│   │   └── premium_provider.dart
│   │
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── onboarding/            # 온보딩 (신규)
│   │   │   │   └── onboarding_screen.dart
│   │   │   ├── auth/                  # 인증 (신규)
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── profile_setup_screen.dart
│   │   │   ├── home/
│   │   │   │   ├── home_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── link_card.dart # 저장 수 표시 추가
│   │   │   │       └── empty_state.dart
│   │   │   ├── add_link/
│   │   │   │   └── add_link_screen.dart
│   │   │   ├── edit_link/
│   │   │   │   └── edit_link_screen.dart
│   │   │   └── settings/
│   │   │       └── settings_screen.dart
│   │   └── widgets/
│   │       ├── premium_banner.dart
│   │       └── share_button.dart      # 공유 버튼 (신규)
│   │
│   └── router/
│       └── app_router.dart
│
├── firebase_options.dart              # FlutterFire 설정
├── pubspec.yaml
└── README.md
```

---

## 4. 데이터 모델 (업데이트)

### LinkReminder 모델 (로컬)

```dart
// lib/data/models/link_reminder.dart

@HiveType(typeId: 0)
class LinkReminder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String urlHash;        // URL 해시 (통계 조회용)

  @HiveField(3)
  final String title;

  @HiveField(4)
  final int hour;

  @HiveField(5)
  final int minute;

  @HiveField(6)
  final List<int> repeatDays;

  @HiveField(7)
  final bool isEnabled;

  @HiveField(8)
  final DateTime createdAt;

  // ...
}
```

### UserProfile 모델 (Firestore)

```dart
// lib/data/models/user_profile.dart

class UserProfile {
  final String uid;
  final String nickname;
  final String country;        // 국가 코드 (KR, US, JP, ...)
  final DateTime createdAt;
  final bool isPremium;

  // Firestore 변환
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      nickname: data['nickname'] ?? '',
      country: data['country'] ?? 'US',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isPremium: data['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nickname': nickname,
      'country': country,
      'createdAt': FieldValue.serverTimestamp(),
      'isPremium': isPremium,
    };
  }
}
```

### UrlStats 모델 (Firestore)

```dart
// lib/data/models/url_stats.dart

class UrlStats {
  final String urlHash;        // URL 해시 (document ID)
  final int saveCount;         // 저장한 사용자 수
  final DateTime lastUpdated;

  factory UrlStats.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UrlStats(
      urlHash: doc.id,
      saveCount: data['saveCount'] ?? 0,
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
```

---

## 5. Firestore 스키마

### 컬렉션 구조

```
firestore/
├── users/                         # 사용자 프로필
│   └── {uid}/
│       ├── nickname: string
│       ├── country: string        # "KR", "US", "JP", ...
│       ├── createdAt: timestamp
│       └── isPremium: boolean
│
├── urlStats/                      # URL별 저장 통계
│   └── {urlHash}/                 # SHA256(url)
│       ├── saveCount: number      # 저장한 사용자 수
│       └── lastUpdated: timestamp
│
└── shares/                        # 공유 링크 (딥링크용)
    └── {shareId}/
        ├── urlHash: string
        ├── title: string
        ├── creatorUid: string
        ├── hour: number
        ├── minute: number
        ├── repeatDays: array
        └── createdAt: timestamp
```

### 보안 규칙

```javascript
// firestore.rules

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // 사용자 프로필: 본인만 읽기/쓰기
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }

    // URL 통계: 로그인 사용자만 읽기, 쓰기는 함수로
    match /urlStats/{urlHash} {
      allow read: if request.auth != null;
      // 쓰기는 Cloud Functions 또는 increment만 허용
      allow update: if request.auth != null
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly(['saveCount', 'lastUpdated']);
    }

    // 공유 링크: 누구나 읽기, 로그인 사용자만 생성
    match /shares/{shareId} {
      allow read: if true;
      allow create: if request.auth != null;
    }
  }
}
```

---

## 6. 인증 흐름

### 소셜 로그인

```dart
// lib/services/auth_service.dart

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google 로그인
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  // Apple 로그인
  Future<UserCredential?> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return await _auth.signInWithCredential(oauthCredential);
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 현재 사용자
  User? get currentUser => _auth.currentUser;

  // 인증 상태 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
```

### 프로필 설정 흐름

```
┌─────────────┐
│  앱 시작    │
└──────┬──────┘
       │
       ▼
┌─────────────┐     No      ┌─────────────┐
│ 로그인 상태? │────────────▶│  로그인 화면 │
└──────┬──────┘             └──────┬──────┘
       │ Yes                       │
       ▼                           ▼
┌─────────────┐     No      ┌─────────────┐
│ 프로필 있음? │────────────▶│ 프로필 설정  │
└──────┬──────┘             │ (닉네임,국가)│
       │ Yes                └──────┬──────┘
       │                           │
       └───────────┬───────────────┘
                   ▼
            ┌─────────────┐
            │    홈 화면   │
            └─────────────┘
```

---

## 7. URL 통계 시스템

### URL 해시 생성

```dart
// lib/core/utils/url_hash.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';

class UrlHash {
  /// URL을 정규화하고 SHA256 해시 생성
  static String generate(String url) {
    // URL 정규화 (소문자, 트레일링 슬래시 제거 등)
    final normalized = _normalizeUrl(url);
    // SHA256 해시
    final bytes = utf8.encode(normalized);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16); // 앞 16자만 사용
  }

  static String _normalizeUrl(String url) {
    var uri = Uri.parse(url.toLowerCase());
    // 쿼리 파라미터 중 트래킹 관련 제거 (utm_ 등)
    final cleanParams = Map<String, String>.from(uri.queryParameters)
      ..removeWhere((key, _) => key.startsWith('utm_'));
    uri = uri.replace(queryParameters: cleanParams.isEmpty ? null : cleanParams);
    // 트레일링 슬래시 제거
    var path = uri.path;
    if (path.endsWith('/') && path.length > 1) {
      path = path.substring(0, path.length - 1);
    }
    return '${uri.host}$path${uri.hasQuery ? '?${uri.query}' : ''}';
  }
}
```

### 저장 수 업데이트

```dart
// lib/data/repositories/stats_repository.dart

class StatsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 링크 저장 시 카운트 증가
  Future<void> incrementSaveCount(String urlHash) async {
    final docRef = _firestore.collection('urlStats').doc(urlHash);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);

      if (doc.exists) {
        transaction.update(docRef, {
          'saveCount': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.set(docRef, {
          'saveCount': 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  /// 링크 삭제 시 카운트 감소
  Future<void> decrementSaveCount(String urlHash) async {
    final docRef = _firestore.collection('urlStats').doc(urlHash);

    await docRef.update({
      'saveCount': FieldValue.increment(-1),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  /// 저장 수 조회
  Future<int> getSaveCount(String urlHash) async {
    final doc = await _firestore.collection('urlStats').doc(urlHash).get();
    if (doc.exists) {
      return doc.data()?['saveCount'] ?? 0;
    }
    return 0;
  }

  /// 여러 URL 저장 수 일괄 조회
  Stream<Map<String, int>> watchSaveCounts(List<String> urlHashes) {
    if (urlHashes.isEmpty) return Stream.value({});

    return _firestore
        .collection('urlStats')
        .where(FieldPath.documentId, whereIn: urlHashes)
        .snapshots()
        .map((snapshot) {
          return Map.fromEntries(
            snapshot.docs.map((doc) => MapEntry(doc.id, doc.data()['saveCount'] ?? 0)),
          );
        });
  }
}
```

---

## 8. 공유 기능

### 외부 앱에서 공유 받기

```dart
// lib/services/sharing_service.dart

class SharingService {
  static final _sharingIntent = ReceiveSharingIntent.instance;

  /// 공유 데이터 스트림
  Stream<List<SharedMediaFile>> get mediaStream =>
      _sharingIntent.getMediaStream();

  /// 앱 시작 시 공유 데이터 확인
  Future<List<SharedMediaFile>> getInitialSharing() async {
    return await _sharingIntent.getInitialMedia();
  }

  /// URL 추출
  String? extractUrl(List<SharedMediaFile> files) {
    for (final file in files) {
      if (file.type == SharedMediaType.url || file.type == SharedMediaType.text) {
        final text = file.path;
        // URL 추출 (정규식)
        final urlRegex = RegExp(r'https?://[^\s]+');
        final match = urlRegex.firstMatch(text);
        if (match != null) {
          return match.group(0);
        }
      }
    }
    return null;
  }
}
```

### 친구 초대 딥링크

```dart
// lib/services/deeplink_service.dart

class DeeplinkService {
  final FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;

  /// 공유 링크 생성
  Future<String> createShareLink({
    required String urlHash,
    required String title,
    required int hour,
    required int minute,
    required List<int> repeatDays,
  }) async {
    // Firestore에 공유 데이터 저장
    final shareDoc = await FirebaseFirestore.instance.collection('shares').add({
      'urlHash': urlHash,
      'title': title,
      'hour': hour,
      'minute': minute,
      'repeatDays': repeatDays,
      'creatorUid': FirebaseAuth.instance.currentUser?.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 다이나믹 링크 생성
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: 'https://linkping.page.link',
      link: Uri.parse('https://linkping.app/share/${shareDoc.id}'),
      androidParameters: const AndroidParameters(
        packageName: 'com.yourcompany.linkping',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.yourcompany.linkping',
        appStoreId: '123456789', // 실제 앱스토어 ID
      ),
    );

    final shortLink = await _dynamicLinks.buildShortLink(dynamicLinkParams);
    return shortLink.shortUrl.toString();
  }

  /// 딥링크 수신 처리
  void handleDynamicLinks(Function(String shareId) onShareLink) {
    // 앱이 열려있을 때
    _dynamicLinks.onLink.listen((dynamicLinkData) {
      final shareId = _extractShareId(dynamicLinkData.link);
      if (shareId != null) {
        onShareLink(shareId);
      }
    });

    // 앱 시작 시
    _dynamicLinks.getInitialLink().then((dynamicLinkData) {
      if (dynamicLinkData != null) {
        final shareId = _extractShareId(dynamicLinkData.link);
        if (shareId != null) {
          onShareLink(shareId);
        }
      }
    });
  }

  String? _extractShareId(Uri link) {
    final pathSegments = link.pathSegments;
    if (pathSegments.length >= 2 && pathSegments[0] == 'share') {
      return pathSegments[1];
    }
    return null;
  }
}
```

---

## 9. 화면 흐름 (업데이트)

### go_router 설정

```dart
// lib/router/app_router.dart

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authProvider);
  final userProfile = ref.watch(userProfileProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final hasProfile = userProfile.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isOnboarding = state.matchedLocation == '/onboarding';

      // 온보딩 체크 (첫 실행)
      if (!_hasSeenOnboarding() && !isOnboarding) {
        return '/onboarding';
      }

      // 비로그인 상태에서 인증 필요 페이지 접근 시
      if (!isLoggedIn && !isAuthRoute && state.matchedLocation != '/') {
        return '/auth/login';
      }

      // 로그인했지만 프로필 없을 때
      if (isLoggedIn && !hasProfile && state.matchedLocation != '/auth/profile') {
        return '/auth/profile';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/profile',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) {
          final url = state.uri.queryParameters['url'];
          return AddLinkScreen(initialUrl: url);
        },
      ),
      GoRoute(
        path: '/edit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditLinkScreen(linkId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/share/:shareId',
        builder: (context, state) {
          final shareId = state.pathParameters['shareId']!;
          return ShareImportScreen(shareId: shareId);
        },
      ),
    ],
  );
}
```

### 화면 전환

```
┌───────────────┐
│   Onboarding  │ (첫 실행)
└───────┬───────┘
        │
        ▼
┌───────────────┐     "나중에"     ┌───────────────┐
│    Login      │ ────────────────▶│     Home      │ (비회원 모드)
│  (소셜 로그인) │                  │  (로컬만)     │
└───────┬───────┘                  └───────────────┘
        │ 로그인 성공
        ▼
┌───────────────┐
│ Profile Setup │ (닉네임, 국가)
└───────┬───────┘
        │
        ▼
┌───────────────┐
│     Home      │ ─── [+] ───────▶ AddLink
│  (소셜 활성)  │ ─── 공유 받기 ──▶ AddLink (URL 자동)
│               │ ─── Card ──────▶ EditLink
│               │ ─── 👤 ────────▶ Settings
│               │ ─── 딥링크 ────▶ ShareImport
└───────────────┘
```

---

## 10. 의존성 (업데이트)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 상태관리
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # 로컬 저장
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_dynamic_links: ^5.4.0
  firebase_analytics: ^10.7.0

  # 소셜 로그인
  google_sign_in: ^6.2.0
  sign_in_with_apple: ^5.0.0

  # 알림
  flutter_local_notifications: ^16.0.0
  timezone: ^0.9.2

  # URL & 공유
  url_launcher: ^6.2.0
  receive_sharing_intent: ^1.6.0
  share_plus: ^7.2.0

  # 라우팅
  go_router: ^12.0.0

  # 광고 & 결제
  google_mobile_ads: ^4.0.0
  in_app_purchase: ^3.1.0

  # 유틸
  uuid: ^4.2.0
  crypto: ^3.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  hive_generator: ^2.0.1
  flutter_lints: ^3.0.0
```

---

## 11. 초기화 순서 (업데이트)

```dart
// lib/main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Hive 초기화
  await Hive.initFlutter();
  Hive.registerAdapter(LinkReminderAdapter());
  await Hive.openBox<LinkReminder>('links');
  await Hive.openBox('settings');

  // 3. 알림 서비스 초기화
  await NotificationService.instance.initialize();

  // 4. 광고 SDK 초기화
  await MobileAds.instance.initialize();

  // 5. 딥링크 핸들러 설정
  DeeplinkService().handleDynamicLinks((shareId) {
    // 공유 링크 처리 (router에서 처리)
  });

  // 6. 앱 실행
  runApp(const ProviderScope(child: App()));
}
```

---

## 12. Firebase 설정 가이드

### 12.1 Firebase 프로젝트 생성 (1회만)

```
1. Firebase 콘솔 접속
   https://console.firebase.google.com

2. "프로젝트 추가" 클릭
   - 프로젝트 이름: linkping
   - Google Analytics: 활성화 (선택)

3. 앱 추가
   - Android: 패키지 이름 입력 (com.yourcompany.linkping)
   - iOS: Bundle ID 입력 (com.yourcompany.linkping)

4. 설정 파일 다운로드
   - Android: google-services.json → android/app/
   - iOS: GoogleService-Info.plist → ios/Runner/
```

### 12.2 Flutter 프로젝트 설정

```bash
# 1. FlutterFire CLI 설치
dart pub global activate flutterfire_cli

# 2. Firebase 프로젝트 연결
flutterfire configure

# 3. 자동으로 생성됨:
# - lib/firebase_options.dart
# - android/app/google-services.json (자동)
# - ios/Runner/GoogleService-Info.plist (자동)
```

### 12.3 Firestore 보안 규칙 설정

```javascript
// Firebase 콘솔 > Firestore Database > 규칙

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // 사용자 프로필: 본인만 읽기/쓰기
    match /users/{uid} {
      allow read, write: if request.auth != null 
        && request.auth.uid == uid;
    }

    // URL 통계: 로그인 사용자만 읽기
    match /urlStats/{urlHash} {
      allow read: if request.auth != null;
      // 쓰기는 Cloud Functions 또는 increment만 허용
      allow update: if request.auth != null
        && request.resource.data.diff(resource.data)
          .affectedKeys().hasOnly(['saveCount', 'lastUpdated']);
    }

    // 공유 링크: 누구나 읽기, 로그인 사용자만 생성
    match /shares/{shareId} {
      allow read: if true;
      allow create: if request.auth != null;
    }
  }
}
```

### 12.4 인증 설정

```
Firebase 콘솔 > Authentication > Sign-in method

1. Google 로그인 활성화
   - 지원 이메일: 프로젝트 지원 이메일
   - SHA-1 인증서 (Android): keytool로 생성

2. Apple 로그인 활성화 (iOS)
   - Apple Developer 계정 필요
   - Service ID 생성
   - OAuth 설정
```

### 12.5 Dynamic Links 설정

```
Firebase 콘솔 > Dynamic Links

1. 도메인 생성
   - linkping.page.link (예시)

2. Android/iOS 앱 연결
   - Android: 패키지 이름
   - iOS: Bundle ID, App Store ID
```

---

## 13. Firebase 비용 예측

### 무료 한도 (Spark Plan)

| 서비스 | 무료 한도 | 예상 사용량 (MAU 10K) |
|--------|-----------|----------------------|
| Auth | 무제한 | 10,000 인증 |
| Firestore 읽기 | 50K/일 | ~30K/일 ✅ |
| Firestore 쓰기 | 20K/일 | ~5K/일 ✅ |
| Firestore 저장 | 1GB | ~100MB ✅ |
| Dynamic Links | 무제한 | 무제한 ✅ |

### 예상 비용

```
MAU 10,000명 기준:
- 무료 한도 내 사용 가능
- Blaze Plan 전환 시: 월 $5-10 예상

비용 최적화:
- URL 통계는 캐싱 (로컬에 저장, 주기적 동기화)
- 일괄 조회로 읽기 횟수 최소화
```

---

## 14. 체크리스트

### 아키텍처 완료 항목
- [x] 기술 스택 결정 (Firebase 추가)
- [x] 프로젝트 구조 설계
- [x] 데이터 모델 정의 (User, UrlStats 추가)
- [x] Firestore 스키마 설계
- [x] 인증 흐름 설계
- [x] URL 통계 시스템 설계
- [x] 공유 기능 설계
- [x] 알림 시스템 설계
- [x] 의존성 목록 작성
- [x] Firebase 비용 예측

### 전달 사항
- [ ] → Developer: Firebase 프로젝트 생성 가이드
- [ ] → Developer: 프로젝트 구조 및 코드 컨벤션
- [ ] → Developer: 초기화 순서 및 플랫폼 설정
