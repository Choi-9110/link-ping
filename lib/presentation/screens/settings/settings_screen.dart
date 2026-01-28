import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/auth_service.dart';
import '../../../services/notification_service.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationEnabled = true;

  void _onEditProfile() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.profileEditNotReady)),
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
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.privacyPolicyNotReady)),
    );
  }

  void _onContact() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.contactNotReady)),
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

  Widget _buildProfileTile(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final isGuest = authState.value?.isAnonymous ?? true;

    // 게스트인 경우
    if (isGuest) {
      final guestNickname = AuthService.instance.getGuestNickname();
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.person_outline,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        title: Row(
          children: [
            Text(guestNickname),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                l10n.guest,
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(l10n.guestSyncMessage),
        trailing: const Icon(Icons.chevron_right),
        onTap: _onEditProfile,
      );
    }

    // 회원인 경우
    final userProfileAsync = ref.watch(userProfileProvider);

    return userProfileAsync.when(
      data: (profile) {
        final nickname = profile?.nickname ?? l10n.guest;
        final country = profile?.country ?? '미설정';
        final isPremium = profile?.isPremium ?? false;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          title: Row(
            children: [
              Text(nickname),
              if (isPremium) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.workspace_premium,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ],
            ],
          ),
          subtitle: Text(country),
          trailing: const Icon(Icons.chevron_right),
          onTap: _onEditProfile,
        );
      },
      loading: () => ListTile(
        leading: const CircleAvatar(child: CircularProgressIndicator(strokeWidth: 2)),
        title: Text(l10n.loading),
      ),
      error: (_, __) => ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(Icons.person, color: colorScheme.onPrimaryContainer),
        ),
        title: Text(l10n.guest),
        subtitle: Text(l10n.guestSyncMessage),
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
}
