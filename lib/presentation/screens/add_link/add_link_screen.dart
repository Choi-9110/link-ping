import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/link_reminder.dart';
import '../../../providers/poring_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/ad_service.dart';
import '../../../services/alarm_sound_service.dart';
import '../../../services/url_launcher_service.dart';
import '../../widgets/sound_picker_bottom_sheet.dart';
import '../../widgets/toast_overlay.dart';
import '../../widgets/wheel_time_picker.dart';

class AddLinkScreen extends ConsumerStatefulWidget {
  final String? initialUrl;

  const AddLinkScreen({super.key, this.initialUrl});

  @override
  ConsumerState<AddLinkScreen> createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends ConsumerState<AddLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();

  // 다중 알림 시간 리스트 (프리미엄) - 현재 시간으로 초기화
  late final List<TimeOfDay> _selectedTimes;
  final Set<int> _selectedDays = {0, 1, 2, 3, 4, 5, 6}; // 기본: 매일

  // 종료일 설정
  bool _hasEndDate = false;
  DateTime? _endDate;

  // 공유 시 시간 고정 여부
  bool _isLocked = false;

  // 광고 로딩 상태
  bool _isLoadingAd = false;

  // 카테고리
  LinkCategory? _selectedCategory;

  // 알람 소리
  String? _selectedSoundId;

  static const int _maxTimesForPremium = 10;

  @override
  void initState() {
    super.initState();

    // 현재 시간으로 초기화 (분은 0으로)
    final now = TimeOfDay.now();
    _selectedTimes = [TimeOfDay(hour: now.hour, minute: 0)];

    if (widget.initialUrl != null) {
      _urlController.text = widget.initialUrl!;
    }
    // 보상형 광고 미리 로드
    AdService.instance.loadRewardedAd(useTestAd: AdService.instance.useTestAds);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String? url) {
    return UrlLauncherService.isValidUrl(url);
  }

  Future<void> _selectTime(int index) async {
    final time = await WheelTimePicker.show(
      context,
      initialTime: _selectedTimes[index],
    );
    if (time != null) {
      setState(() {
        _selectedTimes[index] = time;
      });
    }
  }

  void _addTime() {
    final isPremium = ref.read(userProfileProvider).value?.isPremium ?? false;

    // 프리미엄은 최대 10개까지
    if (isPremium) {
      if (_selectedTimes.length >= _maxTimesForPremium) return;
      _doAddTime();
      return;
    }

    // 무료 유저: 포링 사용 또는 광고 시청
    _showPoringUnlockForTime();
  }

  void _doAddTime() {
    setState(() {
      // 마지막 시간에서 1시간 후를 기본값으로
      final lastTime = _selectedTimes.last;
      final newHour = (lastTime.hour + 1) % 24;
      _selectedTimes.add(TimeOfDay(hour: newHour, minute: lastTime.minute));
    });
  }

  Future<void> _showPoringUnlockForTime() async {
    final l10n = AppLocalizations.of(context)!;
    final poringNotifier = ref.read(poringProvider.notifier);
    final poringState = ref.read(poringProvider);

    if (poringState.balance > 0) {
      // 포링 있으면: 포링으로 잠금해제 확인
      final shouldUse = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.addTimeWithPoring),
          content: Text(l10n.poringCostConfirm),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );

      if (shouldUse != true) return;

