# Firebase 재설정 P0 Runbook
기준일: 2026-02-23

## 목표
삭제된 Firebase 프로젝트를 새로 연결하고, 앱이 즉시 동작 가능한 상태로 복구한다.

## 1) 새 Firebase 프로젝트 생성
- Firebase Console에서 새 프로젝트 생성
- 프로젝트 ID 확정 (예: `linkping-prod`)
- Authentication 활성화
  - Sign-in method: Google, Anonymous
- Firestore Database 생성 (Production mode 권장)
- Hosting 사용 시 활성화

## 2) 앱 등록
- Android 앱 등록
  - 패키지명: 현재 코드 기준 `app.linkping` + `com.example.linkping` 흔적이 함께 있음
  - 출시 전 최종 패키지 1개로 통일 필요
- iOS 앱 등록
  - 번들ID: 현재 코드 기준 `com.example.linkping` (출시 전 실제 번들ID로 교체 권장)
- Web 앱 등록

## 3) 설정 파일 재생성 (필수)
아래 명령으로 기존 연결값을 새 프로젝트로 교체:

```bash
flutterfire configure \
  --project <NEW_FIREBASE_PROJECT_ID> \
  --platforms=android,ios,web
```

생성/갱신 대상:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `firebase.json`(메타 정보)

## 4) Google 로그인 동작 확인 포인트
- Firebase Authentication > Sign-in method > Google 활성화
- Android SHA-1/SHA-256 등록 (릴리즈/디버그 모두)
- iOS URL Types/REVERSED_CLIENT_ID 반영 확인

## 5) Firestore 최소 운영 설정
- `users/{uid}` 문서 생성/업데이트 가능 확인
- 관리자 계정 문서에 `isAdmin: true` 수동 부여
  - 경로: `users/<ADMIN_UID>`

## 6) 배포 전 환경변수 (P0)
### 인앱결제 검증 서버
릴리즈에서 결제 검증 우회는 막혀 있음. 아래 define 필수:

```bash
--dart-define=IAP_VERIFY_ENDPOINT=https://<your-domain>/iap/verify
```

서버 응답 계약:
- 요청: JSON (platform/productId/purchaseId/verificationData)
- 응답: `{ "valid": true }` 또는 `{ "valid": false }`

### 광고 테스트 강제 플래그 (선택)
디버그 외 환경에서 테스트 광고 강제가 필요하면:

```bash
--dart-define=USE_TEST_ADS=true
```

운영 배포에서는 생략 또는 `false`.

## 7) 최종 체크리스트
- [ ] 앱 실행 시 Firebase 초기화 성공
- [ ] 익명 로그인 성공
- [ ] Google 로그인 성공
- [ ] 프로필 저장(Firestore write) 성공
- [ ] 공유/알림/문의 기능 Firestore 반영 확인
- [ ] 관리자 페이지 `/admin` 로그인 후 `isAdmin` 계정만 접근 가능
- [ ] 결제 시 검증 엔드포인트 호출 및 실패/성공 처리 확인

## 8) 주의사항
- 기존 삭제된 프로젝트 키/ID는 더 이상 유효하지 않을 수 있음
- 현재 코드상 패키지/번들 식별자 이력이 혼재되어 있어, 애플 출시 전 1회 정리 필요
