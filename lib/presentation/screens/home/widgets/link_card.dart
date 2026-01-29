import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../data/models/link_reminder.dart';
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SavedUsersBottomSheet(
        urlHash: link.urlHash,
        urlTitle: link.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          builder: (context) => AlertDialog(
            title: const Text('삭제'),
            content: const Text('이 링크를 삭제할까요?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('삭제'),
              ),
            ],
          ),
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
                      // 제목
                      Text(
                        link.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: link.isEnabled ? null : colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // 시간
                      Text(
                        '${link.repeatString} ${link.timeString}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
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
                            '$saveCount명이 저장',
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
      // 스킴이 없을 수 있으므로 ensureScheme 사용
      final normalizedUrl = UrlLauncherService.ensureScheme(url);
      final host = Uri.parse(normalizedUrl).host.toLowerCase();

      // 주요 서비스 매핑
      if (host.contains('naver')) return '네이버';
      if (host.contains('youtube') || host.contains('youtu.be')) return '유튜브';
      if (host.contains('instagram')) return '인스타그램';
      if (host.contains('tiktok')) return '틱톡';
      if (host.contains('twitter') || host.contains('x.com')) return 'X (트위터)';
      if (host.contains('facebook')) return '페이스북';
      if (host.contains('kakao')) return '카카오';
      if (host.contains('google')) return '구글';
      if (host.contains('github')) return 'GitHub';
      if (host.contains('notion')) return '노션';
      if (host.contains('velog')) return '벨로그';
      if (host.contains('tistory')) return '티스토리';
      if (host.contains('brunch')) return '브런치';
      if (host.contains('linkedin')) return '링크드인';
      if (host.contains('reddit')) return '레딧';
      if (host.contains('twitch')) return '트위치';
      if (host.contains('spotify')) return '스포티파이';
      if (host.contains('apple')) return '애플';
      if (host.contains('amazon')) return '아마존';
      if (host.contains('coupang')) return '쿠팡';

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
