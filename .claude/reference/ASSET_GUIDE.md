# 에셋 추가 가이드

## 사운드 추가 방법

### 1. 파일 준비
- **포맷**: MP3 (원본)
- **권장 길이**:
  - 알람(Alarm): 5-15초
  - 효과음(Effect): 2-5초
- **파일명 규칙**: `alm_` 또는 `fxs_` 접두사

### 2. 파일 변환

#### Android용 (MP3 그대로 사용)
```bash
# assets/sounds/ 폴더에 MP3 파일 복사
cp 새파일.mp3 assets/sounds/
```

#### iOS용 (CAF 변환 필요)
```bash
# MP3 → CAF 변환
afconvert -f caff -d LEI16 새파일.mp3 ios/Runner/새파일.caf
```

### 3. 코드 등록

**`lib/services/alarm_sound_service.dart`** 수정:

```dart
// alarmSounds 또는 effectSounds 리스트에 추가
static final List<SoundInfo> alarmSounds = [
  // ... 기존 사운드들
  SoundInfo(
    id: 'alm_새파일',
    name: '사운드 이름',
    nameKo: '사운드 이름 (한글)',
    isPremium: false,  // 무료: false, 프리미엄: true
    isNew: true,       // 신규 표시 (나중에 false로)
    addedDate: DateTime(2024, 2, 4),
  ),
];
```

### 4. pubspec.yaml 확인
```yaml
assets:
  - assets/sounds/  # 폴더 전체 포함되어 있으면 OK
```

---

## 이미지 (픽셀 이모지) 추가 방법

### 1. 파일 준비
- **포맷**: PNG (원본) → WebP (변환)
- **크기**: 512x512 권장 (투명 배경)
- **파일명 규칙**: `카테고리_이름.png`
  - 예: `face_happy.png`, `animal_dog.png`, `food_pizza.png`

### 2. WebP 변환 (용량 93% 감소!)

```bash
# 단일 파일 변환
cwebp -q 90 새파일.png -o 새파일.webp

# 폴더 내 전체 PNG 변환
cd assets/pixel_emojis
for f in *.png; do cwebp -q 90 "$f" -o "${f%.png}.webp"; done

# 원본 PNG 삭제 (선택)
rm *.png
```

### 3. 코드 등록

**`lib/services/pixel_emoji_service.dart`** 수정:

```dart
// profilePixelEmojis 리스트에 추가 (확장자 제외)
static const List<String> profilePixelEmojis = [
  // 얼굴
  'face_grinning',
  'face_새이모지',  // ← 추가

  // 동물
  'animal_dog',
  'animal_새동물',  // ← 추가

  // ... 등등
];
```

### 4. 배지용 이모지 매핑 (선택)

**`lib/services/pixel_emoji_service.dart`**의 `badgeToPixelEmoji` 맵:

```dart
static const Map<String, String> badgeToPixelEmoji = {
  'streak3': 'fire_small',
  '새배지': '새이모지',  // ← 추가
};
```

---

## 카테고리별 파일명 규칙

| 카테고리 | 접두사 | 예시 |
|----------|--------|------|
| 얼굴 | `face_` | face_grinning, face_cool |
| 동물 | `animal_` | animal_dog, animal_cat |
| 자연 | `nature_` | nature_flower, nature_tree |
| 음식 | `food_` | food_pizza, food_cake |
| 물건 | `object_` | object_star, object_heart |
| 기호 | `symbol_` | symbol_check, symbol_fire |

---

## 일괄 작업 스크립트

### 이미지 일괄 추가
```bash
# 1. PNG 파일들을 assets/pixel_emojis/에 복사
cp *.png /path/to/link-ping/assets/pixel_emojis/

# 2. WebP 변환
cd /path/to/link-ping/assets/pixel_emojis
for f in *.png; do cwebp -q 90 "$f" -o "${f%.png}.webp"; done

# 3. PNG 삭제
rm *.png

# 4. 용량 확인
du -sh .
```

### 사운드 일괄 추가 (iOS)
```bash
# MP3 → CAF 일괄 변환
cd /path/to/sounds
for f in *.mp3; do
  afconvert -f caff -d LEI16 "$f" "/path/to/link-ping/ios/Runner/${f%.mp3}.caf"
done

# Android용은 그냥 복사
cp *.mp3 /path/to/link-ping/assets/sounds/
```

---

## 체크리스트

### 사운드 추가 시
- [ ] MP3 파일 `assets/sounds/`에 추가
- [ ] iOS용 CAF 파일 `ios/Runner/`에 추가
- [ ] `alarm_sound_service.dart`에 SoundInfo 등록
- [ ] 앱 빌드 테스트

### 이미지 추가 시
- [ ] PNG → WebP 변환
- [ ] `assets/pixel_emojis/`에 추가
- [ ] 원본 PNG 삭제
- [ ] `pixel_emoji_service.dart`에 등록
- [ ] 앱 빌드 테스트

---

## 현재 에셋 현황

```
assets/
├── pixel_emojis/    # 4MB (110개 WebP)
├── sounds/          # 17MB (40개+ MP3)
└── app_icon.png     # 앱 아이콘

총 에셋: ~21MB
Release APK: ~39MB
```

*마지막 업데이트: 2024-02-04*
