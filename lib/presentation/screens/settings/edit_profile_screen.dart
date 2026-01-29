import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/user_profile.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/badge_service.dart';
import '../../../services/firestore_service.dart';
import '../../../services/auth_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool _isLoading = false;

  /// 현재 닉네임 가져오기
  String _getCurrentNickname() {
    final authState = ref.read(authStateProvider);
    final isGuest = authState.value?.isAnonymous ?? true;

    if (isGuest) {
      return AuthService.instance.getGuestNickname();
    } else {
      final profile = ref.read(userProfileProvider).value;
      return profile?.nickname ?? AuthService.instance.getGuestNickname();
    }
  }

  /// 닉네임 수정 팝업
  void _showNicknameEditDialog() {
    final controller = TextEditingController(text: _getCurrentNickname());
    final formKey = GlobalKey<FormState>();
    bool isChecking = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('닉네임 수정'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: '닉네임을 입력하세요',
                    prefixIcon: const Icon(Icons.person_outline),
                    errorText: errorMessage,
                  ),
                  maxLength: 20,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '닉네임을 입력해주세요';
                    }
                    if (value.trim().length < 2) {
                      return '2자 이상 입력해주세요';
                    }
                    return null;
                  },
                ),
                if (isChecking)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('중복 확인 중...'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: isChecking
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;

                      final newNickname = controller.text.trim();
                      final currentNickname = _getCurrentNickname();

                      // 같은 닉네임이면 그냥 닫기
                      if (newNickname == currentNickname) {
                        Navigator.pop(context);
                        return;
                      }

                      // 중복 검사
                      setDialogState(() {
                        isChecking = true;
                        errorMessage = null;
                      });

                      final isDuplicate = await FirestoreService.instance
                          .isNicknameDuplicate(newNickname);

                      if (isDuplicate) {
                        setDialogState(() {
                          isChecking = false;
                          errorMessage = '이미 사용 중인 닉네임이에요';
                        });
                        return;
                      }

                      // 저장
                      await _saveNickname(newNickname);

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
              child: const Text('수정'),
            ),
          ],
        ),
      ),
    );
  }

  /// 닉네임 저장
  Future<void> _saveNickname(String nickname) async {
    final authState = ref.read(authStateProvider);
    final isGuest = authState.value?.isAnonymous ?? true;

    if (isGuest) {
      // 게스트: 로컬에 저장
      await AuthService.instance.saveGuestNickname(nickname);
    } else {
      // 회원: Firestore에 저장
      final currentProfile = ref.read(userProfileProvider).value;
      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(
          nickname: nickname,
          updatedAt: DateTime.now(),
        );
        await FirestoreService.instance.saveUserProfile(updatedProfile);
        ref.invalidate(userProfileProvider);
      }
    }

    setState(() {}); // UI 새로고침

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임이 변경되었어요')),
      );
    }
  }

  Future<void> _linkGoogleAccount({bool isChanging = false}) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      setState(() => _isLoading = true);

      // 현재 게스트 닉네임 저장 (연동 후에도 유지)
      final guestNickname = AuthService.instance.getGuestNickname();

      // 기존 연동 해제 (계정 변경 시)
      if (isChanging) {
        await AuthService.instance.unlinkGoogle();
      }

      final result = await AuthService.instance.linkWithGoogle();

      if (result == null) {
        // 사용자가 취소함
        return;
      }

      // Firestore에 프로필 생성 (게스트 닉네임 유지)
      final user = result.user;
      if (user != null) {
        final existingProfile = await FirestoreService.instance.getUserProfile(user.uid);
        if (existingProfile == null) {
          // 새 프로필 생성
          final newProfile = UserProfile(
            uid: user.uid,
            nickname: guestNickname,
            country: '미설정',
            createdAt: DateTime.now(),
          );
          await FirestoreService.instance.saveUserProfile(newProfile);
        }
      }

      // authState & userProfile 새로고침
      ref.invalidate(authStateProvider);
      ref.invalidate(userProfileProvider);

      // 계정 연동 배지 지급
      await BadgeService.instance.recordAccountLinked();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.accountLinked)),
        );
      }
    } catch (e) {
      if (mounted) {
        String message = l10n.accountLinkFailed;

        // Firebase 에러 타입별 처리
        final errorString = e.toString();
        if (errorString.contains('credential-already-in-use')) {
          message = '이 구글 계정은 이미 다른 계정에 연동되어 있어요';
        } else if (errorString.contains('provider-already-linked')) {
          message = '이미 구글 계정이 연동되어 있어요';
        } else if (errorString.contains('invalid-credential')) {
          message = '인증 정보가 유효하지 않아요';
        } else if (errorString.contains('network-request-failed')) {
          message = '네트워크 연결을 확인해주세요';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showChangeAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 변경'),
        content: const Text('다른 구글 계정으로 변경하시겠습니까?'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _linkGoogleAccount(isChanging: true);
            },
            child: const Text('변경'),
          ),
        ],
      ),
    );
  }

  Future<void> _linkKakaoAccount() async {
    final l10n = AppLocalizations.of(context)!;
    // 카카오 연동은 추후 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.kakaoLinkComingSoon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final isGuest = user?.isAnonymous ?? true;

    // 연동된 계정 확인
    final linkedProviders = user?.providerData.map((p) => p.providerId).toList() ?? [];
    final isGoogleLinked = linkedProviders.contains('google.com');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 닉네임 수정 섹션
            Text(
              l10n.nickname,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(_getCurrentNickname()),
                trailing: const Icon(Icons.edit, size: 20),
                onTap: _showNicknameEditDialog,
              ),
            ),

            const SizedBox(height: Spacing.xl),

            // 계정 연동 섹션
            Text(
              l10n.accountLink,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: Spacing.sm),

            // 구글 연동
            _buildLinkTile(
              icon: Icons.g_mobiledata,
              iconColor: Colors.red,
              title: 'Google',
              isLinked: isGoogleLinked,
              onTap: _isLoading
                  ? null
                  : (isGoogleLinked ? _showChangeAccountDialog : _linkGoogleAccount),
              l10n: l10n,
            ),

            const SizedBox(height: Spacing.sm),

            // 카카오 연동
            _buildLinkTile(
              icon: Icons.chat_bubble,
              iconColor: const Color(0xFFFEE500),
              title: l10n.kakao,
              isLinked: false, // 카카오 연동 여부 확인 로직 필요
              onTap: _isLoading ? null : _linkKakaoAccount,
              l10n: l10n,
            ),

            if (isGuest) ...[
              const SizedBox(height: Spacing.md),
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Text(
                        l10n.guestLinkInfo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isLinked,
    required VoidCallback? onTap,
    required AppLocalizations l10n,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title),
        trailing: isLinked
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      l10n.linked,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.outline,
                    size: 20,
                  ),
                ],
              )
            : TextButton(
                onPressed: onTap,
                child: Text(l10n.link),
              ),
      ),
    );
  }
}
