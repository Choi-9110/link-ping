import 'package:flutter/material.dart';

class AppTheme {
  // 알라미 스타일 컬러 팔레트
  static const Color primaryColor = Color(0xFFFF5A5F); // 코랄 레드
  static const Color backgroundColor = Color(0xFF000000); // 퓨어 블랙
  static const Color surfaceColor = Color(0xFF1C1C1E); // 다크 그레이 (카드)
  static const Color surfaceVariant = Color(0xFF2C2C2E); // 더 밝은 그레이
  static const Color toggleOnColor = Color(0xFF00D4AA); // 틸/시안 (토글 ON)
  static const Color textPrimary = Color(0xFFFFFFFF); // 흰색
  static const Color textSecondary = Color(0xFF8E8E93); // 회색

  // 라이트 테마도 다크로 통일 (알라미 스타일)
  static ThemeData get lightTheme => darkTheme;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: toggleOnColor,
        surface: surfaceColor,
        surfaceContainerHighest: surfaceVariant,
        onPrimary: textPrimary,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,
        outline: Color(0xFF3A3A3C),
        error: Color(0xFFFF453A),
      ),
      // AppBar 스타일
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      // 카드 스타일
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      // FAB 스타일
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: textPrimary,
      ),
      // 버튼 스타일
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      // 텍스트 버튼 스타일
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textSecondary,
        ),
      ),
      // 스위치 스타일
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textPrimary;
          }
          return textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return toggleOnColor;
          }
          return const Color(0xFF3A3A3C);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      // 입력 필드 스타일
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
      ),
      // 바텀시트 스타일
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      // 다이얼로그 스타일
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      // 리스트 타일 스타일
      listTileTheme: const ListTileThemeData(
        iconColor: textSecondary,
        textColor: textPrimary,
      ),
      // 디바이더 스타일
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A3A3C),
        thickness: 0.5,
      ),
    );
  }
}
