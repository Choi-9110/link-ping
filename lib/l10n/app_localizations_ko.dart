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
  String get nicknameHint => '닉네임을 입력하세요';

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
  String get linkUrl => '링크 또는 전화번호';

  @override
  String get linkUrlHint => 'google.com 또는 01012345678';

  @override
  String get invalidUrl => '올바른 URL 또는 전화번호를 입력하세요';

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
  String get premiumHeadline => '나의 모든 순간을, 놓치지 않게';

  @override
  String get premiumSubtitle => '소중한 사람을 제한 없이 응원하세요';

  @override
  String get premiumBenefit1 => '무제한 응원 & 약올리기';

  @override
  String get premiumBenefit1Desc => '포링 걱정 없이 친구에게 바로 응원을 보내세요';

  @override
  String get premiumBenefit2 => '링크 무제한 등록';

  @override
  String get premiumBenefit2Desc => '운동, 공부, 효도 전화... 원하는 만큼 습관을 만드세요';

  @override
  String get premiumBenefit3 => '추가 알림시간 무제한';

  @override
  String get premiumBenefit3Desc => '하나의 링크에 아침, 점심, 저녁 알림을 자유롭게';

  @override
  String get premiumBenefit4 => '포링 무제한';

  @override
  String get premiumBenefit4Desc => '광고 없이 모든 기능을 바로 사용하세요';

  @override
  String get premiumBenefit5 => '광고 없는 깔끔한 경험';

  @override
  String get premiumBenefit5Desc => '배너도, 보상형 광고도 없는 깨끗한 화면';

  @override
  String get premiumBenefit6 => '모든 프리미엄 소리 해금';

  @override
  String get premiumBenefit6Desc => '나만의 알림음으로 하루를 시작하세요';

  @override
  String get premiumPrice => '월 \$2.99 / 연 \$9.99 / 평생 \$29.99';

  @override
  String get premiumLater => '나중에';

  @override
  String get premiumBuy => '구매하기';

  @override
  String get premiumMonthly => '월간 구독';

  @override
  String get premiumYearly => '연간 구독';

  @override
  String get premiumLifetime => '평생 이용권';

  @override
  String get premiumPurchaseSuccess => '프리미엄 구매가 완료되었습니다!';

  @override
  String get premiumPurchaseFailed => '구매에 실패했습니다. 다시 시도해주세요.';

  @override
  String get premiumRestoreSuccess => '구매 내역이 복원되었습니다!';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get storeNotAvailable => '스토어에 연결할 수 없습니다';

  @override
  String get productsNotFound => '상품을 불러올 수 없습니다';

  @override
  String get retry => '다시 시도';

  @override
  String get premiumPaymentNotReady => '결제 기능 (구현 예정)';

  @override
  String get linkLimitReached => '링크 한도 도달';

  @override
  String get linkLimitMessage =>
      '무료 버전은 2개까지 등록할 수 있어요.\n친구 초대로 +1개, 프리미엄으로 무제한!';

  @override
  String get linkLimitMessageBase => '무료 버전은 2개까지 등록할 수 있어요.';

  @override
  String get inviteFriendForBonus => '친구 초대하기 (+1개)';

  @override
  String get inviteFriendBonusDesc => '친구가 가입하면 보너스 링크 획득!';

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
  String get openSourceLicenses => '오픈소스 라이선스';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String get ok => '확인';

  @override
  String get yes => '예';

  @override
  String get no => '아니요';

  @override
  String get share => '공유하기';

  @override
  String get edit => '수정하기';

  @override
  String get copyLink => '링크 복사';

  @override
  String get linkCopied => '링크가 복사되었습니다';

  @override
  String shareMessage(String time, String url) {
    return '나 이거 $time에 알림 받아서 하고 있어! 너도 같이 하자\n\n$url\n\nLinkPing에서 열기';
  }

  @override
  String get selectAction => '작업 선택';

  @override
  String get profileUpdated => '프로필이 수정되었습니다';

  @override
  String get profileUpdateFailed => '프로필 수정에 실패했습니다';

  @override
  String get accountLink => '계정 연동';

  @override
  String get accountLinked => '계정이 연동되었습니다';

  @override
  String get accountLinkFailed => '계정 연동에 실패했습니다';

  @override
  String get kakao => '카카오톡';

  @override
  String get kakaoLinkComingSoon => '카카오 연동 (준비 중)';

  @override
  String get guestLinkInfo => '계정을 연동하면 다른 기기에서도 데이터를 동기화할 수 있어요';

  @override
  String get linked => '연동됨';

  @override
  String get link => '연동';

  @override
  String get setEndDate => '종료일 설정';

  @override
  String get endDateEnabled => '종료일에 자동으로 알람이 꺼집니다';

  @override
  String get endDateDisabled => '무한 반복 (종료일 없음)';

  @override
  String get selectEndDate => '종료일 선택';

  @override
  String get selectCheerMessage => '응원 메시지 선택';

  @override
  String get selectTeaseMessage => '약올리기 메시지 선택';

  @override
  String pingRateLimited(int minutes) {
    return '$minutes분 후에 다시 보낼 수 있어요';
  }

  @override
  String get addTimeWithAd => '광고 보고 시간 추가';

  @override
  String get watchAdToAddTime =>
      '광고를 시청하면 알림 시간을 추가할 수 있어요.\n프리미엄 유저는 광고 없이 무제한 추가 가능!';

  @override
  String get watchAd => '광고 보기';

  @override
  String get adLoadFailed => '광고를 불러올 수 없습니다';

  @override
  String get timeAddedSuccess => '시간이 추가되었습니다';

  @override
  String get inviteFriends => '친구 초대';

  @override
  String get inviteFriendsMessage => '친구를 초대하면 링크 1개를 더 추가할 수 있어요!';

  @override
  String get bonusLinkEarned => '보너스 링크를 획득했어요!';

  @override
  String get referralCode => '초대 코드';

  @override
  String get copyReferralCode => '초대 코드 복사';

  @override
  String get referralCodeCopied => '초대 코드가 복사되었습니다';

  @override
  String get lockedTime => '잠긴 시간';

  @override
  String get unlockTimeWithAd => '광고 보고 잠금해제';

  @override
  String get watchAdToUnlockTime =>
      '광고를 시청하면 이 알림 시간을 활성화할 수 있어요.\n프리미엄 유저는 모든 시간이 자동으로 활성화됩니다!';

  @override
  String get timeUnlocked => '알림 시간이 활성화되었습니다';

  @override
  String get shareSettings => '공유 설정';

  @override
  String get editable => '수정 가능';

  @override
  String get recipientCanChangeTime => '받는 사람이 시간 변경 가능';

  @override
  String get timeLocked => '시간 고정';

  @override
  String get shareAtThisTime => '이 시간 그대로 공유';

  @override
  String get category => '카테고리';

  @override
  String get consentRequest => '동의 요청';

  @override
  String get consentRequestMessage => '공유받은 사람들에게 수정 동의를 요청합니다.';

  @override
  String get consentNote1 => '최대 24시간 소요될 수 있어요';

  @override
  String get consentNote2 => '동의가 완료되면 알림으로 안내해드려요';

  @override
  String get consentNote3 => '거절 시 기존 시간이 유지됩니다';

  @override
  String get requestConsent => '동의 요청하기';

  @override
  String get timeLockedAlarm => '시간 고정 알람';

  @override
  String receivedSharedAlarmInfo(String nickname) {
    return '$nickname님이 공유한 알람이에요.\n알림 시간과 반복 요일은 수정할 수 없어요.';
  }

  @override
  String get sharedToOthersInfo =>
      '공유받은 사람들도 같은 시간에 알림을 받아요.\n시간 수정 시 동의가 필요해요.';

  @override
  String get locked => '잠김';

  @override
  String get badgesAndStats => '뱃지 & 통계';

  @override
  String get badgeCollection => '뱃지 컬렉션';

  @override
  String streakDays(int days) {
    return '$days일 스트릭';
  }

  @override
  String badgesEarned(int count) {
    return '$count개 획득';
  }

  @override
  String get accountSynced => '계정 연동됨';

  @override
  String get loginToSync => '로그인하여 데이터 동기화';

  @override
  String get termsOfService => '이용약관';

  @override
  String bonusStatus(int current, int max) {
    return '보너스: $current/$max 획득';
  }

  @override
  String andMore(int count) {
    return '외 $count개';
  }

  @override
  String get pingWindowClosed => '알람이 울린 후 5분 내에만 전송할 수 있어요';

  @override
  String pingWindowActive(String time) {
    return '남은 시간: $time';
  }

  @override
  String get pingFreeRemaining => '무료 1회 전송 가능';

  @override
  String get pingWatchAdForMore => '광고 보고 더 보내기';

  @override
  String get premiumUnlimited => '무제한';

  @override
  String get watchAdToSendMore => '광고 보고 더 보내기';

  @override
  String get watchAdDescription =>
      '무료 유저는 알람 1회당 1명에게만 전송할 수 있어요.\n광고를 시청하면 추가 전송 가능! 프리미엄은 무제한!';

  @override
  String get selectProfileEmoji => '프로필 이모지 선택';

  @override
  String get profileEmoji => '프로필 이모지';

  @override
  String get changeEmoji => '이모지 변경';

  @override
  String get profileEmojiDescription => '다른 사람에게 보여지는 프로필 이모지';

  @override
  String get profileEmojiChanged => '프로필 이모지가 변경되었어요';

  @override
  String get myPhoneNumber => '내 전화번호';

  @override
  String get phoneNumberNotSet => '설정 안 됨';

  @override
  String get editNickname => '닉네임 수정';

  @override
  String get enterNickname => '닉네임을 입력하세요';

  @override
  String get pleaseEnterNickname => '닉네임을 입력해주세요';

  @override
  String get minTwoChars => '2자 이상 입력해주세요';

  @override
  String get nicknameChanged => '닉네임이 변경되었어요';

  @override
  String get checkingDuplicate => '중복 확인 중...';

  @override
  String get nicknameAlreadyInUse => '이미 사용 중인 닉네임이에요';

  @override
  String get invalidPhoneNumber => '올바른 전화번호를 입력해주세요';

  @override
  String get phoneNumberSaved => '전화번호가 저장되었어요';

  @override
  String get phoneNumberDeleted => '전화번호가 삭제되었어요';

  @override
  String get changeAccount => '계정 변경';

  @override
  String get changeAccountConfirm => '다른 구글 계정으로 변경하시겠습니까?';

  @override
  String get change => '변경';

  @override
  String cheerReceivedFrom(String name) {
    return '$name님이 응원을 보냈어요!';
  }

  @override
  String teaseReceivedFrom(String name) {
    return '$name님이 약올렸어요!';
  }

  @override
  String get inquiryReplyArrived => '문의 답변 도착';

  @override
  String get linkAlarmDeleted => '링크 알람 삭제됨';

  @override
  String get timeModificationRequest => '시간 수정 요청';

  @override
  String get modificationApproved => '수정 요청 승인됨';

  @override
  String get modificationRejected => '수정 요청 거부됨';

  @override
  String get alarmTurnedOff => '알람이 OFF되었습니다';

  @override
  String get approve => '승인';

  @override
  String get reject => '거절';

  @override
  String get approved => '승인했어요!';

  @override
  String get rejected => '거절했어요.';

  @override
  String get voteFailed => '투표에 실패했어요';

  @override
  String get tapToViewReply => '탭하여 답변 확인하기 →';

  @override
  String get noResponseWarning => '24시간 내 응답하지 않으면 알람이 OFF됩니다';

  @override
  String get inquiry => '문의';

  @override
  String get googleAccountAlreadyLinked => '이 구글 계정은 이미 다른 계정에 연동되어 있어요';

  @override
  String get providerAlreadyLinked => '이미 구글 계정이 연동되어 있어요';

  @override
  String get invalidCredential => '인증 정보가 유효하지 않아요';

  @override
  String get networkError => '네트워크 연결을 확인해주세요';

  @override
  String get noInquiries => '문의 내역이 없어요';

  @override
  String get inquiryHint => '궁금한 점이 있으면 문의해주세요!';

  @override
  String get inquirySubmitted => '문의가 등록되었습니다';

  @override
  String get inquirySubmitFailed => '문의 등록 실패';

  @override
  String get inquiryTitle => '제목';

  @override
  String get inquiryTitleHint => '문의 제목을 입력하세요';

  @override
  String get inquiryTitleRequired => '제목을 입력해주세요';

  @override
  String get inquiryContent => '내용';

  @override
  String get inquiryContentHint => '문의 내용을 자세히 작성해주세요';

  @override
  String get inquiryContentRequired => '내용을 입력해주세요';

  @override
  String get inquiryContentMinLength => '내용을 10자 이상 입력해주세요';

  @override
  String get submitInquiry => '문의 등록';

  @override
  String get inquiryResponsePromise => '문의하신 내용은 빠른 시일 내에 답변드리겠습니다.';

  @override
  String get alarmSound => '알람 소리';

  @override
  String get selectSoundCategory => '어떤 스타일의 소리를 원하세요?';

  @override
  String get pingNotificationSound => 'Ping 알림음';

  @override
  String get pingNotificationSoundDesc => '찔러보기/응원하기 알림 소리';

  @override
  String get currentSound => '현재 소리';

  @override
  String get freeSounds => '무료 소리';

  @override
  String get premiumSounds => '프리미엄 소리';

  @override
  String get premiumSoundsLocked => '프리미엄으로 업그레이드하면 모든 소리를 사용할 수 있어요';

  @override
  String get soundSelected => '소리가 선택되었어요';

  @override
  String get soundNotAvailable => '아직 소리 파일이 준비되지 않았어요';

  @override
  String get alarmSoundDescription => '알림 소리를 선택하세요';

  @override
  String get soundCategoryAlarm => '긴 알림';

  @override
  String get soundCategoryNotify => '간단한 효과음';

  @override
  String get soundCategoryAlarmDesc => '멜로디형\n(5-15초)\n놓치면 안 되는 중요한 알람용';

  @override
  String get soundCategoryNotifyDesc => '짧은 효과음\n(2-5초)\n가볍게 확인할 리마인더용';

  @override
  String get currentStreak => '연속 스트릭';

  @override
  String get achievementRate => '달성률';

  @override
  String get badgeCollected => '뱃지 수집';

  @override
  String longestStreak(int days) {
    return '최장: $days일';
  }

  @override
  String daysCount(int days) {
    return '$days일';
  }

  @override
  String get badgeEarned => '뱃지 획득!';

  @override
  String get badgeNotYetEarned => '아직 획득하지 않음';

  @override
  String badgeEarnedOn(String date) {
    return '$date 획득';
  }

  @override
  String badgeProgress(int progress, int target) {
    return '진행률: $progress/$target';
  }

  @override
  String badgeProgressPercent(int percent) {
    return '$percent% 완료';
  }

  @override
  String get badge_streak3_name => '3일 연속';

  @override
  String get badge_streak3_desc => '3일 연속 달성';

  @override
  String get badge_streak7_name => '일주일 불꽃';

  @override
  String get badge_streak7_desc => '7일 연속 달성';

  @override
  String get badge_streak30_name => '한 달의 열정';

  @override
  String get badge_streak30_desc => '30일 연속 달성';

  @override
  String get badge_streak100_name => '백일의 기적';

  @override
  String get badge_streak100_desc => '100일 연속 달성';

  @override
  String get badge_marathon_name => '마라톤';

  @override
  String get badge_marathon_desc => '365일 연속 달성!';

  @override
  String get badge_comeback_name => '컴백';

  @override
  String get badge_comeback_desc => '스트릭 끊긴 후 다시 7일 달성';

  @override
  String get badge_quickDraw_name => '퀵 드로우';

  @override
  String get badge_quickDraw_desc => '알림 5초 내 클릭';

  @override
  String get badge_speedDemon_name => '스피드 데몬';

  @override
  String get badge_speedDemon_desc => '알림 후 30초 내 오픈 10회';

  @override
  String get badge_quickResponse_name => '빠른 응답';

  @override
  String get badge_quickResponse_desc => '알림 후 3분 내 오픈 50회';

  @override
  String get badge_morningGlory_name => '모닝 글로리';

  @override
  String get badge_morningGlory_desc => '오전 5~7시 클릭 5회';

  @override
  String get badge_earlyBird_name => '얼리버드';

  @override
  String get badge_earlyBird_desc => '오전 7시 전 링크 오픈 10회';

  @override
  String get badge_nightOwl_name => '올빼미';

  @override
  String get badge_nightOwl_desc => '밤 11시 이후 링크 오픈 10회';

  @override
  String get badge_nightShift_name => '야간 근무';

  @override
  String get badge_nightShift_desc => '자정~5시 사이 클릭 5회';

  @override
  String get badge_perfectWeek_name => '완벽한 일주일';

  @override
  String get badge_perfectWeek_desc => '일주일 100% 달성';

  @override
  String get badge_perfectMonth_name => '완벽한 한 달';

  @override
  String get badge_perfectMonth_desc => '한 달 100% 달성';

  @override
  String get badge_perfectionist_name => '완벽주의자';

  @override
  String get badge_perfectionist_desc => '달성률 95% 이상 (50회 이상)';

  @override
  String get badge_firstCheer_name => '첫 응원';

  @override
  String get badge_firstCheer_desc => '첫 응원 보내기';

  @override
  String get badge_cheerLeader_name => '응원단장';

  @override
  String get badge_cheerLeader_desc => '응원 50회 보내기';

  @override
  String get badge_firstPoke_name => '첫 찌르기';

  @override
  String get badge_firstPoke_desc => '첫 찌르기 보내기';

  @override
  String get badge_poker_name => '찌르기 마스터';

  @override
  String get badge_poker_desc => '찌르기 50회 보내기';

  @override
  String get badge_socialButterfly_name => '소셜 버터플라이';

  @override
  String get badge_socialButterfly_desc => '응원/찌르기 10회 받기';

  @override
  String get badge_firstLink_name => '첫 링크';

  @override
  String get badge_firstLink_desc => '첫 링크 등록';

  @override
  String get badge_linkCollector_name => '링크 수집가';

  @override
  String get badge_linkCollector_desc => '링크 10개 등록';

  @override
  String get badge_linkMaster_name => '링크 마스터';

  @override
  String get badge_linkMaster_desc => '링크 50개 등록';

  @override
  String get badge_hotLink_name => '핫 링크';

  @override
  String get badge_hotLink_desc => '내 링크 10명 이상 저장';

  @override
  String get badge_variety_name => '다양성';

  @override
  String get badge_variety_desc => '5개 이상 다른 도메인 링크';

  @override
  String get badge_founder_name => '파운더';

  @override
  String get badge_founder_desc => '앱 초기 사용자';

  @override
  String get badge_premium_name => '프리미엄';

  @override
  String get badge_premium_desc => '프리미엄 구독';

  @override
  String get badge_badgeCollector_name => '뱃지 수집가';

  @override
  String get badge_badgeCollector_desc => '뱃지 10개 획득';

  @override
  String get badge_cloudSynced_name => '클라우드 동기화';

  @override
  String get badge_cloudSynced_desc => '계정 연동으로 데이터 동기화';

  @override
  String get premiumSoundUnlock => '프리미엄 소리';

  @override
  String get premiumSoundUnlockDesc =>
      '이 소리는 프리미엄 전용입니다.\n광고를 시청하거나 프리미엄에 가입하세요.';

  @override
  String get watchAdToUnlock => '광고 보고 사용하기';

  @override
  String get upgradeToPremium => '프리미엄 등록하기';

  @override
  String get adNotReady => '광고를 준비 중입니다. 잠시 후 다시 시도해주세요.';

  @override
  String get adWatchSuccess => '광고 시청 완료! 소리가 적용되었습니다.';

  @override
  String get earnedBadges => '획득한 배지';

  @override
  String get skip => '건너뛰기';

  @override
  String get next => '다음';

  @override
  String get getStarted => '시작하기';

  @override
  String get done => '완료';

  @override
  String get send => '보내기';

  @override
  String get close => '닫기';

  @override
  String get confirm => '확인';

  @override
  String get notSet => '미설정';

  @override
  String get inquiryDetail => '문의 상세';

  @override
  String get inquiryNotFound => '문의를 찾을 수 없습니다';

  @override
  String get reply => '답변';

  @override
  String repliedOn(String date) {
    return '답변일: $date';
  }

  @override
  String get linkPingTeam => 'LinkPing 팀';

  @override
  String get waitingForReply => '답변을 기다리고 있어요.\n답변이 등록되면 알림으로 알려드릴게요!';

  @override
  String get linkNotFound => '링크를 찾을 수 없어요';

  @override
  String get linkLoadFailed => '링크를 불러오는데 실패했어요';

  @override
  String get linkNotificationService => '링크 알림 서비스';

  @override
  String get timeEditable => '시간 수정 가능';

  @override
  String get lockedTimeDesc => '공유자가 설정한 시간 그대로 알림을 받아요';

  @override
  String get editableTimeDesc => '저장 후 원하는 시간으로 변경할 수 있어요';

  @override
  String get openInApp => '앱에서 열기';

  @override
  String get appRequiredMessage => '앱이 설치되어 있어야 해요';

  @override
  String get openLinkInBrowser => '브라우저에서 링크 열기';

  @override
  String viewCount(int count) {
    return '조회 $count회';
  }

  @override
  String get saveAndChangeTime => '저장 후 원하는 시간으로 변경하여 알림 받기';

  @override
  String get generatingShareLink => '공유 링크 생성 중...';

  @override
  String get onboarding1Title => '링크를 저장하세요';

  @override
  String get onboarding1Desc => '인스타, 유튜브, 틱톡...\n나중에 볼 링크를 저장해두세요';

  @override
  String get onboarding2Title => '딱 그 시간에 알림!';

  @override
  String get onboarding2Desc => '원하는 시간에 알림을 받고\n저장한 링크를 바로 열어요';

  @override
  String get onboarding3Title => '장거리 연애 중?';

  @override
  String get onboarding3Desc => '떨어져 있어도 같은 시간에\n넷플릭스 같이 보기';

  @override
  String get onboarding3Sub => '매일 밤 10시, 우리만의 영화 시간';

  @override
  String get onboarding4Title => '매일 성장하고 싶다면';

  @override
  String get onboarding4Desc => '아침 7시 TED 강연\n점심시간 영어 공부 유튜브';

  @override
  String get onboarding4Sub => '루틴을 만들어보세요';

  @override
  String get onboarding5Title => '친구와 함께하면';

  @override
  String get onboarding5Desc => '운동 영상 같이 따라하기\n스터디 자료 공유하기';

  @override
  String get onboarding5Sub => '함께하면 실천율 95%!';

  @override
  String get onboarding6Title => '지금 시작하세요';

  @override
  String get onboarding6Desc => '무료로 2개까지 저장 가능\n프리미엄은 무제한!';

  @override
  String get loginRequired => '로그인이 필요합니다';

  @override
  String get referralCodeQuestion => '친구에게 받은 초대 코드가 있나요?';

  @override
  String get referralCodeHelperText => '8자리 코드를 입력하세요';

  @override
  String get southKorea => '대한민국';

  @override
  String get poring => '포링';

  @override
  String get poringBalance => '포링 잔액';

  @override
  String get poringEarn => '포링 모으기';

  @override
  String get poringEarnDescription =>
      '광고를 시청하면 포링을 받을 수 있어요.\n포링으로 기능을 잠금해제하세요!';

  @override
  String poringDailyProgress(int count, int max) {
    return '오늘 $count/$max';
  }

  @override
  String get poringWatchAd => '광고 보기 (+1 포링)';

  @override
  String poringCooldown(int seconds) {
    return '다음 광고까지 $seconds초';
  }

  @override
  String get poringDailyLimitReached => '오늘 일일 한도를 다 채웠어요! 내일 다시 오세요.';

  @override
  String poringDailyLimitThanks(int max) {
    return '오늘 광고 $max개를 모두 시청해주셨어요! 감사합니다!';
  }

  @override
  String get poringEarned => '포링 +1!';

  @override
  String get poringUnlock => '포링으로 잠금해제';

  @override
  String get poringUnlockConfirm => '포링 1개를 사용하여 잠금해제할까요?';

  @override
  String get poringNotEnough => '포링이 부족합니다';

  @override
  String get poringWatchAdToEarnAndUse => '포링이 부족합니다. 광고를 보고 포링을 획득하세요';

  @override
  String get poringSpent => '포링 사용 완료!';

  @override
  String get poringPremiumInfinite => '프리미엄: 무제한';

  @override
  String referralAcceptedTitle(String nickname) {
    return '$nickname님이 초대에 응했습니다';
  }

  @override
  String get referralBonusLink => '보너스 링크 +1';

  @override
  String referralBonusPoring(int count) {
    return '포링 +$count';
  }

  @override
  String poringRewardClaimed(int count) {
    return '추천 보상 포링 +$count 수령!';
  }

  @override
  String get referralAcceptedMessage => '초대가 수락되었습니다';

  @override
  String get addTimeWithPoring => '알림 시간 추가하기';

  @override
  String get poringCostConfirm => '포링 1개가 소모됩니다';

  @override
  String get poringRequiredToSend => '메시지를 보내려면 포링 1개가 필요합니다';

  @override
  String get deleteTimeConfirm => '추가된 알림 시간을 삭제하시겠습니까?';
}
