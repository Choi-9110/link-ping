# LinkPing 프로젝트 현황 (실제 코드 기준)
기준일: 2026-03-14

## 한 줄 요약
**v1 기능 완성 + 대부분의 P0 보안이슈 해결 완료. 출시까지 남은 건 IAP 서버 배포 + 추천코드 최적화 + 스토어 자료뿐.**

---

## 1. 프로젝트 구조

| 항목 | 내용 |
|------|------|
| 플랫폼 | Flutter (Android/iOS/Web) |
| 스택 | Riverpod, Hive, Firebase(Auth/Firestore), Google Mobile Ads, In-App Purchase |
| Firebase | `linkping-prod` (프로덕션 프로젝트 연결 완료) |
| 번들ID | iOS: `com.drevv.linkping` / Android: 확인 필요 |
| 다국어 | 한/영/일/중/스페인어 (5개) |
| 엔트리 | `lib/main.dart` |

### 데이터 구조
- 로컬: Hive (`links`, `settings`)
- 클라우드: Firestore (`users`, `urlStats`, `notifications`, `sharedLinks`, `inquiries`, `modificationRequests`, `analytics`)

---

## 2. 구현 완료 기능 (22개+)

### 핵심
- [x] Google 소셜 로그인 + 익명(게스트) 로그인
- [x] 게스트 → 회원 전환
- [x] 이모지 아바타 (64종)
- [x] 링크 등록/수정/삭제 + 반복 요일 + 종료일
- [x] 다중 알림 시간 (무료: 재화/광고, 프리미엄: 확장)
- [x] 로컬 푸시 알림 + 알림 탭 → URL/전화 열기
- [x] 카테고리 시스템 (운동/공부/연락/자기계발/기타)
- [x] 알람 소리 커스텀 (무료 10 + 프리미엄 21 + 알람 11)

### 소셜
- [x] 링크 공유 (일반/고정 알람)
- [x] 공유 링크 (`/s/{shareId}`) + 저장자 추적
- [x] 저장한 사람 목록 (이모지 포함)
- [x] 응원/약올리기 핑 + 5분 윈도우 제약
- [x] 고정 알람 수정 투표 시스템
- [x] 알림 센터

### 수익화
- [x] 프리미엄 결제 (월간/연간/평생)
- [x] 배너 광고 + 보상형 광고 (시간 추가, 소리 해금)
- [x] 링크 2개 무료 정책
- [x] 추천 시스템 (첫 추천: +1 링크, 이후: 포링 +5)
- [x] 뱃지 시스템

### 기타
- [x] 문의하기 + 관리자 대시보드 (`/admin`)
- [x] 웹 랜딩/소개 페이지
- [x] 온보딩 화면

### UX 개선 (2월 완료)
- [x] 포링 다이얼로그 바깥 탭 닫기
- [x] 응원/약올리기 플로우 개선
- [x] 알람 시간 변경 악용 방지 (하루 1회)
- [x] 홈 AppBar: 프로필(이모지+닉네임) 좌측 배치
- [x] 포링 아이콘 → toll (알림과 구분)

---

## 3. 보안/운영 이슈 점검 (코드 기준 실사)

### P0 이슈

| 이슈 | 2월 상태 | 현재 상태 | 비고 |
|------|---------|---------|------|
| 관리자 비밀번호 하드코딩 | 문제 있음 | **해결됨** | Google Sign-In + Firestore `isAdmin` 체크로 전환 |
| 인앱결제 서버 검증 | 클라이언트 `true` 반환 | **부분 해결** | 서버 검증 코드 구현됨. 단, `IAP_VERIFY_ENDPOINT` 미설정 시 debug 빌드에서 bypass. 릴리즈에서는 `false` 반환 (안전) |

**IAP 상세:**
- `purchase_service.dart`에서 `--dart-define=IAP_VERIFY_ENDPOINT=...` 방식 사용
- 엔드포인트 설정 시 서버로 `POST /iap/verify` 호출 → `{ "valid": true/false }` 응답 처리
- API 계약: `docs/IAP_VERIFY_API_CONTRACT.md` 참고
- **남은 작업**: 실제 검증 서버 배포 + 빌드 시 엔드포인트 주입

### P1 이슈

| 이슈 | 2월 상태 | 현재 상태 | 비고 |
|------|---------|---------|------|
| 테스트 광고 ID 사용 | 하드코딩 `true` 다수 | **해결됨** | 모든 파일에서 `AdService.instance.useTestAds` 동적 참조로 전환. `kDebugMode`이면 테스트, 릴리즈이면 실제 광고 자동 적용 |
| 디버그 메뉴 노출 | `[DEBUG] 개발자 도구` 존재 | **해결됨** | settings_screen.dart에서 디버그 섹션 완전 제거 |
| 추천코드 전체 유저 스캔 | 전체 스캔 | **미해결** | `firestore_service.dart:949` — `_usersCollection.get()` 후 클라이언트에서 루프 비교. 유저 증가 시 비용/성능/프라이버시 문제 |

### P2 이슈

| 이슈 | 상태 | 비고 |
|------|------|------|
| 테스트 코드 미작성 | 미해결 | 기본 카운터 템플릿 상태 |

---

## 4. Firebase 환경

| 항목 | 상태 |
|------|------|
| 프로젝트 | `linkping-prod` 연결 완료 |
| `firebase_options.dart` | Android/iOS/Web 모두 실제 키 설정됨 |
| `google-services.json` | 업데이트됨 |
| `GoogleService-Info.plist` | 업데이트됨 |
| Authentication | Google + Anonymous 활성화 필요 |
| Firestore | Production mode |
| 관리자 설정 | `users/<ADMIN_UID>`에 `isAdmin: true` 수동 부여 |