      final success = await poringNotifier.spendPoring();
      if (success && mounted) {
        _doAddTime();
        ToastOverlay.showSuccess(context, l10n.poringSpent);
      }
    } else {
      // 포링 없으면: 광고 보고 즉시 획득+사용
      if (_isLoadingAd) return;

      final shouldWatch = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.poringNotEnough),
          content: Text(l10n.poringWatchAdToEarnAndUse),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.watchAd),
            ),
          ],
        ),
      );

      if (shouldWatch != true) return;

      setState(() => _isLoadingAd = true);

      if (!AdService.instance.isRewardedAdReady) {
        await AdService.instance.loadRewardedAd(
          useTestAd: AdService.instance.useTestAds,
        );
        await Future.delayed(const Duration(milliseconds: 1000));

        if (!AdService.instance.isRewardedAdReady) {
          setState(() => _isLoadingAd = false);
          if (mounted) {
            ToastOverlay.showError(context, l10n.adLoadFailed);
          }
          return;
        }
      }

      await AdService.instance.showRewardedAd(
        useTestAd: AdService.instance.useTestAds,
        onRewarded: () async {
          if (mounted) {
            // 포링 획득 후 즉시 차감
            await poringNotifier.earnPoring();
            await poringNotifier.spendPoring();
            _doAddTime();
            ToastOverlay.showSuccess(context, l10n.timeAddedSuccess);
          }
        },
        onAdFailed: (error) {
          if (mounted) {
            ToastOverlay.showError(context, l10n.adLoadFailed);
          }
        },
      );

      if (mounted) {
        setState(() => _isLoadingAd = false);
      }
    }
  }

  Future<void> _removeTime(int index) async {
    if (_selectedTimes.length <= 1) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteTimeConfirm),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _selectedTimes.removeAt(index);
      });
    }
  }

  void _setQuickDays(List<int> days) {
    setState(() {
      _selectedDays.clear();
      _selectedDays.addAll(days);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.selectRepeatDays)));
      return;
    }

    final url = _urlController.text.trim();
    final title = _titleController.text.trim();

    // 첫 번째 시간은 기본 시간, 나머지는 추가 시간
    final primaryTime = _selectedTimes.first;
    final additionalTimes = _selectedTimes.length > 1
        ? _selectedTimes
              .skip(1)
              .map((t) => ReminderTime(hour: t.hour, minute: t.minute))
              .toList()
        : null;

    if (mounted) {
      Navigator.pop(context, {
        'url': url,
        'title': title,
        'hour': primaryTime.hour,
        'minute': primaryTime.minute,
        'repeatDays': _selectedDays.toList()..sort(),
        'additionalTimes': additionalTimes,
        'endDate': _hasEndDate ? _endDate : null,
        'isLocked': _isLocked,
        'category': _selectedCategory,
        'soundId': _selectedSoundId,
      });
    }
  }

  Future<void> _selectEndDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)), // 5년 후까지
    );
    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPremium = ref.watch(userProfileProvider).value?.isPremium ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addLink)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            // URL 또는 전화번호 입력
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: l10n.linkUrl,
                hintText: l10n.linkUrlHint,
                prefixIcon: const Icon(Icons.link),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (!_isValidUrl(value)) {
                  return l10n.invalidUrl;
                }
                return null;
              },
            ),
            const SizedBox(height: Spacing.md),

            // 제목 입력
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.reminderTitle,
                hintText: l10n.reminderTitleHint,
                prefixIcon: const Icon(Icons.notifications),
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.enterTitle;
                }
                return null;
              },
            ),
            const SizedBox(height: Spacing.md),

            // 카테고리 선택
            _buildCategorySection(),
            const SizedBox(height: Spacing.lg),

            // 알람 소리 선택
            _buildSoundSection(),
            const SizedBox(height: Spacing.lg),

            // 알림 시간 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.reminderTime,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (isPremium && _selectedTimes.length < _maxTimesForPremium)
                  TextButton.icon(
                    onPressed: _addTime,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.addTime),
                  )
                else if (!isPremium)
                  TextButton.icon(
                    onPressed: _isLoadingAd ? null : _addTime,
                    icon: _isLoadingAd
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Icons.notifications_active,
                            size: 18,
                            color: Colors.amber.shade700,
                          ),
                    label: Text(
                      _isLoadingAd ? l10n.loading : l10n.addTimeWithPoring,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.sm),

            // 시간 목록
            ..._buildTimesList(),
            const SizedBox(height: Spacing.lg),

            // 반복 요일 섹션
            Text(l10n.repeat, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: Spacing.sm),

            // 빠른 선택 (매일, 평일, 주말)
            _buildQuickSelect(),
            const SizedBox(height: Spacing.sm),

            // 개별 요일 선택
            _buildDayChips(),
            const SizedBox(height: Spacing.lg),

            // 종료일 설정
            _buildEndDateSection(),
            const SizedBox(height: Spacing.lg),

            // 공유 시 시간 고정 설정
            _buildLockSection(),
            const SizedBox(height: Spacing.xl),

            // 저장 버튼
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimesList() {
    return List.generate(_selectedTimes.length, (index) {
      final time = _selectedTimes[index];
      final isFirst = index == 0;

      return Padding(
        padding: const EdgeInsets.only(bottom: Spacing.xs),
        child: ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(time.format(context)),
          trailing: isFirst
              ? const Icon(Icons.chevron_right)
              : IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _removeTime(index),
                ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          onTap: () => _selectTime(index),
        ),
      );
    });
  }

  Widget _buildQuickSelect() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDaily = _selectedDays.length == 7;
    final isWeekdays =
        _selectedDays.length == 5 && _selectedDays.containsAll([1, 2, 3, 4, 5]);
    final isWeekends =
        _selectedDays.length == 2 && _selectedDays.containsAll([0, 6]);

    // 리플 효과 통일을 위한 칩 스타일
    Widget buildChip({
      required String label,
      required bool isSelected,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: Spacing.sm,
      children: [
        buildChip(
          label: l10n.everyday,
          isSelected: isDaily,
          onTap: () => _setQuickDays([0, 1, 2, 3, 4, 5, 6]),
        ),
        buildChip(
          label: l10n.weekdays,
          isSelected: isWeekdays,
          onTap: () => _setQuickDays([1, 2, 3, 4, 5]),
        ),
        buildChip(
          label: l10n.weekends,
          isSelected: isWeekends,
          onTap: () => _setQuickDays([0, 6]),
        ),
      ],
    );
  }

  Widget _buildDayChips() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    // 월화수목금토일 순서 (내부 인덱스: 1,2,3,4,5,6,0)
    final dayOrder = [1, 2, 3, 4, 5, 6, 0]; // 월=1, 화=2, ... 토=6, 일=0
    final dayLabels = [
      l10n.mon,
      l10n.tue,
      l10n.wed,
      l10n.thu,
      l10n.fri,
      l10n.sat,
      l10n.sun,
    ];

    Widget buildDayChip(int dayIndex, String label) {
      final isSelected = _selectedDays.contains(dayIndex);
      return GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedDays.remove(dayIndex);
            } else {
              _selectedDays.add(dayIndex);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단: 월화수목금 (5개)
        Wrap(
          spacing: Spacing.xs,
          children: List.generate(
            5,
            (i) => buildDayChip(dayOrder[i], dayLabels[i]),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        // 하단: 토일 (2개)
        Wrap(
          spacing: Spacing.xs,
          children: List.generate(
            2,
            (i) => buildDayChip(dayOrder[5 + i], dayLabels[5 + i]),
          ),
        ),
      ],
    );
  }

  Widget _buildEndDateSection() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 종료일 토글
        SwitchListTile(
          title: Text(l10n.setEndDate),
          subtitle: Text(
            _hasEndDate ? l10n.endDateEnabled : l10n.endDateDisabled,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          value: _hasEndDate,
          onChanged: (value) {
            setState(() {
              _hasEndDate = value;
              if (value && _endDate == null) {
                _endDate = DateTime.now().add(const Duration(days: 7));
              }
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        // 종료일 선택
        if (_hasEndDate) ...[
          const SizedBox(height: Spacing.sm),
          ListTile(
            leading: const Icon(Icons.event),
            title: Text(
              _endDate != null
                  ? '${_endDate!.year}.${_endDate!.month.toString().padLeft(2, '0')}.${_endDate!.day.toString().padLeft(2, '0')}'
                  : l10n.selectEndDate,
            ),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline),
            ),
            onTap: _selectEndDate,
          ),
        ],
      ],
    );
  }

  Widget _buildLockSection() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: _isLocked
            ? colorScheme.error.withValues(alpha: 0.05)
            : colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isLocked
              ? colorScheme.error.withValues(alpha: 0.3)
              : colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.share, size: 20, color: colorScheme.onSurface),
              const SizedBox(width: 8),
              Text(
                l10n.shareSettings,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          // 옵션 선택
          Row(
            children: [
              Expanded(
                child: _buildLockOption(
                  icon: Icons.lock_open,
                  label: l10n.editable,
                  subtitle: l10n.recipientCanChangeTime,
                  isSelected: !_isLocked,
                  color: colorScheme.primary,
                  onTap: () => setState(() => _isLocked = false),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _buildLockOption(
                  icon: Icons.lock,
                  label: l10n.timeLocked,
                  subtitle: l10n.shareAtThisTime,
                  isSelected: _isLocked,
                  color: colorScheme.error,
                  onTap: () => setState(() => _isLocked = true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.category, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: Spacing.xs,
          runSpacing: Spacing.xs,
          children: LinkCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            final colorScheme = Theme.of(context).colorScheme;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = isSelected ? null : category;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  category.displayName(isKorean),
                  style: TextStyle(
                    color: isSelected ? Colors.white : colorScheme.onSurface,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLockOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? color : Colors.grey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? color.withValues(alpha: 0.8) : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundSection() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final langCode = locale.languageCode;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPremium = ref.watch(userProfileProvider).value?.isPremium ?? false;

    // 현재 선택된 소리 (없으면 전역 설정에서)
    final currentSoundId =
        _selectedSoundId ?? AlarmSoundService.instance.getSelectedSoundId();
    final currentSound = AlarmSoundService.instance.getSoundById(
      currentSoundId,
    );
    final soundName = currentSound?.getName(langCode) ?? l10n.alarmSound;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.alarmSound, style: theme.textTheme.titleMedium),
        const SizedBox(height: Spacing.sm),
        ListTile(
          leading: Icon(
            currentSound?.category == SoundCategory.alarm
                ? Icons.alarm
                : Icons.notifications_active,
            color: colorScheme.primary,
          ),
          title: Text(soundName),
          subtitle: Text(
            _selectedSoundId == null
                ? l10n.alarmSoundDescription
                : (currentSound?.category == SoundCategory.alarm
                      ? l10n.soundCategoryAlarm
                      : l10n.soundCategoryNotify),
          ),
          trailing: const Icon(Icons.chevron_right),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outline),
          ),
          onTap: () async {
            final selectedId = await SoundCategoryDialog.show(
              context,
              initialSoundId: _selectedSoundId,
              isPremium: isPremium,
              langCode: langCode,
            );
            if (selectedId != null && mounted) {
              setState(() => _selectedSoundId = selectedId);
              ToastOverlay.showSuccess(context, l10n.soundSelected);
            }
          },
        ),
      ],
    );
  }
}
