import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/firestore_service.dart';
import '../home/home_screen.dart';
import 'profile_setup_screen.dart';

/// 전화번호 로그인 화면.
/// 1) 번호 입력 → 인증번호(SMS) 요청 → 2) 코드 입력 → 로그인.
/// 성공 시 프로필 유무에 따라 홈/프로필설정으로 이동(구글·애플과 동일).
class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _countryController = TextEditingController(text: '+82');
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  bool _isLoading = false;
  bool _codeSent = false;
  String? _verificationId;

  @override
  void dispose() {
    _countryController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  /// 국가코드 + 번호 → E.164 (선행 0 제거)
  String _e164() {
    var cc = _countryController.text.trim();
    if (!cc.startsWith('+')) cc = '+$cc';
    var number = _phoneController.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (number.startsWith('0')) number = number.substring(1);
    return '$cc$number';
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _sendCode() async {
    if (_phoneController.text.trim().isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.verifyPhoneNumber(
        phoneNumber: _e164(),
        onCodeSent: (verificationId) {
          if (!mounted) return;
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
            _isLoading = false;
          });
          _toast(l10n.phoneCodeSent);
        },
        onAutoVerified: (credential) => _routeAfterLogin(credential.user),
        onFailed: (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          _toast('${l10n.phoneSendFailed}: ${e.message ?? e.code}');
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _toast(l10n.phoneGenericError);
      }
    }
  }

  Future<void> _confirmCode() async {
    final id = _verificationId;
    if (id == null || _codeController.text.trim().isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.signInWithSmsCode(
        verificationId: id,
        smsCode: _codeController.text.trim(),
      );
      await _routeAfterLogin(result.user);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _toast('${l10n.phoneVerifyFailed}: ${e.message ?? e.code}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _toast(l10n.phoneGenericError);
      }
    }
  }

  Future<void> _routeAfterLogin(User? user) async {
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final existingProfile =
        await FirestoreService.instance.getUserProfile(user.uid);
    // 전화 로그인 번호를 기존 프로필에도 반영 (비어있을 때만)
    if (existingProfile != null &&
        (existingProfile.phoneNumber == null ||
            existingProfile.phoneNumber!.isEmpty) &&
        user.phoneNumber != null) {
      await FirestoreService.instance.saveUserProfile(
        existingProfile.copyWith(phoneNumber: user.phoneNumber),
      );
    }
    if (!mounted) return;
    // 로그인/전화 화면을 스택에서 모두 제거 → 홈에 뒤로가기 버튼이 안 생김
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            existingProfile != null ? const HomeScreen() : const ProfileSetupScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.phoneSignIn)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Spacing.lg),
              Text(
                _codeSent ? l10n.phoneEnterCode : l10n.phoneEnterNumber,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: Spacing.lg),

              if (!_codeSent) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 72,
                      child: TextField(
                        controller: _countryController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Code'),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: l10n.phoneNumberLabel,
                          hintText: '01012345678',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.lg),
                FilledButton(
                  onPressed: _isLoading ? null : _sendCode,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.phoneSendCode),
                ),
              ] else ...[
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 6,
                  style: const TextStyle(fontSize: 24, letterSpacing: 8),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: '••••••',
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                FilledButton(
                  onPressed: _isLoading ? null : _confirmCode,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.phoneConfirm),
                ),
                const SizedBox(height: Spacing.sm),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _codeSent = false;
                            _codeController.clear();
                          });
                        },
                  child: Text(
                    l10n.phoneChangeNumber,
                    style: TextStyle(color: colorScheme.outline),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
