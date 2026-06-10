import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../providers/verification_provider.dart';
import '../../../services/verification_video_service.dart';

/// 차단한 사용자 관리 화면 (설정에서 진입). App Store 가이드라인 충족.
class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';
    final blockedAsync = ref.watch(blockedUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isKorean ? '차단한 사용자' : 'Blocked Users'),
      ),
      body: blockedAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 64,
                      color: colorScheme.outline.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(
                      isKorean
                          ? '차단한 사용자가 없어요'
                          : 'No blocked users',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(Spacing.md),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: Spacing.sm),
                color: colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        colorScheme.errorContainer.withValues(alpha: 0.5),
                    child: const Icon(Icons.block, size: 20),
                  ),
                  title: Text(
                    user.nickname.isEmpty
                        ? (isKorean ? '익명' : 'Anonymous')
                        : user.nickname,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _formatDate(user.blockedAt, isKorean),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      await VerificationVideoService.instance
                          .unblockUser(user.uid);
                      ref.invalidate(blockedUsersProvider);
                    },
                    child: Text(isKorean ? '차단 해제' : 'Unblock'),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  String _formatDate(DateTime date, bool isKorean) {
    return isKorean
        ? '${date.year}년 ${date.month}월 ${date.day}일 차단됨'
        : 'Blocked on ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
