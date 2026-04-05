import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../data/models/link_reminder.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/url_launcher_service.dart';
import '../../../widgets/saved_users_bottom_sheet.dart';

class LinkCard extends StatelessWidget {
  final LinkReminder link;
  final int saveCount;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const LinkCard({
    super.key,
    required this.link,
    required this.saveCount,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  void _showSavedUsers(BuildContext context) {
    if (link.sharedLinkId == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SavedUsersBottomSheet(
        sharedLinkId: link.sharedLinkId!,
        urlTitle: link.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Dismissible(
      key: Key(link.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.md),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            final dialogL10n = AppLocalizations.of(dialogContext)!;
            return AlertDialog(
              title: Text(dialogL10n.delete),
              content: Text(dialogL10n.deleteConfirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(dialogL10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(dialogL10n.delete),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) => onDelete(),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: link.isEnabled
                ? colorScheme.outline
                : colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 좌측: 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 카테고리 뱃지
                      if (link.category != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Builder(builder: (context) {
                            final locale = Localizations.localeOf(context);
                            final isKorean = locale.languageCode == 'ko';
                            return Text(
                              link.category!.displayName(isKorean),
                              style: TextStyle(
                                fontSize: 10,
                                color: colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                      ],
                      // 제목
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              link.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: link.isEnabled ? null : colorScheme.outline,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // 잠금 링크 표시
                          if (link.isLocked) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock,
                                    size: 12,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    l10n.locked,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      // 시간
                      Builder(builder: (context) {
                        final locale = Localizations.localeOf(context);
                        final isKorean = locale.languageCode == 'ko';
                        return Text(
                          '${link.getRepeatString(isKorean)} ${link.timeString}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        );
                      }),
                      const SizedBox(height: 2),
                      // 서비스명
                      Text(
                        _getServiceName(link.url),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                      // 저장 수
                      if (saveCount > 0) ...[
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () => _showSavedUsers(context),
                          child: Text(
                            l10n.savedByCount(saveCount),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // 우측: 토글 + D-day + 날짜
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 토글
                    Switch(
                      value: link.isEnabled,
                      onChanged: (_) => onToggle(),
                    ),
                    // D-day 박스
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: link.isEnabled
                            ? (link.hasEndDate
                                ? colorScheme.secondary.withValues(alpha: 0.1)
                                : colorScheme.primary.withValues(alpha: 0.1))
                            : colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        link.dDayString,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: link.isEnabled
                              ? (link.hasEndDate
                                  ? colorScheme.secondary
                                  : colorScheme.primary)
                              : colorScheme.outline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 날짜 (종료일 있으면 종료일, 없으면 생성일)
                    Text(
                      link.hasEndDate
                          ? '~${_formatDate(link.endDate!)}'
                          : _formatDate(link.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// URL에서 서비스명 추출
  String _getServiceName(String url) {
    try {
      // 전화번호인 경우
      final normalizedUrl = UrlLauncherService.ensureScheme(url);
      if (UrlLauncherService.isPhoneUrl(normalizedUrl)) {
        final phoneNumber = UrlLauncherService.getDisplayPhoneNumber(normalizedUrl);
        return '📞 $phoneNumber';
      }

      final host = Uri.parse(normalizedUrl).host.toLowerCase();

      // 주요 서비스 매핑 (영어 브랜드명)
      if (host.contains('naver')) return 'Naver';
      if (host.contains('youtube') || host.contains('youtu.be')) return 'YouTube';
      if (host.contains('instagram')) return 'Instagram';
      if (host.contains('tiktok')) return 'TikTok';
      if (host.contains('twitter') || host.contains('x.com')) return 'X';
      if (host.contains('facebook')) return 'Facebook';
      if (host.contains('kakao')) return 'Kakao';
      if (host.contains('google')) return 'Google';
      if (host.contains('github')) return 'GitHub';
      if (host.contains('notion')) return 'Notion';
      if (host.contains('velog')) return 'Velog';
      if (host.contains('tistory')) return 'Tistory';
      if (host.contains('brunch')) return 'Brunch';
      if (host.contains('linkedin')) return 'LinkedIn';
      if (host.contains('reddit')) return 'Reddit';
      if (host.contains('twitch')) return 'Twitch';
      if (host.contains('spotify')) return 'Spotify';
      if (host.contains('apple')) return 'Apple';
      if (host.contains('amazon')) return 'Amazon';
      if (host.contains('coupang')) return 'Coupang';

      // 매핑되지 않으면 호스트 반환 (www. 제거)
      return host.replaceFirst('www.', '');
    } catch (_) {
      return url;
    }
  }

  /// 날짜 포맷
  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
