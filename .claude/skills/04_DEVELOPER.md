# LinkPing - Developer 개발 명세서

> **작성자**: Developer (Flutter)
> **작성일**: Day 3-10
> **상태**: 개발 준비 완료 (v1.1 - Firebase & 소셜 기능 추가)
> **업데이트**: Firebase 통합, 인증, 소셜 기능 구현 코드 추가

---

## 1. 개발 환경 설정

### 사전 요구사항

```bash
# Flutter 버전 확인
flutter --version
# Flutter 3.16.0 이상 권장

# 프로젝트 생성
flutter create --org com.yourcompany linkping
cd linkping
```

### pubspec.yaml

```yaml
name: linkping
description: 저장한 링크를 알림으로 받아보세요
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

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

  # 광고
  google_mobile_ads: ^4.0.0

  # 인앱결제
  in_app_purchase: ^3.1.0

  # 유틸
  uuid: ^4.2.0
  crypto: ^3.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  hive_generator: ^2.0.1

flutter:
  uses-material-design: true
```

---

## 2. 핵심 코드 구현

### 2.1 main.dart

```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../skills/app.dart';
import '../../skills/data/models/link_reminder.dart';
import '../../skills/services/notification_service.dart';
import '../../skills/services/deeplink_service.dart';
import '../../skills/firebase_options.dart';

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

### 2.2 app.dart

```dart
// lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../skills/core/theme/app_theme.dart';
import '../../skills/router/app_router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'LinkPing',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### 2.3 테마 설정

```dart
// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6750A4);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
    );
  }
}
```

```dart
// lib/core/theme/spacing.dart

class Spacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}
```

### 2.4 상수

```dart
// lib/core/constants/app_constants.dart

class AppConstants {
  static const int freeLinksLimit = 3;
  static const String adUnitIdBanner = 'ca-app-pub-xxxxx/xxxxx'; // 실제 ID로 교체
}
```

---

## 3. 데이터 레이어

### 3.1 LinkReminder 모델

```dart
// lib/data/models/link_reminder.dart

import 'package:hive/hive.dart';

part '../../skills/link_reminder.g.dart';

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
  final List<int> repeatDays; // 0=일, 1=월, ..., 6=토

  @HiveField(7)
  final bool isEnabled;

  @HiveField(8)
  final DateTime createdAt;

  LinkReminder({
    required this.id,
    required this.url,
    required this.urlHash,
    required this.title,
    required this.hour,
    required this.minute,
    required this.repeatDays,
    this.isEnabled = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  LinkReminder copyWith({
    String? id,
    String? url,
    String? urlHash,
    String? title,
    int? hour,
    int? minute,
    List<int>? repeatDays,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return LinkReminder(
      id: id ?? this.id,
      url: url ?? this.url,
      urlHash: urlHash ?? this.urlHash,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      repeatDays: repeatDays ?? this.repeatDays,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get timeString {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get repeatString {
    if (repeatDays.length == 7) return '매일';
    if (listEquals(repeatDays, [1, 2, 3, 4, 5])) return '평일';
    if (listEquals(repeatDays, [0, 6])) return '주말';

    const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
    return repeatDays.map((d) => dayNames[d]).join(', ');
  }
}

bool listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
```

### 3.2 Repository

```dart
// lib/data/repositories/link_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../models/link_reminder.dart';

final linkRepositoryProvider = Provider<LinkRepository>((ref) {
  return LinkRepository();
});

class LinkRepository {
  Box<LinkReminder> get _box => Hive.box<LinkReminder>('links');

  List<LinkReminder> getAllLinks() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  LinkReminder? getLink(String id) {
    return _box.get(id);
  }

  Future<void> saveLink(LinkReminder link) async {
    await _box.put(link.id, link);
  }

  Future<void> deleteLink(String id) async {
    await _box.delete(id);
  }
}
```

---

## 4. Firebase 통합

### 4.1 URL 해시 유틸리티

```dart
// lib/core/utils/url_hash.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';

class UrlHash {
  /// URL을 정규화하고 SHA256 해시 생성
  static String generate(String url) {
    final normalized = _normalizeUrl(url);
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

### 4.2 인증 서비스

```dart
// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

### 4.3 URL 통계 Repository

