import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'LinkPing'**
  String get appName;

  /// No description provided for @appSlogan.
  ///
  /// In en, this message translates to:
  /// **'Save links, take action!'**
  String get appSlogan;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginWithGoogle;

  /// No description provided for @loginLoading.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get loginLoading;

  /// No description provided for @loginLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get loginLater;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get loginFailed;

  /// No description provided for @guestLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Guest sign in failed'**
  String get guestLoginFailed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get logoutConfirm;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @guestSyncMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google to sync your data'**
  String get guestSyncMessage;

  /// No description provided for @profileSetup.
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profileSetup;

  /// No description provided for @profileSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your profile'**
  String get profileSetupTitle;

  /// No description provided for @profileSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This information will be visible to other users'**
  String get profileSetupSubtitle;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @nicknameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your nickname'**
  String get nicknameHint;

  /// No description provided for @nicknameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a nickname'**
  String get nicknameRequired;

  /// No description provided for @nicknameMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 2 characters required'**
  String get nicknameMinLength;

  /// No description provided for @nicknameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Maximum 20 characters allowed'**
  String get nicknameMaxLength;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get complete;

  /// No description provided for @profileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile'**
  String get profileSaveFailed;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @addLink.
  ///
  /// In en, this message translates to:
  /// **'Add Link'**
  String get addLink;

  /// No description provided for @editLink.
  ///
  /// In en, this message translates to:
  /// **'Edit Link'**
  String get editLink;

  /// No description provided for @deleteLink.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLink;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this link?'**
  String get deleteConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @urlHint.
  ///
  /// In en, this message translates to:
  /// **'https://example.com'**
  String get urlHint;

  /// No description provided for @urlRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a URL'**
  String get urlRequired;

  /// No description provided for @urlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get urlInvalid;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'Daily workout routine'**
  String get titleHint;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get titleRequired;

  /// No description provided for @notificationTime.
  ///
  /// In en, this message translates to:
  /// **'Notification Time'**
  String get notificationTime;

  /// No description provided for @repeatDays.
  ///
  /// In en, this message translates to:
  /// **'Repeat Days'**
  String get repeatDays;

  /// No description provided for @selectRepeatDays.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one day'**
  String get selectRepeatDays;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @everyday.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get everyday;

  /// No description provided for @weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get weekdays;

  /// No description provided for @weekends.
  ///
  /// In en, this message translates to:
  /// **'Weekends'**
  String get weekends;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @linkUrl.
  ///
  /// In en, this message translates to:
  /// **'Link or Phone Number'**
  String get linkUrl;

  /// No description provided for @linkUrlHint.
  ///
  /// In en, this message translates to:
  /// **'google.com or +1234567890'**
  String get linkUrlHint;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL or phone number'**
  String get invalidUrl;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Title'**
  String get reminderTitle;

  /// No description provided for @reminderTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Time to stretch!'**
  String get reminderTitleHint;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get enterTitle;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add Time'**
  String get addTime;

  /// No description provided for @addTimePremium.
  ///
  /// In en, this message translates to:
  /// **'Add Time (Premium)'**
  String get addTimePremium;

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get premiumFeature;

  /// No description provided for @multiTimesPremiumMessage.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to set multiple\nreminder times for a single link!'**
  String get multiTimesPremiumMessage;

  /// No description provided for @linkAdded.
  ///
  /// In en, this message translates to:
  /// **'Link added successfully'**
  String get linkAdded;

  /// No description provided for @linkUpdated.
  ///
  /// In en, this message translates to:
  /// **'Link updated successfully'**
  String get linkUpdated;

  /// No description provided for @linkDeleted.
  ///
  /// In en, this message translates to:
  /// **'Link deleted'**
  String get linkDeleted;

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No links yet'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add links you want to visit regularly'**
  String get emptyStateSubtitle;

  /// No description provided for @emptyStateButton.
  ///
  /// In en, this message translates to:
  /// **'Add your first link'**
  String get emptyStateButton;

  /// No description provided for @savedByCount.
  ///
  /// In en, this message translates to:
  /// **'Saved by {count}'**
  String savedByCount(int count);

  /// No description provided for @savedByTitle.
  ///
  /// In en, this message translates to:
  /// **'People who saved this link'**
  String get savedByTitle;

  /// No description provided for @noSavedUsers.
  ///
  /// In en, this message translates to:
  /// **'No one has saved this yet'**
  String get noSavedUsers;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get loadFailed;

  /// No description provided for @cheer.
  ///
  /// In en, this message translates to:
  /// **'Cheer'**
  String get cheer;

  /// No description provided for @tease.
  ///
  /// In en, this message translates to:
  /// **'Poke'**
  String get tease;

  /// No description provided for @cheerSent.
  ///
  /// In en, this message translates to:
  /// **'Cheered {nickname}!'**
  String cheerSent(String nickname);

  /// No description provided for @teaseSent.
  ///
  /// In en, this message translates to:
  /// **'Poked {nickname}!'**
  String teaseSent(String nickname);

  /// No description provided for @sendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send'**
  String get sendFailed;

  /// No description provided for @cannotSendToSelf.
  ///
  /// In en, this message translates to:
  /// **'You can\'t send to yourself'**
  String get cannotSendToSelf;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @noNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When someone sends you cheers or pokes,\nthey\'ll show up here'**
  String get noNotificationsSubtitle;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// No description provided for @cheerReceived.
  ///
  /// In en, this message translates to:
  /// **' cheered you on!'**
  String get cheerReceived;

  /// No description provided for @teaseReceived.
  ///
  /// In en, this message translates to:
  /// **' poked you!'**
  String get teaseReceived;

  /// No description provided for @notificationLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get notificationLoadFailed;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(int hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(int days);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @profileEditNotReady.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile (coming soon)'**
  String get profileEditNotReady;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettings;

  /// No description provided for @notificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow Notifications'**
  String get notificationPermission;

  /// No description provided for @notificationTest.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get notificationTest;

  /// No description provided for @notificationTestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification'**
  String get notificationTestSubtitle;

  /// No description provided for @notificationTestSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get notificationTestSent;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission required'**
  String get notificationPermissionRequired;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium Active'**
  String get premiumActive;

  /// No description provided for @premiumPurchase.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get premiumPurchase;

  /// No description provided for @premiumBenefits.
  ///
  /// In en, this message translates to:
  /// **'Unlimited links, ad-free'**
  String get premiumBenefits;

  /// No description provided for @premiumHeadline.
  ///
  /// In en, this message translates to:
  /// **'Never miss a moment that matters'**
  String get premiumHeadline;

  /// No description provided for @premiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support the people you care about, without limits'**
  String get premiumSubtitle;

  /// No description provided for @premiumBenefit1.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Cheers & Pokes'**
  String get premiumBenefit1;

  /// No description provided for @premiumBenefit1Desc.
  ///
  /// In en, this message translates to:
  /// **'Support friends instantly — no Porings needed'**
  String get premiumBenefit1Desc;

  /// No description provided for @premiumBenefit2.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Links'**
  String get premiumBenefit2;

  /// No description provided for @premiumBenefit2Desc.
  ///
  /// In en, this message translates to:
  /// **'Workouts, study, call reminders... build all the habits you want'**
  String get premiumBenefit2Desc;

  /// No description provided for @premiumBenefit3.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Alarm Times'**
  String get premiumBenefit3;

  /// No description provided for @premiumBenefit3Desc.
  ///
  /// In en, this message translates to:
  /// **'Set morning, afternoon, and evening reminders freely'**
  String get premiumBenefit3Desc;

  /// No description provided for @premiumBenefit4.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Porings'**
  String get premiumBenefit4;

  /// No description provided for @premiumBenefit4Desc.
  ///
  /// In en, this message translates to:
  /// **'Use any feature instantly, no ads required'**
  String get premiumBenefit4Desc;

  /// No description provided for @premiumBenefit5.
  ///
  /// In en, this message translates to:
  /// **'Clean, Ad-Free Experience'**
  String get premiumBenefit5;

  /// No description provided for @premiumBenefit5Desc.
  ///
  /// In en, this message translates to:
  /// **'No banners, no rewarded ads — just a clean screen'**
  String get premiumBenefit5Desc;

  /// No description provided for @premiumBenefit6.
  ///
  /// In en, this message translates to:
  /// **'All Premium Sounds'**
  String get premiumBenefit6;

  /// No description provided for @premiumBenefit6Desc.
  ///
  /// In en, this message translates to:
  /// **'Start your day with your own signature alarm sound'**
  String get premiumBenefit6Desc;

  /// No description provided for @premiumPrice.
  ///
  /// In en, this message translates to:
  /// **'\$2.99/month - \$9.99/year - \$29.99 lifetime'**
  String get premiumPrice;

  /// No description provided for @premiumLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get premiumLater;

  /// No description provided for @premiumBuy.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get premiumBuy;

  /// No description provided for @premiumMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get premiumMonthly;

  /// No description provided for @premiumYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get premiumYearly;

  /// No description provided for @premiumLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get premiumLifetime;

  /// No description provided for @premiumPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Premium purchase completed!'**
  String get premiumPurchaseSuccess;

  /// No description provided for @premiumPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get premiumPurchaseFailed;

  /// No description provided for @premiumRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored successfully!'**
  String get premiumRestoreSuccess;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @storeNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Store is not available'**
  String get storeNotAvailable;

  /// No description provided for @productsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Could not load products'**
  String get productsNotFound;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @premiumPaymentNotReady.
  ///
  /// In en, this message translates to:
  /// **'Payment (coming soon)'**
  String get premiumPaymentNotReady;

  /// No description provided for @linkLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Link limit reached'**
  String get linkLimitReached;

  /// No description provided for @linkLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'Free users can save up to 2 links.\nInvite friends for +1, or upgrade to Premium for unlimited!'**
  String get linkLimitMessage;

  /// No description provided for @linkLimitMessageBase.
  ///
  /// In en, this message translates to:
  /// **'Free users can save up to 2 links.'**
  String get linkLimitMessageBase;

  /// No description provided for @inviteFriendForBonus.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends (+1 link)'**
  String get inviteFriendForBonus;

  /// No description provided for @inviteFriendBonusDesc.
  ///
  /// In en, this message translates to:
  /// **'Get a bonus link when a friend joins!'**
  String get inviteFriendBonusDesc;

  /// No description provided for @viewPremium.
  ///
  /// In en, this message translates to:
  /// **'View Premium'**
  String get viewPremium;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get info;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyNotReady.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy (coming soon)'**
  String get privacyPolicyNotReady;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact;

  /// No description provided for @contactNotReady.
  ///
  /// In en, this message translates to:
  /// **'Contact (coming soon)'**
  String get contactNotReady;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @shareMessage.
  ///
  /// In en, this message translates to:
  /// **'Join me at {time}!\n\n{url}\n\nOpen in LinkPing'**
  String shareMessage(String time, String url);

  /// No description provided for @selectAction.
  ///
  /// In en, this message translates to:
  /// **'Choose an action'**
  String get selectAction;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileUpdateFailed;

  /// No description provided for @accountLink.
  ///
  /// In en, this message translates to:
  /// **'Link Account'**
  String get accountLink;

  /// No description provided for @accountLinked.
  ///
  /// In en, this message translates to:
  /// **'Account linked'**
  String get accountLinked;

  /// No description provided for @accountLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to link account'**
  String get accountLinkFailed;

  /// No description provided for @kakao.
  ///
  /// In en, this message translates to:
  /// **'KakaoTalk'**
  String get kakao;

  /// No description provided for @kakaoLinkComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Kakao link (coming soon)'**
  String get kakaoLinkComingSoon;

  /// No description provided for @guestLinkInfo.
  ///
  /// In en, this message translates to:
  /// **'Link your account to sync data across devices'**
  String get guestLinkInfo;

  /// No description provided for @linked.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get linked;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @setEndDate.
  ///
  /// In en, this message translates to:
  /// **'Set End Date'**
  String get setEndDate;

  /// No description provided for @endDateEnabled.
  ///
  /// In en, this message translates to:
  /// **'Reminders will stop on this date'**
  String get endDateEnabled;

  /// No description provided for @endDateDisabled.
  ///
  /// In en, this message translates to:
  /// **'Repeats forever (no end date)'**
  String get endDateDisabled;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get selectEndDate;

  /// No description provided for @selectCheerMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a cheer message'**
  String get selectCheerMessage;

  /// No description provided for @selectTeaseMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a poke message'**
  String get selectTeaseMessage;

  /// No description provided for @pingRateLimited.
  ///
  /// In en, this message translates to:
  /// **'You can send again in {minutes} minutes'**
  String pingRateLimited(int minutes);

  /// No description provided for @addTimeWithAd.
  ///
  /// In en, this message translates to:
  /// **'Watch ad to add time'**
  String get addTimeWithAd;

  /// No description provided for @watchAdToAddTime.
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad to add another reminder time.\nPremium users can add unlimited times without ads!'**
  String get watchAdToAddTime;

  /// No description provided for @watchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get watchAd;

  /// No description provided for @adLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load ad'**
  String get adLoadFailed;

  /// No description provided for @timeAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Time added successfully'**
  String get timeAddedSuccess;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// No description provided for @inviteFriendsMessage.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend and get 1 extra link slot!'**
  String get inviteFriendsMessage;

  /// No description provided for @bonusLinkEarned.
  ///
  /// In en, this message translates to:
  /// **'You earned a bonus link!'**
  String get bonusLinkEarned;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referralCode;

  /// No description provided for @copyReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Copy referral code'**
  String get copyReferralCode;

  /// No description provided for @referralCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Referral code copied'**
  String get referralCodeCopied;

  /// No description provided for @lockedTime.
  ///
  /// In en, this message translates to:
  /// **'Locked Time'**
  String get lockedTime;

  /// No description provided for @unlockTimeWithAd.
  ///
  /// In en, this message translates to:
  /// **'Watch ad to unlock'**
  String get unlockTimeWithAd;

  /// No description provided for @watchAdToUnlockTime.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to activate this reminder time.\nPremium users have all times automatically activated!'**
  String get watchAdToUnlockTime;

  /// No description provided for @timeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Reminder time unlocked'**
  String get timeUnlocked;

  /// No description provided for @shareSettings.
  ///
  /// In en, this message translates to:
  /// **'Share Settings'**
  String get shareSettings;

  /// No description provided for @editable.
  ///
  /// In en, this message translates to:
  /// **'Editable'**
  String get editable;

  /// No description provided for @recipientCanChangeTime.
  ///
  /// In en, this message translates to:
  /// **'Recipients can change time'**
  String get recipientCanChangeTime;

  /// No description provided for @timeLocked.
  ///
  /// In en, this message translates to:
  /// **'Time Locked'**
  String get timeLocked;

  /// No description provided for @shareAtThisTime.
  ///
  /// In en, this message translates to:
  /// **'Share at this exact time'**
  String get shareAtThisTime;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @consentRequest.
  ///
  /// In en, this message translates to:
  /// **'Consent Request'**
  String get consentRequest;

  /// No description provided for @consentRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'Request modification consent from recipients.'**
  String get consentRequestMessage;

  /// No description provided for @consentNote1.
  ///
  /// In en, this message translates to:
  /// **'May take up to 24 hours'**
  String get consentNote1;

  /// No description provided for @consentNote2.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be notified when consent is complete'**
  String get consentNote2;

  /// No description provided for @consentNote3.
  ///
  /// In en, this message translates to:
  /// **'Original time will be kept if declined'**
  String get consentNote3;

  /// No description provided for @requestConsent.
  ///
  /// In en, this message translates to:
  /// **'Request Consent'**
  String get requestConsent;

  /// No description provided for @timeLockedAlarm.
  ///
  /// In en, this message translates to:
  /// **'Time-locked Alarm'**
  String get timeLockedAlarm;

  /// No description provided for @receivedSharedAlarmInfo.
  ///
  /// In en, this message translates to:
  /// **'Shared by {nickname}.\nNotification time and repeat days cannot be changed.'**
  String receivedSharedAlarmInfo(String nickname);

  /// No description provided for @sharedToOthersInfo.
  ///
  /// In en, this message translates to:
  /// **'Recipients will also receive notifications at this time.\nConsent is required to change the time.'**
  String get sharedToOthersInfo;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @badgesAndStats.
  ///
  /// In en, this message translates to:
  /// **'Badges & Stats'**
  String get badgesAndStats;

  /// No description provided for @badgeCollection.
  ///
  /// In en, this message translates to:
  /// **'Badge Collection'**
  String get badgeCollection;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} day streak'**
  String streakDays(int days);

  /// No description provided for @badgesEarned.
  ///
  /// In en, this message translates to:
  /// **'{count} earned'**
  String badgesEarned(int count);

  /// No description provided for @accountSynced.
  ///
  /// In en, this message translates to:
  /// **'Account synced'**
  String get accountSynced;

  /// No description provided for @loginToSync.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your data'**
  String get loginToSync;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @bonusStatus.
  ///
  /// In en, this message translates to:
  /// **'Bonus: {current}/{max} earned'**
  String bonusStatus(int current, int max);

  /// No description provided for @andMore.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String andMore(int count);

  /// No description provided for @pingWindowClosed.
  ///
  /// In en, this message translates to:
  /// **'You can only send within 5 minutes after your alarm'**
  String get pingWindowClosed;

  /// No description provided for @pingWindowActive.
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {time}'**
  String pingWindowActive(String time);

  /// No description provided for @pingFreeRemaining.
  ///
  /// In en, this message translates to:
  /// **'1 free ping available'**
  String get pingFreeRemaining;

  /// No description provided for @pingWatchAdForMore.
  ///
  /// In en, this message translates to:
  /// **'Watch ad to send more'**
  String get pingWatchAdForMore;

  /// No description provided for @premiumUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get premiumUnlimited;

  /// No description provided for @watchAdToSendMore.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad to Send More'**
  String get watchAdToSendMore;

  /// No description provided for @watchAdDescription.
  ///
  /// In en, this message translates to:
  /// **'Free users can send 1 ping per alarm window.\nWatch an ad to send more, or upgrade to Premium for unlimited!'**
  String get watchAdDescription;

  /// No description provided for @selectProfileEmoji.
  ///
  /// In en, this message translates to:
  /// **'Select Profile Emoji'**
  String get selectProfileEmoji;

  /// No description provided for @profileEmoji.
  ///
  /// In en, this message translates to:
  /// **'Profile Emoji'**
  String get profileEmoji;

  /// No description provided for @changeEmoji.
  ///
  /// In en, this message translates to:
  /// **'Change Emoji'**
  String get changeEmoji;

  /// No description provided for @profileEmojiDescription.
  ///
  /// In en, this message translates to:
  /// **'Profile emoji visible to others'**
  String get profileEmojiDescription;

  /// No description provided for @profileEmojiChanged.
  ///
  /// In en, this message translates to:
  /// **'Profile emoji changed'**
  String get profileEmojiChanged;

  /// No description provided for @myPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'My Phone Number'**
  String get myPhoneNumber;

  /// No description provided for @phoneNumberNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get phoneNumberNotSet;

  /// No description provided for @editNickname.
  ///
  /// In en, this message translates to:
  /// **'Edit Nickname'**
  String get editNickname;

  /// No description provided for @enterNickname.
  ///
  /// In en, this message translates to:
  /// **'Enter nickname'**
  String get enterNickname;

  /// No description provided for @pleaseEnterNickname.
  ///
  /// In en, this message translates to:
  /// **'Please enter a nickname'**
  String get pleaseEnterNickname;

  /// No description provided for @minTwoChars.
  ///
  /// In en, this message translates to:
  /// **'At least 2 characters required'**
  String get minTwoChars;

  /// No description provided for @nicknameChanged.
  ///
  /// In en, this message translates to:
  /// **'Nickname changed'**
  String get nicknameChanged;

  /// No description provided for @checkingDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checkingDuplicate;

  /// No description provided for @nicknameAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Nickname already in use'**
  String get nicknameAlreadyInUse;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @phoneNumberSaved.
  ///
  /// In en, this message translates to:
  /// **'Phone number saved'**
  String get phoneNumberSaved;

  /// No description provided for @phoneNumberDeleted.
  ///
  /// In en, this message translates to:
  /// **'Phone number deleted'**
  String get phoneNumberDeleted;

  /// No description provided for @changeAccount.
  ///
  /// In en, this message translates to:
  /// **'Change Account'**
  String get changeAccount;

  /// No description provided for @changeAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change to a different Google account?'**
  String get changeAccountConfirm;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @cheerReceivedFrom.
  ///
  /// In en, this message translates to:
  /// **'{name} cheered you on!'**
  String cheerReceivedFrom(String name);

  /// No description provided for @teaseReceivedFrom.
  ///
  /// In en, this message translates to:
  /// **'{name} poked you!'**
  String teaseReceivedFrom(String name);

  /// No description provided for @inquiryReplyArrived.
  ///
  /// In en, this message translates to:
  /// **'Inquiry reply arrived'**
  String get inquiryReplyArrived;

  /// No description provided for @linkAlarmDeleted.
  ///
  /// In en, this message translates to:
  /// **'Link alarm deleted'**
  String get linkAlarmDeleted;

  /// No description provided for @timeModificationRequest.
  ///
  /// In en, this message translates to:
  /// **'Time modification request'**
  String get timeModificationRequest;

  /// No description provided for @modificationApproved.
  ///
  /// In en, this message translates to:
  /// **'Modification approved'**
  String get modificationApproved;

  /// No description provided for @modificationRejected.
  ///
  /// In en, this message translates to:
  /// **'Modification rejected'**
  String get modificationRejected;

  /// No description provided for @alarmTurnedOff.
  ///
  /// In en, this message translates to:
  /// **'Alarm has been turned OFF'**
  String get alarmTurnedOff;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved!'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected.'**
  String get rejected;

  /// No description provided for @voteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to vote'**
  String get voteFailed;

  /// No description provided for @tapToViewReply.
  ///
  /// In en, this message translates to:
  /// **'Tap to view reply →'**
  String get tapToViewReply;

  /// No description provided for @noResponseWarning.
  ///
  /// In en, this message translates to:
  /// **'Alarm will be OFF if no response within 24 hours'**
  String get noResponseWarning;

  /// No description provided for @inquiry.
  ///
  /// In en, this message translates to:
  /// **'Inquiry'**
  String get inquiry;

  /// No description provided for @googleAccountAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'This Google account is already linked to another account'**
  String get googleAccountAlreadyLinked;

  /// No description provided for @providerAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'Google account is already linked'**
  String get providerAlreadyLinked;

  /// No description provided for @invalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredential;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Please check your network connection'**
  String get networkError;

  /// No description provided for @noInquiries.
  ///
  /// In en, this message translates to:
  /// **'No inquiries yet'**
  String get noInquiries;

  /// No description provided for @inquiryHint.
  ///
  /// In en, this message translates to:
  /// **'Have a question? Send us an inquiry!'**
  String get inquiryHint;

  /// No description provided for @inquirySubmitted.
  ///
  /// In en, this message translates to:
  /// **'Inquiry submitted'**
  String get inquirySubmitted;

  /// No description provided for @inquirySubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit inquiry'**
  String get inquirySubmitFailed;

  /// No description provided for @inquiryTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get inquiryTitle;

  /// No description provided for @inquiryTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter inquiry title'**
  String get inquiryTitleHint;

  /// No description provided for @inquiryTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get inquiryTitleRequired;

  /// No description provided for @inquiryContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get inquiryContent;

  /// No description provided for @inquiryContentHint.
  ///
  /// In en, this message translates to:
  /// **'Please describe your inquiry in detail'**
  String get inquiryContentHint;

  /// No description provided for @inquiryContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter content'**
  String get inquiryContentRequired;

  /// No description provided for @inquiryContentMinLength.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least 10 characters'**
  String get inquiryContentMinLength;

  /// No description provided for @submitInquiry.
  ///
  /// In en, this message translates to:
  /// **'Submit Inquiry'**
  String get submitInquiry;

  /// No description provided for @inquiryResponsePromise.
  ///
  /// In en, this message translates to:
  /// **'We will respond to your inquiry as soon as possible.'**
  String get inquiryResponsePromise;

  /// No description provided for @alarmSound.
  ///
  /// In en, this message translates to:
  /// **'Alarm Sound'**
  String get alarmSound;

  /// No description provided for @selectSoundCategory.
  ///
  /// In en, this message translates to:
  /// **'What style of sound do you want?'**
  String get selectSoundCategory;

  /// No description provided for @pingNotificationSound.
  ///
  /// In en, this message translates to:
  /// **'Ping Sound'**
  String get pingNotificationSound;

  /// No description provided for @pingNotificationSoundDesc.
  ///
  /// In en, this message translates to:
  /// **'Sound for Ping and Cheer notifications'**
  String get pingNotificationSoundDesc;

  /// No description provided for @currentSound.
  ///
  /// In en, this message translates to:
  /// **'Current Sound'**
  String get currentSound;

  /// No description provided for @freeSounds.
  ///
  /// In en, this message translates to:
  /// **'Free Sounds'**
  String get freeSounds;

  /// No description provided for @premiumSounds.
  ///
  /// In en, this message translates to:
  /// **'Premium Sounds'**
  String get premiumSounds;

  /// No description provided for @premiumSoundsLocked.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to unlock all sounds'**
  String get premiumSoundsLocked;

  /// No description provided for @soundSelected.
  ///
  /// In en, this message translates to:
  /// **'Sound selected'**
  String get soundSelected;

  /// No description provided for @soundNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Sound file not available yet'**
  String get soundNotAvailable;

  /// No description provided for @alarmSoundDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your notification sound'**
  String get alarmSoundDescription;

  /// No description provided for @soundCategoryAlarm.
  ///
  /// In en, this message translates to:
  /// **'Long Alarm'**
  String get soundCategoryAlarm;

  /// No description provided for @soundCategoryNotify.
  ///
  /// In en, this message translates to:
  /// **'Quick Effect'**
  String get soundCategoryNotify;

  /// No description provided for @soundCategoryAlarmDesc.
  ///
  /// In en, this message translates to:
  /// **'Melodic\n(5-15 sec)\nFor must-not-miss alarms'**
  String get soundCategoryAlarmDesc;

  /// No description provided for @soundCategoryNotifyDesc.
  ///
  /// In en, this message translates to:
  /// **'Short effect\n(2-5 sec)\nFor quick reminders'**
  String get soundCategoryNotifyDesc;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @achievementRate.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get achievementRate;

  /// No description provided for @badgeCollected.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badgeCollected;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest: {days} days'**
  String longestStreak(int days);

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String daysCount(int days);

  /// No description provided for @badgeEarned.
  ///
  /// In en, this message translates to:
  /// **'NEW Badge!'**
  String get badgeEarned;

  /// No description provided for @badgeNotYetEarned.
  ///
  /// In en, this message translates to:
  /// **'Not yet earned'**
  String get badgeNotYetEarned;

  /// No description provided for @badgeEarnedOn.
  ///
  /// In en, this message translates to:
  /// **'Earned on {date}'**
  String badgeEarnedOn(String date);

  /// No description provided for @badgeProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress: {progress}/{target}'**
  String badgeProgress(int progress, int target);

  /// No description provided for @badgeProgressPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String badgeProgressPercent(int percent);

  /// No description provided for @badge_streak3_name.
  ///
  /// In en, this message translates to:
  /// **'3-Day Streak'**
  String get badge_streak3_name;

  /// No description provided for @badge_streak3_desc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 3 consecutive days'**
  String get badge_streak3_desc;

  /// No description provided for @badge_streak7_name.
  ///
  /// In en, this message translates to:
  /// **'Week on Fire'**
  String get badge_streak7_name;

  /// No description provided for @badge_streak7_desc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 7 consecutive days'**
  String get badge_streak7_desc;

  /// No description provided for @badge_streak30_name.
  ///
  /// In en, this message translates to:
  /// **'Month of Passion'**
  String get badge_streak30_name;

  /// No description provided for @badge_streak30_desc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 30 consecutive days'**
  String get badge_streak30_desc;

  /// No description provided for @badge_streak100_name.
  ///
  /// In en, this message translates to:
  /// **'100-Day Miracle'**
  String get badge_streak100_name;

  /// No description provided for @badge_streak100_desc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 100 consecutive days'**
  String get badge_streak100_desc;

  /// No description provided for @badge_marathon_name.
  ///
  /// In en, this message translates to:
  /// **'Marathon'**
  String get badge_marathon_name;

  /// No description provided for @badge_marathon_desc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 365 consecutive days!'**
  String get badge_marathon_desc;

  /// No description provided for @badge_comeback_name.
  ///
  /// In en, this message translates to:
  /// **'Comeback'**
  String get badge_comeback_name;

  /// No description provided for @badge_comeback_desc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 7 days after breaking streak'**
  String get badge_comeback_desc;

  /// No description provided for @badge_quickDraw_name.
  ///
  /// In en, this message translates to:
  /// **'Quick Draw'**
  String get badge_quickDraw_name;

  /// No description provided for @badge_quickDraw_desc.
  ///
  /// In en, this message translates to:
  /// **'Click within 5 seconds of notification'**
  String get badge_quickDraw_desc;

  /// No description provided for @badge_speedDemon_name.
  ///
  /// In en, this message translates to:
  /// **'Speed Demon'**
  String get badge_speedDemon_name;

  /// No description provided for @badge_speedDemon_desc.
  ///
  /// In en, this message translates to:
  /// **'Open within 30 seconds 10 times'**
  String get badge_speedDemon_desc;

  /// No description provided for @badge_quickResponse_name.
  ///
  /// In en, this message translates to:
  /// **'Quick Response'**
  String get badge_quickResponse_name;

  /// No description provided for @badge_quickResponse_desc.
  ///
  /// In en, this message translates to:
  /// **'Open within 3 minutes 50 times'**
  String get badge_quickResponse_desc;

  /// No description provided for @badge_morningGlory_name.
  ///
  /// In en, this message translates to:
  /// **'Morning Glory'**
  String get badge_morningGlory_name;

  /// No description provided for @badge_morningGlory_desc.
  ///
  /// In en, this message translates to:
  /// **'Click at 5-7 AM 5 times'**
  String get badge_morningGlory_desc;

  /// No description provided for @badge_earlyBird_name.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get badge_earlyBird_name;

  /// No description provided for @badge_earlyBird_desc.
  ///
  /// In en, this message translates to:
  /// **'Open links before 7 AM 10 times'**
  String get badge_earlyBird_desc;

  /// No description provided for @badge_nightOwl_name.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get badge_nightOwl_name;

  /// No description provided for @badge_nightOwl_desc.
  ///
  /// In en, this message translates to:
  /// **'Open links after 11 PM 10 times'**
  String get badge_nightOwl_desc;

  /// No description provided for @badge_nightShift_name.
  ///
  /// In en, this message translates to:
  /// **'Night Shift'**
  String get badge_nightShift_name;

  /// No description provided for @badge_nightShift_desc.
  ///
  /// In en, this message translates to:
  /// **'Click between midnight and 5 AM 5 times'**
  String get badge_nightShift_desc;

  /// No description provided for @badge_perfectWeek_name.
  ///
  /// In en, this message translates to:
  /// **'Perfect Week'**
  String get badge_perfectWeek_name;

  /// No description provided for @badge_perfectWeek_desc.
  ///
  /// In en, this message translates to:
  /// **'100% achievement for a week'**
  String get badge_perfectWeek_desc;

  /// No description provided for @badge_perfectMonth_name.
  ///
  /// In en, this message translates to:
  /// **'Perfect Month'**
  String get badge_perfectMonth_name;

  /// No description provided for @badge_perfectMonth_desc.
  ///
  /// In en, this message translates to:
  /// **'100% achievement for a month'**
  String get badge_perfectMonth_desc;

  /// No description provided for @badge_perfectionist_name.
  ///
  /// In en, this message translates to:
  /// **'Perfectionist'**
  String get badge_perfectionist_name;

  /// No description provided for @badge_perfectionist_desc.
  ///
  /// In en, this message translates to:
  /// **'95%+ achievement rate (50+ times)'**
  String get badge_perfectionist_desc;

  /// No description provided for @badge_firstCheer_name.
  ///
  /// In en, this message translates to:
  /// **'First Cheer'**
  String get badge_firstCheer_name;

  /// No description provided for @badge_firstCheer_desc.
  ///
  /// In en, this message translates to:
  /// **'Send your first cheer'**
  String get badge_firstCheer_desc;

  /// No description provided for @badge_cheerLeader_name.
  ///
  /// In en, this message translates to:
  /// **'Cheer Leader'**
  String get badge_cheerLeader_name;

  /// No description provided for @badge_cheerLeader_desc.
  ///
  /// In en, this message translates to:
  /// **'Send 50 cheers'**
  String get badge_cheerLeader_desc;

  /// No description provided for @badge_firstPoke_name.
  ///
  /// In en, this message translates to:
  /// **'First Poke'**
  String get badge_firstPoke_name;

  /// No description provided for @badge_firstPoke_desc.
  ///
  /// In en, this message translates to:
  /// **'Send your first poke'**
  String get badge_firstPoke_desc;

  /// No description provided for @badge_poker_name.
  ///
  /// In en, this message translates to:
  /// **'Poke Master'**
  String get badge_poker_name;

  /// No description provided for @badge_poker_desc.
  ///
  /// In en, this message translates to:
  /// **'Send 50 pokes'**
  String get badge_poker_desc;

  /// No description provided for @badge_socialButterfly_name.
  ///
  /// In en, this message translates to:
  /// **'Social Butterfly'**
  String get badge_socialButterfly_name;

  /// No description provided for @badge_socialButterfly_desc.
  ///
  /// In en, this message translates to:
  /// **'Receive 10 cheers/pokes'**
  String get badge_socialButterfly_desc;

  /// No description provided for @badge_firstLink_name.
  ///
  /// In en, this message translates to:
  /// **'First Link'**
  String get badge_firstLink_name;

  /// No description provided for @badge_firstLink_desc.
  ///
  /// In en, this message translates to:
  /// **'Register your first link'**
  String get badge_firstLink_desc;

  /// No description provided for @badge_linkCollector_name.
  ///
  /// In en, this message translates to:
  /// **'Link Collector'**
  String get badge_linkCollector_name;

  /// No description provided for @badge_linkCollector_desc.
  ///
  /// In en, this message translates to:
  /// **'Register 10 links'**
  String get badge_linkCollector_desc;

  /// No description provided for @badge_linkMaster_name.
  ///
  /// In en, this message translates to:
  /// **'Link Master'**
  String get badge_linkMaster_name;

  /// No description provided for @badge_linkMaster_desc.
  ///
  /// In en, this message translates to:
  /// **'Register 50 links'**
  String get badge_linkMaster_desc;

  /// No description provided for @badge_hotLink_name.
  ///
  /// In en, this message translates to:
  /// **'Hot Link'**
  String get badge_hotLink_name;

  /// No description provided for @badge_hotLink_desc.
  ///
  /// In en, this message translates to:
  /// **'10+ people saved your link'**
  String get badge_hotLink_desc;

  /// No description provided for @badge_variety_name.
  ///
  /// In en, this message translates to:
  /// **'Variety'**
  String get badge_variety_name;

  /// No description provided for @badge_variety_desc.
  ///
  /// In en, this message translates to:
  /// **'5+ different domain links'**
  String get badge_variety_desc;

  /// No description provided for @badge_founder_name.
  ///
  /// In en, this message translates to:
  /// **'Founder'**
  String get badge_founder_name;

  /// No description provided for @badge_founder_desc.
  ///
  /// In en, this message translates to:
  /// **'Early app user'**
  String get badge_founder_desc;

  /// No description provided for @badge_premium_name.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get badge_premium_name;

  /// No description provided for @badge_premium_desc.
  ///
  /// In en, this message translates to:
  /// **'Premium subscription'**
  String get badge_premium_desc;

  /// No description provided for @badge_badgeCollector_name.
  ///
  /// In en, this message translates to:
  /// **'Badge Collector'**
  String get badge_badgeCollector_name;

  /// No description provided for @badge_badgeCollector_desc.
  ///
  /// In en, this message translates to:
  /// **'Earn 10 badges'**
  String get badge_badgeCollector_desc;

  /// No description provided for @badge_cloudSynced_name.
  ///
  /// In en, this message translates to:
  /// **'Cloud Synced'**
  String get badge_cloudSynced_name;

  /// No description provided for @badge_cloudSynced_desc.
  ///
  /// In en, this message translates to:
  /// **'Sync data with account linking'**
  String get badge_cloudSynced_desc;

  /// No description provided for @premiumSoundUnlock.
  ///
  /// In en, this message translates to:
  /// **'Premium Sound'**
  String get premiumSoundUnlock;

  /// No description provided for @premiumSoundUnlockDesc.
  ///
  /// In en, this message translates to:
  /// **'This sound is premium only.\nWatch an ad or subscribe to premium.'**
  String get premiumSoundUnlockDesc;

  /// No description provided for @watchAdToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad to Use'**
  String get watchAdToUnlock;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get upgradeToPremium;

  /// No description provided for @adNotReady.
  ///
  /// In en, this message translates to:
  /// **'Ad is loading. Please try again shortly.'**
  String get adNotReady;

  /// No description provided for @adWatchSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ad completed! Sound has been applied.'**
  String get adWatchSuccess;

  /// No description provided for @earnedBadges.
  ///
  /// In en, this message translates to:
  /// **'My Badges'**
  String get earnedBadges;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @inquiryDetail.
  ///
  /// In en, this message translates to:
  /// **'Inquiry Details'**
  String get inquiryDetail;

  /// No description provided for @inquiryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Inquiry not found'**
  String get inquiryNotFound;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @repliedOn.
  ///
  /// In en, this message translates to:
  /// **'Replied on: {date}'**
  String repliedOn(String date);

  /// No description provided for @linkPingTeam.
  ///
  /// In en, this message translates to:
  /// **'LinkPing Team'**
  String get linkPingTeam;

  /// No description provided for @waitingForReply.
  ///
  /// In en, this message translates to:
  /// **'Waiting for reply.\nWe\'ll notify you when we respond!'**
  String get waitingForReply;

  /// No description provided for @linkNotFound.
  ///
  /// In en, this message translates to:
  /// **'Link not found'**
  String get linkNotFound;

  /// No description provided for @linkLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load link'**
  String get linkLoadFailed;

  /// No description provided for @linkNotificationService.
  ///
  /// In en, this message translates to:
  /// **'Link Notification Service'**
  String get linkNotificationService;

  /// No description provided for @timeEditable.
  ///
  /// In en, this message translates to:
  /// **'Time can be edited'**
  String get timeEditable;

  /// No description provided for @lockedTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'ll receive notifications at the time set by the sharer'**
  String get lockedTimeDesc;

  /// No description provided for @editableTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'You can change the time after saving'**
  String get editableTimeDesc;

  /// No description provided for @openInApp.
  ///
  /// In en, this message translates to:
  /// **'Open in App'**
  String get openInApp;

  /// No description provided for @appRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'App installation required'**
  String get appRequiredMessage;

  /// No description provided for @openLinkInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open link in browser'**
  String get openLinkInBrowser;

  /// No description provided for @viewCount.
  ///
  /// In en, this message translates to:
  /// **'Views: {count}'**
  String viewCount(int count);

  /// No description provided for @saveAndChangeTime.
  ///
  /// In en, this message translates to:
  /// **'Save and change to your preferred time'**
  String get saveAndChangeTime;

  /// No description provided for @generatingShareLink.
  ///
  /// In en, this message translates to:
  /// **'Generating share link...'**
  String get generatingShareLink;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Save your links'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Instagram, YouTube, TikTok...\nSave links to view later'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Get notified on time!'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications at your preferred time\nand open your saved links instantly'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Long-distance relationship?'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Watch Netflix together\nat the same time, even apart'**
  String get onboarding3Desc;

  /// No description provided for @onboarding3Sub.
  ///
  /// In en, this message translates to:
  /// **'Every night at 10 PM, our movie time'**
  String get onboarding3Sub;

  /// No description provided for @onboarding4Title.
  ///
  /// In en, this message translates to:
  /// **'Want to grow daily?'**
  String get onboarding4Title;

  /// No description provided for @onboarding4Desc.
  ///
  /// In en, this message translates to:
  /// **'7 AM TED talk\nLunchtime English study video'**
  String get onboarding4Desc;

  /// No description provided for @onboarding4Sub.
  ///
  /// In en, this message translates to:
  /// **'Build your routine'**
  String get onboarding4Sub;

  /// No description provided for @onboarding5Title.
  ///
  /// In en, this message translates to:
  /// **'Better with friends'**
  String get onboarding5Title;

  /// No description provided for @onboarding5Desc.
  ///
  /// In en, this message translates to:
  /// **'Follow workout videos together\nShare study materials'**
  String get onboarding5Desc;

  /// No description provided for @onboarding5Sub.
  ///
  /// In en, this message translates to:
  /// **'95% success rate when together!'**
  String get onboarding5Sub;

  /// No description provided for @onboarding6Title.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get onboarding6Title;

  /// No description provided for @onboarding6Desc.
  ///
  /// In en, this message translates to:
  /// **'Save up to 2 links free\nPremium for unlimited!'**
  String get onboarding6Desc;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login required'**
  String get loginRequired;

  /// No description provided for @referralCodeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Got a referral code from a friend?'**
  String get referralCodeQuestion;

  /// No description provided for @referralCodeHelperText.
  ///
  /// In en, this message translates to:
  /// **'Enter 8-character code'**
  String get referralCodeHelperText;

  /// No description provided for @southKorea.
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get southKorea;

  /// No description provided for @poring.
  ///
  /// In en, this message translates to:
  /// **'Poring'**
  String get poring;

  /// No description provided for @poringBalance.
  ///
  /// In en, this message translates to:
  /// **'Poring Balance'**
  String get poringBalance;

  /// No description provided for @poringEarn.
  ///
  /// In en, this message translates to:
  /// **'Earn Poring'**
  String get poringEarn;

  /// No description provided for @poringEarnDescription.
  ///
  /// In en, this message translates to:
  /// **'Watch ads to earn Porings.\nUse Porings to unlock features!'**
  String get poringEarnDescription;

  /// No description provided for @poringDailyProgress.
  ///
  /// In en, this message translates to:
  /// **'{count}/{max} today'**
  String poringDailyProgress(int count, int max);

  /// No description provided for @poringWatchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad (+1 Poring)'**
  String get poringWatchAd;

  /// No description provided for @poringCooldown.
  ///
  /// In en, this message translates to:
  /// **'Next ad in {seconds}s'**
  String poringCooldown(int seconds);

  /// No description provided for @poringDailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily limit reached! Come back tomorrow.'**
  String get poringDailyLimitReached;

  /// No description provided for @poringDailyLimitThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for watching all {max} ads today!'**
  String poringDailyLimitThanks(int max);

  /// No description provided for @poringEarned.
  ///
  /// In en, this message translates to:
  /// **'Poring +1!'**
  String get poringEarned;

  /// No description provided for @poringUnlock.
  ///
  /// In en, this message translates to:
  /// **'Use Poring to unlock'**
  String get poringUnlock;

  /// No description provided for @poringUnlockConfirm.
  ///
  /// In en, this message translates to:
  /// **'Use 1 Poring to unlock?'**
  String get poringUnlockConfirm;

  /// No description provided for @poringNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Not enough Porings'**
  String get poringNotEnough;

  /// No description provided for @poringWatchAdToEarnAndUse.
  ///
  /// In en, this message translates to:
  /// **'Not enough Porings. Watch an ad to earn Porings'**
  String get poringWatchAdToEarnAndUse;

  /// No description provided for @poringSpent.
  ///
  /// In en, this message translates to:
  /// **'Poring used!'**
  String get poringSpent;

  /// No description provided for @poringPremiumInfinite.
  ///
  /// In en, this message translates to:
  /// **'Premium: Unlimited'**
  String get poringPremiumInfinite;

  /// No description provided for @referralAcceptedTitle.
  ///
  /// In en, this message translates to:
  /// **'{nickname} accepted your invite'**
  String referralAcceptedTitle(String nickname);

  /// No description provided for @referralBonusLink.
  ///
  /// In en, this message translates to:
  /// **'Bonus link +1'**
  String get referralBonusLink;

  /// No description provided for @referralBonusPoring.
  ///
  /// In en, this message translates to:
  /// **'Poring +{count}'**
  String referralBonusPoring(int count);

  /// No description provided for @poringRewardClaimed.
  ///
  /// In en, this message translates to:
  /// **'Referral reward: Poring +{count} claimed!'**
  String poringRewardClaimed(int count);

  /// No description provided for @referralAcceptedMessage.
  ///
  /// In en, this message translates to:
  /// **'Invitation accepted'**
  String get referralAcceptedMessage;

  /// No description provided for @addTimeWithPoring.
  ///
  /// In en, this message translates to:
  /// **'Add alarm time'**
  String get addTimeWithPoring;

  /// No description provided for @poringCostConfirm.
  ///
  /// In en, this message translates to:
  /// **'1 Poring will be used'**
  String get poringCostConfirm;

  /// No description provided for @poringRequiredToSend.
  ///
  /// In en, this message translates to:
  /// **'1 Poring is required to send a message'**
  String get poringRequiredToSend;

  /// No description provided for @deleteTimeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this alarm time?'**
  String get deleteTimeConfirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
