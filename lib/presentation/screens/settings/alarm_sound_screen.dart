import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/alarm_sound_service.dart';
import '../../../services/firestore_service.dart';

/// Ping 알림음 설정 화면
/// 찔러보기/응원하기 알림에 사용되는 소리
/// 효과음만 표시, 모두 무료
class AlarmSoundScreen extends ConsumerStatefulWidget {
  const AlarmSoundScreen({super.key});

  @override
  ConsumerState<AlarmSoundScreen> createState() => _AlarmSoundScreenState();
}

class _AlarmSoundScreenState extends ConsumerState<AlarmSoundScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _selectedSoundId = 'fxs_ding';
  String? _playingSoundId;

  // 캐시된 효과음 리스트 (알람 제외)
  late final List<AlarmSound> _effectSounds;

  @override
  void initState() {
    super.initState();
    _selectedSoundId = AlarmSoundService.instance.getSelectedSoundId();

    // 효과음만 가져오기 (Ping 알림용)
    _effectSounds = AlarmSoundService.instance.getEffectSounds();

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _playingSoundId = null);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(AlarmSound sound) async {
    // 이미 재생 중이면 중지
    if (_playingSoundId == sound.id) {
      await _audioPlayer.stop();
      setState(() => _playingSoundId = null);
      return;
    }

    setState(() => _playingSoundId = sound.id);

    try {
      try {
        await _audioPlayer.play(AssetSource('sounds/${sound.fileName}.mp3'));
      } catch (_) {
        await _audioPlayer.play(AssetSource('sounds/${sound.fileName}.wav'));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _playingSoundId = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.soundNotAvailable),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _selectSound(AlarmSound sound) async {
    setState(() => _selectedSoundId = sound.id);
    await AlarmSoundService.instance.setSelectedSoundId(sound.id);

    // 통계 기록
    FirestoreService.instance.logSoundSelection(
      soundId: sound.id,
      category: 'ping_notification',
      isPremium: sound.isPremium,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.soundSelected),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;

    final selectedSound = AlarmSoundService.instance.getSoundById(_selectedSoundId);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pingNotificationSound),
      ),
      body: Column(
        children: [
          // 설명
          Container(
            margin: const EdgeInsets.all(Spacing.md),
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.notifications_active, color: colorScheme.primary),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.currentSound,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        selectedSound?.getName(langCode) ?? l10n.pingNotificationSound,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.pingNotificationSoundDesc,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_playingSoundId != null)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),

          // 효과음 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              itemCount: _effectSounds.length,
              itemBuilder: (context, index) {
                final sound = _effectSounds[index];
                final isSelected = _selectedSoundId == sound.id;
                final isPlaying = _playingSoundId == sound.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: Spacing.xs),
                  color: isSelected
                      ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                      : null,
                  child: ListTile(
                    onTap: () => _selectSound(sound),
                    leading: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.stop_circle : Icons.play_circle,
                        color: colorScheme.primary,
                      ),
                      onPressed: () => _playSound(sound),
                    ),
                    title: Text(sound.getName(langCode)),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: colorScheme.primary)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
