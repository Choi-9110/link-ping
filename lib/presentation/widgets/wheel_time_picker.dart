import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// iOS 스타일 휠 타임 피커
class WheelTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final bool use24HourFormat;

  const WheelTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
    this.use24HourFormat = false,
  });

  /// 바텀시트로 타임피커 표시
  static Future<TimeOfDay?> show(
    BuildContext context, {
    required TimeOfDay initialTime,
    bool use24HourFormat = false,
  }) async {
    TimeOfDay selectedTime = initialTime;

    final result = await showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 헤더
            Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.cancel),
                      ),
                      Text(
                        l10n.reminderTime,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, selectedTime),
                        child: Text(l10n.ok),
                      ),
                    ],
                  ),
                );
              },
            ),
            // 타임피커
            SizedBox(
              height: 200,
              child: WheelTimePicker(
                initialTime: initialTime,
                use24HourFormat: use24HourFormat,
                onTimeChanged: (time) {
                  selectedTime = time;
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );

    return result;
  }

  @override
  State<WheelTimePicker> createState() => _WheelTimePickerState();
}

class _WheelTimePickerState extends State<WheelTimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  late int _selectedHour;
  late int _selectedMinute;
  late bool _isPM;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    if (widget.use24HourFormat) {
      _selectedHour = widget.initialTime.hour;
      _isPM = false;
    } else {
      _isPM = widget.initialTime.hour >= 12;
      _selectedHour = widget.initialTime.hour % 12;
      if (_selectedHour == 0) _selectedHour = 12;
    }
    _selectedMinute = widget.initialTime.minute;

    _hourController = FixedExtentScrollController(
      initialItem: widget.use24HourFormat ? _selectedHour : _selectedHour - 1,
    );
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
    _periodController = FixedExtentScrollController(initialItem: _isPM ? 1 : 0);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  void _notifyTimeChanged() {
    int hour;
    if (widget.use24HourFormat) {
      hour = _selectedHour;
    } else {
      hour = _selectedHour % 12;
      if (_isPM && hour != 12) hour += 12;
      if (!_isPM && hour == 12) hour = 0;
    }
    widget.onTimeChanged(TimeOfDay(hour: hour, minute: _selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 선택 영역 하이라이트
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // 피커들
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AM/PM (12시간 형식일 때)
            if (!widget.use24HourFormat) ...[
              _buildPeriodPicker(colorScheme),
              const SizedBox(width: 8),
            ],
            // 시간
            _buildHourPicker(colorScheme),
            // 구분자
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            // 분
            _buildMinutePicker(colorScheme),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodPicker(ColorScheme colorScheme) {
    return SizedBox(
      width: 50,
      child: CupertinoPicker(
        scrollController: _periodController,
        itemExtent: 40,
        selectionOverlay: const SizedBox.shrink(),
        onSelectedItemChanged: (index) {
          setState(() {
            _isPM = index == 1;
          });
          _notifyTimeChanged();
        },
        children: ['AM', 'PM']
            .map((period) => Center(
                  child: Text(
                    period,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildHourPicker(ColorScheme colorScheme) {
    final hours = widget.use24HourFormat
        ? List.generate(24, (i) => i)
        : List.generate(12, (i) => i + 1);

    return SizedBox(
      width: 60,
      child: CupertinoPicker(
        scrollController: _hourController,
        itemExtent: 40,
        selectionOverlay: const SizedBox.shrink(),
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedHour = widget.use24HourFormat ? index : index + 1;
          });
          _notifyTimeChanged();
        },
        children: hours
            .map((hour) => Center(
                  child: Text(
                    hour.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildMinutePicker(ColorScheme colorScheme) {
    return SizedBox(
      width: 60,
      child: CupertinoPicker(
        scrollController: _minuteController,
        itemExtent: 40,
        selectionOverlay: const SizedBox.shrink(),
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedMinute = index;
          });
          _notifyTimeChanged();
        },
        children: List.generate(60, (i) => i)
            .map((minute) => Center(
                  child: Text(
                    minute.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
