import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/recommended_link.dart';
import '../../../providers/bookmark_provider.dart';
import '../../../providers/recommended_provider.dart';
import '../../../services/url_launcher_service.dart';
import '../../widgets/toast_overlay.dart';
import '../add_link/add_link_screen.dart';
import 'folder_picker_sheet.dart';

/// 추천 링크 리스트 화면
class RecommendedListScreen extends ConsumerWidget {
  const RecommendedListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedAsync = ref.watch(recommendedLinksProvider);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isKorean ? '⭐ 추천' : '⭐ Recommended',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: recommendedAsync.when(
        data: (recommended) {
          if (recommended.isEmpty) {
            return _buildEmpty(context, isKorean);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(Spacing.md),
            itemCount: recommended.length,
            itemBuilder: (context, index) => _buildCard(
              context,
              ref,
              link: recommended[index],
              isKorean: isKorean,
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildEmpty(context, isKorean),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, bool isKorean) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_outline,
            size: 64,
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            isKorean ? '추천 링크가 곧 업데이트됩니다!' : 'Recommended links coming soon!',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref, {
    required RecommendedLink link,
    required bool isKorean,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(link.emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        title: Text(
          link.title(isKorean),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: link.description(isKorean).isNotEmpty
            ? Text(
                link.description(isKorean),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Icon(Icons.more_horiz, color: colorScheme.outline),
        onTap: () => _showActions(context, ref, link, isKorean),
      ),
    );
  }

  void _showActions(
    BuildContext context,
    WidgetRef ref,
    RecommendedLink link,
    bool isKorean,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                child: Row(
                  children: [
                    Text(link.emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            link.title(isKorean),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (link.description(isKorean).isNotEmpty)
                            Text(
                              link.description(isKorean),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.outline,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.md),
              const Divider(),

              // 링크 열기
              ListTile(
                leading: Icon(Icons.open_in_new, color: colorScheme.primary),
                title: Text(isKorean ? '링크 열기' : 'Open Link'),
                onTap: () {
                  Navigator.pop(ctx);
                  UrlLauncherService.openUrl(link.url);
                },
              ),

              // 알람으로 설정
              ListTile(
                leading: Icon(Icons.alarm_add, color: colorScheme.tertiary),
                title: Text(isKorean ? '링크 알람으로 설정' : 'Set as Link Alarm'),
                subtitle: Text(
                  isKorean
                      ? '매일 알림 받고 꾸준히 실천하기'
                      : 'Get daily reminders to stay consistent',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddLinkScreen(initialUrl: link.url),
                    ),
                  );
                },
              ),

              // 북마크에 저장
              ListTile(
                leading: Icon(Icons.bookmark_add, color: colorScheme.secondary),
                title: Text(isKorean ? '내 북마크에 저장' : 'Save to Bookmarks'),
                subtitle: Text(
                  isKorean ? '폴더를 골라서 저장' : 'Pick a folder to save',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final folderId = await FolderPickerSheet.show(context);
                  if (folderId == null) return;
                  await ref.read(bookmarksProvider.notifier).addBookmark(
                        url: link.url,
                        title: link.title(isKorean),
                        folderId: folderId,
                      );
                  if (context.mounted) {
                    ToastOverlay.showSuccess(
                      context,
                      isKorean ? '북마크에 저장했어요' : 'Saved to bookmarks',
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
