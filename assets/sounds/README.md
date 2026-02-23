# Alarm Sounds / 알람 소리

## 파일 목록 (30개 = 알람 15 + 효과음 15)

### 🔔 알람 스타일 (Alarm Style) - 5-15초, 멜로디형

| ID | 파일명 | 설명 (KO) | Description (EN) | Premium |
|----|--------|-----------|------------------|---------|
| default | alarm_default | 기본 | Default | Free |
| gentle | alarm_gentle | 부드러운 | Gentle | Free |
| morning | alarm_morning | 상쾌한 아침 | Morning | Free |
| digital | alarm_digital | 디지털 | Digital | Free |
| chime | alarm_chime | 차임벨 | Chime | Free |
| energetic | alarm_energetic | 활기찬 | Energetic | Premium |
| nature | alarm_nature | 자연의 소리 | Nature | Premium |
| classic | alarm_classic | 클래식 | Classic | Premium |
| minimal | alarm_minimal | 미니멀 | Minimal | Premium |
| piano | alarm_piano | 피아노 | Piano | Premium |
| bell | alarm_bell | 종소리 | Bell | Premium |
| whistle | alarm_whistle | 휘파람 | Whistle | Premium |
| marimba | alarm_marimba | 마림바 | Marimba | Premium |
| radar | alarm_radar | 레이더 | Radar | Premium |
| meditation | alarm_meditation | 명상 | Meditation | Premium |

### 🔕 효과음 스타일 (Notify Style) - 2-5초, 단순형

| ID | 파일명 | 설명 (KO) | Description (EN) | Premium |
|----|--------|-----------|------------------|---------|
| notify_default | notify_default | 기본 | Default | Free |
| notify_bubble | notify_bubble | 버블 | Bubble | Free |
| notify_ding | notify_ding | 딩 | Ding | Free |
| notify_tap | notify_tap | 탭 | Tap | Free |
| notify_swoosh | notify_swoosh | 스우시 | Swoosh | Free |
| notify_crystal | notify_crystal | 크리스탈 | Crystal | Premium |
| notify_pop | notify_pop | 팝 | Pop | Premium |
| notify_wave | notify_wave | 웨이브 | Wave | Premium |
| notify_star | notify_star | 스타 | Star | Premium |
| notify_string | notify_string | 스트링 | String | Premium |
| notify_wind | notify_wind | 윈드차임 | Wind Chime | Premium |
| notify_click | notify_click | 클릭 | Click | Premium |
| notify_glow | notify_glow | 글로우 | Glow | Premium |
| notify_bounce | notify_bounce | 바운스 | Bounce | Premium |
| notify_zen | notify_zen | 젠 | Zen | Premium |

---

## 파일 추가 방법

### 1. 이 폴더 (Flutter assets - 미리듣기용)
```
assets/sounds/
├── alarm_default.mp3
├── alarm_gentle.mp3
├── notify_default.mp3
├── notify_bubble.mp3
└── ... (모든 mp3 파일)
```

### 2. Android (알림 소리용)
```
android/app/src/main/res/raw/
├── alarm_default.mp3
├── alarm_gentle.mp3
├── notify_default.mp3
├── notify_bubble.mp3
└── ... (모든 mp3 파일)
```
**주의:** 파일명에 하이픈(-) 사용 금지! 언더스코어(_) 사용

### 3. iOS (알림 소리용)
```
ios/Runner/Sounds/
├── alarm_default.caf
├── alarm_gentle.caf
├── notify_default.caf
├── notify_bubble.caf
└── ... (모든 caf 파일)
```

**iOS 추가 작업:**
1. Xcode에서 프로젝트 열기
2. Runner 폴더 우클릭 → "Add Files to Runner..."
3. Sounds 폴더 선택
4. "Create folder references" 체크
5. "Add"

---

## Suno AI 프롬프트

### 알람 스타일 (5-15초)
```
Gentle wake-up alarm tone, soft chime melody, calm and peaceful, 8 seconds, loopable ending, mobile notification style
```

### 효과음 스타일 (2-5초)
```
Short notification sound, single soft chime, warm digital tone, 2 seconds, clean and minimal, gentle ping
```

---

## 파일 변환

### MP3 → CAF (iOS용)
```bash
afconvert -f caff -d LEI16 input.mp3 output.caf
```

### 트리밍 (Suno 결과물 자르기)
```bash
# 처음 8초만 추출
ffmpeg -i input.mp3 -t 8 -c copy output.mp3

# 효과음용 (처음 3초)
ffmpeg -i input.mp3 -t 3 -c copy output.mp3
```

---

## 권장 사양

### 알람 스타일
- **길이:** 5~15초
- **포맷:** MP3 (Android/Flutter), CAF (iOS)
- **샘플레이트:** 44100Hz
- **비트레이트:** 128kbps 이상

### 효과음 스타일
- **길이:** 2~5초
- **포맷:** MP3 (Android/Flutter), CAF (iOS)
- **샘플레이트:** 44100Hz
- **비트레이트:** 128kbps 이상

---

## 무료 사운드 소스

- [Pixabay](https://pixabay.com/sound-effects/search/alarm/)
- [Freesound](https://freesound.org/)
- [Mixkit](https://mixkit.co/free-sound-effects/alarm/)
- [Zapsplat](https://www.zapsplat.com/)

검색 키워드: `alarm tone`, `notification sound`, `gentle wake up`, `chime`, `bell`, `ui sound effect`
