import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'data/models/link_reminder.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/privacy/privacy_policy_screen.dart';
import 'presentation/screens/terms/terms_of_service_screen.dart';
import 'presentation/screens/share_landing/share_landing_screen.dart';
import 'presentation/screens/web_intro/web_intro_screen.dart';
import 'providers/auth_provider.dart';
import 'services/ad_service.dart';
import 'services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 웹에서 경로 기반 URL 사용 (/privacy 대신 /#/privacy 방지)
  usePathUrlStrategy();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 웹이 아닐 때만 네이티브 서비스 초기화
  if (!kIsWeb) {
    // Hive 초기화
    await Hive.initFlutter();
    Hive.registerAdapter(LinkReminderAdapter());
    await Hive.openBox<LinkReminder>('links');
    await Hive.openBox('settings');

    // 알림 서비스 초기화
    await NotificationService.instance.initialize();

    // 광고 서비스 초기화
    await AdService.instance.initialize();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkPing',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
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
        Locale('ko'), // 한국어
        Locale('en'), // 영어
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
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        // 로그인된 상태 (일반 로그인 또는 익명 로그인)
        if (user != null) {
          return const HomeScreen();
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
