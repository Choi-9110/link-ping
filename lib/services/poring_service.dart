import 'package:hive_flutter/hive_flutter.dart';

/// 포링(Poring) 재화 관리 서비스
/// 광고 시청 → 포링 적립, 기능 사용 시 포링 차감
class PoringService {
  static final PoringService instance = PoringService._();
  PoringService._();

  static const _boxName = 'settings';

  // Hive 키
  static const _keyBalance = 'poring_balance';
  static const _keyDailyCount = 'poring_daily_count';
  static const _keyDailyDate = 'poring_daily_date';
  static const _keyLastAdTime = 'poring_last_ad_time';

  // 상수
  static const int maxDailyAds = 15;
  static const int adCooldownSeconds = 45;

  Box get _box => Hive.box(_boxName);

  /// 현재 포링 잔액
  int getBalance() {
    return _box.get(_keyBalance, defaultValue: 0) as int;
  }

  /// 포링 1개 차감 (성공 시 true)
  Future<bool> spendPoring() async {
    final balance = getBalance();
    if (balance <= 0) return false;
    await _box.put(_keyBalance, balance - 1);
    return true;
  }

  /// 포링 N개 추가 (추천 보상 등 외부 보상용)
  Future<void> addPoring(int amount) async {
    if (amount <= 0) return;
    final balance = getBalance();
    await _box.put(_keyBalance, balance + amount);
  }

  /// 포링 1개 적립 (광고 시청 보상)
  Future<bool> earnPoring() async {
    resetDailyIfNeeded();
    final dailyCount = getDailyCount();
    if (dailyCount >= maxDailyAds) return false;

    final balance = getBalance();
    await _box.put(_keyBalance, balance + 1);
    await _box.put(_keyDailyCount, dailyCount + 1);
    await _box.put(_keyLastAdTime, DateTime.now().millisecondsSinceEpoch);
    return true;
  }

  /// 오늘 광고 시청 횟수
  int getDailyCount() {
    resetDailyIfNeeded();
    return _box.get(_keyDailyCount, defaultValue: 0) as int;
  }

  /// 광고 시청 가능 여부 (쿨다운 + 일일 제한)
  bool canWatchAd() {
    resetDailyIfNeeded();
    if (getDailyCount() >= maxDailyAds) return false;
    if (getCooldownRemainingSeconds() > 0) return false;
    return true;
  }

  /// 쿨다운 남은 시간 (초)
  int getCooldownRemainingSeconds() {
    final lastAdTime = _box.get(_keyLastAdTime) as int?;
    if (lastAdTime == null) return 0;

    final lastAd = DateTime.fromMillisecondsSinceEpoch(lastAdTime);
    final elapsed = DateTime.now().difference(lastAd).inSeconds;
    final remaining = adCooldownSeconds - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  /// 자정이 지났으면 일일 카운트 리셋
  void resetDailyIfNeeded() {
    final savedDate = _box.get(_keyDailyDate) as String?;
    final today = _todayString();

    if (savedDate != today) {
      _box.put(_keyDailyCount, 0);
      _box.put(_keyDailyDate, today);
    }
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
