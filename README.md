# 링꾸 (Linkku)

> **저장한 링크를, 딱 그 시간에 알려주는 알람 앱.** (패키지명: `linkping`)
> 나중에 볼 링크를 저장 → 원하는 시간에 "핑" 알림 → 탭 한 번으로 바로 열기. 친구와 같은 시간에 함께 실천하는 게 핵심 차별점.

Flutter + Firebase 기반 iOS/Android 앱. 다크모드 단일 테마, 픽셀 아트 마스코트 "링꾸".

## 핵심 기능
- ⏰ 링크 알람(시간·반복 요일) → 탭하면 링크 오픈
- 🔁 스트릭 · 🏅 뱃지(업적) · 👯 공유 · 📣 응원/찌르기 · 🎥 인증 영상
- 🟣 포링(인앱 재화, 광고 적립) · ⭐ 프리미엄 · 📱 전화/소셜 로그인 · ☁️ 클라우드 백업 · 🃏 링꾸 도감

## 문서 (docs/)
| 문서 | 내용 |
|------|------|
| [BRAND.md](docs/BRAND.md) | 브랜드 전략·타깃·보이스·캐릭터 정의 |
| [DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md) | **컬러/토큰/UI 코딩 규칙 (단일 진실)** + 변경 이력 |
| [PET_SPEC.md](docs/PET_SPEC.md) | 펫/도감 로드맵(출시 후) + 홈 위젯(§12) |
| [FIRESTORE_SCHEMA.md](docs/FIRESTORE_SCHEMA.md) | Firestore 데이터 스키마 |
| [IAP_VERIFY_API_CONTRACT.md](docs/IAP_VERIFY_API_CONTRACT.md) | 인앱결제 검증 API 계약 |
| [VERIFICATION_VIDEO_SETUP.md](docs/VERIFICATION_VIDEO_SETUP.md) | 인증 영상 기능 셋업 |
| [ADMIN_GUIDE.md](docs/ADMIN_GUIDE.md) | 관리자 페이지 가이드 |
| [TESTFLIGHT_CHECKLIST.md](docs/TESTFLIGHT_CHECKLIST.md) | TestFlight/배포 체크리스트 |
| [CHANGELOG.md](CHANGELOG.md) | 버전별 변경 이력 |

## 빌드
```bash
flutter pub get
flutter run                 # 개발 실행 (실기기/시뮬)
flutter build ipa           # iOS 앱스토어용 IPA → build/ios/ipa/
```
버전 관리: `pubspec.yaml`의 `version: 1.0.x+N`. TestFlight 반복은 **빌드번호(+N)만** 올린다(버전 올리면 Apple 베타 심사 24~48h). 업로드는 Transporter 사용.

## 기술 스택
Flutter · Riverpod · Hive(로컬) · Firebase(Auth/Firestore/Storage/Analytics/Crashlytics) · flutter_local_notifications · google_mobile_ads · in_app_purchase · camera/video_player(인증영상)
