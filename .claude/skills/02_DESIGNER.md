# LinkPing - Designer 디자인 가이드

> **작성자**: Designer (UI/UX)
> **작성일**: Day 1-2
> **상태**: 디자인 완료 (v2.0 - 다크 테마 리뉴얼)
> **업데이트**: 알라미 스타일 다크 테마 적용 (블랙 + 코랄 레드)

---

## 1. 디자인 시스템

### 선택: Material 3 + 커스텀 다크 테마

```dart
// 이유
- Flutter 기본 지원 (추가 패키지 불필요)
- 알라미 스타일 다크 모드 (퓨어 블랙 배경)
- 검증된 컴포넌트 + 커스텀 컬러
```

---

## 2. 컬러 팔레트

### 🎨 알라미 스타일 (v2.0)

```dart
// lib/core/theme/app_theme.dart

// 메인 컬러
static const Color primaryColor = Color(0xFFFF5A5F);    // 코랄 레드
static const Color backgroundColor = Color(0xFF000000); // 퓨어 블랙
static const Color surfaceColor = Color(0xFF1C1C1E);    // 다크 그레이 (카드)
static const Color surfaceVariant = Color(0xFF2C2C2E);  // 더 밝은 그레이
static const Color toggleOnColor = Color(0xFF00D4AA);   // 틸/시안 (토글 ON)

// 텍스트
static const Color textPrimary = Color(0xFFFFFFFF);     // 흰색
static const Color textSecondary = Color(0xFF8E8E93);   // 회색
```

### 색상 의미

| 용도 | 컬러 코드 | 색상 | 사용처 |
|------|----------|------|--------|
| Primary | `#FF5A5F` | 🔴 코랄 레드 | CTA 버튼, FAB, 강조 |
| Background | `#000000` | ⬛ 퓨어 블랙 | 전체 배경 |
| Surface | `#1C1C1E` | 다크 그레이 | 카드, 모달, 바텀시트 |
| Toggle ON | `#00D4AA` | 🟢 틸/시안 | 스위치 ON 상태 |
| Text Primary | `#FFFFFF` | ⬜ 흰색 | 주요 텍스트 |
| Text Secondary | `#8E8E93` | 회색 | 보조 텍스트, 힌트 |
| Outline | `#3A3A3C` | 어두운 회색 | 구분선, 비활성 |
| Error | `#FF453A` | 빨강 | 삭제, 에러 |

### 왜 블랙 + 코랄 레드?

```
✅ 선택 이유:
- 알라미 앱 레퍼런스 (검증된 다크 UI)
- 퓨어 블랙 = OLED 배터리 절약, 프리미엄 느낌
- 코랄 레드 = 에너지, 행동 유도, 눈에 띄는 CTA
- 틸 토글 = 활성화 상태 명확히 구분
```

---

## 3. 타이포그래피

### Material 3 기본 사용

```dart
// 사용 방식
Text('제목', style: Theme.of(context).textTheme.headlineMedium)
Text('본문', style: Theme.of(context).textTheme.bodyLarge)
Text('캡션', style: Theme.of(context).textTheme.labelMedium)
```

### 사용할 스타일

| 용도 | TextStyle | 예시 |
|------|-----------|------|
| 앱바 제목 | titleLarge | "LinkPing" |
| 카드 제목 | titleMedium | "아침 스트레칭" |
| 카드 부제목 | bodyMedium | "매일 07:00" |
| 링크 URL | bodySmall | "youtube.com/..." |
| 버튼 | labelLarge | "저장", "이동하기" |

---

## 4. 아이콘

### Material Icons 사용

```dart
// 사용할 아이콘
Icons.add              // FAB, 링크 추가
Icons.notifications    // 알림 관련
Icons.link             // 링크 표시
Icons.access_time      // 시간 표시
Icons.delete           // 삭제
Icons.settings         // 설정
Icons.check_circle     // 완료/활성
Icons.cancel           // 비활성
Icons.open_in_new      // 외부 링크 이동
Icons.edit             // 수정
```

---

## 5. 간격 (Spacing)

### 8의 배수 규칙

```dart
// lib/core/theme/spacing.dart

class Spacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

// 사용
Padding(padding: EdgeInsets.all(Spacing.md))
SizedBox(height: Spacing.sm)
```

---

## 6. 컴포넌트 디자인

### 6.1 링크 카드 (업데이트)

