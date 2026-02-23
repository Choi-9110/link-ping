import 'package:flutter/material.dart';

/// 픽셀 이모지 서비스
/// 기존 이모지를 픽셀 아트 이미지로 대체
class PixelEmojiService {
  static const String _basePath = 'assets/pixel_emojis/';

  /// 프로필용 픽셀 이모지 목록 (이미지 파일명)
  static const List<String> profilePixelEmojis = [
    // 얼굴
    'face_grinning',
    'face_smiling',
    'face_love',
    'face_cool',
    'face_nerd',
    'face_monocle',
    'face_thinking',
    'face_sleeping',
    'face_party',
    'face_angel',
    'face_hugging',
    'face_giggling',
    'face_smirk',
    'face_upsidedown',
    'face_relieved',
    'face_starstruck',
    // 동물
    'animal_dog',
    'animal_cat',
    'animal_cat_1',
    'animal_rabbit',
    'animal_rabbit_1',
    'animal_fox',
    'animal_fox_1',
    'animal_bear',
    'animal_bear_1',
    'animal_panda',
    'animal_panda_1',
    'animal_koala',
    'animal_lion',
    'animal_tiger',
    'animal_cow',
    'animal_cow_1',
    'animal_pig',
    'animal_pig_1',
    'animal_frog',
    'animal_frog_1',
    'animal_monkey_1',  // animal_monkey 제거됨 (디자인 이슈)
    'animal_chicken',
    'animal_chicken_1',
    'animal_penguin',
    'animal_penguin_1',
    'animal_unicorn',
    'animal_unicorn_1',
    // 음식/식물
    'nature_cherry_blossom',
    'nature_cherry_blossom_1',
    'nature_hibiscus',
    'nature_hibiscus_1',
    'nature_sunflower',
    'nature_sunflower_1',
    'nature_tulip',
    'nature_tulip_1',
    'nature_clover',
    'nature_clover_1',
    'nature_cactus',
    'nature_cactus_1',
    'food_apple',
    'food_apple_1',
    'food_peach',
    'food_peach_1',
    'food_strawberry',
    'food_strawberry_1',
    'food_pizza',
    'food_pizza_1',
    'food_donut',
    'food_donut_1',
    'food_cupcake',
    'food_cupcake_1',
    'food_icecream',
    'food_icecream_1',
    'food_icecream_2',
    'food_icecream_3',
    'food_coffee',
    'food_coffee_1',
    'food_boba',
    'food_popcorn',
    // 활동/물건
    'item_soccer',
    'item_basketball',
    'item_tennis',
    'item_gamepad',
    'item_guitar',
    'item_palette',
    'item_books',
    'item_laptop',
    'item_target',
    'item_trophy',
    'item_muscle',
    'item_fire',
    'item_star',
    'item_diamond',
    'item_gift',
    'item_rocket',
  ];

