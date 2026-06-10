import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/verification_video.dart';
import '../../../providers/user_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../services/pixel_emoji_service.dart';
import '../../widgets/premium_purchase_sheet.dart';

/// "누가 봤지?" — 인증 영상 시청자 목록. 프리미엄만 접근 가능.
class VerificationViewersScreen extends ConsumerStatefulWidget {
  final VerificationVideo video;

  const VerificationViewersScreen({super.key, required this.video});

  @override
  ConsumerState<VerificationViewersScreen> createState() =>
      _VerificationViewersScreenState();
}

class _VerificationViewersScreenState
    extends ConsumerState<VerificationViewersScreen> {
  Future<List<UserProfile>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<UserProfile>> _load() async {
    final uids = widget.video.viewedByUids;
    if (uids.isEmpty) return const [];
    final profiles = await Future.wait(
      uids.map((uid) => FirestoreService.instance.getUserProfile(uid)),
    );
    return profiles.whereType<UserProfile>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';
    final profile = ref.watch(userProfileProvider).value;
    final isPremium = profile?.isPremium ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(isKorean ? '누가 봤지? 💎' : 'Who viewed 💎'),
      ),
      body: !isPremium
          ? _buildPremiumGate(context, isKorean, theme)
          : FutureBuilder<List<UserProfile>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.xl),
                      child: Text(
                        isKorean
                            ? '시청자 정보를 불러오지 못했어요'
                            : 'Failed to load viewers',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.outline),
                      ),
                    ),
                  );
                }
                final viewers = snapshot.data ?? const [];
                if (viewers.isEmpty) {
                  return Center(
                    child: Text(
                      isKorean
                          ? '아직 본 사람이 없어요'
                          : 'No one viewed yet',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.outline),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(Spacing.md),
                  itemCount: viewers.length,
                  itemBuilder: (context, index) {
                    final v = viewers[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: Spacing.sm),
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      child: ListTile(
                        leading: PixelEmojiService.buildPixelEmoji(
                          v.profileEmoji,
                          size: 36,
                        ),
                        title: Text(
                          v.nickname,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          v.country,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: colorScheme.outline),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildPremiumGate(
      BuildContext context, bool isKorean, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(Spacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('💎', style: const TextStyle(fontSize: 72)),
          const SizedBox(height: Spacing.lg),
          Text(
            isKorean ? '프리미엄 전용 기능' : 'Premium-only feature',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            isKorean
                ? '내 인증 영상을 누가 봤는지 확인할 수 있어요.\n프리미엄으로 업그레이드해보세요.'
                : 'See who watched your verification videos.\nUpgrade to Premium.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
              height: 1.5,
            ),
          ),
          const SizedBox(height: Spacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.upgrade),
              label: Text(
                isKorean ? '프리미엄 구독하기' : 'Get Premium',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const PremiumPurchaseSheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