```
┌─────────────────────────────────────┐
│                                     │
│  🏃 아침 스트레칭 하자!        🔵   │
│                                     │
│  ⏰ 매일 07:00                      │
│  🔗 youtube.com/watch?v=xxx...      │
│  👥 23명이 저장함                   │ ← 저장 수 표시
│                                     │
└─────────────────────────────────────┘

🔵 = 토글 (ON/OFF)
👥 = 저장 인원 수 (소셜 기능)
```

```dart
// 구현
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: BorderSide(color: Theme.of(context).colorScheme.outline),
  ),
  child: Padding(
    padding: EdgeInsets.all(Spacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: titleMedium)),
            Switch(value: isEnabled, onChanged: onToggle),
          ],
        ),
        SizedBox(height: Spacing.sm),
        Row(
          children: [
            Icon(Icons.access_time, size: 16),
            SizedBox(width: Spacing.xs),
            Text(timeText, style: bodyMedium),
          ],
        ),
        SizedBox(height: Spacing.xs),
        Row(
          children: [
            Icon(Icons.link, size: 16),
            SizedBox(width: Spacing.xs),
            Expanded(
              child: Text(
                url,
                style: bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
                ),
              ],
            ),
          ],
        ),
      ),
    )

// 저장 수 표시 추가
if (saveCount > 0) ...[
  const SizedBox(height: Spacing.xs),
  Row(
    children: [
      Icon(Icons.people, size: 16, color: colorScheme.primary),
      const SizedBox(width: Spacing.xs),
      Text(
        '$saveCount명이 저장함',
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.primary,
        ),
      ),
    ],
  ),
],
```

### 6.2 FAB (추가 버튼)

```dart
FloatingActionButton(
  onPressed: onAddLink,
  child: Icon(Icons.add),
)
```

### 6.3 입력 폼

```dart
// URL 입력
TextFormField(
  decoration: InputDecoration(
    labelText: '링크 URL',
    hintText: 'https://...',
    prefixIcon: Icon(Icons.link),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  validator: (value) => isValidUrl(value) ? null : '올바른 URL을 입력하세요',
)

// 제목 입력
TextFormField(
  decoration: InputDecoration(
    labelText: '알림 제목',
    hintText: '아침 스트레칭 하자!',
    prefixIcon: Icon(Icons.notifications),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

### 6.4 시간 선택

```dart
// TimePicker 사용
ListTile(
  leading: Icon(Icons.access_time),
  title: Text('알림 시간'),
  subtitle: Text(selectedTime.format(context)),
  trailing: Icon(Icons.chevron_right),
  onTap: () async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) onTimeSelected(time);
  },
)
```

### 6.5 반복 요일 선택

```dart
// Chip 그룹
Wrap(
  spacing: Spacing.sm,
  children: [
    ChoiceChip(label: Text('매일'), selected: isDaily, onSelected: ...),
    ChoiceChip(label: Text('평일'), selected: isWeekdays, onSelected: ...),
    ChoiceChip(label: Text('주말'), selected: isWeekends, onSelected: ...),
  ],
)

// 또는 개별 요일
Wrap(
  spacing: Spacing.xs,
  children: ['월', '화', '수', '목', '금', '토', '일']
    .map((day) => FilterChip(
      label: Text(day),
      selected: selectedDays.contains(day),
      onSelected: (selected) => onDayToggle(day, selected),
    ))
    .toList(),
)
```

---

## 7. 화면 디자인

### 7.1 온보딩 화면

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│            🔔                       │
│                                     │
│    저장한 링크를                    │
│    실천하자!                        │
│                                     │
│    인스타, 유튜브 영상을            │
│    정해진 시간에 바로 열어요        │
│                                     │
│                                     │
│    ┌─────────────────────────┐     │
│    │        시작하기          │     │
│    └─────────────────────────┘     │
│                                     │
└─────────────────────────────────────┘
```

