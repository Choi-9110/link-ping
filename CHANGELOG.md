# Changelog

링꾸(Linkku) 변경 이력. 최신이 위.

## [1.0.0+10] — 2026-06-14 · 출시 전 버그픽스 & 마무리

### 🐛 버그 수정
- **애플 로그인 실패 수정 (심사 블로커)** — `[firebase_auth/invalid-credential] Invalid OAuth response from apple.com` 에러.
  Firebase 자격증명에 Apple의 `authorizationCode`(=accessToken)를 안 넘겨서 검증이 실패했음.
  `auth_service.dart`의 `signInWithApple()` / `linkWithApple()` 양쪽에 `accessToken: appleCredential.authorizationCode` 추가.
- **공유 시트가 안 뜨던 문제** — iOS에서 공유 미리보기 다이얼로그를 먼저 닫고(`Navigator.pop`) 공유 시트를 띄워서,
  닫히는 애니메이션 도중 present에 실패하며 시트가 떴다 바로 사라짐.
  순서를 뒤집어 **시트 먼저 present → 닫힌 뒤 다이얼로그 pop**, iPad용 `sharePositionOrigin`도 추가.
  (`link_share_preview_dialog.dart`, `share_preview_dialog.dart`)

### ✨ 인증(영상) 기능 개선
- **후면 카메라 기본값** — 인증 녹화가 전면(셀카)이 아닌 후면으로 시작.
- **인증 가능 시간 윈도우 10분 + 알람 게이팅** — "나도 인증하기"는 알람 알림을 탭한 뒤 10분 안에만 동작.
  윈도우 밖이면 "알람이 울린 뒤 N분 안에만 인증할 수 있어요" 안내(5개 언어). 프롬프트를 닫거나 인증을 마쳐도
  윈도우는 유지돼 재인증 가능.
- **재인증 시 이전 영상 자동 교체** — 같은 링크에 다시 인증하면 내 이전 영상은 삭제되고 최신 1개만 남음(중복 방지).
- **인증 영상/썸네일 로컬 캐싱** — 한 번 본 영상은 다음부터 즉시 재생(네트워크 0). 7일 보존, 최대 300개 자동 정리.
  (`cached_network_image` + `flutter_cache_manager`)
- **인증 폴더 "안 읽음" 뱃지** — 총 개수 대신, 마지막으로 폴더를 연 뒤 올라온 (남의) 인증이 있으면 빨간 점.
  폴더를 열면 사라짐.

### 🌐 문구 / 현지화
- 연결 모드 설명 문구 정리 — "다같이 링 / 릴레이 링" 설명을 짧고 가독성 좋게 (한·영·일·중·스페인어 전부).
- 계정 연동 팝업 버튼 "연동하러 가기" → "연동하기".

### 🎨 리브랜딩 마무리
- iOS `CFBundleName` `linkping` → `Linkku` (시스템 로그인 동의창 등에 뜨던 옛 이름 수정).
- 웹 메타태그(og/twitter) 도메인 `linkping.app`(미소유) → 실제 호스팅 `linkping-prod.web.app`.

### 🔧 빌드 / 설정
- Podfile에 `platform :ios, '13.0'` 명시 (CocoaPods 경고 제거, 동작 변화 없음).

### ⚠️ 코드 외 — 콘솔에서 직접 할 일
- **GCP OAuth 동의화면 앱 이름** → `Linkku` (구글 로그인 웹뷰의 "continue to project-…" 수정).
- **노출된 Apple Sign in 비공개 키(.p8) 폐기·재발급** (디버깅 중 스크린샷에 노출됨).
- (선택) `linkku` 커스텀 도메인 구매 후 Firebase Hosting 연결 → 웹 메타태그를 해당 도메인으로 갱신.

### 🧪 출시 전 반드시 검증 (TestFlight)
- ⭐ **애플 로그인이 실제로 끝까지 성공하는지** — 위 수정은 코드만 반영, 동작 미검증.
- 인증 녹화는 알람→알림 탭→10분 안에서만 열림. 심사 노트에 "인증 영상은 알람 알림을 탭한 뒤 활성화됩니다" 한 줄 권장.
