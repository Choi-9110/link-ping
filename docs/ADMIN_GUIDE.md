# LinkPing 관리자 페이지 가이드

## 접속 방법
1. 브라우저에서 접속: https://linkping-prod.web.app/admin.html
2. 비밀번호 입력: `linkping2026!`
3. 끝!

## 할 수 있는 것
- **추천 링크 추가** — + Add 버튼
- **추천 링크 수정** — Edit 버튼 (제목, URL, 설명, 이모지 등)
- **추천 링크 삭제** — Delete 버튼
- **숨기기/보이기** — Active 체크박스 해제하면 앱에서 안 보임

## 중요
- 여기서 수정하면 **앱 업데이트 없이** 유저에게 바로 반영됨
- 한국어(KO) / 영어(EN) 제목을 따로 입력 가능
- Order 숫자가 작을수록 위에 표시됨 (0이 제일 위)

## 비밀번호 변경 방법

### 1단계: 파일 수정
프로젝트 폴더에서 `public/admin.html` 파일을 열고 이 부분을 찾아서 수정:
```javascript
const ADMIN_PASSWORD = "linkping2026!";  // ← 여기를 원하는 비밀번호로
```

### 2단계: 배포
터미널(맥의 "터미널" 앱)을 열고, 아래 두 줄을 순서대로 입력:

```bash
cd /Users/co._.k/ping-app/link-ping
firebase deploy --only hosting --project linkping-prod
```

- 첫 번째 줄: 프로젝트 폴더로 이동
- 두 번째 줄: 변경된 파일을 인터넷에 올림 (Firebase 서버에 배포)

"Deploy complete!" 라고 뜨면 성공!

### Claude Code에서 하는 법
Claude Code가 열려있으면 더 간단함:
```
firebase deploy --only hosting --project linkping-prod
```
이 한 줄만 실행하면 됨 (이미 프로젝트 폴더에 있으니까)

## 요약
| 하고 싶은 것 | 방법 |
|-------------|------|
| 추천 링크 추가/수정/삭제 | 브라우저에서 admin 페이지 접속 |
| 비밀번호 변경 | admin.html 수정 → 터미널에서 배포 |
| admin 페이지 디자인 변경 | admin.html 수정 → 터미널에서 배포 |
