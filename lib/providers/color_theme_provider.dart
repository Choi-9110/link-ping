import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/color_themes.dart';

/// 현재 선택된 컬러 테마 Provider
///
/// 사용법:
/// ```dart
/// final colorTheme = ref.watch(colorThemeProvider);
/// Container(color: colorTheme.primary)
/// ```
final colorThemeProvider = StateNotifierProvider<ColorThemeNotifier, AppColorTheme>((ref) {
  return ColorThemeNotifier();
});

/// 컬러 테마 상태 관리
class ColorThemeNotifier extends StateNotifier<AppColorTheme> {
  static const _boxName = 'settings';
  static const _prefKey = 'selected_color_theme';

  ColorThemeNotifier() : super(ColorThemes.defaultTheme) {
    _loadSavedTheme();
  }

  /// 저장된 테마 로드
  Future<void> _loadSavedTheme() async {
    try {
      final box = Hive.box(_boxName);
      final savedThemeId = box.get(_prefKey) as String?;
      if (savedThemeId != null) {
        state = ColorThemes.getById(savedThemeId);
      }
    } catch (e) {
      // Box가 아직 열리지 않은 경우 기본값 유지
    }
  }

  /// 테마 변경
  Future<void> setTheme(AppColorTheme theme) async {
    state = theme;
    try {
      final box = Hive.box(_boxName);
      await box.put(_prefKey, theme.id);
    } catch (e) {
      // 저장 실패 시 무시
    }
  }

  /// ID로 테마 변경
  Future<void> setThemeById(String themeId) async {
    final theme = ColorThemes.getById(themeId);
    await setTheme(theme);
  }

  /// 기본 테마로 리셋
  Future<void> resetToDefault() async {
    await setTheme(ColorThemes.defaultTheme);
  }
}

// ============================================================================
// 🔒 아래 코드는 추후 설정 화면에서 테마 선택 기능 추가 시 사용
// ============================================================================

/*
/// 테마 선택 위젯 예시
/// 설정 화면에 추가할 때 사용
///
/// ```dart
/// // settings_screen.dart에 추가
/// _buildThemeSelector(),
/// ```

Widget _buildThemeSelector() {
  return Consumer(
    builder: (context, ref, _) {
      final currentTheme = ref.watch(colorThemeProvider);
      final l10n = AppLocalizations.of(context)!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.colorTheme, // "컬러 테마" 번역 필요
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...ColorThemes.all.map((theme) => RadioListTile<String>(
            title: Text(
              Localizations.localeOf(context).languageCode == 'ko'
                  ? theme.nameKo
                  : theme.name,
            ),
            subtitle: _buildThemePreview(theme),
            value: theme.id,
            groupValue: currentTheme.id,
            onChanged: (value) {
              if (value != null) {
                ref.read(colorThemeProvider.notifier).setThemeById(value);
              }
            },
          )),
        ],
      );
    },
  );
}

Widget _buildThemePreview(AppColorTheme theme) {
  return Row(
    children: [
      _colorDot(theme.primary),
      _colorDot(theme.secondary),
      _colorDot(theme.tertiary),
      _colorDot(theme.background),
    ],
  );
}

Widget _colorDot(Color color) {
  return Container(
    width: 20,
    height: 20,
    margin: const EdgeInsets.only(right: 4),
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white24),
    ),
  );
}
*/