  /// 기존 이모지 → 픽셀 이모지 파일명 매핑
  static const Map<String, String> emojiToPixel = {
    // 얼굴
    '😀': 'face_grinning',
    '😊': 'face_smiling',
    '🥰': 'face_love',
    '😎': 'face_cool',
    '🤓': 'face_nerd',
    '🧐': 'face_monocle',
    '🤔': 'face_thinking',
    '😴': 'face_sleeping',
    '🥳': 'face_party',
    '😇': 'face_angel',
    '🤗': 'face_hugging',
    '🤭': 'face_giggling',
    '😏': 'face_smirk',
    '🙃': 'face_upsidedown',
    '😌': 'face_relieved',
    '🤩': 'face_starstruck',
    // 동물
    '🐶': 'animal_dog',
    '🐱': 'animal_cat',
    '🐰': 'animal_rabbit',
    '🦊': 'animal_fox',
    '🐻': 'animal_bear',
    '🐼': 'animal_panda',
    '🐨': 'animal_koala',
    '🦁': 'animal_lion',
    '🐯': 'animal_tiger',
    '🐮': 'animal_cow',
    '🐷': 'animal_pig',
    '🐸': 'animal_frog',
    '🐵': 'animal_monkey_1',  // animal_monkey 제거됨
    '🐔': 'animal_chicken',
    '🐧': 'animal_penguin',
    '🦄': 'animal_unicorn',
    // 음식/식물
    '🌸': 'nature_cherry_blossom',
    '🌺': 'nature_hibiscus',
    '🌻': 'nature_sunflower',
    '🌷': 'nature_tulip',
    '🍀': 'nature_clover',
    '🌵': 'nature_cactus',
    '🍎': 'food_apple',
    '🍑': 'food_peach',
    '🍓': 'food_strawberry',
    '🍕': 'food_pizza',
    '🍩': 'food_donut',
    '🧁': 'food_cupcake',
    '🍦': 'food_icecream',
    '☕': 'food_coffee',
    '🧋': 'food_boba',
    '🍿': 'food_popcorn',
    // 활동/물건
    '⚽': 'item_soccer',
    '🏀': 'item_basketball',
    '🎾': 'item_tennis',
    '🎮': 'item_gamepad',
    '🎸': 'item_guitar',
    '🎨': 'item_palette',
    '📚': 'item_books',
    '💻': 'item_laptop',
    '🎯': 'item_target',
    '🏆': 'item_trophy',
    '💪': 'item_muscle',
    '🔥': 'item_fire',
    '⭐': 'item_star',
    '💎': 'item_diamond',
    '🎁': 'item_gift',
    '🚀': 'item_rocket',
    // 뱃지 전용
    '🏃': 'badge_runner',
    '🤠': 'badge_cowboy',
    '⚡': 'badge_lightning',
    '☀️': 'badge_sun',
    '🌅': 'badge_sunrise',
    '🦉': 'badge_owl',
    '🌙': 'badge_moon',
    '💯': 'badge_hundred',
    '👏': 'badge_clap',
    '📣': 'badge_megaphone',
    '👊': 'badge_fist',
    '🃏': 'badge_joker',
    '🦋': 'badge_butterfly',
    '🔗': 'badge_link',
    '📖': 'item_books',  // badge_openbook 없어서 item_books 사용
    '👑': 'badge_crown',
    '🗃️': 'badge_filebox',
    '☁️': 'badge_cloud',
  };

  /// 픽셀 이모지 파일명 → 기존 이모지 매핑 (역방향)
  static final Map<String, String> pixelToEmoji = {
    for (final entry in emojiToPixel.entries) entry.value: entry.key,
  };

  /// 이모지를 픽셀 이미지 경로로 변환
  static String? getPixelPath(String emoji) {
    final fileName = emojiToPixel[emoji];
    if (fileName == null) return null;
    return '$_basePath$fileName.webp';
  }

  /// 픽셀 이모지 ID로 이미지 경로 가져오기
  static String getPathById(String pixelId) {
    return '$_basePath$pixelId.webp';
  }

  /// 픽셀 이모지 이미지 위젯 생성
  static Widget buildPixelEmoji(
    String emojiOrPixelId, {
    double size = 32,
    BoxFit fit = BoxFit.contain,
  }) {
    String path;

    // 이미 픽셀 ID인 경우 (face_cool 등)
    if (emojiOrPixelId.startsWith('face_') ||
        emojiOrPixelId.startsWith('animal_') ||
        emojiOrPixelId.startsWith('food_') ||
        emojiOrPixelId.startsWith('nature_') ||
        emojiOrPixelId.startsWith('item_') ||
        emojiOrPixelId.startsWith('badge_')) {
      path = getPathById(emojiOrPixelId);
    } else {
      // 이모지인 경우
      final pixelPath = getPixelPath(emojiOrPixelId);
      if (pixelPath == null) {
        // 매핑 없으면 기존 이모지 텍스트로 표시
        return Text(
          emojiOrPixelId,
          style: TextStyle(fontSize: size * 0.8),
        );
      }
      path = pixelPath;
    }

    return Image.asset(
      path,
      width: size,
      height: size,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // 이미지 로드 실패 시 기존 이모지 표시
        final emoji = pixelToEmoji[emojiOrPixelId] ?? emojiOrPixelId;
        return Text(
          emoji,
          style: TextStyle(fontSize: size * 0.8),
        );
      },
    );
  }

  /// 프로필에 저장된 값이 이모지인지 픽셀 ID인지 확인
  static bool isPixelId(String value) {
    return value.startsWith('face_') ||
        value.startsWith('animal_') ||
        value.startsWith('food_') ||
        value.startsWith('nature_') ||
        value.startsWith('item_') ||
        value.startsWith('badge_');
  }
}
