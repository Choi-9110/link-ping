// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Linkku';

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
  String get premiumBenefit1Desc => '无需Ping，直接为朋友送上鼓励';

  @override
  String get premiumBenefit2 => '无限链接';

  @override
  String get premiumBenefit2Desc => '运动、学习、打电话…随心创建习惯';

  @override
  String get premiumBenefit3 => '无限额外提醒时间';

  @override
  String get premiumBenefit3Desc => '一个链接自由设置早中晚提醒';

  @override
  String get premiumBenefit4 => '无限Ping';

  @override
  String get premiumBenefit4Desc => '无需看广告，直接使用所有功能';

  @override
  String get premiumBenefit5 => '无广告清爽体验';

  @override
  String get premiumBenefit5Desc => '没有横幅广告，没有激励广告';

  @override
  String get premiumBenefit6 => '云端备份与同步';

  @override
  String get premiumBenefit6Desc => '换手机也能自动恢复你保存的链接';

  @override
  String get premiumPrice => '月付 \$2.99 / 年付 \$9.99 / 永久 \$29.99';

  @override
  String get premiumLater => '稍后';

  @override
  String get premiumBuy => '立即购买';

  @override
  String get premiumMonthly => '按月订阅';

  @override
  String get premiumYearly => '按年订阅';

  @override
  String get premiumLifetime => '终身会员';

  @override
  String get premiumPurchaseSuccess => '高级版购买完成啦！';

  @override
  String get premiumPurchaseFailed => '购买失败，请再试一次。';

  @override
  String get premiumRestoreSuccess => '购买记录已成功恢复！';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get storeNotAvailable => '无法连接到商店';

  @override
  String get productsNotFound => '无法加载商品';

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
    return '我在 $time 有个小习惯，一起来吧！\n\n$url\n\n在 Linkku 中打开';
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
  String get badgesAndStats => '成就和统计';

  @override
  String get badgeCollection => '成就收藏';

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
  String get selectProfileEmoji => '选择头像表情';

  @override
  String get profileEmoji => '头像表情';

  @override
  String get changeEmoji => '更换表情';

  @override
  String get profileEmojiDescription => '向他人展示的头像表情';

  @override
  String get profileEmojiChanged => '头像表情已更换';

  @override
  String get myPhoneNumber => '我的手机号';

  @override
  String get phoneNumberNotSet => '未设置';

  @override
  String get editNickname => '修改昵称';

  @override
  String get enterNickname => '请输入昵称';

  @override
  String get pleaseEnterNickname => '请输入昵称';

  @override
  String get minTwoChars => '至少需要 2 个字符';

  @override
  String get nicknameChanged => '昵称已修改';

  @override
  String get checkingDuplicate => '检查中…';

  @override
  String get nicknameAlreadyInUse => '这个昵称已经被用啦';

  @override
  String get invalidPhoneNumber => '请输入正确的手机号';

  @override
  String get phoneNumberSaved => '手机号已保存';

  @override
  String get phoneNumberDeleted => '手机号已删除';

  @override
  String get changeAccount => '更换账号';

  @override
  String get changeAccountConfirm => '要切换到其他 Google 账号吗？';

  @override
  String get change => '更换';

  @override
  String cheerReceivedFrom(String name) {
    return '$name 给你加油啦！';
  }

  @override
  String teaseReceivedFrom(String name) {
    return '$name 戳了戳你！';
  }

  @override
  String get inquiryReplyArrived => '咨询回复来啦';

  @override
  String get linkAlarmDeleted => '链接提醒已删除';

  @override
  String get timeModificationRequest => '时间修改请求';

  @override
  String get modificationApproved => '修改请求已通过';

  @override
  String get modificationRejected => '修改请求已拒绝';

  @override
  String get alarmTurnedOff => '提醒已关闭';

  @override
  String get approve => '通过';

  @override
  String get reject => '拒绝';

  @override
  String get approved => '已通过！';

  @override
  String get rejected => '已拒绝。';

  @override
  String get voteFailed => '投票失败了';

  @override
  String get tapToViewReply => '点击查看回复 →';

  @override
  String get noResponseWarning => '若 24 小时内未回应，提醒将自动关闭';

  @override
  String get inquiry => '咨询';

  @override
  String get googleAccountAlreadyLinked => '这个 Google 账号已经绑定到其他账号啦';

  @override
  String get providerAlreadyLinked => '已经绑定过 Google 账号啦';

  @override
  String get invalidCredential => '认证信息无效';

  @override
  String get networkError => '请检查网络连接';

  @override
  String get noInquiries => '还没有咨询记录';

  @override
  String get inquiryHint => '有问题吗？快来咨询我们吧！';

  @override
  String get inquirySubmitted => '咨询已提交';

  @override
  String get inquirySubmitFailed => '咨询提交失败';

  @override
  String get inquiryTitle => '标题';

  @override
  String get inquiryTitleHint => '请输入咨询标题';

  @override
  String get inquiryTitleRequired => '请输入标题';

  @override
  String get inquiryContent => '内容';

  @override
  String get inquiryContentHint => '请详细描述你的问题';

  @override
  String get inquiryContentRequired => '请输入内容';

  @override
  String get inquiryContentMinLength => '请至少输入 10 个字符';

  @override
  String get submitInquiry => '提交咨询';

  @override
  String get inquiryResponsePromise => '我们会尽快回复你的咨询。';

  @override
  String get alarmSound => '提醒铃声';

  @override
  String get selectSoundCategory => '你想要什么风格的声音呢？';

  @override
  String get pingNotificationSound => '戳一戳提示音';

  @override
  String get pingNotificationSoundDesc => '戳一戳和加油通知的提示音';

  @override
  String get currentSound => '当前铃声';

  @override
  String get freeSounds => '免费铃声';

  @override
  String get premiumSounds => '高级铃声';

  @override
  String get premiumSoundsLocked => '升级到高级版即可解锁全部铃声';

  @override
  String get soundSelected => '铃声已选好';

  @override
  String get soundNotAvailable => '铃声文件还没准备好哦';

  @override
  String get alarmSoundDescription => '选择你的通知铃声';

  @override
  String get soundCategoryAlarm => '长提醒';

  @override
  String get soundCategoryNotify => '快捷音效';

  @override
  String get soundCategoryAlarmDesc => '旋律型\n（5-15 秒）\n适合不能错过的重要提醒';

  @override
  String get soundCategoryNotifyDesc => '短音效\n（2-5 秒）\n适合轻松查看的提醒';

  @override
  String get currentStreak => '当前连续天数';

  @override
  String get achievementRate => '成就';

  @override
  String get badgeCollected => '成就';

  @override
  String longestStreak(int days) {
    return '最长：$days 天';
  }

  @override
  String daysCount(int days) {
    return '$days 天';
  }

  @override
  String get badgeEarned => '解锁新成就！';

  @override
  String get badgeNotYetEarned => '尚未获得';

  @override
  String badgeEarnedOn(String date) {
    return '$date 获得';
  }

  @override
  String badgeProgress(int progress, int target) {
    return '进度：$progress/$target';
  }

  @override
  String badgeProgressPercent(int percent) {
    return '已完成 $percent%';
  }

  @override
  String get badge_streak3_name => '连续 3 天';

  @override
  String get badge_streak3_desc => '连续达成 3 天';

  @override
  String get badge_streak7_name => '燃烧一周';

  @override
  String get badge_streak7_desc => '连续达成 7 天';

  @override
  String get badge_streak30_name => '热情一月';

  @override
  String get badge_streak30_desc => '连续达成 30 天';

  @override
  String get badge_streak100_name => '百日奇迹';

  @override
  String get badge_streak100_desc => '连续达成 100 天';

  @override
  String get badge_marathon_name => '马拉松';

  @override
  String get badge_marathon_desc => '连续达成 365 天！';

  @override
  String get badge_comeback_name => '强势回归';

  @override
  String get badge_comeback_desc => '中断后重新达成 7 天';

  @override
  String get badge_quickDraw_name => '快枪手';

  @override
  String get badge_quickDraw_desc => '通知后 5 秒内点击';

  @override
  String get badge_speedDemon_name => '极速达人';

  @override
  String get badge_speedDemon_desc => '通知后 30 秒内打开 10 次';

  @override
  String get badge_quickResponse_name => '快速响应';

  @override
  String get badge_quickResponse_desc => '通知后 3 分钟内打开 50 次';

  @override
  String get badge_morningGlory_name => '晨曦荣耀';

  @override
  String get badge_morningGlory_desc => '凌晨 5-7 点点击 5 次';

  @override
  String get badge_earlyBird_name => '早起鸟儿';

  @override
  String get badge_earlyBird_desc => '早上 7 点前打开链接 10 次';

  @override
  String get badge_nightOwl_name => '夜猫子';

  @override
  String get badge_nightOwl_desc => '晚上 11 点后打开链接 10 次';

  @override
  String get badge_nightShift_name => '夜班达人';

  @override
  String get badge_nightShift_desc => '午夜至凌晨 5 点之间点击 5 次';

  @override
  String get badge_perfectWeek_name => '完美一周';

  @override
  String get badge_perfectWeek_desc => '一周内 100% 达成';

  @override
  String get badge_perfectMonth_name => '完美一月';

  @override
  String get badge_perfectMonth_desc => '一个月内 100% 达成';

  @override
  String get badge_perfectionist_name => '完美主义者';

  @override
  String get badge_perfectionist_desc => '达成率 95% 以上（50 次以上）';

  @override
  String get badge_firstCheer_name => '初次加油';

  @override
  String get badge_firstCheer_desc => '发送你的第一次加油';

  @override
  String get badge_cheerLeader_name => '加油队长';

  @override
  String get badge_cheerLeader_desc => '发送 50 次加油';

  @override
  String get badge_firstPoke_name => '初次戳戳';

  @override
  String get badge_firstPoke_desc => '发送你的第一次戳一戳';

  @override
  String get badge_poker_name => '戳戳大师';

  @override
  String get badge_poker_desc => '发送 50 次戳一戳';

  @override
  String get badge_socialButterfly_name => '社交达人';

  @override
  String get badge_socialButterfly_desc => '收到 10 次加油/戳一戳';

  @override
  String get badge_firstLink_name => '第一个链接';

  @override
  String get badge_firstLink_desc => '注册你的第一个链接';

  @override
  String get badge_linkCollector_name => '链接收藏家';

  @override
  String get badge_linkCollector_desc => '注册 10 个链接';

  @override
  String get badge_linkMaster_name => '链接大师';

  @override
  String get badge_linkMaster_desc => '注册 50 个链接';

  @override
  String get badge_hotLink_name => '热门链接';

  @override
  String get badge_hotLink_desc => '10 人以上保存了你的链接';

  @override
  String get badge_variety_name => '多样达人';

  @override
  String get badge_variety_desc => '5 个以上不同域名的链接';

  @override
  String get badge_founder_name => '创始成员';

  @override
  String get badge_founder_desc => '应用的早期用户';

  @override
  String get badge_premium_name => '高级会员';

  @override
  String get badge_premium_desc => '高级版订阅';

  @override
  String get badge_badgeCollector_name => '成就收藏家';

  @override
  String get badge_badgeCollector_desc => '获得 10 个成就';

  @override
  String get badge_cloudSynced_name => '云端同步';

  @override
  String get badge_cloudSynced_desc => '通过账号绑定同步数据';

  @override
  String get premiumSoundUnlock => '高级铃声';

  @override
  String get premiumSoundUnlockDesc => '这是高级版专属铃声。\n观看广告或订阅高级版即可使用。';

  @override
  String get watchAdToUnlock => '看广告解锁使用';

  @override
  String get upgradeToPremium => '开通高级版';

  @override
  String get adNotReady => '广告加载中，请稍后再试。';

  @override
  String get adWatchSuccess => '广告观看完成！铃声已应用。';

  @override
  String get earnedBadges => '我的成就';

  @override
  String get skip => '跳过';

  @override
  String get next => '下一步';

  @override
  String get getStarted => '开始使用';

  @override
  String get done => '完成';

  @override
  String get send => '发送';

  @override
  String get close => '关闭';

  @override
  String get confirm => '确认';

  @override
  String get notSet => '未设置';

  @override
  String get inquiryDetail => '咨询详情';

  @override
  String get inquiryNotFound => '找不到该咨询';

  @override
  String get reply => '回复';

  @override
  String repliedOn(String date) {
    return '回复日期：$date';
  }

  @override
  String get linkPingTeam => 'Linkku 团队';

  @override
  String get waitingForReply => '正在等待回复哦。\n回复来了我们会通知你！';

  @override
  String get linkNotFound => '找不到该链接';

  @override
  String get linkLoadFailed => '链接加载失败';

  @override
  String get linkNotificationService => '链接通知服务';

  @override
  String get timeEditable => '时间可修改';

  @override
  String get lockedTimeDesc => '你将在分享者设定的时间收到通知';

  @override
  String get editableTimeDesc => '保存后可以更改时间';

  @override
  String get openInApp => '在应用中打开';

  @override
  String get appRequiredMessage => '需要先安装应用';

  @override
  String get openLinkInBrowser => '在浏览器中打开链接';

  @override
  String viewCount(int count) {
    return '浏览 $count 次';
  }

  @override
  String get saveAndChangeTime => '保存后改成你喜欢的时间来接收提醒';

  @override
  String get generatingShareLink => '正在生成分享链接…';

  @override
  String get onboarding1Title => '保存你的链接';

  @override
  String get onboarding1Desc => 'Instagram、YouTube、TikTok…\n保存稍后想看的链接';

  @override
  String get onboarding2Title => '准时收到提醒！';

  @override
  String get onboarding2Desc => '在你想要的时间收到通知\n立刻打开已保存的链接';

  @override
  String get onboarding3Title => '正在异地恋？';

  @override
  String get onboarding3Desc => '即使相隔两地\n也能在同一时间一起看 Netflix';

  @override
  String get onboarding3Sub => '每晚 10 点，属于我们的电影时间';

  @override
  String get onboarding4Title => '想每天进步吗？';

  @override
  String get onboarding4Desc => '早上 7 点 TED 演讲\n午休时间英语学习视频';

  @override
  String get onboarding4Sub => '打造你的日常习惯';

  @override
  String get onboarding5Title => '和朋友一起更带劲';

  @override
  String get onboarding5Desc => '一起跟练运动视频\n共享学习资料';

  @override
  String get onboarding5Sub => '一起做，实践率高达 95%！';

  @override
  String get onboarding6Title => '现在就开始';

  @override
  String get onboarding6Desc => '免费可保存 2 个链接\n高级版无限保存！';

  @override
  String get loginRequired => '需要先登录';

  @override
  String get referralCodeQuestion => '有朋友给你的邀请码吗？';

  @override
  String get referralCodeHelperText => '请输入 8 位邀请码';

  @override
  String get southKorea => '韩国';

  @override
  String get poring => 'Ping';

  @override
  String get poringBalance => 'Ping余额';

  @override
  String get poringEarn => '收集Ping';

  @override
  String get poringEarnDescription => '观看广告获得Ping。\n用Ping解锁功能！';

  @override
  String poringDailyProgress(int count, int max) {
    return '今日 $count/$max';
  }

  @override
  String get poringWatchAd => '观看广告 (+1Ping)';

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
  String get poringEarned => 'Ping +1！';

  @override
  String get poringUnlock => '用Ping解锁';

  @override
  String get poringUnlockConfirm => '使用1个Ping解锁？';

  @override
  String get poringNotEnough => 'Ping不足';

  @override
  String get poringWatchAdToEarnAndUse => 'Ping不足。观看广告获取Ping';

  @override
  String get poringSpent => 'Ping已使用！';

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
    return 'Ping +$count';
  }

  @override
  String poringRewardClaimed(int count) {
    return '推荐奖励 Ping +$count 已领取！';
  }

  @override
  String get referralAcceptedMessage => '邀请已被接受';

  @override
  String get addTimeWithPoring => '添加提醒时间';

  @override
  String get poringCostConfirm => '将消耗1个Ping';

  @override
  String get poringRequiredToSend => '发送消息需要1个Ping';

  @override
  String get deleteTimeConfirm => '删除此提醒时间？';

  @override
  String get linkkuDexTitle => 'Linkku图鉴';

  @override
  String get linkkuDexCollect => '收集你的 Linkku';

  @override
  String get linkkuDexComingHint => '新朋友会一个一个到来。';

  @override
  String get linkkuDexDefault => '默认';

  @override
  String get linkkuDexComingSoon => '敬请期待';

  @override
  String get linkkuDexSubtitle => '带铃铛的闹钟史莱姆';

  @override
  String get linkkuPersonality => '性格';

  @override
  String get linkkuTraitCaring => '贴心';

  @override
  String get linkkuTraitAttentive => '细心';

  @override
  String get linkkuPersonalityDesc =>
      '绝不会忘记你时间的贴心朋友。\n很快每只 Linkku 都会有自己的性格，连说话方式都不一样哦。';

  @override
  String get linkkuWhatsNext => '接下来';

  @override
  String get linkkuWhatsNextDesc => '养成、装扮、收集新朋友的功能会逐步到来。🥚';

  @override
  String get phoneSignIn => '用手机号登录';

  @override
  String get phoneEnterCode => '请输入验证码';

  @override
  String get phoneEnterNumber => '请输入手机号';

  @override
  String get phoneNumberLabel => '手机号';

  @override
  String get phoneSendCode => '获取验证码';

  @override
  String get phoneConfirm => '确认';

  @override
  String get phoneChangeNumber => '重新输入号码';

  @override
  String get phoneCodeSent => '验证码已发送';

  @override
  String get phoneSendFailed => '验证码发送失败';

  @override
  String get phoneVerifyFailed => '验证失败';

  @override
  String get phoneGenericError => '出错了';

  @override
  String get deleteAccount => '注销账号';

  @override
  String get deleteAccountConfirm => '确定要注销吗？账号、链接、统计和认证视频将被永久删除，无法恢复。';

  @override
  String get deleteAccountReauth => '为了安全，请重新登录后再试。';

  @override
  String get deleteAccountFailed => '注销失败，请稍后再试。';

  @override
  String get ringModeTitle => '要怎么连接？';

  @override
  String get ringModeAllName => '全员链';

  @override
  String get ringModeAllDesc => '和拥有链接的所有人一起';

  @override
  String get ringModeChainName => '接力链';

  @override
  String get ringModeChainDesc => '和你分享过的人一起';

  @override
  String get ringModeFixedNote => '选定后此闹钟将一直使用该方式';

  @override
  String get ringModeHelpTooltip => '详细说明';

  @override
  String get ringModeHelpTitle => '有什么区别？';

  @override
  String get ringModeHelpBody =>
      '🔗 全员链\nA创建后分享给B，B再传给C\n→ A、B、C全员同组。\n所有人都能看到并为彼此的3秒打卡加油。\n\n🤝 接力链\n按 A → B → C → D 传递时\n→ C只能看到B（分享给我的人）和D（我分享的人），看不到A。\n我的3秒打卡也只对直接往来的人可见。\n\n💡 区别在于打卡视频对谁可见。\n家人密友安静地用 = 接力链，\n社团学习小组一起用 = 全员链！';

  @override
  String get ringModeHelpOk => '明白了！';

  @override
  String get ringBannerAll => '🔗 全员链 — 打卡对所有持链接者可见';

  @override
  String get ringBannerChain => '🤝 接力链 — 打卡只对我分享的人可见';

  @override
  String get shareAlreadySaved => '该闹钟已保存';

  @override
  String get shareNotFound => '找不到分享链接';

  @override
  String get shareDuplicateAlarm => '已有相同的闹钟';

  @override
  String shareRepeatWeekly(int count) {
    return '每周$count次';
  }

  @override
  String get shareArrivedTitle => '收到共享闹钟 💌';

  @override
  String shareArrivedWith(String nickname) {
    return '和$nickname在同一时间收到提醒';
  }

  @override
  String get shareLater => '稍后';

  @override
  String get shareAddToMyAlarms => '添加到我的闹钟';

  @override
  String get shareKeptInInbox => '📥 已存入通知页的“收到的分享”';

  @override
  String get shareAddedTogether => '闹钟已添加！同一时间一起加油 🔔';

  @override
  String get shareAddFailed => '添加失败';

  @override
  String get slotFullTitle => '闹钟栏位已满';

  @override
  String get slotFullAdBody => '免费闹钟栏位已全部用完。\n观看广告即可添加这个共享闹钟！\n\n（高级版无广告无限制 ✨）';

  @override
  String get slotFullLater => '下次吧';

  @override
  String get slotFullWatchAd => '看广告并添加';

  @override
  String get adNotCompleted => '广告未看完';

  @override
  String inboxSectionTitle(int count) {
    return '📥 收到的分享（$count）';
  }

  @override
  String inboxFrom(String nickname, String time) {
    return '来自$nickname · ⏰ $time';
  }

  @override
  String get inboxDecline => '拒绝';

  @override
  String get inboxAdd => '添加';

  @override
  String pingCheerToast(String nickname) {
    return '📣 $nickname为你加油了！';
  }

  @override
  String pingPokeToast(String nickname) {
    return '👉 $nickname戳了你一下！';
  }

  @override
  String get pingReferralToast => '🎁 朋友用你的邀请码注册了！';

  @override
  String get pingInquiryToast => '💬 你的咨询收到了回复';

  @override
  String get pingGenericToast => '🔔 收到新通知';

  @override
  String get proofGalleryTitle => '打卡相册';

  @override
  String get proofLoadFailed => '加载失败，下拉刷新';

  @override
  String get proofNoSharedAlarms => '还没有共同的约定';

  @override
  String get proofNoSharedAlarmsHint => '把链接分享给朋友\n就能在这里集中查看彼此的3秒打卡 💪';

  @override
  String proofLatest(String time) {
    return '最近 $time';
  }

  @override
  String get proofNoneYet => '暂无打卡';

  @override
  String get proofRecordMine => '我也打卡';

  @override
  String proofVerifyWindowClosed(int minutes) {
    return '只能在闹钟响起后$minutes分钟内打卡';
  }

  @override
  String get proofMineBadge => '我的';

  @override
  String timeAgoMinutes(int count) {
    return '$count分钟前';
  }

  @override
  String timeAgoHours(int count) {
    return '$count小时前';
  }

  @override
  String timeAgoDays(int count) {
    return '$count天前';
  }

  @override
  String get guestPurchaseTitle => '需要绑定账号';

  @override
  String get guestPurchaseBody =>
      '为了安全保存购买记录，\n请先绑定Google或Apple账号。\n\n绑定后现有闹钟和记录都会保留！';

  @override
  String get guestPurchaseLink => '去绑定';

  @override
  String get lockedSlotTitle => '已锁定的闹钟栏位';

  @override
  String get lockedSlotSubtitle => '邀请好友+1 · 高级版无限制';

  @override
  String get dayChipLabels => '一,二,三,四,五,六,日';

  @override
  String get cameraNotFound => '找不到相机';

  @override
  String cameraInitFailed(String error) {
    return '相机初始化失败: $error';
  }

  @override
  String recordStartFailed(String error) {
    return '开始录制失败: $error';
  }

  @override
  String recordStopFailed(String error) {
    return '停止录制失败: $error';
  }

  @override
  String proofDeleteFailed(String error) {
    return '删除失败: $error';
  }

  @override
  String get shareRepeatDaily => '每天';
}
