// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'LinkPing';

  @override
  String get appSlogan => '收藏链接，立即行动！';

  @override
  String get login => '登录';

  @override
  String get loginWithGoogle => '使用 Google 登录';

  @override
  String get loginLoading => '正在登录...';

  @override
  String get loginLater => '稍后再说';

  @override
  String get loginFailed => '登录失败';

  @override
  String get guestLoginFailed => '访客登录失败';

  @override
  String get logout => '退出登录';

  @override
  String get logoutConfirm => '确定要退出登录吗？';

  @override
  String get guest => '访客';

  @override
  String get guestSyncMessage => '使用 Google 登录以同步数据';

  @override
  String get profileSetup => '设置资料';

  @override
  String get profileSetupTitle => '设置您的个人资料';

  @override
  String get profileSetupSubtitle => '这些信息将对其他用户可见';

  @override
  String get nickname => '昵称';

  @override
  String get nicknameHint => '健身小明';

  @override
  String get nicknameRequired => '请输入昵称';

  @override
  String get nicknameMinLength => '至少2个字符';

  @override
  String get nicknameMaxLength => '最多20个字符';

  @override
  String get country => '国家';

  @override
  String get complete => '完成';

  @override
  String get profileSaveFailed => '保存资料失败';

  @override
  String get home => '首页';

  @override
  String get settings => '设置';

  @override
  String get notifications => '通知';

  @override
  String get addLink => '添加链接';

  @override
  String get editLink => '编辑链接';

  @override
  String get deleteLink => '删除';

  @override
  String get deleteConfirm => '确定删除此链接？';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get url => '网址';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get urlRequired => '请输入网址';

  @override
  String get urlInvalid => '请输入有效的网址';

  @override
  String get title => '标题';

  @override
  String get titleHint => '每日健身计划';

  @override
  String get titleRequired => '请输入标题';

  @override
  String get notificationTime => '提醒时间';

  @override
  String get repeatDays => '重复日期';

  @override
  String get selectRepeatDays => '请选择重复的日期';

  @override
  String get sun => '日';

  @override
  String get mon => '一';

  @override
  String get tue => '二';

  @override
  String get wed => '三';

  @override
  String get thu => '四';

  @override
  String get fri => '五';

  @override
  String get sat => '六';

  @override
  String get sunday => '周日';

  @override
  String get monday => '周一';

  @override
  String get tuesday => '周二';

  @override
  String get wednesday => '周三';

  @override
  String get thursday => '周四';

  @override
  String get friday => '周五';

  @override
  String get saturday => '周六';

  @override
  String get everyday => '每天';

  @override
  String get weekdays => '工作日';

  @override
  String get weekends => '周末';

  @override
  String get repeat => '重复';

  @override
  String get linkUrl => '链接或电话号码';

  @override
  String get linkUrlHint => 'google.com 或 13812345678';

  @override
  String get invalidUrl => '请输入有效的链接或电话号码';

  @override
  String get reminderTitle => '提醒标题';

  @override
  String get reminderTitleHint => '该做拉伸了！';

  @override
  String get enterTitle => '请输入标题';

  @override
  String get reminderTime => '提醒时间';

  @override
  String get addTime => '添加时间';

  @override
  String get addTimePremium => '添加时间（高级版）';

  @override
  String get premiumFeature => '高级功能';

  @override
  String get multiTimesPremiumMessage => '升级高级版可为单个链接\n设置多个提醒时间！';

  @override
  String get linkAdded => '链接已添加';

  @override
  String get linkUpdated => '链接已更新';

  @override
  String get linkDeleted => '链接已删除';

  @override
  String get emptyStateTitle => '暂无链接';

  @override
  String get emptyStateSubtitle => '添加您想定期访问的链接';

  @override
  String get emptyStateButton => '添加第一个链接';

  @override
  String savedByCount(int count) {
    return '$count人已收藏';
  }

  @override
  String get savedByTitle => '收藏此链接的用户';

  @override
  String get noSavedUsers => '暂无人收藏';

  @override
  String get me => '我';

  @override
  String get loadFailed => '加载失败';

  @override
  String get cheer => '加油';

  @override
  String get tease => '催一下';

  @override
  String cheerSent(String nickname) {
    return '已为 $nickname 加油！';
  }

  @override
  String teaseSent(String nickname) {
    return '已催促 $nickname！';
  }

  @override
  String get sendFailed => '发送失败';

  @override
  String get cannotSendToSelf => '不能发送给自己';

  @override
  String get noNotifications => '暂无通知';

  @override
  String get noNotificationsSubtitle => '当有人给您加油或催促时，\n会显示在这里';

  @override
  String get markAllRead => '全部标为已读';

  @override
  String get cheerReceived => ' 为您加油！';

  @override
  String get teaseReceived => ' 催促了您！';

  @override
  String get notificationLoadFailed => '加载通知失败';

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(int minutes) {
    return '$minutes分钟前';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours小时前';
  }

  @override
  String daysAgo(int days) {
    return '$days天前';
  }

  @override
  String get profile => '个人资料';

  @override
  String get editProfile => '编辑资料';

  @override
  String get profileEditNotReady => '编辑资料（即将推出）';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get notificationPermission => '允许通知';

  @override
  String get notificationTest => '测试通知';

  @override
  String get notificationTestSubtitle => '发送测试通知';

  @override
  String get notificationTestSent => '测试通知已发送';

  @override
  String get notificationPermissionRequired => '需要通知权限';

  @override
  String get premium => '高级版';

  @override
  String get premiumActive => '高级版使用中';

  @override
  String get premiumPurchase => '获取高级版';

  @override
  String get premiumBenefits => '无限链接，无广告';

  @override
  String get premiumHeadline => '每一个重要时刻，都不再错过';

  @override
  String get premiumSubtitle => '无限制地为重要的人加油';

  @override
  String get premiumBenefit1 => '无限加油和戳一戳';

  @override
  String get premiumBenefit1Desc => '无需Poring，直接为朋友送上鼓励';

  @override
  String get premiumBenefit2 => '无限链接';

  @override
  String get premiumBenefit2Desc => '运动、学习、打电话…随心创建习惯';

  @override
  String get premiumBenefit3 => '无限额外提醒时间';

  @override
  String get premiumBenefit3Desc => '一个链接自由设置早中晚提醒';

  @override
  String get premiumBenefit4 => '无限Poring';

  @override
  String get premiumBenefit4Desc => '无需看广告，直接使用所有功能';

  @override
  String get premiumBenefit5 => '无广告清爽体验';

  @override
  String get premiumBenefit5Desc => '没有横幅广告，没有激励广告';

  @override
  String get premiumBenefit6 => '解锁全部高级铃声';

  @override
  String get premiumBenefit6Desc => '用专属铃声开启每一天';

  @override
  String get premiumPrice => '月付 \$2.99 / 年付 \$9.99 / 永久 \$29.99';

  @override
  String get premiumLater => '稍后';

  @override
  String get premiumBuy => '立即购买';

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
  String get retry => '重试';

  @override
  String get premiumPaymentNotReady => '支付功能（即将推出）';

  @override
  String get linkLimitReached => '已达链接上限';

  @override
  String get linkLimitMessage => '免费用户最多可保存2个链接。\n邀请好友可+1，升级高级版享无限！';

  @override
  String get linkLimitMessageBase => '免费用户最多可保存2个链接。';

  @override
  String get inviteFriendForBonus => '邀请好友（+1链接）';

  @override
  String get inviteFriendBonusDesc => '好友注册后可获得额外链接！';

  @override
  String get viewPremium => '查看高级版';

  @override
  String get account => '账户';

  @override
  String get info => '关于';

  @override
  String get version => '版本';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyPolicyNotReady => '隐私政策（即将推出）';

  @override
  String get contact => '联系我们';

  @override
  String get contactNotReady => '联系我们（即将推出）';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get ok => '确定';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get share => '分享';

  @override
  String get edit => '编辑';

  @override
  String get copyLink => '复制链接';

  @override
  String get linkCopied => '链接已复制';

  @override
  String shareMessage(String time, String url) {
    return '我在 $time 有个小习惯，一起来吧！\n\n$url\n\n在 LinkPing 中打开';
  }

  @override
  String get selectAction => '选择操作';

  @override
  String get profileUpdated => '资料已更新';

  @override
  String get profileUpdateFailed => '更新资料失败';

  @override
  String get accountLink => '关联账户';

  @override
  String get accountLinked => '账户已关联';

  @override
  String get accountLinkFailed => '关联账户失败';

  @override
  String get kakao => 'KakaoTalk';

  @override
  String get kakaoLinkComingSoon => 'Kakao关联（即将推出）';

  @override
  String get guestLinkInfo => '关联账户以在多设备间同步数据';

  @override
  String get linked => '已关联';

  @override
  String get link => '关联';

  @override
  String get setEndDate => '设置结束日期';

  @override
  String get endDateEnabled => '提醒将在此日期停止';

  @override
  String get endDateDisabled => '永久重复（无结束日期）';

  @override
  String get selectEndDate => '选择结束日期';

  @override
  String get selectCheerMessage => '选择加油消息';

  @override
  String get selectTeaseMessage => '选择催促消息';

  @override
  String pingRateLimited(int minutes) {
    return '$minutes分钟后可再次发送';
  }

  @override
  String get addTimeWithAd => '看广告添加时间';

  @override
  String get watchAdToAddTime => '观看短视频广告即可添加新的提醒时间。\n高级版用户可无限添加，无需看广告！';

  @override
  String get watchAd => '观看广告';

  @override
  String get adLoadFailed => '广告加载失败';

  @override
  String get timeAddedSuccess => '时间已添加';

  @override
  String get inviteFriends => '邀请好友';

  @override
  String get inviteFriendsMessage => '邀请好友可获得额外1个链接名额！';

  @override
  String get bonusLinkEarned => '获得额外链接！';

  @override
  String get referralCode => '邀请码';

  @override
  String get copyReferralCode => '复制邀请码';

  @override
  String get referralCodeCopied => '邀请码已复制';

  @override
  String get lockedTime => '锁定的时间';

  @override
  String get unlockTimeWithAd => '看广告解锁';

  @override
  String get watchAdToUnlockTime => '观看广告即可激活此提醒时间。\n高级版用户自动激活所有时间！';

  @override
  String get timeUnlocked => '提醒时间已解锁';

  @override
  String get shareSettings => '分享设置';

  @override
  String get editable => '可编辑';

  @override
  String get recipientCanChangeTime => '接收者可更改时间';

  @override
  String get timeLocked => '时间锁定';

  @override
  String get shareAtThisTime => '以此时间分享';

  @override
  String get category => '分类';

  @override
  String get consentRequest => '请求同意';

  @override
  String get consentRequestMessage => '向接收者请求修改同意。';

  @override
  String get consentNote1 => '最多可能需要24小时';

  @override
  String get consentNote2 => '同意完成后会通知您';

  @override
  String get consentNote3 => '如被拒绝，将保持原时间';

  @override
  String get requestConsent => '请求同意';

  @override
  String get timeLockedAlarm => '时间锁定闹钟';

  @override
  String receivedSharedAlarmInfo(String nickname) {
    return '由$nickname分享的闹钟。\n无法更改提醒时间和重复日期。';
  }

  @override
  String get sharedToOthersInfo => '接收者也会在同一时间收到通知。\n更改时间需要获得同意。';

  @override
  String get locked => '已锁定';

  @override
  String get badgesAndStats => '徽章和统计';

  @override
  String get badgeCollection => '徽章收藏';

  @override
  String streakDays(int days) {
    return '连续$days天';
  }

  @override
  String badgesEarned(int count) {
    return '已获得$count个';
  }

  @override
  String get accountSynced => '账户已同步';

  @override
  String get loginToSync => '登录以同步数据';

  @override
  String get termsOfService => '服务条款';

  @override
  String bonusStatus(int current, int max) {
    return '奖励: 已获得$current/$max';
  }

  @override
  String andMore(int count) {
    return '另外$count个';
  }

  @override
  String get pingWindowClosed => '只能在闹钟响起后5分钟内发送';

  @override
  String pingWindowActive(String time) {
    return '剩余时间: $time';
  }

  @override
  String get pingFreeRemaining => '免费发送1次';

  @override
  String get pingWatchAdForMore => '看广告发送更多';

  @override
  String get premiumUnlimited => '无限';

  @override
  String get watchAdToSendMore => '看广告发送更多';

  @override
  String get watchAdDescription => '免费用户每次闹钟只能发送给1人。\n看广告可以发送更多，或升级到高级版无限发送！';

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
  String get poring => '波灵';

  @override
  String get poringBalance => '波灵余额';

  @override
  String get poringEarn => '收集波灵';

  @override
  String get poringEarnDescription => '观看广告获得波灵。\n用波灵解锁功能！';

  @override
  String poringDailyProgress(int count, int max) {
    return '今日 $count/$max';
  }

  @override
  String get poringWatchAd => '观看广告 (+1波灵)';

  @override
  String poringCooldown(int seconds) {
    return '下一个广告还需 $seconds秒';
  }

  @override
  String get poringDailyLimitReached => '已达今日上限！明天再来吧。';

  @override
  String poringDailyLimitThanks(int max) {
    return '今天已观看全部$max个广告！感谢您！';
  }

  @override
  String get poringEarned => '波灵 +1！';

  @override
  String get poringUnlock => '用波灵解锁';

  @override
  String get poringUnlockConfirm => '使用1个波灵解锁？';

  @override
  String get poringNotEnough => '波灵不足';

  @override
  String get poringWatchAdToEarnAndUse => '波灵不足。观看广告获取波灵';

  @override
  String get poringSpent => '波灵已使用！';

  @override
  String get poringPremiumInfinite => '高级版：无限';

  @override
  String referralAcceptedTitle(String nickname) {
    return '$nickname接受了你的邀请';
  }

  @override
  String get referralBonusLink => '奖励链接 +1';

  @override
  String referralBonusPoring(int count) {
    return '波灵 +$count';
  }

  @override
  String poringRewardClaimed(int count) {
    return '推荐奖励 波灵 +$count 已领取！';
  }

  @override
  String get referralAcceptedMessage => '邀请已被接受';

  @override
  String get addTimeWithPoring => '添加提醒时间';

  @override
  String get poringCostConfirm => '将消耗1个波灵';

  @override
  String get poringRequiredToSend => '发送消息需要1个波灵';

  @override
  String get deleteTimeConfirm => '删除此提醒时间？';
}
