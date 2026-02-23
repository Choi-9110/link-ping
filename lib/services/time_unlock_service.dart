import 'package:hive_flutter/hive_flutter.dart';

/// 공유받은 링크의 추가 알림 시간 잠금해제 상태 관리
class TimeUnlockService {
  static const _boxName = 'settings';
  static const _keyPrefix = 'unlocked_times_';

  /// 특정 링크의 잠금해제된 시간 인덱스 목록 조회
  /// 첫 번째 시간(인덱스 0)은 항상 잠금해제됨
  static Set<int> getUnlockedTimeIndices(String linkId) {
    final box = Hive.box(_boxName);
    final List<dynamic>? stored = box.get('$_keyPrefix$linkId');

    // 기본적으로 첫 번째 시간은 항상 해제
    final result = <int>{0};
    if (stored != null) {
      result.addAll(stored.cast<int>());
    }
    return result;
  }

  /// 특정 시간 인덱스 잠금해제
  static Future<void> unlockTimeIndex(String linkId, int timeIndex) async {
    final box = Hive.box(_boxName);
    final currentSet = getUnlockedTimeIndices(linkId);
    currentSet.add(timeIndex);
    await box.put('$_keyPrefix$linkId', currentSet.toList());
  }

  /// 특정 시간이 잠금해제되었는지 확인
  static bool isTimeUnlocked(String linkId, int timeIndex) {
    // 첫 번째 시간은 항상 해제
    if (timeIndex == 0) return true;

    final unlockedIndices = getUnlockedTimeIndices(linkId);
    return unlockedIndices.contains(timeIndex);
  }

  /// 링크 삭제 시 저장된 잠금해제 정보도 삭제
  static Future<void> clearUnlockData(String linkId) async {
    final box = Hive.box(_boxName);
    await box.delete('$_keyPrefix$linkId');
  }
}