```dart
// lib/data/repositories/stats_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

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

### 4.4 사용자 프로필 Repository

```dart
// lib/data/repositories/user_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_profile.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 프로필 조회
  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserProfile.fromFirestore(doc);
    }
    return null;
  }

  /// 프로필 저장
  Future<void> saveProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set(
      profile.toFirestore(),
      SetOptions(merge: true),
    );
  }

  /// 현재 사용자 프로필 스트림
  Stream<UserProfile?> watchCurrentProfile() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserProfile.fromFirestore(doc) : null);
  }
}
```

### 4.5 공유 서비스

```dart
// lib/services/sharing_service.dart

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class SharingService {
  static final SharingService instance = SharingService._();
  SharingService._();
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

### 4.6 딥링크 서비스

```dart
// lib/services/deeplink_service.dart

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final shareDoc = await FirebaseFirestore.instance.collection('shares').add({
      'urlHash': urlHash,
      'title': title,
      'hour': hour,
      'minute': minute,
      'repeatDays': repeatDays,
      'creatorUid': FirebaseAuth.instance.currentUser?.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: 'https://linkping.page.link',
      link: Uri.parse('https://linkping.app/share/${shareDoc.id}'),
      androidParameters: const AndroidParameters(
        packageName: 'com.yourcompany.linkping',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.yourcompany.linkping',
        appStoreId: '123456789',
      ),
    );

    final shortLink = await _dynamicLinks.buildShortLink(dynamicLinkParams);
    return shortLink.shortUrl.toString();
  }

  /// 딥링크 수신 처리
  void handleDynamicLinks(Function(String shareId) onShareLink) {
    _dynamicLinks.onLink.listen((dynamicLinkData) {
      final shareId = _extractShareId(dynamicLinkData.link);
      if (shareId != null) {
        onShareLink(shareId);
      }
    });

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

## 5. 서비스 레이어

### 5.1 NotificationService

```dart
// lib/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../data/models/link_reminder.dart';
import '../../skills/url_launcher_service.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      UrlLauncherService.openUrl(payload);
    }
  }

  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleReminder(LinkReminder link) async {
    // 기존 알림 취소
    await cancelReminder(link.id);

    if (!link.isEnabled) return;

    final androidDetails = AndroidNotificationDetails(
      'linkping_reminders',
      'Link Reminders',
      channelDescription: '링크 알림',
      importance: Importance.high,
      priority: Priority.high,
      actions: [
        const AndroidNotificationAction(
          'open',
          '이동하기',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'dismiss',
          '나중에',
          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 선택된 요일마다 알림 스케줄
    for (final day in link.repeatDays) {
      final id = _generateNotificationId(link.id, day);
      final scheduledDate = _nextInstanceOfDayTime(
        day,
        link.hour,
        link.minute,
      );

      await _plugin.zonedSchedule(
        id,
        link.title,
        '탭하여 이동하기',
        scheduledDate,
        details,
        payload: link.url,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> cancelReminder(String linkId) async {
    // 모든 요일의 알림 취소 (0-6)
    for (int day = 0; day <= 6; day++) {
      final id = _generateNotificationId(linkId, day);
      await _plugin.cancel(id);
    }
  }

  int _generateNotificationId(String linkId, int dayOfWeek) {
    return linkId.hashCode.abs() % 100000 * 10 + dayOfWeek;
  }

  tz.TZDateTime _nextInstanceOfDayTime(int dayOfWeek, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // 해당 요일까지 날짜 조정
    while (scheduledDate.weekday % 7 != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // 이미 지난 시간이면 다음 주로
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }
}
```

### 4.2 UrlLauncherService

```dart
// lib/services/url_launcher_service.dart

import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static Future<bool> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }
}
```

---

## 6. Provider 레이어

### 6.1 인증 Provider

```dart
// lib/providers/auth_provider.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
```

### 6.2 사용자 프로필 Provider

```dart
// lib/providers/user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(userRepositoryProvider).watchCurrentProfile();
});
```

### 6.3 URL 통계 Provider

```dart
// lib/providers/stats_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/stats_repository.dart';

final statsRepositoryProvider = Provider<StatsRepository>((ref) => StatsRepository());

/// 여러 URL의 저장 수를 실시간으로 조회
final urlStatsProvider = StreamProvider.family<Map<String, int>, List<String>>((ref, urlHashes) {
  return ref.watch(statsRepositoryProvider).watchSaveCounts(urlHashes);
});
```

### 6.4 Links Provider (업데이트)

```dart
// lib/providers/links_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/link_reminder.dart';
import '../../data/repositories/link_repository.dart';
import '../../services/notification_service.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/url_hash.dart';
import '../../data/repositories/stats_repository.dart';

// 링크 목록
final linksProvider = StateNotifierProvider<LinksNotifier, List<LinkReminder>>((ref) {
  return LinksNotifier(ref.read(linkRepositoryProvider));
});

class LinksNotifier extends StateNotifier<List<LinkReminder>> {
  final LinkRepository _repository;
  final _uuid = const Uuid();

  LinksNotifier(this._repository) : super([]) {
    _loadLinks();
  }

  void _loadLinks() {
    state = _repository.getAllLinks();
  }

  Future<bool> addLink({
    required String url,
    required String title,
    required int hour,
    required int minute,
    required List<int> repeatDays,
  }) async {
    // URL 해시 생성
    final urlHash = UrlHash.generate(url);

    // 무료 제한 체크는 UI에서 처리
    final link = LinkReminder(
      id: _uuid.v4(),
      url: url,
      urlHash: urlHash,
      title: title,
      hour: hour,
      minute: minute,
      repeatDays: repeatDays,
    );

    await _repository.saveLink(link);
    await NotificationService.instance.scheduleReminder(link);

    // Firebase에 저장 수 증가
    final statsRepo = StatsRepository();
    await statsRepo.incrementSaveCount(urlHash);

    _loadLinks();
    return true;
  }

  Future<void> updateLink(LinkReminder link) async {
    await _repository.saveLink(link);
    await NotificationService.instance.scheduleReminder(link);
    _loadLinks();
  }

  Future<void> deleteLink(String id) async {
    final link = _repository.getLink(id);
    if (link != null) {
      // Firebase에서 저장 수 감소
      final statsRepo = StatsRepository();
      await statsRepo.decrementSaveCount(link.urlHash);
    }

    await NotificationService.instance.cancelReminder(id);
    await _repository.deleteLink(id);
    _loadLinks();
  }

  Future<void> toggleLink(String id) async {
    final link = _repository.getLink(id);
    if (link != null) {
      final updated = link.copyWith(isEnabled: !link.isEnabled);
      await updateLink(updated);
    }
  }
}

// 프리미엄 상태
final isPremiumProvider = StateProvider<bool>((ref) {
  final box = Hive.box('settings');
  return box.get('isPremium', defaultValue: false);
});

// 링크 추가 가능 여부
final canAddMoreLinksProvider = Provider<bool>((ref) {
  final links = ref.watch(linksProvider);
  final isPremium = ref.watch(isPremiumProvider);
  return isPremium || links.length < AppConstants.freeLinksLimit;
});

// 남은 무료 슬롯
final remainingFreeSlotsProvider = Provider<int>((ref) {
  final links = ref.watch(linksProvider);
  final isPremium = ref.watch(isPremiumProvider);
  if (isPremium) return -1; // 무제한
  return AppConstants.freeLinksLimit - links.length;
});
```

---

## 7. 화면 구현

### 7.1 로그인 화면

```dart
// lib/presentation/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../services/auth_service.dart';
import '../../../../core/theme/spacing.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.link, size: 80, color: Color(0xFF6750A4)),
              const SizedBox(height: Spacing.xl),
              Text(
                'LinkPing',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                '저장한 링크, 실천하자!',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.xl * 2),
              FilledButton.icon(
                onPressed: () => _signInWithGoogle(context, ref),
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: const Text('Google로 계속하기'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              const SizedBox(height: Spacing.md),
              if (Theme.of(context).platform == TargetPlatform.iOS)
                FilledButton.icon(
                  onPressed: () => _signInWithApple(context, ref),
                  icon: const Icon(Icons.apple, size: 28),
                  label: const Text('Apple로 계속하기'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                ),
              const SizedBox(height: Spacing.xl),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('나중에 할게요'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
      if (context.mounted) {
        // 프로필 설정 화면으로 이동 (프로필 없으면)
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: $e')),
        );
      }
    }
  }

  Future<void> _signInWithApple(BuildContext context, WidgetRef ref) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithApple();
      if (context.mounted) {
        // 프로필 설정 화면으로 이동
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: $e')),
        );
      }
    }
  }
}
```

### 7.2 프로필 설정 화면

```dart
// lib/presentation/screens/auth/profile_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../providers/user_provider.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/models/user_profile.dart';
import '../../../../core/theme/spacing.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  String _selectedCountry = 'KR';

  final List<Map<String, String>> _countries = [
    {'code': 'KR', 'name': '🇰🇷 대한민국'},
    {'code': 'US', 'name': '🇺🇸 United States'},
    {'code': 'JP', 'name': '🇯🇵 日本'},
    {'code': 'GB', 'name': '🇬🇧 United Kingdom'},
    {'code': 'CA', 'name': '🇨🇦 Canada'},
    {'code': 'AU', 'name': '🇦🇺 Australia'},
  ];

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 설정'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            const SizedBox(height: Spacing.lg),
            Text(
              '프로필을 설정해주세요',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: Spacing.xl),
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '닉네임',
                hintText: '운동하는민수',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '닉네임을 입력하세요';
                }
                if (value.length < 2 || value.length > 20) {
                  return '2-20자 사이로 입력하세요';
                }
                return null;
              },
            ),
            const SizedBox(height: Spacing.md),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration: const InputDecoration(
                labelText: '국가',
                prefixIcon: Icon(Icons.public),
                border: OutlineInputBorder(),
              ),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country['code'],
                  child: Text(country['name']!),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCountry = value;
                  });
                }
              },
            ),
            const SizedBox(height: Spacing.xl),
            FilledButton(
              onPressed: _saveProfile,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final profile = UserProfile(
      uid: user.uid,
      nickname: _nicknameController.text,
      country: _selectedCountry,
      createdAt: DateTime.now(),
      isPremium: false,
    );

    try {
      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.saveProfile(profile);

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    }
  }
}
```

### 7.3 HomeScreen (업데이트)

```dart
// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../providers/links_provider.dart';
import '../../../../providers/stats_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../core/theme/spacing.dart';
import '../../skills/widgets/link_card.dart';
import '../../skills/widgets/empty_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final links = ref.watch(linksProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final canAddMore = ref.watch(canAddMoreLinksProvider);
    final userProfile = ref.watch(userProfileProvider);

    // URL 해시 목록 추출
    final urlHashes = links.map((link) => link.urlHash).toList();
    final urlStats = ref.watch(urlStatsProvider(urlHashes));

    return Scaffold(
      appBar: AppBar(
        title: const Text('LinkPing'),
        actions: [
          // 사용자 프로필 표시
          if (userProfile.value != null)
            Padding(
              padding: const EdgeInsets.only(right: Spacing.sm),
              child: Center(
                child: Text(
                  userProfile.value!.nickname,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: links.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(Spacing.md),
                    itemCount: links.length,
                    itemBuilder: (context, index) {
                      final link = links[index];
                      final saveCount = urlStats.value?[link.urlHash] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Spacing.sm),
                        child: LinkCard(
                          link: link,
                          saveCount: saveCount,
                          onTap: () => context.push('/edit/${link.id}'),
                          onToggle: () {
                            ref.read(linksProvider.notifier).toggleLink(link.id);
                          },
                          onDelete: () {
                            ref.read(linksProvider.notifier).deleteLink(link.id);
                          },
                        ),
                      );
                    },
                  ),
          ),
          // 배너 광고 (프리미엄 아닐 때만)
          if (!isPremium) const BannerAdWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (canAddMore) {
            context.push('/add');
          } else {
            _showPremiumDialog(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('링크 한도 도달'),
        content: const Text(
          '무료 버전은 3개까지 등록할 수 있어요.\n'
          '프리미엄으로 업그레이드하면 무제한으로 등록할 수 있어요!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('나중에'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/settings'); // 설정 > 프리미엄 구매
            },
            child: const Text('프리미엄 보기'),
          ),
        ],
      ),
    );
  }
}
```

### 7.4 LinkCard 위젯 (업데이트)

```dart
// lib/presentation/screens/home/widgets/link_card.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../data/models/link_reminder.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../services/deeplink_service.dart';

