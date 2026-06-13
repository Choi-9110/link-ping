# 링꾸(Linkku) 디자인 시스템 & UI 규칙

> 최종 정리: 2026-06-11 · 다크모드 단일 테마 · 브랜드킷 v1.0(DREVV) 승계
> 단일 진실 공급원(코드): `lib/core/theme/brand_tokens.dart`, `lib/core/theme/color_themes.dart`, `lib/core/theme/app_theme.dart`

---

## 1. 브랜드 메인 컬러 (역할 고정)

한 화면에서 세 강조색을 동시에 강조하지 않는다. **역할이 곧 색**이다.

| 색 | HEX | 역할 |
|----|-----|------|
| 🔴 코랄 (primary) | `#FF5A5F` | 액션 · 알람 · 브랜드 · 마스코트 바디 |
| 🟢 민트 (secondary) | `#00D4AA` | 완료 · 함께 · 핑 · 성공 · 벨 |
| 🟣 퍼플 (tertiary) | `#6C5CE7` | 보상 · 인앱 재화(포링) · 프리미엄 · 뱃지 |

권장 면적 비율 — 다크 62 : 텍스트 22 : 코랄 10 : 민트 6.

## 2. 다크 서피스 & 텍스트 토큰

순수 `#000`은 쓰지 않는다(특히 아이콘 타일).

| 토큰 | HEX | 용도 |
|------|-----|------|
| background | `#0E0E11` | 앱 전체 배경 |
| surface | `#17171B` | 카드 · 바텀시트 · 다이얼로그 |
| surfaceVariant | `#1F1F25` | 입력필드 등 밝은 표면 |
| outline | `#2A2A31` | **테두리/구분선 전용** |
| textPrimary (ink) | `#FFFFFF` | 본문 주요 텍스트 |
| textSecondary (onSurfaceVariant) | `#8E8E93` | 보조/흐린 텍스트 |
| dim | `#5A5A60` | 비활성/플레이스홀더 |

## 3. 코딩 규칙 (★ 반드시 지킬 것)

1. **하드코딩 색 금지.** `Colors.grey`, `Colors.white70`, `Color(0x..)` 직접 사용 금지 → `Theme.of(context).colorScheme.*` 또는 `BrandTokens.*` 사용. (web 인트로/관리자 페이지는 예외로 잔존)
2. **`colorScheme.outline`(#2A2A31)은 절대 텍스트/아이콘 색으로 쓰지 않는다.** 다크 배경 대비 ~2:1이라 안 보인다. 흐린 텍스트·아이콘은 **`colorScheme.onSurfaceVariant`(#8E8E93)**. outline은 `Border`/`BorderSide`/`Divider`/시트 핸들에만.
3. **다이얼로그 버튼은 항상 균등 너비("반반").** 멀티버튼 `AlertDialog`는 `lib/presentation/widgets/dialog_actions.dart`의 `DialogActions(buttons: [...])`로 감싼다. 기본 `actions:`(OverflowBar)는 우측 쏠림이라 금지. 단일 버튼은 테마상 이미 풀폭.
4. **SnackBar 스타일은 테마에서 통일됨**(`app_theme.dart` snackBarTheme: 다크배경+흰글자+floating). 복사/성공 알림은 가능하면 중앙 토스트 `ToastOverlay.showSuccess(context, msg)` 사용(가독성↑, 앱 표준).
5. **다국어:** 사용자 노출 문자열은 `l10n.*`(ARB) 사용. 브랜드명은 `l10n.appName`(ko "링꾸" / en "Linkku") — 하드코딩 "링꾸" 금지.
6. **폰트:** 본문/제목 = `Pretendard`(`BrandTokens.fontSans`). 픽셀 악센트(`Galmuri11`, `BrandTokens.fontPixel`)는 스트릭 카운터·뱃지명·시간 표기 등 악센트에만, 본문 금지.

## 4. 2026-06-11 변경 이력 (이 문서 기준 작업)

- **다크모드 가독성:** 텍스트/아이콘에 오용된 `outline` ~62곳 → `onSurfaceVariant`로 전수 교체. 테두리/구분선/핸들/요일칩은 보존. 빈 화면 큰 아이콘(alpha 0.4로 거의 투명이던 것)도 가시화.
- **SnackBar 테마 추가:** 앱 전체 SnackBar(45개)가 다크배경+흰글자로 가독성 확보.
- **다이얼로그 버튼 반반:** `DialogActions` 신설 + 멀티버튼 다이얼로그 11곳 적용.
- **공유 다이얼로그 2개 통일**(`link_share_preview_dialog`, `share_preview_dialog`): 리프래시=아이콘 only(툴팁) 상단 / 하단=[복사][공유] 반반 / 복사 알림=ToastOverlay.
- **도감 i18n:** 하드코딩 "링꾸" → `l10n.appName`(영어모드 "Linkku").
- **앱 아이콘 버그 수정:** `tool/gen_app_icon.dart` 정규식이 `rx`를 `x`로 오인해 생긴 좌측 흰 띠 제거.
- **포링 보상 유실 버그 수정:** `firestore_service.dart` `pending as int` → `(pending as num?)?.toInt()`.

## 5. 향후

- 홈 위젯(WidgetKit) — `docs/PET_SPEC.md` §12 참고. **실배포(첫 심사 통과) 이후 업데이트로 진행.**
- 하드코딩 포인트 컬러(문의/관리자 상태배지 `Colors.green`, 경고 `Colors.amber`, 알림 아이콘 알록달록 등)를 브랜드 3색 역할로 정리할지 — 미정(취향 결정 대기).
