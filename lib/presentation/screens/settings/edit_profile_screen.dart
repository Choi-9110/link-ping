import 'dart:io';

import 'package:flutter/material.dart';

import '../../widgets/dialog_actions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../data/models/user_profile.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/badge_service.dart';
import '../../../services/firestore_service.dart';
import '../../../services/auth_service.dart';
import '../../widgets/emoji_picker_dialog.dart';
import '../../../services/pixel_emoji_service.dart';

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

  /// 현재 이모지 가져오기
  String _getCurrentEmoji() {
    final authState = ref.read(authStateProvider);
    final isGuest = authState.value?.isAnonymous ?? true;

    if (isGuest) {
      return AuthService.instance.getGuestEmoji();
    } else {
      final profile = ref.read(userProfileProvider).value;
      return profile?.profileEmoji ?? 'face_grinning';
    }
  }

  /// 현재 전화번호 가져오기
  String? _getCurrentPhoneNumber() {
    final authState = ref.read(authStateProvider);
    final isGuest = authState.value?.isAnonymous ?? true;

    if (isGuest) {
      return AuthService.instance.getGuestPhoneNumber();
    } else {
      final profile = ref.read(userProfileProvider).value;
      return profile?.phoneNumber;
    }
  }

  /// 현재 국가 코드 가져오기
  String? _getCurrentCountry() {
    final profile = ref.read(userProfileProvider).value;
    return profile?.country;
  }

  /// 이모지 선택 팝업
  void _showEmojiPickerDialog() async {
    final currentEmoji = _getCurrentEmoji();
    final selectedEmoji = await showDialog<String>(
      context: context,
      builder: (context) => EmojiPickerDialog(currentEmoji: currentEmoji),
    );

    if (selectedEmoji != null && selectedEmoji != currentEmoji) {
      await _saveEmoji(selectedEmoji);
    }
  }

  /// 이모지 저장
  Future<void> _saveEmoji(String emoji) async {
    final authState = ref.read(authStateProvider);
    final isGuest = authState.value?.isAnonymous ?? true;

    String nickname;

    if (isGuest) {
      // 게스트: 로컬에 저장
      await AuthService.instance.saveGuestEmoji(emoji);
      nickname = AuthService.instance.getGuestNickname();
      ref.invalidate(guestProfileProvider); // 게스트 프로필 갱신
    } else {
      // 회원: Firestore에 저장
      final currentProfile = ref.read(userProfileProvider).value;
      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(
          profileEmoji: emoji,
          updatedAt: DateTime.now(),
        );
        await FirestoreService.instance.saveUserProfile(updatedProfile);
        nickname = currentProfile.nickname;
        ref.invalidate(userProfileProvider);
      } else {
        nickname = AuthService.instance.getGuestNickname();
      }
    }

    // 저장한 링크 목록에서도 이모지 업데이트
    await FirestoreService.instance.updateUserProfileInSavedBy(
      nickname: nickname,
      emoji: emoji,
    );

    setState(() {}); // UI 새로고침

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileEmojiChanged)),
      );
    }
  }

  /// 닉네임 수정 팝업
  void _showNicknameEditDialog() {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _getCurrentNickname());
    final formKey = GlobalKey<FormState>();
    bool isChecking = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final dialogL10n = AppLocalizations.of(dialogContext)!;
          return AlertDialog(
            title: Text(dialogL10n.editNickname),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: dialogL10n.enterNickname,
                      prefixIcon: const Icon(Icons.person_outline),
                      errorText: errorMessage,
                    ),
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return dialogL10n.pleaseEnterNickname;
                      }
                      if (value.trim().length < 2) {
                        return dialogL10n.minTwoChars;
                      }
                      return null;
                    },
                  ),
                  if (isChecking)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Text(dialogL10n.checkingDuplicate),
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
                          Navigator.pop(dialogContext);
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
                            errorMessage = dialogL10n.nicknameAlreadyInUse;
                          });
                          return;
                        }

                        // 저장
                        await _saveNickname(newNickname);

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      },
                child: Text(l10n.edit),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 닉네임 저장
  Future<void> _saveNickname(String nickname) async {
    final authState = ref.read(authStateProvider);
    final isGuest = authState.value?.isAnonymous ?? true;

    String emoji;

    if (isGuest) {
      // 게스트: 로컬에 저장
      await AuthService.instance.saveGuestNickname(nickname);
      emoji = AuthService.instance.getGuestEmoji();
      ref.invalidate(guestProfileProvider); // 게스트 프로필 갱신
    } else {
      // 회원: Firestore에 저장
      final currentProfile = ref.read(userProfileProvider).value;
      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(
          nickname: nickname,
          updatedAt: DateTime.now(),
        );
        await FirestoreService.instance.saveUserProfile(updatedProfile);
        emoji = currentProfile.profileEmoji;
        ref.invalidate(userProfileProvider);
      } else {
        emoji = 'face_grinning';
      }
    }

    // 저장한 링크 목록에서도 닉네임 업데이트
    await FirestoreService.instance.updateUserProfileInSavedBy(
      nickname: nickname,
      emoji: emoji,
    );

    setState(() {}); // UI 새로고침

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nicknameChanged)),
      );
    }
  }

  /// 전화번호 수정 팝업 (국가 선택 드롭다운 포함)
  void _showPhoneNumberEditDialog() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';
    final currentPhone = _getCurrentPhoneNumber() ?? '';
    final countryCode = _getCurrentCountry();
    final controller = TextEditingController(text: currentPhone);
    final formKey = GlobalKey<FormState>();

    var selectedCountry = PhoneUtils.getCountryInfo(countryCode);

    showDialog(
      context: context,
      builder: (dialogContext) {
        final dialogL10n = AppLocalizations.of(dialogContext)!;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(dialogL10n.myPhoneNumber),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 국가 선택 드롭다운
                    DropdownButtonFormField<String>(
                      value: selectedCountry.code,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                      items: PhoneUtils.countries.map((country) {
                        return DropdownMenuItem<String>(
                          value: country.code,
                          child: Text(
                            country.display(isKorean),
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (code) {
                        if (code != null) {
                          setDialogState(() {
                            selectedCountry = PhoneUtils.getCountryInfo(code);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    // 전화번호 입력
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: PhoneUtils.getPhoneHint(selectedCountry.code),
                        prefixIcon: const Icon(Icons.phone),
                        prefixText: '${selectedCountry.phoneCode} ',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');
                          if (cleaned.length < 8 || cleaned.length > 15) {
                            return dialogL10n.invalidPhoneNumber;
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                DialogActions(buttons: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(dialogL10n.cancel),
                  ),
                  FilledButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;

                      final newPhone = controller.text.trim();
                      await _savePhoneNumber(newPhone.isEmpty ? null : newPhone);

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                    },
                    child: Text(l10n.save),
                  ),
                ]),
              ],
            );
          },
        );
      },
    );
  }

  /// 전화번호 저장
  Future<void> _savePhoneNumber(String? phoneNumber) async {
    final authState = ref.read(authStateProvider);
    final isGuest = authState.value?.isAnonymous ?? true;

    if (isGuest) {
      // 게스트: 로컬에 저장
      await AuthService.instance.saveGuestPhoneNumber(phoneNumber);
    } else {
      // 회원: private 서브컬렉션에 저장 (공개 프로필 문서에 두면 노출됨)
      await FirestoreService.instance.savePhoneNumber(phoneNumber);
      ref.invalidate(userProfileProvider);
    }

    setState(() {}); // UI 새로고침

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(phoneNumber == null ? l10n.phoneNumberDeleted : l10n.phoneNumberSaved),
        ),
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
            country: l10n.notSet,
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
          message = l10n.googleAccountAlreadyLinked;
        } else if (errorString.contains('provider-already-linked')) {
          message = l10n.providerAlreadyLinked;
        } else if (errorString.contains('invalid-credential')) {
          message = l10n.invalidCredential;
        } else if (errorString.contains('network-request-failed')) {
          message = l10n.networkError;
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.changeAccount),
        content: Text(l10n.changeAccountConfirm),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _linkGoogleAccount(isChanging: true);
            },
            child: Text(l10n.change),
          ),
        ],
      ),
    );
  }

  Future<void> _linkAppleAccount({bool isChanging = false}) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      setState(() => _isLoading = true);

      final guestNickname = AuthService.instance.getGuestNickname();

      if (isChanging) {
        // Apple 연동 해제
        final user = AuthService.instance.currentUser;
        if (user != null) {
          await user.unlink('apple.com');
        }
      }

      final result = await AuthService.instance.linkWithApple();

      if (result == null) return;

      final user = result.user;
      if (user != null) {
        final existingProfile = await FirestoreService.instance.getUserProfile(user.uid);
        if (existingProfile == null) {
          final newProfile = UserProfile(
            uid: user.uid,
            nickname: guestNickname,
            country: l10n.notSet,
            createdAt: DateTime.now(),
          );
          await FirestoreService.instance.saveUserProfile(newProfile);
        }
      }

      ref.invalidate(authStateProvider);
      ref.invalidate(userProfileProvider);

      await BadgeService.instance.recordAccountLinked();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.accountLinked)),
        );
      }
    } catch (e) {
      if (mounted) {
        String message = l10n.accountLinkFailed;

        final errorString = e.toString();
        if (errorString.contains('credential-already-in-use')) {
          message = l10n.googleAccountAlreadyLinked;
        } else if (errorString.contains('provider-already-linked')) {
          message = l10n.providerAlreadyLinked;
        } else if (errorString.contains('invalid-credential')) {
          message = l10n.invalidCredential;
        } else if (errorString.contains('network-request-failed')) {
          message = l10n.networkError;
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

  void _showChangeAppleAccountDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.changeAccount),
        content: Text(l10n.changeAccountConfirm),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _linkAppleAccount(isChanging: true);
            },
            child: Text(l10n.change),
          ),
        ],
      ),
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
    final isAppleLinked = linkedProviders.contains('apple.com');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 이모지 섹션
            Text(
              l10n.profileEmoji,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Card(
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.center,
                  child: PixelEmojiService.buildPixelEmoji(
                    _getCurrentEmoji(),
                    size: 32,
                  ),
                ),
                title: Text(l10n.changeEmoji),
                subtitle: Text(l10n.profileEmojiDescription),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showEmojiPickerDialog,
              ),
            ),

            const SizedBox(height: Spacing.lg),

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
                trailing: const Icon(Icons.chevron_right),
                onTap: _showNicknameEditDialog,
              ),
            ),

            const SizedBox(height: Spacing.lg),

            // 전화번호 섹션 (전화 알람용)
            Text(
              l10n.myPhoneNumber,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: Text(
                  _getCurrentPhoneNumber() ?? l10n.phoneNumberNotSet,
                  style: TextStyle(
                    color: _getCurrentPhoneNumber() == null
                        ? colorScheme.onSurfaceVariant
                        : null,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showPhoneNumberEditDialog,
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

            // Apple 연동 (iOS만)
            if (Platform.isIOS) ...[
              const SizedBox(height: Spacing.sm),
              _buildLinkTile(
                icon: Icons.apple,
                iconColor: Colors.black,
                title: 'Apple',
                isLinked: isAppleLinked,
                onTap: _isLoading
                    ? null
                    : (isAppleLinked ? _showChangeAppleAccountDialog : _linkAppleAccount),
                l10n: l10n,
              ),
            ],

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
                    color: colorScheme.onSurfaceVariant,
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
