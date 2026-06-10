// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Linkku';

  @override
  String get appSlogan => 'Save links, take action!';

  @override
  String get login => 'Sign In';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get loginLoading => 'Signing in...';

  @override
  String get loginLater => 'Maybe later';

  @override
  String get loginFailed => 'Sign in failed';

  @override
  String get guestLoginFailed => 'Guest sign in failed';

  @override
  String get logout => 'Sign Out';

  @override
  String get logoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get guest => 'Guest';

  @override
  String get guestSyncMessage => 'Sign in with Google to sync your data';

  @override
  String get profileSetup => 'Profile Setup';

  @override
  String get profileSetupTitle => 'Set up your profile';

  @override
  String get profileSetupSubtitle =>
      'This information will be visible to other users';

  @override
  String get nickname => 'Nickname';

  @override
  String get nicknameHint => 'Enter your nickname';

  @override
  String get nicknameRequired => 'Please enter a nickname';

  @override
  String get nicknameMinLength => 'At least 2 characters required';

  @override
  String get nicknameMaxLength => 'Maximum 20 characters allowed';

  @override
  String get country => 'Country';

  @override
  String get complete => 'Done';

  @override
  String get profileSaveFailed => 'Failed to save profile';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get addLink => 'Add Link';

  @override
  String get editLink => 'Edit Link';

  @override
  String get deleteLink => 'Delete';

  @override
  String get deleteConfirm => 'Delete this link?';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get url => 'URL';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get urlRequired => 'Please enter a URL';

  @override
  String get urlInvalid => 'Please enter a valid URL';

  @override
  String get title => 'Title';

  @override
  String get titleHint => 'Daily workout routine';

  @override
  String get titleRequired => 'Please enter a title';

  @override
  String get notificationTime => 'Notification Time';

  @override
  String get repeatDays => 'Repeat Days';

  @override
  String get selectRepeatDays => 'Please select at least one day';

  @override
  String get sun => 'Sun';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sunday => 'Sunday';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get everyday => 'Daily';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get weekends => 'Weekends';

  @override
  String get repeat => 'Repeat';

  @override
  String get linkUrl => 'Link or Phone Number';

  @override
  String get linkUrlHint => 'google.com or +1234567890';

  @override
  String get invalidUrl => 'Please enter a valid URL or phone number';

  @override
  String get reminderTitle => 'Reminder Title';

  @override
  String get reminderTitleHint => 'Time to stretch!';

  @override
  String get enterTitle => 'Please enter a title';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get addTime => 'Add Time';

  @override
  String get addTimePremium => 'Add Time (Premium)';

  @override
  String get premiumFeature => 'Premium Feature';

  @override
  String get multiTimesPremiumMessage =>
      'Upgrade to Premium to set multiple\nreminder times for a single link!';

  @override
  String get linkAdded => 'Link added successfully';

  @override
  String get linkUpdated => 'Link updated successfully';

  @override
  String get linkDeleted => 'Link deleted';

  @override
  String get emptyStateTitle => 'No links yet';

  @override
  String get emptyStateSubtitle => 'Add links you want to visit regularly';

  @override
  String get emptyStateButton => 'Add your first link';

  @override
  String savedByCount(int count) {
    return 'Saved by $count';
  }

  @override
  String get savedByTitle => 'People who saved this link';

  @override
  String get noSavedUsers => 'No one has saved this yet';

  @override
  String get me => 'Me';

  @override
  String get loadFailed => 'Failed to load';

  @override
  String get cheer => 'Cheer';

  @override
  String get tease => 'Poke';

  @override
  String cheerSent(String nickname) {
    return 'Cheered $nickname!';
  }

  @override
  String teaseSent(String nickname) {
    return 'Poked $nickname!';
  }

  @override
  String get sendFailed => 'Failed to send';

  @override
  String get cannotSendToSelf => 'You can\'t send to yourself';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get noNotificationsSubtitle =>
      'When someone sends you cheers or pokes,\nthey\'ll show up here';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get cheerReceived => ' cheered you on!';

  @override
  String get teaseReceived => ' poked you!';

  @override
  String get notificationLoadFailed => 'Failed to load notifications';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profileEditNotReady => 'Edit Profile (coming soon)';

  @override
  String get notificationSettings => 'Notifications';

  @override
  String get notificationPermission => 'Allow Notifications';

  @override
  String get notificationTest => 'Test Notification';

  @override
  String get notificationTestSubtitle => 'Send a test notification';

  @override
  String get notificationTestSent => 'Test notification sent';

  @override
  String get notificationPermissionRequired =>
      'Notification permission required';

  @override
  String get premium => 'Premium';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get premiumPurchase => 'Get Premium';

  @override
  String get premiumBenefits => 'Unlimited links, ad-free';

  @override
  String get premiumHeadline => 'Never miss a moment that matters';

  @override
  String get premiumSubtitle =>
      'Support the people you care about, without limits';

  @override
  String get premiumBenefit1 => 'Unlimited Cheers & Pokes';

  @override
  String get premiumBenefit1Desc =>
      'Support friends instantly — no Porings needed';

  @override
  String get premiumBenefit2 => 'Unlimited Links';

  @override
  String get premiumBenefit2Desc =>
      'Workouts, study, call reminders... build all the habits you want';

  @override
  String get premiumBenefit3 => 'Unlimited Alarm Times';

  @override
  String get premiumBenefit3Desc =>
      'Set morning, afternoon, and evening reminders freely';

  @override
  String get premiumBenefit4 => 'Unlimited Porings';

  @override
  String get premiumBenefit4Desc =>
      'Use any feature instantly, no ads required';

  @override
  String get premiumBenefit5 => 'Clean, Ad-Free Experience';

  @override
  String get premiumBenefit5Desc =>
      'No banners, no rewarded ads — just a clean screen';

  @override
  String get premiumBenefit6 => 'All Premium Sounds';

  @override
  String get premiumBenefit6Desc =>
      'Start your day with your own signature alarm sound';

  @override
  String get premiumPrice => '\$2.99/month - \$9.99/year - \$29.99 lifetime';

  @override
  String get premiumLater => 'Later';

  @override
  String get premiumBuy => 'Purchase';

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
  String get retry => 'Retry';

  @override
  String get premiumPaymentNotReady => 'Payment (coming soon)';

  @override
  String get linkLimitReached => 'Link limit reached';

  @override
  String get linkLimitMessage =>
      'Free users can save up to 2 links.\nInvite friends for +1, or upgrade to Premium for unlimited!';

  @override
  String get linkLimitMessageBase => 'Free users can save up to 2 links.';

  @override
  String get inviteFriendForBonus => 'Invite Friends (+1 link)';

  @override
  String get inviteFriendBonusDesc => 'Get a bonus link when a friend joins!';

  @override
  String get viewPremium => 'View Premium';

  @override
  String get account => 'Account';

  @override
  String get info => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyNotReady => 'Privacy Policy (coming soon)';

  @override
  String get contact => 'Contact Us';

  @override
  String get contactNotReady => 'Contact (coming soon)';

  @override
  String get openSourceLicenses => 'Open Source Licenses';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get share => 'Share';

  @override
  String get edit => 'Edit';

  @override
  String get copyLink => 'Copy link';

  @override
  String get linkCopied => 'Link copied';

  @override
  String shareMessage(String time, String url) {
    return 'Join me at $time!\n\n$url\n\nOpen in Linkku';
  }

  @override
  String get selectAction => 'Choose an action';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get profileUpdateFailed => 'Failed to update profile';

  @override
  String get accountLink => 'Link Account';

  @override
  String get accountLinked => 'Account linked';

  @override
  String get accountLinkFailed => 'Failed to link account';

  @override
  String get kakao => 'KakaoTalk';

  @override
  String get kakaoLinkComingSoon => 'Kakao link (coming soon)';

  @override
  String get guestLinkInfo => 'Link your account to sync data across devices';

  @override
  String get linked => 'Linked';

  @override
  String get link => 'Link';

  @override
  String get setEndDate => 'Set End Date';

  @override
  String get endDateEnabled => 'Reminders will stop on this date';

  @override
  String get endDateDisabled => 'Repeats forever (no end date)';

  @override
  String get selectEndDate => 'Select end date';

  @override
  String get selectCheerMessage => 'Choose a cheer message';

  @override
  String get selectTeaseMessage => 'Choose a poke message';

  @override
  String pingRateLimited(int minutes) {
    return 'You can send again in $minutes minutes';
  }

  @override
  String get addTimeWithAd => 'Watch ad to add time';

  @override
  String get watchAdToAddTime =>
      'Watch a short ad to add another reminder time.\nPremium users can add unlimited times without ads!';

  @override
  String get watchAd => 'Watch Ad';

  @override
  String get adLoadFailed => 'Failed to load ad';

  @override
  String get timeAddedSuccess => 'Time added successfully';

  @override
  String get inviteFriends => 'Invite Friends';

  @override
  String get inviteFriendsMessage =>
      'Invite a friend and get 1 extra link slot!';

  @override
  String get bonusLinkEarned => 'You earned a bonus link!';

  @override
  String get referralCode => 'Referral Code';

  @override
  String get copyReferralCode => 'Copy referral code';

  @override
  String get referralCodeCopied => 'Referral code copied';

  @override
  String get lockedTime => 'Locked Time';

  @override
  String get unlockTimeWithAd => 'Watch ad to unlock';

  @override
  String get watchAdToUnlockTime =>
      'Watch an ad to activate this reminder time.\nPremium users have all times automatically activated!';

  @override
  String get timeUnlocked => 'Reminder time unlocked';

  @override
  String get shareSettings => 'Share Settings';

  @override
  String get editable => 'Editable';

  @override
  String get recipientCanChangeTime => 'Recipients can change time';

  @override
  String get timeLocked => 'Time Locked';

  @override
  String get shareAtThisTime => 'Share at this exact time';

  @override
  String get category => 'Category';

  @override
  String get consentRequest => 'Consent Request';

  @override
  String get consentRequestMessage =>
      'Request modification consent from recipients.';

  @override
  String get consentNote1 => 'May take up to 24 hours';

  @override
  String get consentNote2 => 'You\'ll be notified when consent is complete';

  @override
  String get consentNote3 => 'Original time will be kept if declined';

  @override
  String get requestConsent => 'Request Consent';

  @override
  String get timeLockedAlarm => 'Time-locked Alarm';

  @override
  String receivedSharedAlarmInfo(String nickname) {
    return 'Shared by $nickname.\nNotification time and repeat days cannot be changed.';
  }

  @override
  String get sharedToOthersInfo =>
      'Recipients will also receive notifications at this time.\nConsent is required to change the time.';

  @override
  String get locked => 'Locked';

  @override
  String get badgesAndStats => 'Badges & Stats';

  @override
  String get badgeCollection => 'Badge Collection';

  @override
  String streakDays(int days) {
    return '$days day streak';
  }

  @override
  String badgesEarned(int count) {
    return '$count earned';
  }

  @override
  String get accountSynced => 'Account synced';

  @override
  String get loginToSync => 'Sign in to sync your data';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String bonusStatus(int current, int max) {
    return 'Bonus: $current/$max earned';
  }

  @override
  String andMore(int count) {
    return '+$count more';
  }

  @override
  String get pingWindowClosed =>
      'You can only send within 5 minutes after your alarm';

  @override
  String pingWindowActive(String time) {
    return 'Time remaining: $time';
  }

  @override
  String get pingFreeRemaining => '1 free ping available';

  @override
  String get pingWatchAdForMore => 'Watch ad to send more';

  @override
  String get premiumUnlimited => 'Unlimited';

  @override
  String get watchAdToSendMore => 'Watch Ad to Send More';

  @override
  String get watchAdDescription =>
      'Free users can send 1 ping per alarm window.\nWatch an ad to send more, or upgrade to Premium for unlimited!';

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
  String get linkPingTeam => 'Linkku Team';

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
  String get poring => 'Poring';

  @override
  String get poringBalance => 'Poring Balance';

  @override
  String get poringEarn => 'Earn Poring';

  @override
  String get poringEarnDescription =>
      'Watch ads to earn Porings.\nUse Porings to unlock features!';

  @override
  String poringDailyProgress(int count, int max) {
    return '$count/$max today';
  }

  @override
  String get poringWatchAd => 'Watch Ad (+1 Poring)';

  @override
  String poringCooldown(int seconds) {
    return 'Next ad in ${seconds}s';
  }

  @override
  String get poringDailyLimitReached =>
      'Daily limit reached! Come back tomorrow.';

  @override
  String poringDailyLimitThanks(int max) {
    return 'Thanks for watching all $max ads today!';
  }

  @override
  String get poringEarned => 'Poring +1!';

  @override
  String get poringUnlock => 'Use Poring to unlock';

  @override
  String get poringUnlockConfirm => 'Use 1 Poring to unlock?';

  @override
  String get poringNotEnough => 'Not enough Porings';

  @override
  String get poringWatchAdToEarnAndUse =>
      'Not enough Porings. Watch an ad to earn Porings';

  @override
  String get poringSpent => 'Poring used!';

  @override
  String get poringPremiumInfinite => 'Premium: Unlimited';

  @override
  String referralAcceptedTitle(String nickname) {
    return '$nickname accepted your invite';
  }

  @override
  String get referralBonusLink => 'Bonus link +1';

  @override
  String referralBonusPoring(int count) {
    return 'Poring +$count';
  }

  @override
  String poringRewardClaimed(int count) {
    return 'Referral reward: Poring +$count claimed!';
  }

  @override
  String get referralAcceptedMessage => 'Invitation accepted';

  @override
  String get addTimeWithPoring => 'Add alarm time';

  @override
  String get poringCostConfirm => '1 Poring will be used';

  @override
  String get poringRequiredToSend => '1 Poring is required to send a message';

  @override
  String get deleteTimeConfirm => 'Delete this alarm time?';
}
