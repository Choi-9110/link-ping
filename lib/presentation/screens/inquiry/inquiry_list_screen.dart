import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/inquiry.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/firestore_service.dart';
import 'create_inquiry_screen.dart';
import 'inquiry_detail_screen.dart';

class InquiryListScreen extends StatelessWidget {
  const InquiryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contact),
      ),
      body: StreamBuilder<List<Inquiry>>(
        stream: FirestoreService.instance.myInquiriesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text('${l10n.error}: ${snapshot.error}'),
                ],
              ),
            );
          }

          final inquiries = snapshot.data ?? [];

          if (inquiries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 80,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    l10n.noInquiries,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    l10n.inquiryHint,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  FilledButton.icon(
                    onPressed: () => _createInquiry(context),
                    icon: const Icon(Icons.edit),
                    label: Text(l10n.contact),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(Spacing.md),
            itemCount: inquiries.length,
            itemBuilder: (context, index) {
              final inquiry = inquiries[index];
              return _InquiryCard(
                inquiry: inquiry,
                onTap: () => _viewInquiry(context, inquiry.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createInquiry(context),
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _createInquiry(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateInquiryScreen()),
    );
  }

  void _viewInquiry(BuildContext context, String inquiryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InquiryDetailScreen(inquiryId: inquiryId),
      ),
    );
  }
}

class _InquiryCard extends StatelessWidget {
  final Inquiry inquiry;
  final VoidCallback onTap;

  const _InquiryCard({
    required this.inquiry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAnswered = inquiry.status == InquiryStatus.answered;

    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 상태 배지
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isAnswered
                          ? Colors.green.withValues(alpha: 0.1)
                          : colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      inquiry.statusString,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isAnswered ? Colors.green : colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  // 날짜
                  Text(
                    _formatDate(inquiry.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              // 제목
              Text(
                inquiry.title,
                style: theme.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // 내용 미리보기
              Text(
                inquiry.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // 답변 미리보기 (있는 경우)
              if (isAnswered && inquiry.adminReply != null) ...[
                const SizedBox(height: Spacing.sm),
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.reply,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          inquiry.adminReply!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.green.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