### 7.2 로그인 화면

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│            🔗                       │
│                                     │
│         LinkPing                    │
│                                     │
│    저장한 링크, 실천하자!           │
│                                     │
│                                     │
│    ┌─────────────────────────┐     │
│    │  🍎 Apple로 계속하기     │     │
│    └─────────────────────────┘     │
│                                     │
│    ┌─────────────────────────┐     │
│    │  🔵 Google로 계속하기    │     │
│    └─────────────────────────┘     │
│                                     │
│         나중에 할게요 →             │
│                                     │
└─────────────────────────────────────┘
```

### 7.3 프로필 설정 화면

```
┌─────────────────────────────────────┐
│  ← 프로필 설정                     │
├─────────────────────────────────────┤
│                                     │
│    프로필을 설정해주세요            │
│                                     │
│    ┌─────────────────────────┐     │
│    │ 👤 닉네임                │     │
│    │ 운동하는민수             │     │
│    └─────────────────────────┘     │
│    * 다른 사용자에게 표시됩니다      │
│                                     │
│    ┌─────────────────────────┐     │
│    │ 🌍 국가                  │     │
│    │ 🇰🇷 대한민국          ▼  │     │
│    └─────────────────────────┘     │
│                                     │
│    ┌─────────────────────────┐     │
│    │         완료             │     │
│    └─────────────────────────┘     │
│                                     │
└─────────────────────────────────────┘
```

### 7.4 홈 화면 (목록) - 업데이트

```
┌─────────────────────────────────────┐
│  LinkPing  운동하는민수        ⚙️   │ ← AppBar (닉네임 표시)
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏃 아침 스트레칭 하자!   🔵 │   │ ← 링크 카드
│  │ ⏰ 매일 07:00               │   │
│  │ 🔗 youtube.com/...          │   │
│  │ 👥 23명이 저장함            │   │ ← 저장 수 표시
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💪 허리 운동             🔵 │   │
│  │ ⏰ 평일 10:00, 15:00, 20:00 │   │
│  │ 🔗 instagram.com/...        │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📚 영어 듣기             ⚪ │   │ ← 비활성
│  │ ⏰ 매일 12:30               │   │
│  │ 🔗 youtube.com/...          │   │
│  └─────────────────────────────┘   │
│                                     │
│                          ┌───┐     │
│                          │ + │     │ ← FAB
│                          └───┘     │
├─────────────────────────────────────┤
│         [ 배너 광고 ]              │ ← AdMob 배너
└─────────────────────────────────────┘
```

### 7.2 빈 상태 (Empty State)

```
┌─────────────────────────────────────┐
│  LinkPing                     ⚙️   │
├─────────────────────────────────────┤
│                                     │
│                                     │
│                                     │
│            🔔                       │
│                                     │
│    저장한 링크를 알림으로           │
│    받아보세요!                      │
│                                     │
│    인스타, 유튜브 영상을            │
│    정해진 시간에 바로 열어요        │
│                                     │
│       [ 첫 번째 링크 추가 ]         │
│                                     │
│                                     │
│                          ┌───┐     │
│                          │ + │     │
│                          └───┘     │
└─────────────────────────────────────┘
```

### 7.3 링크 추가/수정 화면

```
┌─────────────────────────────────────┐
│  ← 링크 추가                       │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔗 링크 URL                 │   │
│  │ https://youtube.com/...     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔔 알림 제목                │   │
│  │ 아침 스트레칭 하자!         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⏰ 알림 시간                │   │
│  │ 오전 7:00               ▶  │   │
│  └─────────────────────────────┘   │
│                                     │
│  반복                              │
│  ┌────┐ ┌────┐ ┌────┐            │
│  │매일│ │평일│ │주말│            │
│  └────┘ └────┘ └────┘            │
│                                     │
│  ┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐  │
│  │월││화││수││목││금││토││일│  │
│  └──┘└──┘└──┘└──┘└──┘└──┘└──┘  │
│                                     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │           저장              │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 7.5 설정 화면 (업데이트)

