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
  String get premiumMonthly => 'Monthly';

  @override
  String get premiumYearly => 'Yearly';

  @override
  String get premiumLifetime => 'Lifetime';

  @override
  String get premiumPurchaseSuccess => 'Premium purchase completed!';

  @override
  String get premiumPurchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get premiumRestoreSuccess => 'Purchases restored successfully!';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get storeNotAvailable => 'Store is not available';

  @override
  String get productsNotFound => 'Could not load products';

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
  String get openSourceLicenses => '开源许可证';

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
  String get selectProfileEmoji => 'Select Profile Emoji';

  @override
  String get profileEmoji => 'Profile Emoji';

  @override
  String get changeEmoji => 'Change Emoji';

  @override
  String get profileEmojiDescription => 'Profile emoji visible to others';

  @override
  String get profileEmojiChanged => 'Profile emoji changed';

  @override
  String get myPhoneNumber => 'My Phone Number';

  @override
  String get phoneNumberNotSet => 'Not set';

  @override
  String get editNickname => 'Edit Nickname';

  @override
  String get enterNickname => 'Enter nickname';

  @override
  String get pleaseEnterNickname => 'Please enter a nickname';

  @override
  String get minTwoChars => 'At least 2 characters required';

  @override
  String get nicknameChanged => 'Nickname changed';

  @override
  String get checkingDuplicate => 'Checking...';

  @override
  String get nicknameAlreadyInUse => 'Nickname already in use';

  @override
  String get invalidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get phoneNumberSaved => 'Phone number saved';

  @override
  String get phoneNumberDeleted => 'Phone number deleted';

  @override
  String get changeAccount => 'Change Account';

  @override
  String get changeAccountConfirm =>
      'Do you want to change to a different Google account?';

  @override
  String get change => 'Change';

  @override
  String cheerReceivedFrom(String name) {
    return '$name cheered you on!';
  }

  @override
  String teaseReceivedFrom(String name) {
    return '$name poked you!';
  }

  @override
  String get inquiryReplyArrived => 'Inquiry reply arrived';

  @override
  String get linkAlarmDeleted => 'Link alarm deleted';

  @override
  String get timeModificationRequest => 'Time modification request';

  @override
  String get modificationApproved => 'Modification approved';

  @override
  String get modificationRejected => 'Modification rejected';

  @override
  String get alarmTurnedOff => 'Alarm has been turned OFF';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get approved => 'Approved!';

  @override
  String get rejected => 'Rejected.';

  @override
  String get voteFailed => 'Failed to vote';

  @override
  String get tapToViewReply => 'Tap to view reply →';

  @override
  String get noResponseWarning =>
      'Alarm will be OFF if no response within 24 hours';

  @override
  String get inquiry => 'Inquiry';

  @override
  String get googleAccountAlreadyLinked =>
      'This Google account is already linked to another account';

  @override
  String get providerAlreadyLinked => 'Google account is already linked';

  @override
  String get invalidCredential => 'Invalid credentials';

  @override
  String get networkError => 'Please check your network connection';

  @override
  String get noInquiries => 'No inquiries yet';

  @override
  String get inquiryHint => 'Have a question? Send us an inquiry!';

  @override
  String get inquirySubmitted => 'Inquiry submitted';

  @override
  String get inquirySubmitFailed => 'Failed to submit inquiry';

  @override
  String get inquiryTitle => 'Title';

  @override
  String get inquiryTitleHint => 'Enter inquiry title';

  @override
  String get inquiryTitleRequired => 'Please enter a title';

  @override
  String get inquiryContent => 'Content';

  @override
  String get inquiryContentHint => 'Please describe your inquiry in detail';

  @override
  String get inquiryContentRequired => 'Please enter content';

  @override
  String get inquiryContentMinLength => 'Please enter at least 10 characters';

  @override
  String get submitInquiry => 'Submit Inquiry';

  @override
  String get inquiryResponsePromise =>
      'We will respond to your inquiry as soon as possible.';

  @override
  String get alarmSound => 'Alarm Sound';

  @override
  String get selectSoundCategory => 'What style of sound do you want?';

  @override
  String get pingNotificationSound => 'Ping Sound';

  @override
  String get pingNotificationSoundDesc =>
      'Sound for Ping and Cheer notifications';

  @override
  String get currentSound => 'Current Sound';

  @override
  String get freeSounds => 'Free Sounds';

  @override
  String get premiumSounds => 'Premium Sounds';

  @override
  String get premiumSoundsLocked => 'Upgrade to Premium to unlock all sounds';

  @override
  String get soundSelected => 'Sound selected';

  @override
  String get soundNotAvailable => 'Sound file not available yet';

  @override
  String get alarmSoundDescription => 'Choose your notification sound';

  @override
  String get soundCategoryAlarm => 'Long Alarm';

  @override
  String get soundCategoryNotify => 'Quick Effect';

  @override
  String get soundCategoryAlarmDesc =>
      'Melodic\n(5-15 sec)\nFor must-not-miss alarms';

  @override
  String get soundCategoryNotifyDesc =>
      'Short effect\n(2-5 sec)\nFor quick reminders';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get achievementRate => 'Achievement';

  @override
  String get badgeCollected => 'Badges';

  @override
  String longestStreak(int days) {
    return 'Longest: $days days';
  }

  @override
  String daysCount(int days) {
    return '$days days';
  }

  @override
  String get badgeEarned => 'NEW Badge!';

  @override
  String get badgeNotYetEarned => 'Not yet earned';

  @override
  String badgeEarnedOn(String date) {
    return 'Earned on $date';
  }

  @override
  String badgeProgress(int progress, int target) {
    return 'Progress: $progress/$target';
  }

  @override
  String badgeProgressPercent(int percent) {
    return '$percent% complete';
  }

  @override
  String get badge_streak3_name => '3-Day Streak';

  @override
  String get badge_streak3_desc => 'Achieve 3 consecutive days';

  @override
  String get badge_streak7_name => 'Week on Fire';

  @override
  String get badge_streak7_desc => 'Achieve 7 consecutive days';

  @override
  String get badge_streak30_name => 'Month of Passion';

  @override
  String get badge_streak30_desc => 'Achieve 30 consecutive days';

  @override
  String get badge_streak100_name => '100-Day Miracle';

  @override
  String get badge_streak100_desc => 'Achieve 100 consecutive days';

  @override
  String get badge_marathon_name => 'Marathon';

  @override
  String get badge_marathon_desc => 'Achieve 365 consecutive days!';

  @override
  String get badge_comeback_name => 'Comeback';

  @override
  String get badge_comeback_desc => 'Achieve 7 days after breaking streak';

  @override
  String get badge_quickDraw_name => 'Quick Draw';

  @override
  String get badge_quickDraw_desc => 'Click within 5 seconds of notification';

  @override
  String get badge_speedDemon_name => 'Speed Demon';

  @override
  String get badge_speedDemon_desc => 'Open within 30 seconds 10 times';

  @override
  String get badge_quickResponse_name => 'Quick Response';

  @override
  String get badge_quickResponse_desc => 'Open within 3 minutes 50 times';

  @override
  String get badge_morningGlory_name => 'Morning Glory';

  @override
  String get badge_morningGlory_desc => 'Click at 5-7 AM 5 times';

  @override
  String get badge_earlyBird_name => 'Early Bird';

  @override
  String get badge_earlyBird_desc => 'Open links before 7 AM 10 times';

  @override
  String get badge_nightOwl_name => 'Night Owl';

  @override
  String get badge_nightOwl_desc => 'Open links after 11 PM 10 times';

  @override
  String get badge_nightShift_name => 'Night Shift';

  @override
  String get badge_nightShift_desc => 'Click between midnight and 5 AM 5 times';

  @override
  String get badge_perfectWeek_name => 'Perfect Week';

  @override
  String get badge_perfectWeek_desc => '100% achievement for a week';

  @override
  String get badge_perfectMonth_name => 'Perfect Month';

  @override
  String get badge_perfectMonth_desc => '100% achievement for a month';

  @override
  String get badge_perfectionist_name => 'Perfectionist';

  @override
  String get badge_perfectionist_desc => '95%+ achievement rate (50+ times)';

  @override
  String get badge_firstCheer_name => 'First Cheer';

  @override
  String get badge_firstCheer_desc => 'Send your first cheer';

  @override
  String get badge_cheerLeader_name => 'Cheer Leader';

  @override
  String get badge_cheerLeader_desc => 'Send 50 cheers';

  @override
  String get badge_firstPoke_name => 'First Poke';

  @override
  String get badge_firstPoke_desc => 'Send your first poke';

  @override
  String get badge_poker_name => 'Poke Master';

  @override
  String get badge_poker_desc => 'Send 50 pokes';

  @override
  String get badge_socialButterfly_name => 'Social Butterfly';

  @override
  String get badge_socialButterfly_desc => 'Receive 10 cheers/pokes';

  @override
  String get badge_firstLink_name => 'First Link';

  @override
  String get badge_firstLink_desc => 'Register your first link';

  @override
  String get badge_linkCollector_name => 'Link Collector';

  @override
  String get badge_linkCollector_desc => 'Register 10 links';

  @override
  String get badge_linkMaster_name => 'Link Master';

  @override
  String get badge_linkMaster_desc => 'Register 50 links';

  @override
  String get badge_hotLink_name => 'Hot Link';

  @override
  String get badge_hotLink_desc => '10+ people saved your link';

  @override
  String get badge_variety_name => 'Variety';

  @override
  String get badge_variety_desc => '5+ different domain links';

  @override
  String get badge_founder_name => 'Founder';

  @override
  String get badge_founder_desc => 'Early app user';

  @override
  String get badge_premium_name => 'Premium';

  @override
  String get badge_premium_desc => 'Premium subscription';

  @override
  String get badge_badgeCollector_name => 'Badge Collector';

  @override
  String get badge_badgeCollector_desc => 'Earn 10 badges';

  @override
  String get badge_cloudSynced_name => 'Cloud Synced';

  @override
  String get badge_cloudSynced_desc => 'Sync data with account linking';

  @override
  String get premiumSoundUnlock => 'Premium Sound';

  @override
  String get premiumSoundUnlockDesc =>
      'This sound is premium only.\nWatch an ad or subscribe to premium.';

  @override
  String get watchAdToUnlock => 'Watch Ad to Use';

  @override
  String get upgradeToPremium => 'Get Premium';

  @override
  String get adNotReady => 'Ad is loading. Please try again shortly.';

  @override
  String get adWatchSuccess => 'Ad completed! Sound has been applied.';

  @override
  String get earnedBadges => 'My Badges';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get done => 'Done';

  @override
  String get send => 'Send';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get notSet => 'Not set';

  @override
  String get inquiryDetail => 'Inquiry Details';

  @override
  String get inquiryNotFound => 'Inquiry not found';

  @override
  String get reply => 'Reply';

  @override
  String repliedOn(String date) {
    return 'Replied on: $date';
  }

  @override
  String get linkPingTeam => 'LinkPing Team';

  @override
  String get waitingForReply =>
      'Waiting for reply.\nWe\'ll notify you when we respond!';

  @override
  String get linkNotFound => 'Link not found';

  @override
  String get linkLoadFailed => 'Failed to load link';

  @override
  String get linkNotificationService => 'Link Notification Service';

  @override
  String get timeEditable => 'Time can be edited';

  @override
  String get lockedTimeDesc =>
      'You\'ll receive notifications at the time set by the sharer';

  @override
  String get editableTimeDesc => 'You can change the time after saving';

  @override
  String get openInApp => 'Open in App';

  @override
  String get appRequiredMessage => 'App installation required';

  @override
  String get openLinkInBrowser => 'Open link in browser';

  @override
  String viewCount(int count) {
    return 'Views: $count';
  }

  @override
  String get saveAndChangeTime => 'Save and change to your preferred time';

  @override
  String get generatingShareLink => 'Generating share link...';

  @override
  String get onboarding1Title => 'Save your links';

  @override
  String get onboarding1Desc =>
      'Instagram, YouTube, TikTok...\nSave links to view later';

  @override
  String get onboarding2Title => 'Get notified on time!';

  @override
  String get onboarding2Desc =>
      'Receive notifications at your preferred time\nand open your saved links instantly';

  @override
  String get onboarding3Title => 'Long-distance relationship?';

  @override
  String get onboarding3Desc =>
      'Watch Netflix together\nat the same time, even apart';

  @override
  String get onboarding3Sub => 'Every night at 10 PM, our movie time';

  @override
  String get onboarding4Title => 'Want to grow daily?';

  @override
  String get onboarding4Desc => '7 AM TED talk\nLunchtime English study video';

  @override
  String get onboarding4Sub => 'Build your routine';

  @override
  String get onboarding5Title => 'Better with friends';

  @override
  String get onboarding5Desc =>
      'Follow workout videos together\nShare study materials';

  @override
  String get onboarding5Sub => '95% success rate when together!';

  @override
  String get onboarding6Title => 'Start now';

  @override
  String get onboarding6Desc =>
      'Save up to 2 links free\nPremium for unlimited!';

  @override
  String get loginRequired => 'Login required';

  @override
  String get referralCodeQuestion => 'Got a referral code from a friend?';

  @override
  String get referralCodeHelperText => 'Enter 8-character code';

  @override
  String get southKorea => 'South Korea';

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
