import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 앱에서 사용 가능한 컬러 테마 프리셋
///
/// 사용법:
/// - ColorThemes.vibrant (기본값)
/// - ColorThemes.soft
/// - ColorThemes.minimal
/// - ColorThemes.getById('vibrant')
class ColorThemes {
  ColorThemes._();

  /// 🅰️ Vibrant - 현재 스타일 정제 (기본값)
  /// 코랄 레드 + 민트 조합, 에너지 넘치는 느낌
  static const vibrant = AppColorTheme(
    id: 'vibrant',
    name: 'Vibrant',
    nameKo: '비비드',
    // 주요 컬러
    primary: Color(0xFFFF5A5F),      // 코랄 레드 - 메인 액션
    onPrimary: Color(0xFFFFFFFF),    // 화이트 - primary 위 텍스트
    secondary: Color(0xFF00D4AA),    // 민트 - 토글, 성공 상태
    onSecondary: Color(0xFFFFFFFF),  // 화이트 - secondary 위 텍스트
    tertiary: Color(0xFF6C5CE7),     // 퍼플 - 배지, 카테고리
    // 배경
    background: Color(0xFF000000),   // 퓨어 블랙
    surface: Color(0xFF1C1C1E),      // 다크 그레이
    surfaceVariant: Color(0xFF2C2C2E), // 라이트 그레이
    // 텍스트
    textPrimary: Color(0xFFFFFFFF),  // 화이트
    textSecondary: Color(0xFF8E8E93), // 그레이
    // 시스템
    outline: Color(0xFF3A3A3C),      // 테두리
    error: Color(0xFFFF453A),        // 에러 레드
    // 그라데이션 (공유 페이지용)
    gradientColors: [
      Color(0xFF1a1a2e),
      Color(0xFF16213e),
      Color(0xFF0f3460),
    ],
    // 브랜드 액센트
    brandAccent: Color(0xFFFF5A5F),  // primary와 동일하게 통일
  );

  /// 🅱️ Soft - 부드러운 다크 테마
  /// 소프트 코랄 + 소프트 민트, 눈의 피로 감소
  static const soft = AppColorTheme(
    id: 'soft',
    name: 'Soft',
    nameKo: '소프트',
    // 주요 컬러
    primary: Color(0xFFFF6B6B),      // 소프트 코랄
    onPrimary: Color(0xFFFFFFFF),    // 화이트 - primary 위 텍스트
    secondary: Color(0xFF4ECDC4),    // 소프트 민트
    onSecondary: Color(0xFFFFFFFF),  // 화이트 - secondary 위 텍스트
    tertiary: Color(0xFF9B59B6),     // 소프트 퍼플
    // 배경
    background: Color(0xFF1A1A2E),   // 다크 네이비
    surface: Color(0xFF16213E),      // 네이비
    surfaceVariant: Color(0xFF1F2B47), // 라이트 네이비
    // 텍스트
    textPrimary: Color(0xFFFFFFFF),  // 화이트
    textSecondary: Color(0xFFA0A0B0), // 라이트 그레이
    // 시스템
    outline: Color(0xFF2D3A5C),      // 네이비 테두리
    error: Color(0xFFE74C3C),        // 소프트 레드
    // 그라데이션
    gradientColors: [
      Color(0xFF1A1A2E),
      Color(0xFF16213E),
      Color(0xFF0F3460),
    ],
    // 브랜드 액센트
    brandAccent: Color(0xFFFF6B6B),
  );

  /// 🅲 Minimal - 미니멀 모노크롬
  /// 라이트 그레이 + 차분한 톤, Apple 스타일 고급스러움
  static const minimal = AppColorTheme(
    id: 'minimal',
    name: 'Minimal',
    nameKo: '미니멀',
    // 주요 컬러
    primary: Color(0xFFE5E5EA),      // 라이트 그레이 - 버튼, 강조
    onPrimary: Color(0xFF1C1C1E),    // 다크 - 라이트 그레이 버튼 위 텍스트
    secondary: Color(0xFF8E8E93),    // 미디엄 그레이 - 토글
    onSecondary: Color(0xFFFFFFFF),  // 화이트
    tertiary: Color(0xFF636366),     // 다크 그레이 - 보조
    // 배경
    background: Color(0xFF000000),   // 퓨어 블랙
    surface: Color(0xFF1C1C1E),      // iOS 다크 서피스
    surfaceVariant: Color(0xFF2C2C2E), // 다크 그레이
    // 텍스트
    textPrimary: Color(0xFFFFFFFF),  // 화이트
    textSecondary: Color(0xFF8E8E93), // 미디엄 그레이
    // 시스템
    outline: Color(0xFF38383A),      // 테두리
    error: Color(0xFFFF453A),        // 에러 레드
    // 그라데이션
    gradientColors: [
      Color(0xFF000000),
      Color(0xFF1C1C1E),
      Color(0xFF2C2C2E),
    ],
    // 브랜드 액센트
    brandAccent: Color(0xFFE5E5EA),  // 라이트 그레이
  );

  /// 모든 테마 목록
  static const List<AppColorTheme> all = [
    vibrant,
    soft,
    minimal,
  ];

  /// ID로 테마 가져오기
  static AppColorTheme getById(String id) {
    return all.firstWhere(
      (theme) => theme.id == id,
      orElse: () => vibrant,
    );
  }

  /// 기본 테마
  static const AppColorTheme defaultTheme = vibrant;
}