class LinkCard extends StatelessWidget {
  final LinkReminder link;
  final int saveCount;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const LinkCard({
    super.key,
    required this.link,
    required this.saveCount,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key(link.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.md),
        color: colorScheme.error,
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('삭제'),
            content: const Text('이 링크를 삭제할까요?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('삭제'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: link.isEnabled
                ? colorScheme.outline
                : colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        link.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: link.isEnabled ? null : colorScheme.outline,
                        ),
                      ),
                    ),
                    Switch(
                      value: link.isEnabled,
                      onChanged: (_) => onToggle(),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      '${link.repeatString} ${link.timeString}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.link,
                      size: 16,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        Uri.parse(link.url).host,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (saveCount > 0) ...[
                  const SizedBox(height: Spacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        '$saveCount명이 저장함',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        // 공유 버튼 (스와이프 시 표시)
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareLink(context),
          ),
        ],
      ),
    );
  }

  Future<void> _shareLink(BuildContext context) async {
    try {
      final deeplinkService = DeeplinkService();
      final shareUrl = await deeplinkService.createShareLink(
        urlHash: link.urlHash,
        title: link.title,
        hour: link.hour,
        minute: link.minute,
        repeatDays: link.repeatDays,
      );

      // 공유 다이얼로그 표시
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('친구 초대'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('이 링크를 친구와 공유하세요!'),
                const SizedBox(height: Spacing.md),
                SelectableText(
                  shareUrl,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('닫기'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('공유 실패: $e')),
        );
      }
    }
  }
}
```

### 7.5 AddLinkScreen (업데이트)

```dart
// lib/presentation/screens/add_link/add_link_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../providers/links_provider.dart';
import '../../../../services/url_launcher_service.dart';
import '../../../../core/theme/spacing.dart';

