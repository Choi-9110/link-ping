import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';
import '../services/poring_service.dart';

/// 포링 상태
class PoringState {
  final int balance;
  final int dailyCount;
  final int cooldownSeconds;
  final bool isPremium;

  const PoringState({
    this.balance = 0,
    this.dailyCount = 0,
    this.cooldownSeconds = 0,
    this.isPremium = false,
  });

  bool get canWatchAd =>
      !isPremium &&
      dailyCount < PoringService.maxDailyAds &&
      cooldownSeconds <= 0;

  bool get dailyLimitReached => dailyCount >= PoringService.maxDailyAds;

  PoringState copyWith({
    int? balance,
    int? dailyCount,
    int? cooldownSeconds,
    bool? isPremium,
  }) {
    return PoringState(
      balance: balance ?? this.balance,
      dailyCount: dailyCount ?? this.dailyCount,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

/// 포링 상태 관리 Notifier
class PoringNotifier extends StateNotifier<PoringState> {
  final Ref _ref;
  Timer? _cooldownTimer;

  PoringNotifier(this._ref) : super(const PoringState()) {
    _init();
  }

  void _init() {
    // 프리미엄 상태 구독
    _ref.listen(userProfileProvider, (prev, next) {
      final isPremium = next.value?.isPremium ?? false;
      state = state.copyWith(isPremium: isPremium);
    });

    // 초기 상태 로드
    _refresh();
    _startCooldownTimer();
  }

  void _refresh() {
    final service = PoringService.instance;
    final isPremium = _ref.read(userProfileProvider).value?.isPremium ?? false;
    state = PoringState(
      balance: service.getBalance(),
      dailyCount: service.getDailyCount(),
      cooldownSeconds: service.getCooldownRemainingSeconds(),
      isPremium: isPremium,
    );
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = PoringService.instance.getCooldownRemainingSeconds();
      if (remaining != state.cooldownSeconds) {
        state = state.copyWith(cooldownSeconds: remaining);
      }
    });
  }

  /// 외부에서 상태 갱신 (추천 보상 클레임 후 등)
  void refresh() => _refresh();

  /// 포링 적립 (광고 시청 후 호출)
  Future<bool> earnPoring() async {
    final success = await PoringService.instance.earnPoring();
    if (success) {
      _refresh();
    }
    return success;
  }

  /// 포링 차감 (기능 사용 시 호출)
  Future<bool> spendPoring() async {
    final success = await PoringService.instance.spendPoring();
    if (success) {
      _refresh();
    }
    return success;
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }
}

/// 포링 Provider
final poringProvider = StateNotifierProvider<PoringNotifier, PoringState>((ref) {
  return PoringNotifier(ref);
});

/// 편의 Provider: 포링 잔액만
final poringBalanceProvider = Provider<int>((ref) {
  return ref.watch(poringProvider).balance;
});
