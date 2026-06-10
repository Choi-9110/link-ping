# 인증 영상 기능 — 서버 사이드 설정 가이드

배포 전 Firebase 콘솔에서 **반드시** 설정해줘야 비용 자동 절감과 데이터 정리가 동작해요.

## ✅ 코드에서 자동으로 처리되는 것
- 7일 후 만료될 `expiresAt` 필드를 영상마다 자동 기록
- 클라이언트에서 만료된 영상 / 차단된 유저 영상 / `isHidden=true` 영상 자동 필터링
- 신고 5건 누적 시 자동 `isHidden=true`

## ⚠️ Firebase 콘솔에서 직접 설정해야 하는 것

### 1. Firestore TTL 정책 활성화 (Firestore 자동 삭제)

> 콘솔에서 활성화 안 하면 영상 메타데이터가 영원히 남아서 비용 누적 ⚠️

1. Firebase Console → **Firestore Database** → **TTL** 탭
2. **Create policy** 클릭
3. 입력:
   - Collection: `verificationVideos`
   - Timestamp field: `expiresAt`
4. **Create** 클릭

→ 매일 새벽 Firestore가 자동으로 `expiresAt < now()` 인 문서를 삭제해요. 무료, 비동기.

### 2. Cloud Storage 수명주기 규칙 (영상 파일 자동 삭제)

> Firestore 메타만 지워지면 Storage 영상 파일은 남아서 비용 누적 ⚠️
> 반드시 두 개 모두 설정해야 해요.

1. [Google Cloud Console — Storage Browser](https://console.cloud.google.com/storage/browser) 접속
2. 프로젝트 `linkping-prod` 의 default bucket 선택 (`linkping-prod.firebasestorage.app`)
3. **수명주기(Lifecycle)** 탭 → **규칙 추가**
4. 다음 두 규칙 추가:

#### 규칙 A — 7일 후 영상 파일 삭제
- **작업**: 객체 삭제
- **조건**:
  - 객체 사용 기간: **7일**
  - 접두사 일치: `verifications/`

#### 규칙 B — 30일 후 미사용 객체 정리 (안전망)
- **작업**: 객체 삭제
- **조건**:
  - 객체 사용 기간: **30일**
  - 접두사 일치: `verifications/`

5. **저장**

### 3. 보안 규칙 배포

리포지토리 루트에서:

```bash
firebase deploy --only firestore:rules,firestore:indexes,storage:rules --project linkping-prod
```

이 명령으로 다음 파일들이 배포돼요:
- `firestore.rules` — Firestore 보안 규칙 (인증 영상 + 신고 + 차단 목록)
- `firestore.indexes.json` — 쿼리 인덱스 (sharedLinkId 기반 조회)
- `storage.rules` — Storage 보안 규칙 (본인 경로만 쓰기/삭제, 30MB 제한)

### 4. 인덱스 자동 생성 확인

배포 후 첫 쿼리 실행 시 Firestore가 인덱스를 생성합니다. 콘솔에 인덱스 빌딩 로그가 뜨면 **3~5분** 대기 후 정상 동작.

만약 인덱스 누락 에러가 클라이언트 로그에 뜨면, 에러 메시지 안의 URL을 클릭하면 자동으로 인덱스 생성 페이지가 열려요.

---

## 🔍 비용 모니터링

### 예상 월 비용 (1,000 MAU 기준)
| 항목 | 예상 사용량 | 월 비용 |
|------|-------------|---------|
| Firestore reads | ~150k | 무료 (50k/일 무료) |
| Firestore writes | ~30k | 무료 |
| Storage 저장 | <5GB (7일 회전) | 무료 (5GB 무료) |
| Storage egress | ~30GB | $3.6 |
| **합계** | | **약 $4/월** |

### 비용이 갑자기 오르면 의심할 것
1. **Storage egress 폭증** → 누가 한 영상을 수백 번 다운로드 (자동 봇 의심)
2. **Firestore writes 폭증** → 신고/시청 카운트 트리거 비정상
3. **Storage 누적** → 수명주기 규칙이 동작 안 함 (콘솔에서 확인)

Firebase Console → **Usage and billing** 에서 매주 한 번 확인 추천.

---

## 🚨 App Store / Play Store 심사 대응

배포 시 다음이 모두 충족되어 있어야 합니다 (UGC 가이드라인):

- ✅ **신고 기능** (`VerificationReportDialog`) — 4개 사유 + 차단 옵션
- ✅ **차단 기능** (`BlockedUsersScreen`) — 설정에서 관리
- ✅ **자동 숨김** — 신고 5건 누적 시 자동 `isHidden=true`
- ✅ **자동 만료** — 7일 후 모든 콘텐츠 자동 삭제
- ✅ **권한 명세** — iOS `NSCameraUsageDescription`, `NSMicrophoneUsageDescription`, Android `CAMERA`/`RECORD_AUDIO`
- ✅ **본인 영상 삭제** — 영상 플레이어에서 우상단 메뉴 → 삭제

App Store 심사 메모에 다음 문구를 적어두면 통과 확률 ↑:
> Verification videos auto-expire after 7 days. Users can report and block other users.
> Reports trigger auto-hide after 5 accumulations. Reported content is reviewed within 24 hours.

---

## 📝 변경 사항이 있을 때

이 문서를 마지막 업데이트한 시점에서 코드 변경되면 다음 항목 재확인:
- `VerificationVideoService.retention` 값 변경 → Storage Lifecycle 규칙 일수 동기화
- 새 컬렉션 추가 시 `firestore.rules` 업데이트
- 새 쿼리 추가 시 `firestore.indexes.json` 업데이트
