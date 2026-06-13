import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/firestore_service.dart';
import '../../widgets/linkku_logo.dart';
import '../home/home_screen.dart';
import 'phone_login_screen.dart';
import 'profile_setup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  String _friendlyError(Object e, AppLocalizations l10n) {
    final msg = e.toString();
    if (msg.contains('[cloud_firestore/permission-denied]')) {
      return l10n.loginFailed;
    }
    if (msg.contains('[cloud_firestore/unavailable]')) {
      return l10n.loginFailed;
    }
    return l10n.loginFailed;
  }

  Future<void> _signInWithApple() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.signInWithApple();

      if (result != null && result.user != null) {
        final existingProfile = await FirestoreService.instance
            .getUserProfile(result.user!.uid);

        if (!mounted) return;

        if (existingProfile != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileSetupScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_friendlyError(e, l10n))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.signInWithGoogle();

      if (result != null && result.user != null) {
        // 기존 프로필이 있는지 확인
        final existingProfile = await FirestoreService.instance
            .getUserProfile(result.user!.uid);

        if (!mounted) return;

        if (existingProfile != null) {
          // 기존 회원 → 홈으로 바로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          // 신규 회원 → 프로필 설정 화면으로
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileSetupScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_friendlyError(e, l10n))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _skipLogin() async {
    setState(() => _isLoading = true);

    try {
      // 기기 언어 감지 (한국어인지 확인)
      final locale = View.of(context).platformDispatcher.locale;
      final isKorean = locale.languageCode == 'ko';

      // 익명 로그인으로 게스트 ID 부여
      final authService = ref.read(authServiceProvider);
      await authService.signInAnonymously(isKorean: isKorean);

      if (mounted) {
        // 게스트 프로필 자동 생성 후 홈으로
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.guestLoginFailed)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            children: [
              const Spacer(),

              // 브랜드 락업 (심볼 + 워드마크)
              const LinkkuLockup(
                variant: LinkkuLockupVariant.color,
                height: 64,
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                l10n.appSlogan,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const Spacer(),

              // Apple 로그인 버튼 (iOS만)
              if (Platform.isIOS) ...[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _signInWithApple,
                    icon: const Icon(Icons.apple, size: 28),
                    label: Text(_isLoading ? l10n.loginLoading : 'Sign in with Apple'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.inverseSurface,
                      foregroundColor: colorScheme.onInverseSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
              ],

              // Google 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.g_mobiledata, size: 28),
                  label: Text(_isLoading ? l10n.loginLoading : l10n.loginWithGoogle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.sm),

              // 전화번호 로그인 버튼 (애플/구글/전화 3종)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PhoneLoginScreen(),
                            ),
                          ),
                  icon: const Icon(Icons.phone_iphone, size: 24),
                  label: Text(l10n.phoneSignIn),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.onSurface,
                    side: BorderSide(color: colorScheme.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.md),

              // 나중에 하기
              TextButton(
                onPressed: _isLoading ? null : _skipLogin,
                child: Text(
                  l10n.loginLater,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: Spacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
