import 'package:hive/hive.dart';

/// 북마크 폴더 튜토리얼 진행 단계.
enum BookmarkTutorialStep {
  notStarted,
  createFolder, // 1단계: 폴더 만들기
  enterFolder, // 2단계: 폴더 진입 안내
  addLink, // 3단계: 링크 추가 안내
  completed,
}

/// 튜토리얼 완료 여부 + 진행 단계를 settings box에 저장.
class BookmarkTutorialService {
  static const _doneKey = 'bookmark_folder_tutorial_done_v1';
  static const _stepKey = 'bookmark_folder_tutorial_step_v1';

  static Box get _box => Hive.box('settings');

  static bool get isCompleted =>
      _box.get(_doneKey, defaultValue: false) == true;

  static BookmarkTutorialStep get currentStep {
    if (isCompleted) return BookmarkTutorialStep.completed;
    final raw = _box.get(_stepKey, defaultValue: 0) as int;
    if (raw < 0 || raw >= BookmarkTutorialStep.values.length) {
      return BookmarkTutorialStep.notStarted;
    }
    return BookmarkTutorialStep.values[raw];
  }

  static bool isStepActive(BookmarkTutorialStep step) {
    if (isCompleted) return false;
    return currentStep == step;
  }

  static Future<void> setStep(BookmarkTutorialStep step) async {
    await _box.put(_stepKey, step.index);
  }

  static Future<void> markCompleted() async {
    await _box.put(_doneKey, true);
    await _box.put(_stepKey, BookmarkTutorialStep.completed.index);
  }

  static Future<void> skip() async => markCompleted();
}
