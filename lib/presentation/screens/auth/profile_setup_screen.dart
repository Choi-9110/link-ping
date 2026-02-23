import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/user_profile.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/firestore_service.dart';
import '../home/home_screen.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _referralCodeController = TextEditingController();
  String _selectedCountry = 'KR';
  bool _isLoading = false;
  bool _hasReferralCode = false;

  final List<Map<String, String>> _countries = [
    {'code': 'KR', 'name': '대한민국', 'flag': '🇰🇷'},
    {'code': 'US', 'name': 'United States', 'flag': '🇺🇸'},
    {'code': 'JP', 'name': '日本', 'flag': '🇯🇵'},
    {'code': 'GB', 'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'code': 'CA', 'name': 'Canada', 'flag': '🇨🇦'},
    {'code': 'AU', 'name': 'Australia', 'flag': '🇦🇺'},
  ];

  @override
  void dispose() {
    _nicknameController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  String _getCountryName(String code) {
    final country = _countries.firstWhere(
      (c) => c['code'] == code,
      orElse: () => {'name': code},
    );
    return country['name'] ?? code;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final l10n = AppLocalizations.of(context)!;
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        throw Exception(l10n.loginRequired);
      }

      final nickname = _nicknameController.text.trim();
      final countryName = _getCountryName(_selectedCountry);
      final referralCode = _referralCodeController.text.trim().toUpperCase();

      // UserProfile 생성
      final profile = UserProfile(
        uid: user.uid,
        nickname: nickname,
        country: countryName,
        createdAt: DateTime.now(),
      );

      // Firestore에 저장
      await ref.read(firestoreServiceProvider).saveUserProfile(profile);

      // 추천 코드가 있으면 처리
      if (_hasReferralCode && referralCode.isNotEmpty) {
        await FirestoreService.instance.processReferral(
          newUserUid: user.uid,
          referralCode: referralCode,
        );
      }

      if (mounted) {
        // 홈 화면으로 이동
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
          SnackBar(content: Text('${l10n.profileSaveFailed}: $e')),
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileSetup),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            const SizedBox(height: Spacing.lg),

            // 안내 텍스트
            Text(
              l10n.profileSetupTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              l10n.profileSetupSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),

            const SizedBox(height: Spacing.xl),

            // 닉네임 입력
            TextFormField(
              controller: _nicknameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: l10n.nickname,
                hintText: l10n.nicknameHint,
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.nicknameRequired;
                }
                if (value.trim().length < 2) {
                  return l10n.nicknameMinLength;
                }
                if (value.trim().length > 20) {
                  return l10n.nicknameMaxLength;
                }
                return null;
              },
            ),

            const SizedBox(height: Spacing.md),

            // 국가 선택
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration: InputDecoration(
                labelText: l10n.country,
                prefixIcon: const Icon(Icons.public),
                border: const OutlineInputBorder(),
              ),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country['code'],
                  child: Text('${country['flag']} ${country['name']}'),
                );
              }).toList(),
              onChanged: _isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCountry = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: Spacing.lg),

            // 추천 코드 섹션
            _buildReferralCodeSection(theme),

            const SizedBox(height: Spacing.xl),

            // 완료 버튼
            FilledButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.done),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralCodeSection(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎁', style: TextStyle(fontSize: 20)),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  l10n.referralCode,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                value: _hasReferralCode,
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _hasReferralCode = value;
                        });
                      },
              ),
            ],
          ),
          if (_hasReferralCode) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              l10n.referralCodeQuestion,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _referralCodeController,
              enabled: !_isLoading,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'ABCD1234',
                prefixIcon: const Icon(Icons.card_giftcard),
                border: const OutlineInputBorder(),
                helperText: l10n.referralCodeHelperText,
                helperStyle: TextStyle(color: colorScheme.outline),
              ),
              maxLength: 8,
            ),
          ],
        ],
      ),
    );
  }
}
