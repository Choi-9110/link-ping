// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'LinkPing';

  @override
  String get appSlogan => '저장한 링크, 실천하자!';

  @override
  String get login => '로그인';

  @override
  String get loginWithGoogle => 'Google로 계속하기';

  @override
  String get loginLoading => '로그인 중...';

  @override
  String get loginLater => '나중에 할게요';

  @override
  String get loginFailed => '로그인 실패';

  @override
  String get guestLoginFailed => '게스트 로그인 실패';

  @override
  String get logout => '로그아웃';

  @override
  String get logoutConfirm => '로그아웃 하시겠습니까?';

  @override
  String get guest => '게스트';

  @override
  String get guestSyncMessage => 'Google 로그인으로 데이터 동기화';

  @override
  String get profileSetup => '프로필 설정';

  @override
  String get profileSetupTitle => '프로필을 설정해주세요';

  @override
  String get profileSetupSubtitle => '다른 사용자에게 표시될 정보입니다';

  @override
  String get nickname => '닉네임';

  @override
  String get nicknameHint => '운동하는민수';

  @override
  String get nicknameRequired => '닉네임을 입력하세요';

  @override
  String get nicknameMinLength => '2자 이상 입력하세요';

  @override
  String get nicknameMaxLength => '20자 이하로 입력하세요';

  @override
  String get country => '국가';

  @override
  String get complete => '완료';

  @override
  String get profileSaveFailed => '프로필 저장 실패';

  @override
  String get home => '홈';

  @override
  String get settings => '설정';

  @override
  String get notifications => '알림';

  @override
  String get addLink => '링크 추가';

  @override
  String get editLink => '링크 수정';

  @override
  String get deleteLink => '삭제';

  @override
  String get deleteConfirm => '이 링크를 삭제할까요?';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get url => 'URL';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get urlRequired => 'URL을 입력하세요';

  @override
  String get urlInvalid => '올바른 URL을 입력하세요';

  @override
  String get title => '제목';

  @override
  String get titleHint => '매일 운동 루틴';

  @override
  String get titleRequired => '제목을 입력하세요';

  @override
  String get notificationTime => '알림 시간';

  @override
  String get repeatDays => '반복 요일';

  @override
  String get selectRepeatDays => '반복 요일을 선택하세요';

  @override
  String get sun => '일';

  @override
  String get mon => '월';

  @override
  String get tue => '화';

  @override
  String get wed => '수';

  @override
  String get thu => '목';

  @override
  String get fri => '금';

  @override
  String get sat => '토';

  @override
  String get sunday => '일요일';

  @override
  String get monday => '월요일';

  @override
  String get tuesday => '화요일';

  @override
  String get wednesday => '수요일';

  @override
  String get thursday => '목요일';

  @override
  String get friday => '금요일';

  @override
  String get saturday => '토요일';

  @override
  String get everyday => '매일';

  @override
  String get weekdays => '평일';

  @override
  String get weekends => '주말';

  @override
  String get repeat => '반복';

  @override
  String get linkUrl => '링크 URL';

  @override
  String get invalidUrl => '올바른 URL을 입력하세요';

  @override
  String get reminderTitle => '알림 제목';

  @override
  String get reminderTitleHint => '아침 스트레칭 하자!';

  @override
  String get enterTitle => '제목을 입력하세요';

  @override
  String get reminderTime => '알림 시간';

  @override
  String get addTime => '시간 추가';

  @override
  String get addTimePremium => '시간 추가 (프리미엄)';

  @override
  String get premiumFeature => '프리미엄 기능';

  @override
  String get multiTimesPremiumMessage =>
      '하나의 링크에 여러 시간을 설정하려면\n프리미엄으로 업그레이드하세요!';

  @override
  String get linkAdded => '링크가 추가되었습니다';

  @override
  String get linkUpdated => '링크가 수정되었습니다';

  @override
  String get linkDeleted => '링크가 삭제되었습니다';

  @override
  String get emptyStateTitle => '아직 링크가 없어요';

  @override
  String get emptyStateSubtitle => '자주 방문하고 싶은 링크를 추가해보세요';

  @override
  String get emptyStateButton => '첫 링크 추가하기';

  @override
  String savedByCount(int count) {
    return '$count명이 저장함';
  }

  @override
  String get savedByTitle => '이 링크를 저장한 사람들';

  @override
  String get noSavedUsers => '아직 저장한 사람이 없어요';

  @override
  String get me => '나';

  @override
  String get loadFailed => '불러오기 실패';

  @override
  String get cheer => '응원';

  @override
  String get tease => '약올리기';

  @override
  String cheerSent(String nickname) {
    return '$nickname님에게 응원을 보냈어요!';
  }

  @override
  String teaseSent(String nickname) {
    return '$nickname님에게 약올리기를 보냈어요!';
  }

  @override
  String get sendFailed => '전송 실패';

  @override
  String get cannotSendToSelf => '자기 자신에게는 보낼 수 없어요';

  @override
  String get noNotifications => '아직 알림이 없어요';

  @override
  String get noNotificationsSubtitle => '다른 유저가 응원이나 약올리기를 보내면\n여기에 표시됩니다';

  @override
  String get markAllRead => '모두 읽음';

  @override
  String get cheerReceived => '님이 응원을 보냈어요!';

  @override
  String get teaseReceived => '님이 약올렸어요!';

  @override
  String get notificationLoadFailed => '알림을 불러올 수 없습니다';

  @override
  String get justNow => '방금';

  @override
  String minutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String daysAgo(int days) {
    return '$days일 전';
  }

  @override
  String get profile => '프로필';

  @override
  String get editProfile => '프로필 수정';

  @override
  String get profileEditNotReady => '프로필 수정 (구현 예정)';

  @override
  String get notificationSettings => '알림';

  @override
  String get notificationPermission => '알림 권한';

  @override
  String get notificationTest => '알림 테스트';

  @override
  String get notificationTestSubtitle => '테스트 알림 보내기';

  @override
  String get notificationTestSent => '테스트 알림을 보냈습니다';

  @override
  String get notificationPermissionRequired => '알림 권한이 필요합니다';

  @override
  String get premium => '프리미엄';

  @override
  String get premiumActive => '프리미엄 사용 중';

  @override
  String get premiumPurchase => '프리미엄 구매';

  @override
  String get premiumBenefits => '무제한 링크, 광고 제거';

  @override
  String get premiumBenefitsList => '프리미엄 혜택:';

  @override
  String get premiumBenefit1 => '무제한 링크 등록';

  @override
  String get premiumBenefit2 => '광고 제거';

  @override
  String get premiumPrice => '월 \$2.99 / 평생 \$19.99';

  @override
  String get premiumLater => '나중에';

  @override
  String get premiumBuy => '구매하기';

  @override
  String get premiumPaymentNotReady => '결제 기능 (구현 예정)';

  @override
  String get linkLimitReached => '링크 한도 도달';

  @override
  String get linkLimitMessage =>
      '무료 버전은 3개까지 등록할 수 있어요.\n프리미엄으로 업그레이드하면 무제한으로 등록할 수 있어요!';

  @override
  String get viewPremium => '프리미엄 보기';

  @override
  String get account => '계정';

  @override
  String get info => '정보';

  @override
  String get version => '버전';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privacyPolicyNotReady => '개인정보 처리방침 (구현 예정)';

  @override
  String get contact => '문의하기';

  @override
  String get contactNotReady => '문의하기 (구현 예정)';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String get retry => '다시 시도';

  @override
  String get ok => '확인';

  @override
  String get yes => '예';

  @override
  String get no => '아니요';
}
