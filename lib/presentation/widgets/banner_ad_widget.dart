import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    // 위젯 빌드 후 광고 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAd();
    });
  }

  void _loadAd() async {
    if (!mounted) return;

    // 화면 너비에 맞는 적응형 배너 사이즈
    final width = MediaQuery.of(context).size.width;
    final adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          width.truncate(),
        );

    if (adSize == null || !mounted) {
      debugPrint('적응형 배너 사이즈를 가져올 수 없음');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: AdService.instance.useTestAds
          ? AdService.instance.testBannerAdUnitId
          : AdService.instance.bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('배너 광고 로드 실패: $error');
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox(height: 60);
    }

    return Container(
      width: double.infinity,
      height: _bannerAd!.size.height.toDouble(),
      color: Theme.of(context).colorScheme.surface,
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
