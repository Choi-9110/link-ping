import 'dart:async';

import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/foundation.dart'
    show kIsWeb, kReleaseMode, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'data/models/bookmark.dart';
import 'data/models/bookmark_folder.dart';
import 'data/models/link_reminder.dart';
import 'data/repositories/bookmark_folder_repository.dart';
import 'providers/color_theme_provider.dart';
import 'presentation/screens/main/main_shell.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/admin/admin_login_screen.dart';
import 'presentation/screens/privacy/privacy_policy_screen.dart';
import 'presentation/screens/terms/terms_of_service_screen.dart';
import 'presentation/screens/share_landing/share_landing_screen.dart';
import 'presentation/screens/web_intro/web_intro_screen.dart';
import 'providers/auth_provider.dart';
import 'services/ad_service.dart';
import 'services/bookmark_migration_service.dart';
import 'services/firestore_service.dart';
import 'services/notification_service.dart';
import 'services/poring_service.dart';
import 'services/purchase_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 위젯 빌드 실패 시 사용자에게 빨간 에러 박스 노출 방지.
  // 콘솔에는 그대로 기록되니 디버깅엔 영향 없음.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      return const SizedBox.shrink();
    }
    // 디버그/프로파일: 작은 경고 아이콘만 표시 (자리 차지 작음 → 오버플로우 방지)
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(4),
        color: Colors.orange.withValues(alpha: 0.15),
        child: const Icon(Icons.warning_amber_rounded,
            color: Colors.orange, size: 18),
      ),
    );
  };

  // 웹에서 경로 기반 URL 사용 (/privacy 대신 /#/privacy 방지)
  usePathUrlStrategy();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase 로컬 에뮬레이터 연결 (테스트용 / release 빌드에서는 절대 활성화 안 됨)
  // 실행 예: flutter run --dart-define=USE_EMULATOR=true
  // Android 에뮬레이터는 호스트가 10.0.2.2, 그 외(iOS 시뮬/웹)는 localhost
  const useEmulator = bool.fromEnvironment('USE_EMULATOR');
  if (useEmulator && !kReleaseMode) {
    // iOS 시뮬은 localhost가 IPv6(::1)로 풀려 에뮬레이터(IPv4)에 못 닿는 경우가 있어
    // 명시적으로 127.0.0.1 사용. Android 에뮬레이터만 게이트웨이 10.0.2.2 필요.
    final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : '127.0.0.1';
    // Firestore 오프라인 캐시 비활성화 — 운영 캐시가 남아있으면 emulator 와 충돌해
    // [cloud_firestore/unavailable] 가 나는 케이스가 있음.
    // Settings 는 useFirestoreEmulator 호출 전에 적용해야 함.
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
    );
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    await FirebaseStorage.instance.useStorageEmulator(host, 9199);
    debugPrint('🔥 Firebase Emulator 연결됨 (host: $host)');
  }

  // Crashlytics + Analytics (웹 제외)
  if (!kIsWeb) {
    // 크래시 리포트 자동 수집
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Analytics 초기화 (자동 수집)
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }

  // 웹이 아닐 때만 네이티브 서비스 초기화
  if (!kIsWeb) {
    // Hive 초기화
    await Hive.initFlutter();
    // 순서 중요: LinkCategory를 먼저 등록 (LinkReminder가 사용하므로)
    Hive.registerAdapter(LinkCategoryAdapter());
    Hive.registerAdapter(ReminderTimeAdapter());
    Hive.registerAdapter(LinkReminderAdapter());
    Hive.registerAdapter(BookmarkCategoryAdapter());
    Hive.registerAdapter(BookmarkAdapter());
    Hive.registerAdapter(BookmarkFolderAdapter());
    await Hive.openBox<LinkReminder>('links');
    await Hive.openBox<Bookmark>('bookmarks');
    await Hive.openBox<BookmarkFolder>(BookmarkFolderRepository.boxName);
    await Hive.openBox('settings');

    // 기존 카테고리 enum → 폴더 모델 마이그레이션 (1회성)
    await BookmarkMigrationService.runIfNeeded();

    // 서비스 병렬 초기화 (3개 서비스가 서로 독립적 → 직렬 await 불필요)
    // 직렬 대비 첫 프레임까지 1~3초 단축.
    await Future.wait([
      NotificationService.instance.initialize(),
      AdService.instance.initialize(),
      PurchaseService.instance.initialize(),
    ]);

    // 포링 일일 카운트 리셋 (UI 차단 안 함)
    PoringService.instance.resetDailyIfNeeded();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );

  // 앱 UI가 뜬 후, 종료 상태에서 알림 탭으로 실행된 경우 링크 열기
  if (!kIsWeb) {
    NotificationService.instance.handleAppLaunchNotification();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 컬러 테마 Provider 구독 - 변경 시 자동 rebuild
    final colorTheme = ref.watch(colorThemeProvider);

    // AppTheme에 현재 테마 설정
    AppTheme.setColorTheme(colorTheme);

    return MaterialApp(
      title: 'Linkku',
      theme: AppTheme.createTheme(colorTheme),
      darkTheme: AppTheme.createTheme(colorTheme),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,

      // 다국어 지원
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // 영어 (기본)
        Locale('ko'), // 한국어
        Locale('es'), // 스페인어
        Locale('ja'), // 일본어
        Locale('zh'), // 중국어
      ],

      // 웹 라우팅 (공유 링크 처리)
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '/');

        // 웹인 경우
        if (kIsWeb) {
          // /s/{shareId} 경로 처리 (공유 랜딩페이지)
          if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 's') {
            if (uri.pathSegments.length > 1) {
              final shareId = uri.pathSegments[1];
              return MaterialPageRoute(
                builder: (_) => ShareLandingScreen(shareId: shareId),
                settings: settings,
              );
            }
          }

          // /privacy 경로 처리 (개인정보처리방침)
          if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'privacy') {
            return MaterialPageRoute(
              builder: (_) => const PrivacyPolicyScreen(),
              settings: settings,
            );
          }

          // /terms 경로 처리 (이용약관)
          if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'terms') {
            return MaterialPageRoute(
              builder: (_) => const TermsOfServiceScreen(),
              settings: settings,
            );
          }

          // /admin 경로 처리 (관리자 페이지)
          if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'admin') {
            return MaterialPageRoute(
              builder: (_) => const AdminLoginScreen(),
              settings: settings,
            );
          }

          // 웹 기본 라우트 → 앱 소개 페이지
          return MaterialPageRoute(
            builder: (_) => const WebIntroScreen(),
            settings: settings,
          );
        }

        // 앱 기본 라우트
        return MaterialPageRoute(
          builder: (_) => const AuthWrapper(),
          settings: settings,
        );
      },

      // 웹이면 라우팅 사용, 앱이면 home 사용
      initialRoute: kIsWeb ? '/' : null,
      home: kIsWeb ? null : const AuthWrapper(),
    );
  }
}

/// 로그인 상태에 따라 화면 분기
class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _checkedExpiredRequests = false;

  @override
  void initState() {
    super.initState();
  }

  /// 만료된 수정 요청 처리 (앱 시작 시 1회)
  Future<void> _checkExpiredModificationRequests() async {
    if (_checkedExpiredRequests) return;
    _checkedExpiredRequests = true;

    try {
      await FirestoreService.instance.processExpiredModificationRequests();
    } catch (_) {
      // 오류 무시 (앱 시작에 영향 주지 않음)
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        // 로그인된 상태 (일반 로그인 또는 익명 로그인)
        if (user != null) {
          // 로그인 후 만료된 수정 요청 처리
          _checkExpiredModificationRequests();
          return const MainShell();
        }
        // 로그인 안된 상태 → 온보딩
        return const OnboardingScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const OnboardingScreen(),
    );
  }
}
