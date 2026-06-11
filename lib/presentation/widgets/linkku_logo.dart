import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Linkku 브랜드킷 SVG 에셋 렌더링 위젯 모음.
///
/// 모든 로고는 `assets/linkku-logo-assets/`의 픽셀 좌표 기반 SVG로,
/// 어떤 크기로도 손실 없이 확대됩니다. (flutter_svg 사용)
const String _kBasePath = 'assets/linkku-logo-assets';

/// 심볼(마스코트) 변형.
enum LinkkuSymbolVariant {
  /// 기본형 — 다크 배경 위 표준.
  color,

  /// 핑 스파크 변형 — 알림·획득·축하 순간.
  spark,

  /// 단색 화이트 — 코랄/브랜드 단색 지면.
  white,

  /// 단색 블랙 — 밝은 지면·인쇄·각인.
  black,
}

/// 마스코트 심볼 "링꾸". 정사각 비율.
class LinkkuSymbol extends StatelessWidget {
  const LinkkuSymbol({
    super.key,
    this.variant = LinkkuSymbolVariant.color,
    this.size = 48,
  });

  final LinkkuSymbolVariant variant;
  final double size;

  String get _asset {
    switch (variant) {
      case LinkkuSymbolVariant.color:
        return '$_kBasePath/linkku-symbol-color.svg';
      case LinkkuSymbolVariant.spark:
        return '$_kBasePath/linkku-symbol-spark.svg';
      case LinkkuSymbolVariant.white:
        return '$_kBasePath/linkku-symbol-white.svg';
      case LinkkuSymbolVariant.black:
        return '$_kBasePath/linkku-symbol-black.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_asset, width: size, height: size);
  }
}

/// 락업(심볼 + 워드마크 가로 조합) 변형.
enum LinkkuLockupVariant { color, white, black }

/// 가로형 락업 — 스플래시·랜딩 헤더·문서 머리.
class LinkkuLockup extends StatelessWidget {
  const LinkkuLockup({
    super.key,
    this.variant = LinkkuLockupVariant.color,
    this.height = 40,
  });

  final LinkkuLockupVariant variant;
  final double height;

  String get _asset {
    switch (variant) {
      case LinkkuLockupVariant.color:
        return '$_kBasePath/linkku-lockup-color.svg';
      case LinkkuLockupVariant.white:
        return '$_kBasePath/linkku-lockup-white.svg';
      case LinkkuLockupVariant.black:
        return '$_kBasePath/linkku-lockup-black.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_asset, height: height);
  }
}

/// 인앱 재화 "핑"(퍼플 오브). 정사각 비율.
class LinkkuCurrency extends StatelessWidget {
  const LinkkuCurrency({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      '$_kBasePath/linkku-currency.svg',
      width: size,
      height: size,
    );
  }
}
