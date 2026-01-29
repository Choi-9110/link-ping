import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/link_reminder.dart';
import '../../../providers/user_provider.dart';
import '../../../services/url_launcher_service.dart';

class AddLinkScreen extends ConsumerStatefulWidget {
  final String? initialUrl;

  const AddLinkScreen({
    super.key,
    this.initialUrl,
  });

  @override
  ConsumerState<AddLinkScreen> createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends ConsumerState<AddLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();

  // 다중 알림 시간 리스트 (프리미엄)
  final List<TimeOfDay> _selectedTimes = [const TimeOfDay(hour: 7, minute: 0)];
  final Set<int> _selectedDays = {0, 1, 2, 3, 4, 5, 6}; // 기본: 매일

  // 종료일 설정
  bool _hasEndDate = false;
  DateTime? _endDate;

  static const int _maxTimesForFree = 1;
  static const int _maxTimesForPremium = 10;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null) {
      _urlController.text = widget.initialUrl!;
    }
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
    final time = await showTimePicker(
      context: context,
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
    final maxTimes = isPremium ? _maxTimesForPremium : _maxTimesForFree;

    if (_selectedTimes.length >= maxTimes) {
      final l10n = AppLocalizations.of(context)!;
      if (!isPremium) {
        // 프리미엄 유도 다이얼로그
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.premiumFeature),
            content: Text(l10n.multiTimesPremiumMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.premiumLater),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: 프리미엄 구매 화면으로
                },
                child: Text(l10n.viewPremium),
              ),
            ],
          ),
        );
      }
      return;
    }

    setState(() {
      // 마지막 시간에서 1시간 후를 기본값으로
      final lastTime = _selectedTimes.last;
      final newHour = (lastTime.hour + 1) % 24;
      _selectedTimes.add(TimeOfDay(hour: newHour, minute: lastTime.minute));
    });
  }

  void _removeTime(int index) {
    if (_selectedTimes.length <= 1) return;
    setState(() {
      _selectedTimes.removeAt(index);
    });
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectRepeatDays)),
      );
      return;
    }

    final url = _urlController.text.trim();
    final title = _titleController.text.trim();

    // 첫 번째 시간은 기본 시간, 나머지는 추가 시간
    final primaryTime = _selectedTimes.first;
    final additionalTimes = _selectedTimes.length > 1
        ? _selectedTimes.skip(1).map((t) => ReminderTime(hour: t.hour, minute: t.minute)).toList()
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
    final maxTimes = isPremium ? _maxTimesForPremium : _maxTimesForFree;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addLink),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            // URL 입력
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: l10n.linkUrl,
                hintText: 'google.com',
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

            // 알림 시간 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.reminderTime,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_selectedTimes.length < maxTimes || !isPremium)
                  TextButton.icon(
                    onPressed: _addTime,
                    icon: Icon(
                      Icons.add,
                      size: 18,
                      color: isPremium ? null : Theme.of(context).colorScheme.outline,
                    ),
                    label: Text(
                      isPremium ? l10n.addTime : l10n.addTimePremium,
                      style: TextStyle(
                        color: isPremium ? null : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.sm),

            // 시간 목록
            ..._buildTimesList(),
            const SizedBox(height: Spacing.lg),

            // 반복 요일 섹션
            Text(
              l10n.repeat,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Spacing.sm),

            // 빠른 선택 (매일, 평일, 주말)
            _buildQuickSelect(),
            const SizedBox(height: Spacing.sm),

            // 개별 요일 선택
            _buildDayChips(),
            const SizedBox(height: Spacing.lg),

            // 종료일 설정
            _buildEndDateSection(),
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
    final isDaily = _selectedDays.length == 7;
    final isWeekdays = _selectedDays.length == 5 &&
        _selectedDays.containsAll([1, 2, 3, 4, 5]);
    final isWeekends =
        _selectedDays.length == 2 && _selectedDays.containsAll([0, 6]);

    return Wrap(
      spacing: Spacing.sm,
      children: [
        ChoiceChip(
          label: Text(l10n.everyday),
          selected: isDaily,
          onSelected: (selected) {
            if (selected) _setQuickDays([0, 1, 2, 3, 4, 5, 6]);
          },
        ),
        ChoiceChip(
          label: Text(l10n.weekdays),
          selected: isWeekdays,
          onSelected: (selected) {
            if (selected) _setQuickDays([1, 2, 3, 4, 5]);
          },
        ),
        ChoiceChip(
          label: Text(l10n.weekends),
          selected: isWeekends,
          onSelected: (selected) {
            if (selected) _setQuickDays([0, 6]);
          },
        ),
      ],
    );
  }

  Widget _buildDayChips() {
    final l10n = AppLocalizations.of(context)!;
    final days = [l10n.sun, l10n.mon, l10n.tue, l10n.wed, l10n.thu, l10n.fri, l10n.sat];

    return Wrap(
      spacing: Spacing.xs,
      children: List.generate(7, (index) {
        return FilterChip(
          label: Text(days[index]),
          selected: _selectedDays.contains(index),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedDays.add(index);
              } else {
                _selectedDays.remove(index);
              }
            });
          },
        );
      }),
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
}