class AddLinkScreen extends ConsumerStatefulWidget {
  const AddLinkScreen({super.key, this.initialUrl});

  final String? initialUrl;

  @override
  ConsumerState<AddLinkScreen> createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends ConsumerState<AddLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();
  final Set<int> _selectedDays = {1, 2, 3, 4, 5, 6, 0}; // 기본: 매일

  @override
  void initState() {
    super.initState();
    // 공유로 받은 URL이 있으면 자동 입력
    if (widget.initialUrl != null) {
      _urlController.text = widget.initialUrl!;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('링크 추가'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            // URL 입력
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: '링크 URL',
                hintText: 'https://...',
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (!UrlLauncherService.isValidUrl(value)) {
                  return '올바른 URL을 입력하세요';
                }
                return null;
              },
            ),
            const SizedBox(height: Spacing.md),

            // 제목 입력
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '알림 제목',
                hintText: '아침 스트레칭 하자!',
                prefixIcon: Icon(Icons.notifications),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '제목을 입력하세요';
                }
                return null;
              },
            ),
            const SizedBox(height: Spacing.md),

            // 시간 선택
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('알림 시간'),
              subtitle: Text(_selectedTime.format(context)),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              onTap: _selectTime,
            ),
            const SizedBox(height: Spacing.md),

            // 반복 요일
            Text(
              '반복',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Spacing.sm),
            _buildQuickSelect(),
            const SizedBox(height: Spacing.sm),
            _buildDayChips(),
            const SizedBox(height: Spacing.xl),

            // 저장 버튼
            FilledButton(
              onPressed: _save,
              child: const Padding(
                padding: EdgeInsets.all(Spacing.md),
                child: Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSelect() {
    return Wrap(
      spacing: Spacing.sm,
      children: [
        ChoiceChip(
          label: const Text('매일'),
          selected: _selectedDays.length == 7,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedDays.addAll([0, 1, 2, 3, 4, 5, 6]);
              }
            });
          },
        ),
        ChoiceChip(
          label: const Text('평일'),
          selected: _selectedDays.length == 5 &&
              _selectedDays.containsAll([1, 2, 3, 4, 5]),
          onSelected: (selected) {
            setState(() {
              _selectedDays.clear();
              if (selected) {
                _selectedDays.addAll([1, 2, 3, 4, 5]);
              }
            });
          },
        ),
        ChoiceChip(
          label: const Text('주말'),
          selected:
              _selectedDays.length == 2 && _selectedDays.containsAll([0, 6]),
          onSelected: (selected) {
            setState(() {
              _selectedDays.clear();
              if (selected) {
                _selectedDays.addAll([0, 6]);
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildDayChips() {
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    return Wrap(
      spacing: Spacing.xs,
      children: List.generate(7, (index) {
        return FilterChip(
          label: Text(days[index]),
          selected: _selectedDays.contains(index),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedDays.add(index);
              } else {
                _selectedDays.remove(index);
              }
            });
          },
        );
      }),
    );
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('반복 요일을 선택하세요')),
      );
      return;
    }

    await ref.read(linksProvider.notifier).addLink(
          url: _urlController.text.trim(),
          title: _titleController.text.trim(),
          hour: _selectedTime.hour,
          minute: _selectedTime.minute,
          repeatDays: _selectedDays.toList()..sort(),
        );

    if (mounted) {
      context.pop();
    }
  }
}
```

### 7.6 공유 받기 처리

```dart
// lib/app.dart에 추가

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../../skills/services/sharing_service.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    _handleSharing();
  }

  void _handleSharing() {
    final sharingService = SharingService.instance;

    // 앱 시작 시 공유 데이터 확인
    sharingService.getInitialSharing().then((files) {
      final url = sharingService.extractUrl(files);
      if (url != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final router = ref.read(routerProvider);
          router.push('/add?url=${Uri.encodeComponent(url)}');
        });
      }
    });

    // 앱 실행 중 공유 받기
    sharingService.mediaStream.listen((files) {
      final url = sharingService.extractUrl(files);
      if (url != null) {
        final router = ref.read(routerProvider);
        router.push('/add?url=${Uri.encodeComponent(url)}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'LinkPing',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### 7.7 공유 링크 가져오기 화면

```dart
// lib/presentation/screens/share_import/share_import_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../providers/links_provider.dart';
import '../../../../core/theme/spacing.dart';

class ShareImportScreen extends ConsumerStatefulWidget {
  const ShareImportScreen({super.key, required this.shareId});

  final String shareId;

  @override
  ConsumerState<ShareImportScreen> createState() => _ShareImportScreenState();
}

class _ShareImportScreenState extends ConsumerState<ShareImportScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _shareData;

  @override
  void initState() {
    super.initState();
    _loadShareData();
  }

  Future<void> _loadShareData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('shares')
          .doc(widget.shareId)
          .get();

      if (doc.exists) {
        setState(() {
          _shareData = doc.data();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('공유 링크를 찾을 수 없습니다')),
          );
          context.pop();
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $e')),
        );
      }
    }
  }

  Future<void> _importLink() async {
    if (_shareData == null) return;

    // URL 해시로 실제 URL은 가져올 수 없으므로, 사용자에게 입력 요청
    // 또는 공유 데이터에 URL이 포함되어 있다면 사용
    // 여기서는 간단히 링크 추가 화면으로 이동
    if (mounted) {
      context.push('/add');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_shareData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('공유 링크')),
        body: const Center(child: Text('링크를 찾을 수 없습니다')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('친구가 공유한 링크')),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _shareData!['title'] ?? '제목 없음',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      '${_shareData!['hour']}:${_shareData!['minute'].toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            FilledButton(
              onPressed: _importLink,
              child: const Padding(
                padding: EdgeInsets.all(Spacing.md),
                child: Text('내 링크에 추가하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 7.8 라우터 설정 (업데이트)

```dart
// lib/router/app_router.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/profile_setup_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/add_link/add_link_screen.dart';
import '../../presentation/screens/edit_link/edit_link_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/share_import/share_import_screen.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authProvider);
  final userProfile = ref.watch(userProfileProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isLoggedIn = authState.value != null;
      final hasProfile = userProfile.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isOnboarding = state.matchedLocation == '/onboarding';

      // 온보딩 체크
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
      if (!hasSeenOnboarding && !isOnboarding) {
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

---

## 8. 데이터 모델 추가

### 8.1 UserProfile 모델

```dart
// lib/data/models/user_profile.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String nickname;
  final String country;
  final DateTime createdAt;
  final bool isPremium;

  UserProfile({
    required this.uid,
    required this.nickname,
    required this.country,
    required this.createdAt,
    this.isPremium = false,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      nickname: data['nickname'] ?? '',
      country: data['country'] ?? 'US',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPremium: data['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nickname': nickname,
      'country': country,
      'createdAt': Timestamp.fromDate(createdAt),
      'isPremium': isPremium,
    };
  }
}
```

---

## 9. 광고 구현

```dart
// lib/presentation/widgets/banner_ad_widget.dart

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/constants/app_constants.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AppConstants.adUnitIdBanner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox(height: 50);
    }

    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      width: _bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
```

---

## 10. 개발 체크리스트

### Week 1

#### Day 3: Firebase & 인증
- [ ] Firebase 프로젝트 생성 및 설정
- [ ] Firebase 패키지 설치
- [ ] AuthService 구현 (Google, Apple 로그인)
- [ ] 로그인 화면 구현
- [ ] 프로필 설정 화면 구현
- [ ] UserProfile 모델 구현

#### Day 4: 로컬 기능
- [ ] 데이터 모델 구현 (LinkReminder with urlHash)
- [ ] Hive 설정 및 Repository 구현
- [ ] NotificationService 구현
- [ ] URL 해시 유틸리티 구현

#### Day 5: UI 구현
- [ ] Provider 구현 (Links, Auth, User, Stats)
- [ ] HomeScreen 구현 (저장 수 표시 포함)
- [ ] AddLinkScreen 구현 (공유 받기 지원)
- [ ] EditLinkScreen 구현
- [ ] LinkCard 위젯 업데이트 (공유 버튼 추가)

### Week 2

#### Day 6: 소셜 기능
- [ ] URL 통계 Repository 구현
- [ ] Stats Provider 구현
- [ ] 저장 수 표시 UI 통합
- [ ] 공유 링크 생성 기능

#### Day 7: 공유 & 딥링크
- [ ] 공유 받기 서비스 구현
- [ ] 딥링크 서비스 구현
- [ ] 공유 링크 가져오기 화면
- [ ] 라우터 설정 업데이트

#### Day 8: 설정 & 프리미엄
- [ ] SettingsScreen 구현
- [ ] 프리미엄 구매 연동
- [ ] 광고 연동
- [ ] 로그아웃 기능

#### Day 9: 테스트 & 버그 수정
- [ ] 전체 기능 테스트
- [ ] 버그 수정
- [ ] 성능 최적화

#### Day 10: 배포 준비
- [ ] 스토어 준비
- [ ] 스크린샷 준비
- [ ] 앱 설명 작성

### 코드 생성 명령
```bash
# Hive, Riverpod 코드 생성
dart run build_runner build --delete-conflicting-outputs

# Firebase 설정 파일 생성
flutterfire configure
```

### Firebase 설정 가이드
```bash
# 1. Firebase CLI 설치
npm install -g firebase-tools

# 2. Firebase 프로젝트 생성 (웹 콘솔에서)
# https://console.firebase.google.com

# 3. FlutterFire CLI 설치
dart pub global activate flutterfire_cli

# 4. Firebase 프로젝트 연결
flutterfire configure

# 5. Android/iOS 설정 확인
# - Android: android/app/google-services.json
# - iOS: ios/Runner/GoogleService-Info.plist
```

---

## 11. 테스트 시나리오

| # | 시나리오 | 예상 결과 |
|---|----------|-----------|
| 1 | 소셜 로그인 (Google/Apple) | 인증 성공, 프로필 설정 화면 이동 |
| 2 | 프로필 설정 | Firestore에 저장, 홈 화면 이동 |
| 3 | 링크 추가 | 목록에 표시, 알림 스케줄, 저장 수 증가 |
| 4 | 저장 수 표시 | "N명이 저장함" 표시 |
| 5 | 알림 받기 | 지정 시간에 알림 표시 |
| 6 | 알림 탭 | 해당 URL 앱/브라우저 열림 |
| 7 | 토글 OFF | 알림 취소됨 |
| 8 | 링크 삭제 | 목록에서 제거, 알림 취소, 저장 수 감소 |
| 9 | 4번째 링크 추가 (무료) | 프리미엄 유도 다이얼로그 |
| 10 | 외부 앱에서 공유 | LinkPing 앱 열림, URL 자동 입력 |
| 11 | 친구 초대 링크 클릭 | 공유 링크 가져오기 화면 표시 |
| 12 | 비회원 모드 | 로컬 기능만 사용, 소셜 기능 비활성 |
