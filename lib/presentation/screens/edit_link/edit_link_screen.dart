import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/link_reminder.dart';
import '../../../providers/poring_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/ad_service.dart';
import '../../../services/alarm_sound_service.dart';
import '../../../services/time_unlock_service.dart';
import '../../../services/url_launcher_service.dart';
import '../../widgets/sound_picker_bottom_sheet.dart';
import '../../widgets/toast_overlay.dart';
import '../../widgets/wheel_time_picker.dart';

class EditLinkScreen extends ConsumerStatefulWidget {
  final LinkReminder link;

  const EditLinkScreen({
    super.key,
    required this.link,
  });

  @override
  ConsumerState<EditLinkScreen> createState() => _EditLinkScreenState();
}

class _EditLinkScreenState extends ConsumerState<EditLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;
  late final TextEditingController _titleController;

  late List<TimeOfDay> _selectedTimes;
  late Set<int> _selectedDays;

  // 종료일 설정
  late bool _hasEndDate;
  DateTime? _endDate;

  // 공유 시 시간 고정 여부 (내가 만든 링크만 수정 가능)
  late bool _isLocked;

  // 광고 로딩 상태
  bool _isLoadingAd = false;

  // 카테고리
  LinkCategory? _selectedCategory;

  // 공유받은 링크의 잠금해제된 시간 인덱스
  Set<int> _unlockedTimeIndices = {0}; // 첫 번째 시간은 항상 해제

  // 알람 소리
  String? _selectedSoundId;

  static const int _maxTimesForPremium = 10;

  @override
  void initState() {
    super.initState();
    // 기존 데이터로 초기화
    _urlController = TextEditingController(text: widget.link.url);
    _titleController = TextEditingController(text: widget.link.title);

    // 모든 시간 목록 초기화 (기본 시간 + 추가 시간)
    _selectedTimes = [TimeOfDay(hour: widget.link.hour, minute: widget.link.minute)];
    if (widget.link.additionalTimes != null) {
      _selectedTimes.addAll(
        widget.link.additionalTimes!.map((t) => TimeOfDay(hour: t.hour, minute: t.minute)),
      );
    }
    _selectedDays = Set<int>.from(widget.link.repeatDays);

    // 종료일 초기화
    _hasEndDate = widget.link.hasEndDate;
    _endDate = widget.link.endDate;

    // 잠금 설정 초기화
    _isLocked = widget.link.isLocked;

    // 카테고리 초기화
    _selectedCategory = widget.link.category;

    // 공유받은 링크의 잠금해제 상태 로드
    _unlockedTimeIndices = TimeUnlockService.getUnlockedTimeIndices(widget.link.id);

    // 알람 소리 초기화
    _selectedSoundId = widget.link.soundId;

    // 보상형 광고 미리 로드
    AdService.instance.loadRewardedAd(useTestAd: true); // TODO: 출시 시 false로
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
        await AdService.instance.loadRewardedAd(useTestAd: true); // TODO: 출시 시 false로
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
        useTestAd: true, // TODO: 출시 시 false로
        onRewarded: () async {
          if (mounted) {
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

  /// 공유받은 링크의 잠긴 시간을 포링으로 해제
  Future<void> _unlockTimeWithPoring(int timeIndex) async {
    final l10n = AppLocalizations.of(context)!;
    final poringNotifier = ref.read(poringProvider.notifier);
    final poringState = ref.read(poringProvider);

    if (poringState.balance > 0) {
      final shouldUse = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.poringUnlock),
          content: Text(l10n.poringUnlockConfirm),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.poringUnlock),
            ),
          ],
        ),
      );

      if (shouldUse != true) return;

      final success = await poringNotifier.spendPoring();
      if (success && mounted) {
        await TimeUnlockService.unlockTimeIndex(widget.link.id, timeIndex);
        setState(() {
          _unlockedTimeIndices.add(timeIndex);
        });
        ToastOverlay.showSuccess(context, l10n.poringSpent);
      }
    } else {
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
        await AdService.instance.loadRewardedAd(useTestAd: true); // TODO: 출시 시 false로
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
        useTestAd: true, // TODO: 출시 시 false로
        onRewarded: () async {
          if (mounted) {
            await poringNotifier.earnPoring();
            await poringNotifier.spendPoring();
            await TimeUnlockService.unlockTimeIndex(widget.link.id, timeIndex);
            setState(() {
              _unlockedTimeIndices.add(timeIndex);
            });
            ToastOverlay.showSuccess(context, l10n.timeUnlocked);
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
      ToastOverlay.showError(context, l10n.selectRepeatDays);
      return;
    }

    final url = _urlController.text.trim();
    final title = _titleController.text.trim();

    final isPremium = ref.read(userProfileProvider).value?.isPremium ?? false;
    final isSharedLink = widget.link.sharedBy != null;
    final isMyLockedAlarm = widget.link.isLocked &&
                            widget.link.sharedBy == null &&
                            widget.link.sharedLinkId != null;

    // 내가 만든 고정 알람인 경우, 시간/요일이 변경되었는지 확인
    if (isMyLockedAlarm) {
      final timeChanged = _hasTimeOrDaysChanged();
      if (timeChanged) {
        // 동의 요청 안내 다이얼로그
        final proceed = await _showConsentRequestDialog();
        if (proceed != true) return;
      }
    }

    // 공유받은 링크이고 무료 사용자면 잠금해제된 시간만 포함
    List<TimeOfDay> effectiveTimes;
    if (isSharedLink && !isPremium) {
      effectiveTimes = [];
      for (int i = 0; i < _selectedTimes.length; i++) {
        if (_unlockedTimeIndices.contains(i)) {
          effectiveTimes.add(_selectedTimes[i]);
        }
      }
      // 최소 1개는 있어야 함
      if (effectiveTimes.isEmpty) {
        effectiveTimes = [_selectedTimes.first];
      }
    } else {
      effectiveTimes = _selectedTimes;
    }

    final primaryTime = effectiveTimes.first;
    final additionalTimes = effectiveTimes.length > 1
        ? effectiveTimes.skip(1).map((t) => ReminderTime(hour: t.hour, minute: t.minute)).toList()
        : null;

    if (mounted) {
      Navigator.pop(context, {
        'id': widget.link.id,
        'url': url,
        'title': title,
        'hour': primaryTime.hour,
        'minute': primaryTime.minute,
        'repeatDays': _selectedDays.toList()..sort(),
        'additionalTimes': additionalTimes,
        'endDate': _hasEndDate ? _endDate : null,
        'clearEndDate': !_hasEndDate && widget.link.hasEndDate,
        'isLocked': _isLocked,
        'category': _selectedCategory,
        'clearCategory': _selectedCategory == null && widget.link.category != null,
        'soundId': _selectedSoundId,
        'clearSoundId': _selectedSoundId == null && widget.link.soundId != null,
        'needsConsent': isMyLockedAlarm && _hasTimeOrDaysChanged(), // 동의 필요 플래그
      });
    }
  }

  /// 시간 또는 요일이 변경되었는지 확인
  bool _hasTimeOrDaysChanged() {
    // 기본 시간 비교
    final originalTime = TimeOfDay(hour: widget.link.hour, minute: widget.link.minute);
    if (_selectedTimes.isEmpty || _selectedTimes.first != originalTime) {
      return true;
    }

    // 추가 시간 개수 비교
    final originalAdditionalCount = widget.link.additionalTimes?.length ?? 0;
    if (_selectedTimes.length - 1 != originalAdditionalCount) {
      return true;
    }

    // 추가 시간 내용 비교
    if (widget.link.additionalTimes != null) {
      for (int i = 0; i < widget.link.additionalTimes!.length; i++) {
        final orig = widget.link.additionalTimes![i];
        final curr = _selectedTimes[i + 1];
        if (orig.hour != curr.hour || orig.minute != curr.minute) {
          return true;
        }
      }
    }

    // 요일 비교
    final originalDays = Set<int>.from(widget.link.repeatDays);
    if (!_setEquals(originalDays, _selectedDays)) {
      return true;
    }

    return false;
  }

  bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    for (final item in a) {
      if (!b.contains(item)) return false;
    }
    return true;
  }

  /// 동의 요청 안내 다이얼로그
  Future<bool?> _showConsentRequestDialog() {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.people_outline),
            const SizedBox(width: 8),
            Text(l10n.consentRequest),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.consentRequestMessage,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Text(
              '• ${l10n.consentNote1}\n'
              '• ${l10n.consentNote2}\n'
              '• ${l10n.consentNote3}',
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.requestConsent),
          ),
        ],
      ),
    );
  }

  Future<void> _selectEndDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  void _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.pop(context, {'delete': true, 'id': widget.link.id});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPremium = ref.watch(userProfileProvider).value?.isPremium ?? false;
    final isLocked = widget.link.isLocked;
    // 공유받은 고정 알람인 경우에만 시간/요일 수정 불가
    // 내가 만든 고정 알람은 수정 가능 (저장 시 동의 요청)
    final isReceivedLocked = isLocked && widget.link.sharedBy != null;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editLink),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _delete,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            // 공유받은 고정 알람 안내 배너 (sharedBy가 있을 때만)
            if (isLocked && widget.link.sharedBy != null) ...[
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.timeLockedAlarm,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.receivedSharedAlarmInfo(widget.link.sharedBy!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.md),
            ],
            // 내가 만든 고정 알람 안내 배너 (공유한 경우)
            if (isLocked && widget.link.sharedBy == null && widget.link.sharedLinkId != null) ...[
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.secondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: colorScheme.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.timeLockedAlarm,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.sharedToOthersInfo,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.md),
            ],
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
                Row(
                  children: [
                    Text(
                      l10n.reminderTime,
                      style: theme.textTheme.titleMedium,
                    ),
                    if (isReceivedLocked) ...[
                      const SizedBox(width: Spacing.xs),
                      Icon(Icons.lock, size: 16, color: colorScheme.outline),
                    ],
                  ],
                ),
                if (!isReceivedLocked && isPremium && _selectedTimes.length < _maxTimesForPremium)
                  TextButton.icon(
                    onPressed: _addTime,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.addTime),
                  )
                else if (!isReceivedLocked && !isPremium)
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
                    label: Text(_isLoadingAd ? l10n.loading : l10n.addTimeWithPoring),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.sm),

            // 시간 목록
            ..._buildTimesList(isLocked: isReceivedLocked),
            const SizedBox(height: Spacing.lg),

            // 반복 요일 섹션
            Row(
              children: [
                Text(
                  l10n.repeat,
                  style: theme.textTheme.titleMedium,
                ),
                if (isReceivedLocked) ...[
                  const SizedBox(width: Spacing.xs),
                  Icon(Icons.lock, size: 16, color: colorScheme.outline),
                ],
              ],
            ),
            const SizedBox(height: Spacing.sm),

            // 빠른 선택
            _buildQuickSelect(isLocked: isReceivedLocked),
            const SizedBox(height: Spacing.sm),

            // 개별 요일 선택
            _buildDayChips(isLocked: isReceivedLocked),
            const SizedBox(height: Spacing.lg),

            // 종료일 설정
            _buildEndDateSection(),
            const SizedBox(height: Spacing.lg),

            // 공유 설정 (내가 만든 링크만 수정 가능)
            if (widget.link.sharedBy == null)
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

  List<Widget> _buildTimesList({bool isLocked = false}) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isPremium = ref.watch(userProfileProvider).value?.isPremium ?? false;
    final isSharedLink = widget.link.sharedBy != null;

    return List.generate(_selectedTimes.length, (index) {
      final time = _selectedTimes[index];
      final isFirst = index == 0;

      // 공유받은 링크 + 무료 사용자 + 첫 번째가 아닌 시간 = 잠금 가능
      final isTimeLocked = isSharedLink && !isPremium && !_unlockedTimeIndices.contains(index);

      // 전체 isLocked(시간 고정) 또는 개별 시간 잠금
      final showLocked = isLocked || isTimeLocked;

      return Padding(
        padding: const EdgeInsets.only(bottom: Spacing.xs),
        child: ListTile(
          leading: Icon(
            isTimeLocked ? Icons.lock_clock : Icons.access_time,
            color: showLocked ? colorScheme.outline : null,
          ),
          title: Row(
            children: [
              Text(
                time.format(context),
                style: TextStyle(
                  color: showLocked ? colorScheme.outline : null,
                ),
              ),
              // 잠긴 시간 뱃지
              if (isTimeLocked) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 12,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        l10n.locked,
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          trailing: isTimeLocked
              ? _isLoadingAd
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.play_circle_outline,
                        color: colorScheme.primary,
                      ),
                      tooltip: l10n.poringUnlock,
                      onPressed: () => _unlockTimeWithPoring(index),
                    )
              : isLocked
                  ? Icon(Icons.lock, size: 18, color: colorScheme.outline)
                  : (isFirst
                      ? const Icon(Icons.chevron_right)
                      : IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _removeTime(index),
                        )),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isTimeLocked
                  ? colorScheme.error.withValues(alpha: 0.5)
                  : (showLocked
                      ? colorScheme.outline.withValues(alpha: 0.5)
                      : colorScheme.outline),
            ),
          ),
          onTap: showLocked ? null : () => _selectTime(index),
        ),
      );
    });
  }

  Widget _buildQuickSelect({bool isLocked = false}) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDaily = _selectedDays.length == 7;
    final isWeekdays = _selectedDays.length == 5 &&
        _selectedDays.containsAll([1, 2, 3, 4, 5]);
    final isWeekends =
        _selectedDays.length == 2 && _selectedDays.containsAll([0, 6]);

    Widget buildChip({
      required String label,
      required bool isSelected,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: isLocked ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isLocked ? colorScheme.outline : colorScheme.primary)
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? (isLocked ? colorScheme.outline : colorScheme.primary)
                  : colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isLocked ? colorScheme.outline : colorScheme.onSurface),
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

  Widget _buildDayChips({bool isLocked = false}) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    // 월화수목금토일 순서 (내부 인덱스: 1,2,3,4,5,6,0)
    final dayOrder = [1, 2, 3, 4, 5, 6, 0];
    final dayLabels = [l10n.mon, l10n.tue, l10n.wed, l10n.thu, l10n.fri, l10n.sat, l10n.sun];

    Widget buildDayChip(int dayIndex, String label) {
      final isSelected = _selectedDays.contains(dayIndex);
      return GestureDetector(
        onTap: isLocked
            ? null
            : () {
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
                ? (isLocked ? colorScheme.outline : colorScheme.primary)
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? (isLocked ? colorScheme.outline : colorScheme.primary)
                  : colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isLocked ? colorScheme.outline : colorScheme.onSurface),
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
          children: List.generate(5, (i) => buildDayChip(dayOrder[i], dayLabels[i])),
        ),
        const SizedBox(height: Spacing.xs),
        // 하단: 토일 (2개)
        Wrap(
          spacing: Spacing.xs,
          children: List.generate(2, (i) => buildDayChip(dayOrder[5 + i], dayLabels[5 + i])),
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
            title: Text(_endDate != null
                ? '${_endDate!.year}.${_endDate!.month.toString().padLeft(2, '0')}.${_endDate!.day.toString().padLeft(2, '0')}'
                : l10n.selectEndDate),
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
              Icon(
                Icons.share,
                size: 20,
                color: colorScheme.onSurface,
              ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.category,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: Spacing.xs,
          runSpacing: Spacing.xs,
          children: LinkCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = isSelected ? null : category;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  category.displayName(isKorean),
                  style: TextStyle(
                    color: isSelected ? Colors.white : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 24,
            ),
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
    final currentSoundId = _selectedSoundId ?? AlarmSoundService.instance.getSelectedSoundId();
    final currentSound = AlarmSoundService.instance.getSoundById(currentSoundId);
    final soundName = currentSound?.getName(langCode) ?? l10n.alarmSound;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.alarmSound,
          style: theme.textTheme.titleMedium,
        ),
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
