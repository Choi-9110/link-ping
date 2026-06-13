import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'brand_tokens.dart';
import 'color_themes.dart';

class AppTheme {
  AppTheme._();

  // =========================================================================
  // 기본 컬러 상수 (하위 호환성 유지)
  // 새 코드에서는 colorTheme.primary 등을 사용하세요
  // =========================================================================
  static const Color primaryColor = Color(0xFFFF5A5F);
  static const Color backgroundColor = Color(0xFF000000);
  static const Color surfaceColor = Color(0xFF1C1C1E);
  static const Color surfaceVariant = Color(0xFF2C2C2E);
  static const Color toggleOnColor = Color(0xFF00D4AA);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);

  // =========================================================================
  // 현재 활성 컬러 테마
  // 추후 사용자 선택에 따라 변경 가능
  // =========================================================================
  static AppColorTheme _currentTheme = ColorThemes.defaultTheme;

  /// 현재 컬러 테마 가져오기
  static AppColorTheme get colorTheme => _currentTheme;

  /// 컬러 테마 변경 (Provider에서 호출)
  static void setColorTheme(AppColorTheme theme) {
    _currentTheme = theme;
  }

  // 라이트 테마도 다크로 통일
  static ThemeData get lightTheme => darkTheme;

  /// 현재 컬러 테마 기반으로 ThemeData 생성
  static ThemeData get darkTheme => createTheme(_currentTheme);

  /// 특정 컬러 테마로 ThemeData 생성
  static ThemeData createTheme(AppColorTheme colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // 본문/제목 기본 폰트 — Pretendard (브랜드킷)
      // 픽셀 악센트(Galmuri11)는 BrandTokens.fontPixel로 개별 위젯에서만 사용
      fontFamily: BrandTokens.fontSans,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        secondary: colors.secondary,
        tertiary: colors.tertiary,
        surface: colors.surface,
        surfaceContainerHighest: colors.surfaceVariant,
        onPrimary: colors.onPrimary,        // ★ 테마별 다름
        onSecondary: colors.onSecondary,    // ★ 테마별 다름
        onSurface: colors.textPrimary,
        onSurfaceVariant: colors.textSecondary,
        outline: colors.outline,
        error: colors.error,
      ),
      // AppBar 스타일
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      // 카드 스타일 (브랜드킷: 라운드 14 + 1px 라인)
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: colors.outline, width: 1),
        ),
      ),
      // FAB 스타일
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,  // ★ Minimal에서 검정색
      ),
      // 버튼 스타일
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,  // ★ Minimal에서 검정색
          minimumSize: const Size(double.infinity, 56),
          textStyle: const TextStyle(
            fontFamily: BrandTokens.fontSans,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),  // 브랜드킷 라운드 14
          ),
        ),
      ),
      // 텍스트 버튼 스타일
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.textSecondary,
        ),
      ),
      // 스위치 스타일
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.onSecondary;  // ★ secondary 트랙 위의 thumb
          }
          return colors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.secondary;
          }
          return colors.outline;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      // 입력 필드 스타일
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colors.textSecondary),
        hintStyle: TextStyle(color: colors.textSecondary),
      ),
      // 스낵바 스타일 — 다크 배경 위 흰 글자로 가독성 보장(기존엔 글자가 어두웠음)
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceVariant,
        contentTextStyle: TextStyle(
          color: colors.textPrimary,
          fontFamily: BrandTokens.fontSans,
          fontSize: 14,
        ),
        actionTextColor: colors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // 바텀시트 스타일
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      // 다이얼로그 스타일
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      // 리스트 타일 스타일
      listTileTheme: ListTileThemeData(
        iconColor: colors.textSecondary,
        textColor: colors.textPrimary,
      ),
      // 디바이더 스타일
      dividerTheme: DividerThemeData(
        color: colors.outline,
        thickness: 0.5,
      ),
      // 타이포 — 제목은 Pretendard Bold, 본문은 행간 1.5 (브랜드킷)
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.2),
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(height: 1.5),
        bodySmall: TextStyle(height: 1.45),
      ).apply(
        fontFamily: BrandTokens.fontSans,
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),
    );
  }
}