Firebase 재설정 가이드: `docs/FIREBASE_RESET_P0_RUNBOOK.md`

---

## 5. 광고 현황

### AdMob 광고 ID (실제 등록됨)
| 타입 | Android | iOS | 상태 |
|------|---------|-----|------|
| 배너 | `ca-app-pub-1117.../2979940293` | `ca-app-pub-1117.../9604284316` | OK |
| 보상형 | `ca-app-pub-1117.../8079722729` | `ca-app-pub-1117.../280291054` | OK |
| 네이티브 | 플레이스홀더 | 플레이스홀더 | Phase 3 예정 |

### 광고 로직
- `AdService.useTestAds` = `kDebugMode || USE_TEST_ADS dart-define`
- 릴리즈 빌드에서는 자동으로 실제 광고 ID 사용
- 모든 위젯(배너/보상형/네이티브)이 동적으로 참조 → **추가 수정 불필요**

---

## 6. 빌드 환경변수 (dart-define)

```bash
# 필수 (릴리즈 배포 시)
--dart-define=IAP_VERIFY_ENDPOINT=https://<your-domain>/iap/verify

# 선택 (디버그 외 환경에서 테스트 광고 강제)
--dart-define=USE_TEST_ADS=true

# 선택 (웹 베이스 URL 변경 시)
--dart-define=PUBLIC_WEB_BASE_URL=https://linkping.app
```

---

## 7. 출시까지 남은 할 일

### 블로커 (출시 전 필수)
- [ ] **IAP 검증 서버 배포** — Cloud Functions 또는 별도 서버에서 Apple/Google 영수증 검증 엔드포인트 운영
- [ ] **Apple Developer 법인 검증 완료** (2월 제출, 대기 중이었음)

### 권장 (출시 전 강력 권장)
- [ ] **추천코드 조회 최적화** — Firestore에 `referralCode` 필드 인덱싱 또는 Cloud Function으로 대체
- [ ] 릴리즈 빌드 테스트 (Android appbundle, iOS Archive)
- [ ] 주요 플로우 수동 테스트 (TODO.md 섹션 3 체크리스트 참고)

### 스토어 자료 (Apple 승인 후)
- [ ] 앱 아이콘 최종 확인 (1024x1024)
- [ ] 스크린샷 (iPhone 6.7"/5.5" 필수) — 한/영
- [ ] 개인정보처리방침/이용약관 URL 동작 확인
- [ ] App Store Connect + Google Play Console 등록
- [ ] 인앱 구매 상품 등록 (월간/연간/평생)

### 출시 후 (Phase 2)
- [ ] 스트릭 시스템, 하단 네비게이션, 통계 대시보드
- [ ] ASO 최적화, 인플루언서 협업
- [ ] 네이티브 광고, 프리미엄 소리팩
- [ ] 위젯 개발, 챌린지 기능

---

## 8. 수익화 구조

### 모델
- **광고**: 무료 유저 대상 배너 + 보상형 (시간 추가, 소리 해금)
- **구독**: 월간/연간/평생 프리미엄 (무제한 링크, 광고 제거, 전체 소리)
- **리퍼럴**: 초대코드 보상 (바이럴 루프)

### 매출 추정 (참고용)
| 시나리오 | MAU | 광고 | 구독 | 합계 |
|---------|------|------|------|------|
| 보수 | 10,000 | $2,500 | $270 | **$2,770/월** |
| 기준 | 50,000 | $15,000 | $3,375 | **$18,375/월** |
| 공격 | 200,000 | $96,000 | $27,000 | **$123,000/월** |

---

## 9. 관련 문서

| 문서 | 위치 | 용도 |
|------|------|------|
| TODO & 체크리스트 | `.claude/TODO.md` | 상세 할 일 + 테스트 체크리스트 |
| IAP 검증 API 계약 | `docs/IAP_VERIFY_API_CONTRACT.md` | 서버 구현 시 참고 |
| Firebase 재설정 가이드 | `docs/FIREBASE_RESET_P0_RUNBOOK.md` | Firebase 재설정 필요 시 참고 |
| 스토어 등록 자료 | `.claude/STORE_LISTING.md` | 앱스토어 설명문/키워드 |
| 마케팅 가이드 | `.claude/MARKETING_GUIDE.md` | 해외 MZ 타겟 마케팅 전략 |
| PM 기획서 | `.claude/skills/01_PM.md` | 제품 기획 |
| 디자인 가이드 | `.claude/skills/02_DESIGNER.md` | UI/UX |
| 아키텍처 | `.claude/skills/03_ARCHITECT.md` | 기술 구조 |
| 개발 현황 | `.claude/skills/04_DEVELOPER.md` | 구현 상세 |
| 전략서 | `.claude/skills/05_STRATEGIST.md` | 사업 전략 |

---

## 10. 결론

| 항목 | 평가 |
|------|------|
| 기능 완성도 | **상** — MVP 이상, 22개+ 기능 구현 완료 |
| 보안 상태 | **중상** — P0 2개 중 1개 완전 해결, 1개 코드 완성 (서버 배포만 남음) |
| 출시 준비도 | **중상** — IAP 서버 + Apple 승인만 해결되면 배포 가능 |
| 수익 모델 | **유효** — Freemium + Ad + Subscription 구조 검증된 조합 |

> 2월 감사 때 지적된 P0 5개 항목 중 3개(관리자 인증, 테스트 광고, 디버그 메뉴)가 이미 해결됨.
> 남은 핵심 블로커는 **IAP 검증 서버 배포** 1개뿐.
