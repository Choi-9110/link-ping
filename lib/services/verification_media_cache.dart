import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 인증 영상·썸네일 로컬 캐시.
///
/// 한 번 네트워크에서 받은 미디어를 기기 로컬에 저장해 두고,
/// 다음에 같은 영상을 열 때는 네트워크 없이 로컬 파일에서 바로 재생한다.
/// (영상 보존 기간 7일과 맞춰 캐시도 7일이면 자동 정리)
class VerificationMediaCache {
  VerificationMediaCache._();

  static const _key = 'verificationMediaCache';

  static final CacheManager instance = CacheManager(
    Config(
      _key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 300,
    ),
  );

  /// 영상 URL을 로컬 캐시 파일로 변환.
  /// 캐시에 있으면 즉시 반환, 없으면 받아서 저장한 뒤 반환.
  static Future<String> videoFilePath(String url) async {
    final file = await instance.getSingleFile(url);
    return file.path;
  }
}
