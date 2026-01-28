import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/user_profile.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../home/home_screen.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  String _selectedCountry = 'KR';
  bool _isLoading = false;

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
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        throw Exception('로그인이 필요합니다');
      }

      final nickname = _nicknameController.text.trim();
      final countryName = _getCountryName(_selectedCountry);

      // UserProfile 생성
      final profile = UserProfile(
        uid: user.uid,
        nickname: nickname,
        country: countryName,
        createdAt: DateTime.now(),
      );

      // Firestore에 저장
      await ref.read(firestoreServiceProvider).saveUserProfile(profile);

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 저장 실패: $e')),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 설정'),
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
              '프로필을 설정해주세요',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              '다른 사용자에게 표시될 정보입니다',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),

            const SizedBox(height: Spacing.xl),

            // 닉네임 입력
            TextFormField(
              controller: _nicknameController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: '닉네임',
                hintText: '운동하는민수',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '닉네임을 입력하세요';
                }
                if (value.trim().length < 2) {
                  return '2자 이상 입력하세요';
                }
                if (value.trim().length > 20) {
                  return '20자 이하로 입력하세요';
                }
                return null;
              },
            ),

            const SizedBox(height: Spacing.md),

            // 국가 선택
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
                  : const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
