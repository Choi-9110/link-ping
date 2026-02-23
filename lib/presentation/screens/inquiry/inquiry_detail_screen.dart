import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/inquiry.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/firestore_service.dart';

class InquiryDetailScreen extends StatelessWidget {
  final String inquiryId;

  const InquiryDetailScreen({super.key, required this.inquiryId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inquiryDetail),
      ),
      body: StreamBuilder<Inquiry?>(
        stream: FirestoreService.instance.inquiryStream(inquiryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final inquiry = snapshot.data;
          if (inquiry == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(l10n.inquiryNotFound),
                ],
              ),
            );
          }

          final isAnswered = inquiry.status == InquiryStatus.answered;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상태 및 날짜
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isAnswered
                            ? Colors.green.withValues(alpha: 0.1)
                            : colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        inquiry.statusString,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isAnswered ? Colors.green : colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      _formatDateTime(inquiry.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.lg),

                // 제목
                Text(
                  inquiry.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Spacing.md),

                // 내용
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    inquiry.content,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                  ),
                ),

                // 답변 (있는 경우)
                if (isAnswered && inquiry.adminReply != null) ...[
                  const SizedBox(height: Spacing.xl),
                  // 구분선
                  Row(
                    children: [
                      Expanded(child: Divider(color: colorScheme.outline.withValues(alpha: 0.3))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                        child: Text(
                          l10n.reply,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: colorScheme.outline.withValues(alpha: 0.3))),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  // 답변 날짜
                  if (inquiry.repliedAt != null)
                    Text(
                      l10n.repliedOn(_formatDateTime(inquiry.repliedAt!)),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  const SizedBox(height: Spacing.sm),
                  // 답변 내용
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.support_agent,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                            Text(
                              l10n.linkPingTeam,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.md),
                        Text(
                          inquiry.adminReply!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 대기중 안내
                if (!isAnswered) ...[
                  const SizedBox(height: Spacing.xl),
                  Container(
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            l10n.waitingForReply,
                            style: TextStyle(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
