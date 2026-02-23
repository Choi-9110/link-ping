import 'package:hive_flutter/hive_flutter.dart';

/// 응원/약올리기 전송 가능 시간 윈도우 관리
/// - 내 알람이 울린 후 5분 내에만 전송 가능
/// - 무료 유저: 1명 (추가는 광고 시청)
/// - 프리미엄: 무제한
class PingWindowService {
  static final PingWindowService instance = PingWindowService._();
  PingWindowService._();

  static const _boxName = 'settings';
  static const _lastAlarmKey = 'lastAlarmFiredAt';
  static const _pingSentCountKey = 'pingSentCountInWindow';
  static const _lastWindowDateKey = 'lastPingWindowDate';
  static const _windowDuration = Duration(minutes: 5);

  Box get _box => Hive.box(_boxName);

  /// 알람이 울렸을 때 호출 - 윈도우 시작
  /// 같은 날 시간 변경으로 무한 윈도우 악용 방지:
  /// - 같은 날 이미 윈도우를 사용했으면 카운트를 리셋하지 않음
  /// - 윈도우 타이머(5분)만 갱신
  Future<void> recordAlarmFired() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = _box.get(_lastWindowDateKey) as String?;

    if (lastDate == today) {
      // 같은 날 → 윈도우 시간만 갱신, 카운트는 유지
      final now = DateTime.now().millisecondsSinceEpoch;
      await _box.put(_lastAlarmKey, now);
      return;
    }

    // 새로운 날 → 완전 리셋
    final now = DateTime.now().millisecondsSinceEpoch;
    await _box.put(_lastAlarmKey, now);
    await _box.put(_pingSentCountKey, 0);
    await _box.put(_lastWindowDateKey, today);
  }

  /// 현재 윈도우 내인지 확인
  bool isWithinWindow() {
    final lastAlarmAt = _box.get(_lastAlarmKey) as int?;
    if (lastAlarmAt == null) return false;

    final lastAlarmTime = DateTime.fromMillisecondsSinceEpoch(lastAlarmAt);
    final now = DateTime.now();
    final diff = now.difference(lastAlarmTime);

    return diff <= _windowDuration;
  }

  /// 남은 윈도우 시간 (초)
  int getRemainingSeconds() {
    final lastAlarmAt = _box.get(_lastAlarmKey) as int?;
    if (lastAlarmAt == null) return 0;

    final lastAlarmTime = DateTime.fromMillisecondsSinceEpoch(lastAlarmAt);
    final windowEndTime = lastAlarmTime.add(_windowDuration);
    final now = DateTime.now();

    if (now.isAfter(windowEndTime)) return 0;
    return windowEndTime.difference(now).inSeconds;
  }

  /// 이번 윈도우에서 몇 명에게 보냈는지
  int getPingSentCount() {
    if (!isWithinWindow()) return 0;
    return _box.get(_pingSentCountKey, defaultValue: 0) as int;
  }

  /// 무료 유저가 전송 가능한지 (1명까지 무료)
  bool canSendFree() {
    if (!isWithinWindow()) return false;
    return getPingSentCount() < 1;
  }

  /// Ping 전송 기록
  Future<void> recordPingSent() async {
    final currentCount = getPingSentCount();
    await _box.put(_pingSentCountKey, currentCount + 1);
  }

  /// 마지막 알람 시간 (디버그용)
  DateTime? getLastAlarmTime() {
    final lastAlarmAt = _box.get(_lastAlarmKey) as int?;
    if (lastAlarmAt == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(lastAlarmAt);
  }

  /// 윈도우 정보 텍스트 (UI 표시용)
  String getWindowStatusText({required bool isKorean}) {
    if (!isWithinWindow()) {
      return isKorean
          ? '알람이 울린 후 5분 내에만 전송할 수 있어요'
          : 'You can only send within 5 minutes after your alarm';
    }

    final remaining = getRemainingSeconds();
    final minutes = remaining ~/ 60;
    final seconds = remaining % 60;

    if (isKorean) {
      return '남은 시간: $minutes분 $seconds초';
    } else {
      return 'Time left: ${minutes}m ${seconds}s';
    }
  }
}
