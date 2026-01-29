// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LinkPing';

  @override
  String get appSlogan => 'Save links, take action!';

  @override
  String get login => 'Login';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get loginLoading => 'Logging in...';

  @override
  String get loginLater => 'Maybe later';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get guestLoginFailed => 'Guest login failed';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get guest => 'Guest';

  @override
  String get guestSyncMessage => 'Sign in with Google to sync data';

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
  String get nicknameHint => 'FitnessMike';

  @override
  String get nicknameRequired => 'Please enter a nickname';

  @override
  String get nicknameMinLength => 'At least 2 characters required';

  @override
  String get nicknameMaxLength => 'Maximum 20 characters';

  @override
  String get country => 'Country';

  @override
  String get complete => 'Complete';

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
  String get selectRepeatDays => 'Please select repeat days';

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
  String get everyday => 'Everyday';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get weekends => 'Weekends';

  @override
  String get repeat => 'Repeat';

  @override
  String get linkUrl => 'Link URL';

  @override
  String get invalidUrl => 'Please enter a valid URL';

  @override
  String get reminderTitle => 'Reminder Title';

  @override
  String get reminderTitleHint => 'Let\'s stretch!';

  @override
  String get enterTitle => 'Please enter a title';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get addTime => 'Add time';

  @override
  String get addTimePremium => 'Add time (Premium)';

  @override
  String get premiumFeature => 'Premium Feature';

  @override
  String get multiTimesPremiumMessage =>
      'Upgrade to Premium to set multiple\ntimes for a single link!';

  @override
  String get linkAdded => 'Link added';

  @override
  String get linkUpdated => 'Link updated';

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
  String get tease => 'Tease';

  @override
  String cheerSent(String nickname) {
    return 'Sent cheer to $nickname!';
  }

  @override
  String teaseSent(String nickname) {
    return 'Sent tease to $nickname!';
  }

  @override
  String get sendFailed => 'Failed to send';

  @override
  String get cannotSendToSelf => 'Cannot send to yourself';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get noNotificationsSubtitle =>
      'When others send you cheers or teases,\nthey will appear here';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get cheerReceived => ' sent you a cheer!';

  @override
  String get teaseReceived => ' teased you!';

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
  String get profileEditNotReady => 'Edit profile (coming soon)';

  @override
  String get notificationSettings => 'Notifications';

  @override
  String get notificationPermission => 'Notification Permission';

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
  String get premiumBenefits => 'Unlimited links, no ads';

  @override
  String get premiumBenefitsList => 'Premium benefits:';

  @override
  String get premiumBenefit1 => 'Unlimited links';

  @override
  String get premiumBenefit2 => 'No ads';

  @override
  String get premiumPrice => '\$2.99/month or \$19.99 lifetime';

  @override
  String get premiumLater => 'Later';

  @override
  String get premiumBuy => 'Purchase';

  @override
  String get premiumPaymentNotReady => 'Payment (coming soon)';

  @override
  String get linkLimitReached => 'Link limit reached';

  @override
  String get linkLimitMessage =>
      'Free version allows up to 3 links.\nUpgrade to Premium for unlimited links!';

  @override
  String get viewPremium => 'View Premium';

  @override
  String get account => 'Account';

  @override
  String get info => 'Info';

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
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

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
    return 'I\'m doing this at $time! Join me\n\n$url\n\nOpen in LinkPing';
  }

  @override
  String get selectAction => 'Select action';

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
  String get endDateEnabled => 'Alarm will turn off on end date';

  @override
  String get endDateDisabled => 'Repeats forever (no end date)';

  @override
  String get selectEndDate => 'Select end date';

  @override
  String get selectCheerMessage => 'Select cheer message';

  @override
  String get selectTeaseMessage => 'Select tease message';

  @override
  String pingRateLimited(int minutes) {
    return 'You can send again in $minutes minutes';
  }
}
