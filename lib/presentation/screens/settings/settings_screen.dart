import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/auth_service.dart';
import '../../../services/badge_service.dart';
import '../../../services/firestore_service.dart';
import '../../../services/notification_service.dart';
import '../auth/login_screen.dart';
import '../badges/badge_collection_screen.dart';
import '../privacy/privacy_policy_screen.dart';
import '../terms/terms_of_service_screen.dart';
import 'edit_profile_screen.dart';

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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.premium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.premiumBenefitsList),
            const SizedBox(height: 8),
            Text('• ${l10n.premiumBenefit1}'),
            Text('• ${l10n.premiumBenefit2}'),
            const SizedBox(height: 16),
            Text(l10n.premiumPrice),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.premiumLater),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.premiumPaymentNotReady)),
              );
            },
            child: Text(l10n.premiumBuy),
          ),
        ],
      ),
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
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
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.contactNotReady)),
    );
  }

  void _onTermsOfService() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
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

          const SizedBox(height: Spacing.md),

          // 뱃지 & 통계 섹션
          _buildSectionTitle('뱃지 & 통계'),
          _buildBadgeTile(colorScheme),

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
            title: '이용약관',
            trailing: const Icon(Icons.chevron_right),
            onTap: _onTermsOfService,
          ),
          _buildSettingsTile(
            icon: Icons.mail_outline,
            title: l10n.contact,
            trailing: const Icon(Icons.chevron_right),
            onTap: _onContact,
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

  Widget _buildPremiumTile(ColorScheme colorScheme) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final isPremium = userProfileAsync.value?.isPremium ?? false;

    return _buildSettingsTile(
      icon: Icons.workspace_premium_outlined,
      title: isPremium ? '프리미엄 사용 중' : '프리미엄 구매',
      subtitle: isPremium ? null : '무제한 링크, 광고 제거',
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
    if (providerIds.contains('oidc.kakao')) return '카카오';
    return '';
  }

  Widget _buildProfileTile(ColorScheme colorScheme) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final isGuest = user?.isAnonymous ?? true;

    // 연결된 provider 확인
    final linkedProviders = user?.providerData.map((p) => p.providerId).toList() ?? [];
    final snsType = _getLinkedSnsType(linkedProviders);
    final hasLinkedSns = snsType.isNotEmpty;

    // 닉네임 가져오기
    String nickname;
    bool isPremium = false;

    if (isGuest) {
      nickname = AuthService.instance.getGuestNickname();
    } else {
      final profile = ref.watch(userProfileProvider).value;
      nickname = profile?.nickname ?? AuthService.instance.getGuestNickname();
      isPremium = profile?.isPremium ?? false;
    }

    return GestureDetector(
      onLongPress: _onTogglePremium,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            hasLinkedSns ? Icons.person : Icons.person_outline,
            color: colorScheme.onPrimaryContainer,
          ),
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
          hasLinkedSns ? '계정 연동됨' : '로그인하여 데이터 동기화',
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

  Widget _buildBadgeTile(ColorScheme colorScheme) {
    return FutureBuilder(
      future: BadgeService.instance.getStats(),
      builder: (context, snapshot) {
        final stats = snapshot.data;
        final streak = stats?.currentStreak ?? 0;
        final badgeCount = stats?.badges.length ?? 0;

        return ListTile(
          leading: const Text('🏆', style: TextStyle(fontSize: 24)),
          title: const Text('뱃지 컬렉션'),
          subtitle: Text('🔥 $streak일 스트릭 · $badgeCount개 획득'),
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
}