```
┌─────────────────────────────────────┐
│  ← 설정                            │
├─────────────────────────────────────┤
│                                     │
│  프로필                             │
│  ┌─────────────────────────────┐   │
│  │ 👤 운동하는민수          ▶  │   │ ← 닉네임 표시
│  │ 🇰🇷 대한민국                │   │
│  └─────────────────────────────┘   │
│                                     │
│  알림                              │
│  ┌─────────────────────────────┐   │
│  │ 알림 권한                🔵 │   │
│  └─────────────────────────────┘   │
│                                     │
│  프리미엄                          │
│  ┌─────────────────────────────┐   │
│  │ 프리미엄 구매            ▶  │   │
│  │ 무제한 링크, 광고 제거      │   │
│  └─────────────────────────────┘   │
│                                     │
│  계정                              │
│  ┌─────────────────────────────┐   │
│  │ 로그아웃                  ▶  │   │ ← 로그아웃 추가
│  └─────────────────────────────┘   │
│                                     │
│  정보                              │
│  ┌─────────────────────────────┐   │
│  │ 버전                  1.0.0 │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 개인정보 처리방침        ▶  │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 문의하기                 ▶  │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 7.6 공유 링크 가져오기 화면

```
┌─────────────────────────────────────┐
│  ← 친구가 공유한 링크              │
├─────────────────────────────────────┤
│                                     │
│    ┌─────────────────────────┐     │
│    │ 🏃 아침 스트레칭 하자!   │     │
│    │ ⏰ 07:00                │     │
│    └─────────────────────────┘     │
│                                     │
│    친구가 이 링크를 공유했어요!     │
│                                     │
│    ┌─────────────────────────┐     │
│    │   내 링크에 추가하기     │     │
│    └─────────────────────────┘     │
│                                     │
└─────────────────────────────────────┘
```

---

## 8. 소셜 기능 UI

### 8.1 저장 수 표시

```dart
// LinkCard에 추가
Row(
  children: [
    Icon(Icons.people, size: 16, color: colorScheme.primary),
    const SizedBox(width: Spacing.xs),
    Text(
      '$saveCount명이 저장함',
      style: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.primary,
      ),
    ),
  ],
)
```

**디자인 가이드:**
- Primary 색상 사용 (Deep Purple)
- 작은 아이콘 (16px)
- bodySmall 텍스트 스타일
- 0명일 때는 표시하지 않음

### 8.2 공유 버튼

```dart
// LinkCard 스와이프 시 표시
IconButton(
  icon: const Icon(Icons.share),
  onPressed: () => _shareLink(),
)
```

**디자인 가이드:**
- Material Icons의 `share` 아이콘
- 카드 스와이프 시 오른쪽에 표시
- 공유 다이얼로그에서 링크 URL 표시

### 8.3 로그인 버튼

```dart
// Google 로그인
FilledButton.icon(
  icon: Icon(Icons.g_mobiledata, size: 28),
  label: Text('Google로 계속하기'),
  style: FilledButton.styleFrom(
    minimumSize: Size(double.infinity, 56),
  ),
)

// Apple 로그인 (iOS만)
FilledButton.icon(
  icon: Icon(Icons.apple, size: 28),
  label: Text('Apple로 계속하기'),
  style: FilledButton.styleFrom(
    minimumSize: Size(double.infinity, 56),
  ),
)
```

**디자인 가이드:**
- FilledButton 사용 (Primary 색상)
- 아이콘 + 텍스트 조합
- 최소 높이 56px (터치 영역 확보)
- 전체 너비 사용

### 8.4 프로필 표시 (AppBar)

```dart
// AppBar에 닉네임 표시
AppBar(
  title: const Text('LinkPing'),
  actions: [
    Padding(
      padding: EdgeInsets.only(right: Spacing.sm),
      child: Center(
        child: Text(
          userProfile.nickname,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => context.push('/settings'),
    ),
  ],
)
```

**디자인 가이드:**
- bodyMedium 텍스트 스타일
- Settings 아이콘 왼쪽에 배치
- 간격: Spacing.sm

---

## 9. 알림 디자인

### Android Notification

```
┌─────────────────────────────────────┐
│ 🔔 LinkPing              오전 7:00 │
├─────────────────────────────────────┤
│                                     │
│  아침 스트레칭 하자!               │
│  youtube.com                        │
│                                     │
│  [ 이동하기 ]       [ 나중에 ]     │
│                                     │
└─────────────────────────────────────┘
```

### iOS Notification

```
┌─────────────────────────────────────┐
│ LINKPING                   오전 7:00│
│                                     │
│ 아침 스트레칭 하자!                │
│ 탭하여 영상으로 이동               │
└─────────────────────────────────────┘
```

---

## 10. 다크모드

```dart
// 자동 지원 (Material 3)
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system, // 시스템 설정 따름
)
```

### 라이트 vs 다크

| 요소 | 라이트 | 다크 |
|------|--------|------|
| 배경 | White | #121212 |
| 카드 | White (elevation) | #1E1E1E |
| Primary | Deep Purple | Deep Purple (밝게) |
| 텍스트 | Black | White |

---

## 11. 체크리스트

### 디자인 완료 항목
- [x] 디자인 시스템 선택 (Material 3)
- [x] 컬러 팔레트 확정
- [x] 컴포넌트 디자인
- [x] 화면 와이어프레임
- [x] 다크모드 지원
- [x] 로그인 화면 디자인
- [x] 프로필 설정 화면 디자인
- [x] 저장 수 표시 UI 디자인
- [x] 공유 기능 UI 디자인

### 전달 사항
- [x] → Developer: 컴포넌트 코드 예시 전달
- [x] → Developer: 색상/간격 상수 전달
- [x] → Developer: 소셜 기능 UI 가이드 전달
