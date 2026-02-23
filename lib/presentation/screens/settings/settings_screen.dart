import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/theme/color_themes.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/color_theme_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../data/models/ping_notification.dart';
import '../../../services/auth_service.dart';
import '../../../services/badge_service.dart';
import '../../../services/firestore_service.dart';
import '../../../services/notification_service.dart';
import '../onboarding/onboarding_screen.dart';
import '../badges/badge_collection_screen.dart';
import '../inquiry/inquiry_list_screen.dart';
import '../privacy/privacy_policy_screen.dart';
import '../terms/terms_of_service_screen.dart';
import 'alarm_sound_screen.dart';
import 'edit_profile_screen.dart';
import '../../widgets/share_preview_dialog.dart';
import '../../widgets/premium_purchase_sheet.dart';
import '../../../services/alarm_sound_service.dart';
import '../../../services/pixel_emoji_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationEnabled = true;

  void _onEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
  }

  void _onToggleNotification(bool value) async {
    final l10n = AppLocalizations.of(context)!;
    if (value) {
      final granted = await NotificationService.instance.requestPermission();
      setState(() {
        _notificationEnabled = granted;
      });
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.notificationPermissionRequired)),
        );
      }
    } else {
      setState(() {
        _notificationEnabled = false;
      });
    }
  }

  void _onTestNotification() async {
    await NotificationService.instance.showTestNotification();
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.notificationTestSent)),
      );
    }
  }

  void _onPurchasePremium() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const PremiumPurchaseSheet(),
    );
  }

  void _onLogout() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await ref.read(authServiceProvider).signOut();

              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                  (route) => false,
                );
              }
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  void _onPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
    );
  }

  void _onContact() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InquiryListScreen()),
    );
  }

  void _onTermsOfService() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
    );
  }

  /// [DEBUG] 현재 유저 UID 보기
  void _showDebugInfo() {
    final authState = ref.read(authStateProvider);
    final user = authState.value;
    final uid = user?.uid ?? 'N/A';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('[DEBUG] 유저 정보'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('UID: $uid'),
            const SizedBox(height: 8),
            Text('익명: ${user?.isAnonymous ?? true}'),
            Text('이메일: ${user?.email ?? "없음"}'),
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

  /// [DEBUG] 테스트 알림 데이터 생성
  void _createTestNotification() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('[DEBUG] 테스트 알림 보내기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('받는 사람 UID 입력:'),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'UID 붙여넣기',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () async {
              final toUid = controller.text.trim();
              if (toUid.isEmpty) return;

              Navigator.pop(context);

              try {
                await FirestoreService.instance.sendPing(
                  toUid: toUid,
                  type: PingType.cheer,
                  urlTitle: '테스트 링크',
                  customMessage: '테스트 응원 메시지입니다! 🎉',
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('테스트 알림 전송 완료!')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('에러: $e')),
                  );
                }
              }
            },
            child: const Text('보내기'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          const SizedBox(height: Spacing.sm),

          // 프로필 섹션
          _buildSectionTitle(l10n.profile),
          _buildProfileTile(colorScheme),

          const SizedBox(height: Spacing.md),

          // 알림 섹션
          _buildSectionTitle(l10n.notificationSettings),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: l10n.notificationPermission,
            trailing: Switch(
              value: _notificationEnabled,
              onChanged: _onToggleNotification,
            ),
          ),
          _buildSettingsTile(
            icon: Icons.notifications_active_outlined,
            title: l10n.notificationTest,
            subtitle: l10n.notificationTestSubtitle,
            trailing: const Icon(Icons.chevron_right),
            onTap: _onTestNotification,
          ),
          _buildAlarmSoundTile(),

          const SizedBox(height: Spacing.md),

          // =========================================================
          // 🎨 컬러 테마 섹션 - 추후 활성화 예정
          // =========================================================
          // _buildSectionTitle('컬러 테마'),
          // _buildColorThemeSelector(colorScheme),
          // const SizedBox(height: Spacing.md),

          // 뱃지 & 통계 섹션
          _buildSectionTitle(l10n.badgesAndStats),
          _buildBadgeTile(colorScheme),

          const SizedBox(height: Spacing.md),

          // 친구 초대 섹션
          _buildSectionTitle(l10n.inviteFriends),
          _buildInviteTile(colorScheme),

          const SizedBox(height: Spacing.md),

          // 프리미엄 섹션
          _buildSectionTitle(l10n.premium),
          _buildPremiumTile(colorScheme),

          const SizedBox(height: Spacing.md),

          // 계정 섹션
          _buildSectionTitle(l10n.account),
          _buildSettingsTile(
            icon: Icons.logout,
            title: l10n.logout,
            onTap: _onLogout,
          ),

          const SizedBox(height: Spacing.md),

          // 정보 섹션
          _buildSectionTitle(l10n.info),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: l10n.version,
            trailing: Text(
              '1.0.0',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.privacyPolicy,
            trailing: const Icon(Icons.chevron_right),
            onTap: _onPrivacyPolicy,
          ),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: l10n.termsOfService,
            trailing: const Icon(Icons.chevron_right),
            onTap: _onTermsOfService,
          ),
          _buildSettingsTile(
            icon: Icons.mail_outline,
            title: l10n.contact,
            trailing: const Icon(Icons.chevron_right),
            onTap: _onContact,
          ),

          const SizedBox(height: Spacing.md),

          // [DEBUG] 개발자 섹션 - 출시 전 제거
          _buildSectionTitle('[DEBUG] 개발자 도구'),
          _buildSettingsTile(
            icon: Icons.bug_report_outlined,
            title: '내 UID 보기',
            trailing: const Icon(Icons.chevron_right),
            onTap: _showDebugInfo,
          ),
          _buildSettingsTile(
            icon: Icons.send_outlined,
            title: '테스트 알림 보내기',
            subtitle: '다른 유저에게 테스트 알림 전송',
            trailing: const Icon(Icons.chevron_right),
            onTap: _createTestNotification,
          ),

          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  /// 🎨 컬러 테마 선택기 (테스트용)
  Widget _buildColorThemeSelector(ColorScheme colorScheme) {
    final currentTheme = ref.watch(colorThemeProvider);
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette_outlined, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '테마 선택 (테스트)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          ...ColorThemes.all.map((theme) {
            final isSelected = currentTheme.id == theme.id;
            return GestureDetector(
              onTap: () {
                ref.read(colorThemeProvider.notifier).setTheme(theme);
                // 즉시 반영을 위해 setState 호출
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${isKorean ? theme.nameKo : theme.name} 테마 적용! 앱을 재시작하면 완전히 적용됩니다.'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: Spacing.sm),
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // 컬러 프리뷰
                    Row(
                      children: [
                        _colorDot(theme.primary),
                        _colorDot(theme.secondary),
                        _colorDot(theme.tertiary),
                        _colorDot(theme.background),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // 테마 이름
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isKorean ? theme.nameKo : theme.name,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? colorScheme.primary : null,
                            ),
                          ),
                          Text(
                            _getThemeDescription(theme.id),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 선택 표시
                    if (isSelected)
                      Icon(Icons.check_circle, color: colorScheme.primary, size: 24),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 1),
      ),
    );
  }

  String _getThemeDescription(String themeId) {
    switch (themeId) {
      case 'vibrant':
        return '코랄 + 민트 조합';
      case 'soft':
        return '부드러운 네이비 톤';
      case 'minimal':
        return '모노크롬 미니멀';
      default:
        return '';
    }
  }

  Widget _buildPremiumTile(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    final userProfileAsync = ref.watch(userProfileProvider);
    final isPremium = userProfileAsync.value?.isPremium ?? false;

    return _buildSettingsTile(
      icon: Icons.workspace_premium_outlined,
      title: isPremium ? l10n.premiumActive : l10n.premiumPurchase,
      subtitle: isPremium ? null : l10n.premiumBenefits,
      trailing: isPremium
          ? Icon(Icons.check_circle, color: colorScheme.primary)
          : const Icon(Icons.chevron_right),
      onTap: isPremium ? null : _onPurchasePremium,
    );
  }

  void _onTogglePremium() async {
    final authState = ref.read(authStateProvider);
    final user = authState.value;
    if (user == null) return;

    bool willBePremium = false;

    if (user.isAnonymous) {
      // 게스트: 로컬에 저장
      final settings = Hive.box('settings');
      final current = settings.get('guestIsPremium', defaultValue: false) as bool;
      willBePremium = !current;
      await settings.put('guestIsPremium', willBePremium);
      setState(() {}); // UI 갱신
    } else {
      // 회원: Firestore에 저장
      final currentProfile = ref.read(userProfileProvider).value;
      willBePremium = !(currentProfile?.isPremium ?? false);
      await FirestoreService.instance.togglePremium(user.uid);
      ref.invalidate(userProfileProvider);
    }

    // 프리미엄 배지 지급 (프리미엄 활성화 시에만)
    if (willBePremium) {
      await BadgeService.instance.recordPremiumPurchase();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프리미엄 상태 변경됨! 👑')),
      );
    }
  }

  /// 연결된 SNS 타입 가져오기
  String _getLinkedSnsType(List<String> providerIds) {
    if (providerIds.contains('google.com')) return 'Google';
    if (providerIds.contains('apple.com')) return 'Apple';
    if (providerIds.contains('oidc.kakao')) return 'Kakao';
    return '';
  }

  Widget _buildProfileTile(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final isGuest = user?.isAnonymous ?? true;

    // 연결된 provider 확인
    final linkedProviders = user?.providerData.map((p) => p.providerId).toList() ?? [];
    final snsType = _getLinkedSnsType(linkedProviders);
    final hasLinkedSns = snsType.isNotEmpty;

    // 닉네임, 이모지 가져오기
    String nickname;
    String emoji;
    bool isPremium = false;

    if (isGuest) {
      final guestProfile = ref.watch(guestProfileProvider);
      nickname = guestProfile.nickname;
      emoji = guestProfile.emoji;
    } else {
      final profile = ref.watch(userProfileProvider).value;
      nickname = profile?.nickname ?? AuthService.instance.getGuestNickname();
      emoji = profile?.profileEmoji ?? 'face_grinning';
      isPremium = profile?.isPremium ?? false;
    }

    return GestureDetector(
      onLongPress: _onTogglePremium,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.surfaceContainerHighest,
          child: PixelEmojiService.buildPixelEmoji(emoji, size: 28),
        ),
        title: Row(
          children: [
            Flexible(child: Text(nickname, overflow: TextOverflow.ellipsis)),
            if (isPremium) ...[
              const SizedBox(width: 8),
              Icon(Icons.workspace_premium, size: 16, color: colorScheme.primary),
            ],
            if (hasLinkedSns) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  snsType,
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          hasLinkedSns ? l10n.accountSynced : l10n.loginToSync,
          style: TextStyle(
            color: hasLinkedSns ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: _onEditProfile,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildAlarmSoundTile() {
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;
    final selectedSoundId = AlarmSoundService.instance.getSelectedSoundId();
    final selectedSound = AlarmSoundService.instance.getSoundById(selectedSoundId);

    return ListTile(
      leading: const Icon(Icons.notifications_active_outlined),
      title: Text(l10n.pingNotificationSound),
      subtitle: Text(selectedSound?.getName(langCode) ?? l10n.pingNotificationSound),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AlarmSoundScreen()),
        );
        // 돌아왔을 때 UI 새로고침
        setState(() {});
      },
    );
  }

  Widget _buildBadgeTile(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: BadgeService.instance.getStats(),
      builder: (context, snapshot) {
        final stats = snapshot.data;
        final streak = stats?.currentStreak ?? 0;
        final badgeCount = stats?.badges.length ?? 0;

        return ListTile(
          leading: const Text('🏆', style: TextStyle(fontSize: 24)),
          title: Text(l10n.badgeCollection),
          subtitle: Text('🔥 ${l10n.streakDays(streak)} · ${l10n.badgesEarned(badgeCount)}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BadgeCollectionScreen(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInviteTile(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final userProfile = ref.watch(userProfileProvider).value;
    final bonusLinks = userProfile?.bonusLinks ?? 0;
    final maxBonus = 1; // AppConstants.maxBonusLinks

    // 사용자의 추천 코드
    final referralCode = user != null
        ? FirestoreService.instance.generateReferralCode(user.uid)
        : '--------';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎁', style: TextStyle(fontSize: 24)),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.inviteFriendsMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.bonusStatus(bonusLinks, maxBonus),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          // 초대 코드 표시
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.referralCode,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                    ),
                    Text(
                      referralCode,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _copyReferralCode(referralCode),
                      tooltip: l10n.copyReferralCode,
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareReferralCode(referralCode),
                      tooltip: l10n.share,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyReferralCode(String code) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.referralCodeCopied)),
    );
  }

  void _shareReferralCode(String code) {
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    // 미리보기 다이얼로그로 공유
    SharePreviewDialog.show(
      context,
      referralCode: code,
      isKorean: isKorean,
    );
  }
}
