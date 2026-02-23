import 'package:flutter/material.dart';

/// 앱 컬러 테마 정의
/// 사용자가 선택할 수 있는 컬러 테마의 기본 구조
class AppColorTheme {
  final String id;
  final String name;
  final String nameKo;

  // 주요 컬러
  final Color primary;        // 메인 액션 컬러 (버튼, FAB 등)
  final Color onPrimary;      // primary 위에 올라가는 텍스트/아이콘 색상
  final Color secondary;      // 보조 액션 컬러 (토글, 성공 상태)
  final Color onSecondary;    // secondary 위에 올라가는 텍스트/아이콘 색상
  final Color tertiary;       // 3차 컬러 (배지, 카테고리 등)

  // 배경 컬러
  final Color background;     // 앱 전체 배경
  final Color surface;        // 카드, 바텀시트 배경
  final Color surfaceVariant; // 더 밝은 표면 (입력필드 등)

  // 텍스트 컬러
  final Color textPrimary;    // 주요 텍스트
  final Color textSecondary;  // 보조 텍스트

  // 시스템 컬러
  final Color outline;        // 테두리, 구분선
  final Color error;          // 에러 상태

  // 그라데이션 (공유 페이지, 랜딩 페이지용)
  final List<Color> gradientColors;

  // 브랜드 액센트 (특별한 강조용)
  final Color brandAccent;

  const AppColorTheme({
    required this.id,
    required this.name,
    required this.nameKo,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.outline,
    required this.error,
    required this.gradientColors,
    required this.brandAccent,
  });

  /// primary 컬러의 다양한 투명도 버전
  Color get primaryLight => primary.withValues(alpha: 0.1);
  Color get primaryMedium => primary.withValues(alpha: 0.3);
  Color get primaryDark => primary.withValues(alpha: 0.7);

  /// secondary 컬러의 다양한 투명도 버전
  Color get secondaryLight => secondary.withValues(alpha: 0.1);
  Color get secondaryMedium => secondary.withValues(alpha: 0.3);

  /// surface 컬러의 다양한 투명도 버전
  Color get surfaceLight => surface.withValues(alpha: 0.5);

  /// 그라데이션 생성 헬퍼
  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: gradientColors,
  );

  /// 카드 그라데이션 (primary 기반)
  LinearGradient get cardGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      primary.withValues(alpha: 0.8),
    ],
  );
}
