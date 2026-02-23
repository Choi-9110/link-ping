import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService instance = AdService._();
  AdService._();

  bool _isInitialized = false;
  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoading = false;

  /// 배너 광고 단위 ID
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1117215826626141/2979940293';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1117215826626141/9604284316';
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// 테스트용 배너 광고 단위 ID
  String get testBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// 네이티브 광고 단위 ID (TODO: AdMob에서 생성 후 교체)
  String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1117215826626141/XXXXXXXXXX'; // TODO: 실제 ID로 교체
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1117215826626141/XXXXXXXXXX'; // TODO: 실제 ID로 교체
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// 테스트용 네이티브 광고 단위 ID
  String get testNativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511';
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// 보상형 광고 단위 ID
  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1117215826626141/8079722729';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1117215826626141/280291054';
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// 테스트용 보상형 광고 단위 ID
  String get testRewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// AdMob 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  /// 배너 광고 생성
  BannerAd createBannerAd({
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
    bool useTestAd = false,
    AdSize adSize = AdSize.banner,
  }) {
    return BannerAd(
      adUnitId: useTestAd ? testBannerAdUnitId : bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  /// 앵커드 적응형 배너 사이즈 (화면 너비에 맞춤)
  Future<AnchoredAdaptiveBannerAdSize?> getAdaptiveBannerSize(double width) async {
    return await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width.truncate(),
    );
  }

  /// 보상형 광고 로드
  Future<void> loadRewardedAd({bool useTestAd = false}) async {
    if (_isRewardedAdLoading || _rewardedAd != null) return;
    _isRewardedAdLoading = true;

    await RewardedAd.load(
      adUnitId: useTestAd ? testRewardedAdUnitId : rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isRewardedAdLoading = false;
        },
      ),
    );
  }

  /// 보상형 광고 준비 여부
  bool get isRewardedAdReady => _rewardedAd != null;

  /// 보상형 광고 표시
  /// [onRewarded] 광고 시청 완료 시 호출되는 콜백
  /// [onAdDismissed] 광고 닫힘 시 호출되는 콜백 (보상 여부 관계없이)
  /// [onAdFailed] 광고 표시 실패 시 호출되는 콜백
  Future<void> showRewardedAd({
    required void Function() onRewarded,
    void Function()? onAdDismissed,
    void Function(String error)? onAdFailed,
    bool useTestAd = false,
  }) async {
    if (_rewardedAd == null) {
      onAdFailed?.call('Ad not loaded');
      // 광고가 없으면 다시 로드 시도
      loadRewardedAd(useTestAd: useTestAd);
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        onAdDismissed?.call();
        // 다음 광고 미리 로드
        loadRewardedAd(useTestAd: useTestAd);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        onAdFailed?.call(error.message);
        // 실패 시 다시 로드
        loadRewardedAd(useTestAd: useTestAd);
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onRewarded();
      },
    );
  }

  /// 보상형 광고 해제
  void disposeRewardedAd() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
