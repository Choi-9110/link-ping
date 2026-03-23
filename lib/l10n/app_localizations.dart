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
  /// In ko, this message translates to:
  /// **'LinkPing'**
  String get appName;

  /// No description provided for @appSlogan.
  ///
  /// In ko, this message translates to:
  /// **'저장한 링크, 실천하자!'**
  String get appSlogan;

  /// No description provided for @login.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get login;

  /// No description provided for @loginWithGoogle.
  ///
  /// In ko, this message translates to:
  /// **'Google로 계속하기'**
  String get loginWithGoogle;

  /// No description provided for @loginLoading.
  ///
  /// In ko, this message translates to:
  /// **'로그인 중...'**
  String get loginLoading;

  /// No description provided for @loginLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에 할게요'**
  String get loginLater;

  /// No description provided for @loginFailed.
  ///
  /// In ko, this message translates to:
  /// **'로그인 실패'**
  String get loginFailed;

  /// No description provided for @guestLoginFailed.
  ///
  /// In ko, this message translates to:
  /// **'게스트 로그인 실패'**
  String get guestLoginFailed;

  /// No description provided for @logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃 하시겠습니까?'**
  String get logoutConfirm;

  /// No description provided for @guest.
  ///
  /// In ko, this message translates to:
  /// **'게스트'**
  String get guest;

  /// No description provided for @guestSyncMessage.
  ///
  /// In ko, this message translates to:
  /// **'Google 로그인으로 데이터 동기화'**
  String get guestSyncMessage;

  /// No description provided for @profileSetup.
  ///
  /// In ko, this message translates to:
  /// **'프로필 설정'**
  String get profileSetup;

  /// No description provided for @profileSetupTitle.
  ///
  /// In ko, this message translates to:
  /// **'프로필을 설정해주세요'**
  String get profileSetupTitle;

  /// No description provided for @profileSetupSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'다른 사용자에게 표시될 정보입니다'**
  String get profileSetupSubtitle;

  /// No description provided for @nickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임'**
  String get nickname;

  /// No description provided for @nicknameHint.
  ///
  /// In ko, this message translates to:
  /// **'닉네임을 입력하세요'**
  String get nicknameHint;

  /// No description provided for @nicknameRequired.
  ///
  /// In ko, this message translates to:
  /// **'닉네임을 입력하세요'**
  String get nicknameRequired;

  /// No description provided for @nicknameMinLength.
  ///
  /// In ko, this message translates to:
  /// **'2자 이상 입력하세요'**
  String get nicknameMinLength;

  /// No description provided for @nicknameMaxLength.
  ///
  /// In ko, this message translates to:
  /// **'20자 이하로 입력하세요'**
  String get nicknameMaxLength;

  /// No description provided for @country.
  ///
  /// In ko, this message translates to:
  /// **'국가'**
  String get country;

  /// No description provided for @complete.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get complete;

  /// No description provided for @profileSaveFailed.
  ///
  /// In ko, this message translates to:
  /// **'프로필 저장 실패'**
  String get profileSaveFailed;

  /// No description provided for @home.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notifications;

  /// No description provided for @addLink.
  ///
  /// In ko, this message translates to:
  /// **'링크 추가'**
  String get addLink;

  /// No description provided for @editLink.
  ///
  /// In ko, this message translates to:
  /// **'링크 수정'**
  String get editLink;

  /// No description provided for @deleteLink.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get deleteLink;

  /// No description provided for @deleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'이 링크를 삭제할까요?'**
  String get deleteConfirm;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @url.
  ///
  /// In ko, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @urlHint.
  ///
  /// In ko, this message translates to:
  /// **'https://example.com'**
  String get urlHint;

  /// No description provided for @urlRequired.
  ///
  /// In ko, this message translates to:
  /// **'URL을 입력하세요'**
  String get urlRequired;

  /// No description provided for @urlInvalid.
  ///
  /// In ko, this message translates to:
  /// **'올바른 URL을 입력하세요'**
  String get urlInvalid;

  /// No description provided for @title.
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get title;

  /// No description provided for @titleHint.
  ///
  /// In ko, this message translates to:
  /// **'매일 운동 루틴'**
  String get titleHint;

  /// No description provided for @titleRequired.
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력하세요'**
  String get titleRequired;

  /// No description provided for @notificationTime.
  ///
  /// In ko, this message translates to:
  /// **'알림 시간'**
  String get notificationTime;

  /// No description provided for @repeatDays.
  ///
  /// In ko, this message translates to:
  /// **'반복 요일'**
  String get repeatDays;

  /// No description provided for @selectRepeatDays.
  ///
  /// In ko, this message translates to:
  /// **'반복 요일을 선택하세요'**
  String get selectRepeatDays;

  /// No description provided for @sun.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get sun;

  /// No description provided for @mon.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get sat;

  /// No description provided for @sunday.
  ///
  /// In ko, this message translates to:
  /// **'일요일'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In ko, this message translates to:
  /// **'월요일'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In ko, this message translates to:
  /// **'화요일'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In ko, this message translates to:
  /// **'수요일'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In ko, this message translates to:
  /// **'목요일'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In ko, this message translates to:
  /// **'금요일'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In ko, this message translates to:
  /// **'토요일'**
  String get saturday;

  /// No description provided for @everyday.
  ///
  /// In ko, this message translates to:
  /// **'매일'**
  String get everyday;

  /// No description provided for @weekdays.
  ///
  /// In ko, this message translates to:
  /// **'평일'**
  String get weekdays;

  /// No description provided for @weekends.
  ///
  /// In ko, this message translates to:
  /// **'주말'**
  String get weekends;

  /// No description provided for @repeat.
  ///
  /// In ko, this message translates to:
  /// **'반복'**
  String get repeat;

  /// No description provided for @linkUrl.
  ///
  /// In ko, this message translates to:
  /// **'링크 또는 전화번호'**
  String get linkUrl;

  /// No description provided for @linkUrlHint.
  ///
  /// In ko, this message translates to:
  /// **'google.com 또는 01012345678'**
  String get linkUrlHint;

  /// No description provided for @invalidUrl.
  ///
  /// In ko, this message translates to:
  /// **'올바른 URL 또는 전화번호를 입력하세요'**
  String get invalidUrl;

  /// No description provided for @reminderTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림 제목'**
  String get reminderTitle;

  /// No description provided for @reminderTitleHint.
  ///
  /// In ko, this message translates to:
  /// **'아침 스트레칭 하자!'**
  String get reminderTitleHint;

  /// No description provided for @enterTitle.
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력하세요'**
  String get enterTitle;

  /// No description provided for @reminderTime.
  ///
  /// In ko, this message translates to:
  /// **'알림 시간'**
  String get reminderTime;

  /// No description provided for @addTime.
  ///
  /// In ko, this message translates to:
  /// **'시간 추가'**
  String get addTime;

  /// No description provided for @addTimePremium.
  ///
  /// In ko, this message translates to:
  /// **'시간 추가 (프리미엄)'**
  String get addTimePremium;

  /// No description provided for @premiumFeature.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 기능'**
  String get premiumFeature;

  /// No description provided for @multiTimesPremiumMessage.
  ///
  /// In ko, this message translates to:
  /// **'하나의 링크에 여러 시간을 설정하려면\n프리미엄으로 업그레이드하세요!'**
  String get multiTimesPremiumMessage;

  /// No description provided for @linkAdded.
  ///
  /// In ko, this message translates to:
  /// **'링크가 추가되었습니다'**
  String get linkAdded;

  /// No description provided for @linkUpdated.
  ///
  /// In ko, this message translates to:
  /// **'링크가 수정되었습니다'**
  String get linkUpdated;

  /// No description provided for @linkDeleted.
  ///
  /// In ko, this message translates to:
  /// **'링크가 삭제되었습니다'**
  String get linkDeleted;

  /// No description provided for @emptyStateTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 링크가 없어요'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'자주 방문하고 싶은 링크를 추가해보세요'**
  String get emptyStateSubtitle;

  /// No description provided for @emptyStateButton.
  ///
  /// In ko, this message translates to:
  /// **'첫 링크 추가하기'**
  String get emptyStateButton;

  /// No description provided for @savedByCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}명이 저장함'**
  String savedByCount(int count);

  /// No description provided for @savedByTitle.
  ///
  /// In ko, this message translates to:
  /// **'이 링크를 저장한 사람들'**
  String get savedByTitle;

  /// No description provided for @noSavedUsers.
  ///
  /// In ko, this message translates to:
  /// **'아직 저장한 사람이 없어요'**
  String get noSavedUsers;

  /// No description provided for @me.
  ///
  /// In ko, this message translates to:
  /// **'나'**
  String get me;

  /// No description provided for @loadFailed.
  ///
  /// In ko, this message translates to:
  /// **'불러오기 실패'**
  String get loadFailed;

  /// No description provided for @cheer.
  ///
  /// In ko, this message translates to:
  /// **'응원'**
  String get cheer;

  /// No description provided for @tease.
  ///
  /// In ko, this message translates to:
  /// **'약올리기'**
  String get tease;

  /// No description provided for @cheerSent.
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님에게 응원을 보냈어요!'**
  String cheerSent(String nickname);

  /// No description provided for @teaseSent.
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님에게 약올리기를 보냈어요!'**
  String teaseSent(String nickname);

  /// No description provided for @sendFailed.
  ///
  /// In ko, this message translates to:
  /// **'전송 실패'**
  String get sendFailed;

  /// No description provided for @cannotSendToSelf.
  ///
  /// In ko, this message translates to:
  /// **'자기 자신에게는 보낼 수 없어요'**
  String get cannotSendToSelf;

  /// No description provided for @noNotifications.
  ///
  /// In ko, this message translates to:
  /// **'아직 알림이 없어요'**
  String get noNotifications;

  /// No description provided for @noNotificationsSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'다른 유저가 응원이나 약올리기를 보내면\n여기에 표시됩니다'**
  String get noNotificationsSubtitle;

  /// No description provided for @markAllRead.
  ///
  /// In ko, this message translates to:
  /// **'모두 읽음'**
  String get markAllRead;

  /// No description provided for @cheerReceived.
  ///
  /// In ko, this message translates to:
  /// **'님이 응원을 보냈어요!'**
  String get cheerReceived;

  /// No description provided for @teaseReceived.
  ///
  /// In ko, this message translates to:
  /// **'님이 약올렸어요!'**
  String get teaseReceived;

  /// No description provided for @notificationLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'알림을 불러올 수 없습니다'**
  String get notificationLoadFailed;

  /// No description provided for @justNow.
  ///
  /// In ko, this message translates to:
  /// **'방금'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 전'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 전'**
  String hoursAgo(int hours);

  /// No description provided for @daysAgo.
  ///
  /// In ko, this message translates to:
  /// **'{days}일 전'**
  String daysAgo(int days);

  /// No description provided for @profile.
  ///
  /// In ko, this message translates to:
  /// **'프로필'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In ko, this message translates to:
  /// **'프로필 수정'**
  String get editProfile;

  /// No description provided for @profileEditNotReady.
  ///
  /// In ko, this message translates to:
  /// **'프로필 수정 (구현 예정)'**
  String get profileEditNotReady;

  /// No description provided for @notificationSettings.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notificationSettings;

  /// No description provided for @notificationPermission.
  ///
  /// In ko, this message translates to:
  /// **'알림 권한'**
  String get notificationPermission;

  /// No description provided for @notificationTest.
  ///
  /// In ko, this message translates to:
  /// **'알림 테스트'**
  String get notificationTest;

  /// No description provided for @notificationTestSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'테스트 알림 보내기'**
  String get notificationTestSubtitle;

  /// No description provided for @notificationTestSent.
  ///
  /// In ko, this message translates to:
  /// **'테스트 알림을 보냈습니다'**
  String get notificationTestSent;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In ko, this message translates to:
  /// **'알림 권한이 필요합니다'**
  String get notificationPermissionRequired;

  /// No description provided for @premium.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄'**
  String get premium;

  /// No description provided for @premiumActive.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 사용 중'**
  String get premiumActive;

  /// No description provided for @premiumPurchase.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 구매'**
  String get premiumPurchase;

  /// No description provided for @premiumBenefits.
  ///
  /// In ko, this message translates to:
  /// **'무제한 링크, 광고 제거'**
  String get premiumBenefits;

  /// No description provided for @premiumHeadline.
  ///
  /// In ko, this message translates to:
  /// **'나의 모든 순간을, 놓치지 않게'**
  String get premiumHeadline;

  /// No description provided for @premiumSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'소중한 사람을 제한 없이 응원하세요'**
  String get premiumSubtitle;

  /// No description provided for @premiumBenefit1.
  ///
  /// In ko, this message translates to:
  /// **'무제한 응원 & 약올리기'**
  String get premiumBenefit1;

  /// No description provided for @premiumBenefit1Desc.
  ///
  /// In ko, this message translates to:
  /// **'포링 걱정 없이 친구에게 바로 응원을 보내세요'**
  String get premiumBenefit1Desc;

  /// No description provided for @premiumBenefit2.
  ///
  /// In ko, this message translates to:
  /// **'링크 무제한 등록'**
  String get premiumBenefit2;

  /// No description provided for @premiumBenefit2Desc.
  ///
  /// In ko, this message translates to:
  /// **'운동, 공부, 효도 전화... 원하는 만큼 습관을 만드세요'**
  String get premiumBenefit2Desc;

  /// No description provided for @premiumBenefit3.
  ///
  /// In ko, this message translates to:
  /// **'추가 알림시간 무제한'**
  String get premiumBenefit3;

  /// No description provided for @premiumBenefit3Desc.
  ///
  /// In ko, this message translates to:
  /// **'하나의 링크에 아침, 점심, 저녁 알림을 자유롭게'**
  String get premiumBenefit3Desc;

  /// No description provided for @premiumBenefit4.
  ///
  /// In ko, this message translates to:
  /// **'포링 무제한'**
  String get premiumBenefit4;

  /// No description provided for @premiumBenefit4Desc.
  ///
  /// In ko, this message translates to:
  /// **'광고 없이 모든 기능을 바로 사용하세요'**
  String get premiumBenefit4Desc;

  /// No description provided for @premiumBenefit5.
  ///
  /// In ko, this message translates to:
  /// **'광고 없는 깔끔한 경험'**
  String get premiumBenefit5;

  /// No description provided for @premiumBenefit5Desc.
  ///
  /// In ko, this message translates to:
  /// **'배너도, 보상형 광고도 없는 깨끗한 화면'**
  String get premiumBenefit5Desc;

  /// No description provided for @premiumBenefit6.
  ///
  /// In ko, this message translates to:
  /// **'모든 프리미엄 소리 해금'**
  String get premiumBenefit6;

  /// No description provided for @premiumBenefit6Desc.
  ///
  /// In ko, this message translates to:
  /// **'나만의 알림음으로 하루를 시작하세요'**
  String get premiumBenefit6Desc;

  /// No description provided for @premiumPrice.
  ///
  /// In ko, this message translates to:
  /// **'월 \$2.99 / 연 \$9.99 / 평생 \$29.99'**
  String get premiumPrice;

  /// No description provided for @premiumLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get premiumLater;

  /// No description provided for @premiumBuy.
  ///
  /// In ko, this message translates to:
  /// **'구매하기'**
  String get premiumBuy;

  /// No description provided for @premiumMonthly.
  ///
  /// In ko, this message translates to:
  /// **'월간 구독'**
  String get premiumMonthly;

  /// No description provided for @premiumYearly.
  ///
  /// In ko, this message translates to:
  /// **'연간 구독'**
  String get premiumYearly;

  /// No description provided for @premiumLifetime.
  ///
  /// In ko, this message translates to:
  /// **'평생 이용권'**
  String get premiumLifetime;

  /// No description provided for @premiumPurchaseSuccess.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 구매가 완료되었습니다!'**
  String get premiumPurchaseSuccess;

  /// No description provided for @premiumPurchaseFailed.
  ///
  /// In ko, this message translates to:
  /// **'구매에 실패했습니다. 다시 시도해주세요.'**
  String get premiumPurchaseFailed;

  /// No description provided for @premiumRestoreSuccess.
  ///
  /// In ko, this message translates to:
  /// **'구매 내역이 복원되었습니다!'**
  String get premiumRestoreSuccess;

  /// No description provided for @restorePurchases.
  ///
  /// In ko, this message translates to:
  /// **'구매 복원'**
  String get restorePurchases;

  /// No description provided for @storeNotAvailable.
  ///
  /// In ko, this message translates to:
  /// **'스토어에 연결할 수 없습니다'**
  String get storeNotAvailable;

  /// No description provided for @productsNotFound.
  ///
  /// In ko, this message translates to:
  /// **'상품을 불러올 수 없습니다'**
  String get productsNotFound;

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// No description provided for @premiumPaymentNotReady.
  ///
  /// In ko, this message translates to:
  /// **'결제 기능 (구현 예정)'**
  String get premiumPaymentNotReady;

  /// No description provided for @linkLimitReached.
  ///
  /// In ko, this message translates to:
  /// **'링크 한도 도달'**
  String get linkLimitReached;

  /// No description provided for @linkLimitMessage.
  ///
  /// In ko, this message translates to:
  /// **'무료 버전은 2개까지 등록할 수 있어요.\n친구 초대로 +1개, 프리미엄으로 무제한!'**
  String get linkLimitMessage;

  /// No description provided for @linkLimitMessageBase.
  ///
  /// In ko, this message translates to:
  /// **'무료 버전은 2개까지 등록할 수 있어요.'**
  String get linkLimitMessageBase;

  /// No description provided for @inviteFriendForBonus.
  ///
  /// In ko, this message translates to:
  /// **'친구 초대하기 (+1개)'**
  String get inviteFriendForBonus;

  /// No description provided for @inviteFriendBonusDesc.
  ///
  /// In ko, this message translates to:
  /// **'친구가 가입하면 보너스 링크 획득!'**
  String get inviteFriendBonusDesc;

  /// No description provided for @viewPremium.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 보기'**
  String get viewPremium;

  /// No description provided for @account.
  ///
  /// In ko, this message translates to:
  /// **'계정'**
  String get account;

  /// No description provided for @info.
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get info;

  /// No description provided for @version.
  ///
  /// In ko, this message translates to:
  /// **'버전'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyNotReady.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침 (구현 예정)'**
  String get privacyPolicyNotReady;

  /// No description provided for @contact.
  ///
  /// In ko, this message translates to:
  /// **'문의하기'**
  String get contact;

  /// No description provided for @contactNotReady.
  ///
  /// In ko, this message translates to:
  /// **'문의하기 (구현 예정)'**
  String get contactNotReady;

  /// No description provided for @loading.
  ///
  /// In ko, this message translates to:
  /// **'로딩 중...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In ko, this message translates to:
  /// **'오류'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In ko, this message translates to:
  /// **'예'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In ko, this message translates to:
  /// **'아니요'**
  String get no;

  /// No description provided for @share.
  ///
  /// In ko, this message translates to:
  /// **'공유하기'**
  String get share;

  /// No description provided for @edit.
  ///
  /// In ko, this message translates to:
  /// **'수정하기'**
  String get edit;

  /// No description provided for @copyLink.
  ///
  /// In ko, this message translates to:
  /// **'링크 복사'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In ko, this message translates to:
  /// **'링크가 복사되었습니다'**
  String get linkCopied;

  /// No description provided for @shareMessage.
  ///
  /// In ko, this message translates to:
  /// **'나 이거 {time}에 알림 받아서 하고 있어! 너도 같이 하자\n\n{url}\n\nLinkPing에서 열기'**
  String shareMessage(String time, String url);

  /// No description provided for @selectAction.
  ///
  /// In ko, this message translates to:
  /// **'작업 선택'**
  String get selectAction;

  /// No description provided for @profileUpdated.
  ///
  /// In ko, this message translates to:
  /// **'프로필이 수정되었습니다'**
  String get profileUpdated;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In ko, this message translates to:
  /// **'프로필 수정에 실패했습니다'**
  String get profileUpdateFailed;

  /// No description provided for @accountLink.
  ///
  /// In ko, this message translates to:
  /// **'계정 연동'**
  String get accountLink;

  /// No description provided for @accountLinked.
  ///
  /// In ko, this message translates to:
  /// **'계정이 연동되었습니다'**
  String get accountLinked;

  /// No description provided for @accountLinkFailed.
  ///
  /// In ko, this message translates to:
  /// **'계정 연동에 실패했습니다'**
  String get accountLinkFailed;

  /// No description provided for @kakao.
  ///
  /// In ko, this message translates to:
  /// **'카카오톡'**
  String get kakao;

  /// No description provided for @kakaoLinkComingSoon.
  ///
  /// In ko, this message translates to:
  /// **'카카오 연동 (준비 중)'**
  String get kakaoLinkComingSoon;

  /// No description provided for @guestLinkInfo.
  ///
  /// In ko, this message translates to:
  /// **'계정을 연동하면 다른 기기에서도 데이터를 동기화할 수 있어요'**
  String get guestLinkInfo;

  /// No description provided for @linked.
  ///
  /// In ko, this message translates to:
  /// **'연동됨'**
  String get linked;

  /// No description provided for @link.
  ///
  /// In ko, this message translates to:
  /// **'연동'**
  String get link;

  /// No description provided for @setEndDate.
  ///
  /// In ko, this message translates to:
  /// **'종료일 설정'**
  String get setEndDate;

  /// No description provided for @endDateEnabled.
  ///
  /// In ko, this message translates to:
  /// **'종료일에 자동으로 알람이 꺼집니다'**
  String get endDateEnabled;

  /// No description provided for @endDateDisabled.
  ///
  /// In ko, this message translates to:
  /// **'무한 반복 (종료일 없음)'**
  String get endDateDisabled;

  /// No description provided for @selectEndDate.
  ///
  /// In ko, this message translates to:
  /// **'종료일 선택'**
  String get selectEndDate;

  /// No description provided for @selectCheerMessage.
  ///
  /// In ko, this message translates to:
  /// **'응원 메시지 선택'**
  String get selectCheerMessage;

  /// No description provided for @selectTeaseMessage.
  ///
  /// In ko, this message translates to:
  /// **'약올리기 메시지 선택'**
  String get selectTeaseMessage;

  /// No description provided for @pingRateLimited.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 후에 다시 보낼 수 있어요'**
  String pingRateLimited(int minutes);

  /// No description provided for @addTimeWithAd.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 시간 추가'**
  String get addTimeWithAd;

  /// No description provided for @watchAdToAddTime.
  ///
  /// In ko, this message translates to:
  /// **'광고를 시청하면 알림 시간을 추가할 수 있어요.\n프리미엄 유저는 광고 없이 무제한 추가 가능!'**
  String get watchAdToAddTime;

  /// No description provided for @watchAd.
  ///
  /// In ko, this message translates to:
  /// **'광고 보기'**
  String get watchAd;

  /// No description provided for @adLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'광고를 불러올 수 없습니다'**
  String get adLoadFailed;

  /// No description provided for @timeAddedSuccess.
  ///
  /// In ko, this message translates to:
  /// **'시간이 추가되었습니다'**
  String get timeAddedSuccess;

  /// No description provided for @inviteFriends.
  ///
  /// In ko, this message translates to:
  /// **'친구 초대'**
  String get inviteFriends;

  /// No description provided for @inviteFriendsMessage.
  ///
  /// In ko, this message translates to:
  /// **'친구를 초대하면 링크 1개를 더 추가할 수 있어요!'**
  String get inviteFriendsMessage;

  /// No description provided for @bonusLinkEarned.
  ///
  /// In ko, this message translates to:
  /// **'보너스 링크를 획득했어요!'**
  String get bonusLinkEarned;

  /// No description provided for @referralCode.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드'**
  String get referralCode;

  /// No description provided for @copyReferralCode.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드 복사'**
  String get copyReferralCode;

  /// No description provided for @referralCodeCopied.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드가 복사되었습니다'**
  String get referralCodeCopied;

  /// No description provided for @lockedTime.
  ///
  /// In ko, this message translates to:
  /// **'잠긴 시간'**
  String get lockedTime;

  /// No description provided for @unlockTimeWithAd.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 잠금해제'**
  String get unlockTimeWithAd;

  /// No description provided for @watchAdToUnlockTime.
  ///
  /// In ko, this message translates to:
  /// **'광고를 시청하면 이 알림 시간을 활성화할 수 있어요.\n프리미엄 유저는 모든 시간이 자동으로 활성화됩니다!'**
  String get watchAdToUnlockTime;

  /// No description provided for @timeUnlocked.
  ///
  /// In ko, this message translates to:
  /// **'알림 시간이 활성화되었습니다'**
  String get timeUnlocked;

  /// No description provided for @shareSettings.
  ///
  /// In ko, this message translates to:
  /// **'공유 설정'**
  String get shareSettings;

  /// No description provided for @editable.
  ///
  /// In ko, this message translates to:
  /// **'수정 가능'**
  String get editable;

  /// No description provided for @recipientCanChangeTime.
  ///
  /// In ko, this message translates to:
  /// **'받는 사람이 시간 변경 가능'**
  String get recipientCanChangeTime;

  /// No description provided for @timeLocked.
  ///
  /// In ko, this message translates to:
  /// **'시간 고정'**
  String get timeLocked;

  /// No description provided for @shareAtThisTime.
  ///
  /// In ko, this message translates to:
  /// **'이 시간 그대로 공유'**
  String get shareAtThisTime;

  /// No description provided for @category.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get category;

  /// No description provided for @consentRequest.
  ///
  /// In ko, this message translates to:
  /// **'동의 요청'**
  String get consentRequest;

  /// No description provided for @consentRequestMessage.
  ///
  /// In ko, this message translates to:
  /// **'공유받은 사람들에게 수정 동의를 요청합니다.'**
  String get consentRequestMessage;

  /// No description provided for @consentNote1.
  ///
  /// In ko, this message translates to:
  /// **'최대 24시간 소요될 수 있어요'**
  String get consentNote1;

  /// No description provided for @consentNote2.
  ///
  /// In ko, this message translates to:
  /// **'동의가 완료되면 알림으로 안내해드려요'**
  String get consentNote2;

  /// No description provided for @consentNote3.
  ///
  /// In ko, this message translates to:
  /// **'거절 시 기존 시간이 유지됩니다'**
  String get consentNote3;

  /// No description provided for @requestConsent.
  ///
  /// In ko, this message translates to:
  /// **'동의 요청하기'**
  String get requestConsent;

  /// No description provided for @timeLockedAlarm.
  ///
  /// In ko, this message translates to:
  /// **'시간 고정 알람'**
  String get timeLockedAlarm;

  /// No description provided for @receivedSharedAlarmInfo.
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님이 공유한 알람이에요.\n알림 시간과 반복 요일은 수정할 수 없어요.'**
  String receivedSharedAlarmInfo(String nickname);

  /// No description provided for @sharedToOthersInfo.
  ///
  /// In ko, this message translates to:
  /// **'공유받은 사람들도 같은 시간에 알림을 받아요.\n시간 수정 시 동의가 필요해요.'**
  String get sharedToOthersInfo;

  /// No description provided for @locked.
  ///
  /// In ko, this message translates to:
  /// **'잠김'**
  String get locked;

  /// No description provided for @badgesAndStats.
  ///
  /// In ko, this message translates to:
  /// **'뱃지 & 통계'**
  String get badgesAndStats;

  /// No description provided for @badgeCollection.
  ///
  /// In ko, this message translates to:
  /// **'뱃지 컬렉션'**
  String get badgeCollection;

  /// No description provided for @streakDays.
  ///
  /// In ko, this message translates to:
  /// **'{days}일 스트릭'**
  String streakDays(int days);

  /// No description provided for @badgesEarned.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 획득'**
  String badgesEarned(int count);

  /// No description provided for @accountSynced.
  ///
  /// In ko, this message translates to:
  /// **'계정 연동됨'**
  String get accountSynced;

  /// No description provided for @loginToSync.
  ///
  /// In ko, this message translates to:
  /// **'로그인하여 데이터 동기화'**
  String get loginToSync;

  /// No description provided for @termsOfService.
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get termsOfService;

  /// No description provided for @bonusStatus.
  ///
  /// In ko, this message translates to:
  /// **'보너스: {current}/{max} 획득'**
  String bonusStatus(int current, int max);

  /// No description provided for @andMore.
  ///
  /// In ko, this message translates to:
  /// **'외 {count}개'**
  String andMore(int count);

  /// No description provided for @pingWindowClosed.
  ///
  /// In ko, this message translates to:
  /// **'알람이 울린 후 5분 내에만 전송할 수 있어요'**
  String get pingWindowClosed;

  /// No description provided for @pingWindowActive.
  ///
  /// In ko, this message translates to:
  /// **'남은 시간: {time}'**
  String pingWindowActive(String time);

  /// No description provided for @pingFreeRemaining.
  ///
  /// In ko, this message translates to:
  /// **'무료 1회 전송 가능'**
  String get pingFreeRemaining;

  /// No description provided for @pingWatchAdForMore.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 더 보내기'**
  String get pingWatchAdForMore;

  /// No description provided for @premiumUnlimited.
  ///
  /// In ko, this message translates to:
  /// **'무제한'**
  String get premiumUnlimited;

  /// No description provided for @watchAdToSendMore.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 더 보내기'**
  String get watchAdToSendMore;

  /// No description provided for @watchAdDescription.
  ///
  /// In ko, this message translates to:
  /// **'무료 유저는 알람 1회당 1명에게만 전송할 수 있어요.\n광고를 시청하면 추가 전송 가능! 프리미엄은 무제한!'**
  String get watchAdDescription;

  /// No description provided for @selectProfileEmoji.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이모지 선택'**
  String get selectProfileEmoji;

  /// No description provided for @profileEmoji.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이모지'**
  String get profileEmoji;

  /// No description provided for @changeEmoji.
  ///
  /// In ko, this message translates to:
  /// **'이모지 변경'**
  String get changeEmoji;

  /// No description provided for @profileEmojiDescription.
  ///
  /// In ko, this message translates to:
  /// **'다른 사람에게 보여지는 프로필 이모지'**
  String get profileEmojiDescription;

  /// No description provided for @profileEmojiChanged.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이모지가 변경되었어요'**
  String get profileEmojiChanged;

  /// No description provided for @myPhoneNumber.
  ///
  /// In ko, this message translates to:
  /// **'내 전화번호'**
  String get myPhoneNumber;

  /// No description provided for @phoneNumberNotSet.
  ///
  /// In ko, this message translates to:
  /// **'설정 안 됨'**
  String get phoneNumberNotSet;

  /// No description provided for @editNickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임 수정'**
  String get editNickname;

  /// No description provided for @enterNickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임을 입력하세요'**
  String get enterNickname;

  /// No description provided for @pleaseEnterNickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임을 입력해주세요'**
  String get pleaseEnterNickname;

  /// No description provided for @minTwoChars.
  ///
  /// In ko, this message translates to:
  /// **'2자 이상 입력해주세요'**
  String get minTwoChars;

  /// No description provided for @nicknameChanged.
  ///
  /// In ko, this message translates to:
  /// **'닉네임이 변경되었어요'**
  String get nicknameChanged;

  /// No description provided for @checkingDuplicate.
  ///
  /// In ko, this message translates to:
  /// **'중복 확인 중...'**
  String get checkingDuplicate;

  /// No description provided for @nicknameAlreadyInUse.
  ///
  /// In ko, this message translates to:
  /// **'이미 사용 중인 닉네임이에요'**
  String get nicknameAlreadyInUse;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In ko, this message translates to:
  /// **'올바른 전화번호를 입력해주세요'**
  String get invalidPhoneNumber;

  /// No description provided for @phoneNumberSaved.
  ///
  /// In ko, this message translates to:
  /// **'전화번호가 저장되었어요'**
  String get phoneNumberSaved;

  /// No description provided for @phoneNumberDeleted.
  ///
  /// In ko, this message translates to:
  /// **'전화번호가 삭제되었어요'**
  String get phoneNumberDeleted;

  /// No description provided for @changeAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정 변경'**
  String get changeAccount;

  /// No description provided for @changeAccountConfirm.
  ///
  /// In ko, this message translates to:
  /// **'다른 구글 계정으로 변경하시겠습니까?'**
  String get changeAccountConfirm;

  /// No description provided for @change.
  ///
  /// In ko, this message translates to:
  /// **'변경'**
  String get change;

  /// No description provided for @cheerReceivedFrom.
  ///
  /// In ko, this message translates to:
  /// **'{name}님이 응원을 보냈어요!'**
  String cheerReceivedFrom(String name);

  /// No description provided for @teaseReceivedFrom.
  ///
  /// In ko, this message translates to:
  /// **'{name}님이 약올렸어요!'**
  String teaseReceivedFrom(String name);

  /// No description provided for @inquiryReplyArrived.
  ///
  /// In ko, this message translates to:
  /// **'문의 답변 도착'**
  String get inquiryReplyArrived;

  /// No description provided for @linkAlarmDeleted.
  ///
  /// In ko, this message translates to:
  /// **'링크 알람 삭제됨'**
  String get linkAlarmDeleted;

  /// No description provided for @timeModificationRequest.
  ///
  /// In ko, this message translates to:
  /// **'시간 수정 요청'**
  String get timeModificationRequest;

  /// No description provided for @modificationApproved.
  ///
  /// In ko, this message translates to:
  /// **'수정 요청 승인됨'**
  String get modificationApproved;

  /// No description provided for @modificationRejected.
  ///
  /// In ko, this message translates to:
  /// **'수정 요청 거부됨'**
  String get modificationRejected;

  /// No description provided for @alarmTurnedOff.
  ///
  /// In ko, this message translates to:
  /// **'알람이 OFF되었습니다'**
  String get alarmTurnedOff;

  /// No description provided for @approve.
  ///
  /// In ko, this message translates to:
  /// **'승인'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In ko, this message translates to:
  /// **'거절'**
  String get reject;

  /// No description provided for @approved.
  ///
  /// In ko, this message translates to:
  /// **'승인했어요!'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In ko, this message translates to:
  /// **'거절했어요.'**
  String get rejected;

  /// No description provided for @voteFailed.
  ///
  /// In ko, this message translates to:
  /// **'투표에 실패했어요'**
  String get voteFailed;

  /// No description provided for @tapToViewReply.
  ///
  /// In ko, this message translates to:
  /// **'탭하여 답변 확인하기 →'**
  String get tapToViewReply;

  /// No description provided for @noResponseWarning.
  ///
  /// In ko, this message translates to:
  /// **'24시간 내 응답하지 않으면 알람이 OFF됩니다'**
  String get noResponseWarning;

  /// No description provided for @inquiry.
  ///
  /// In ko, this message translates to:
  /// **'문의'**
  String get inquiry;

  /// No description provided for @googleAccountAlreadyLinked.
  ///
  /// In ko, this message translates to:
  /// **'이 구글 계정은 이미 다른 계정에 연동되어 있어요'**
  String get googleAccountAlreadyLinked;

  /// No description provided for @providerAlreadyLinked.
  ///
  /// In ko, this message translates to:
  /// **'이미 구글 계정이 연동되어 있어요'**
  String get providerAlreadyLinked;

  /// No description provided for @invalidCredential.
  ///
  /// In ko, this message translates to:
  /// **'인증 정보가 유효하지 않아요'**
  String get invalidCredential;

  /// No description provided for @networkError.
  ///
  /// In ko, this message translates to:
  /// **'네트워크 연결을 확인해주세요'**
  String get networkError;

  /// No description provided for @noInquiries.
  ///
  /// In ko, this message translates to:
  /// **'문의 내역이 없어요'**
  String get noInquiries;

  /// No description provided for @inquiryHint.
  ///
  /// In ko, this message translates to:
  /// **'궁금한 점이 있으면 문의해주세요!'**
  String get inquiryHint;

  /// No description provided for @inquirySubmitted.
  ///
  /// In ko, this message translates to:
  /// **'문의가 등록되었습니다'**
  String get inquirySubmitted;

  /// No description provided for @inquirySubmitFailed.
  ///
  /// In ko, this message translates to:
  /// **'문의 등록 실패'**
  String get inquirySubmitFailed;

  /// No description provided for @inquiryTitle.
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get inquiryTitle;

  /// No description provided for @inquiryTitleHint.
  ///
  /// In ko, this message translates to:
  /// **'문의 제목을 입력하세요'**
  String get inquiryTitleHint;

  /// No description provided for @inquiryTitleRequired.
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력해주세요'**
  String get inquiryTitleRequired;

  /// No description provided for @inquiryContent.
  ///
  /// In ko, this message translates to:
  /// **'내용'**
  String get inquiryContent;

  /// No description provided for @inquiryContentHint.
  ///
  /// In ko, this message translates to:
  /// **'문의 내용을 자세히 작성해주세요'**
  String get inquiryContentHint;

  /// No description provided for @inquiryContentRequired.
  ///
  /// In ko, this message translates to:
  /// **'내용을 입력해주세요'**
  String get inquiryContentRequired;

  /// No description provided for @inquiryContentMinLength.
  ///
  /// In ko, this message translates to:
  /// **'내용을 10자 이상 입력해주세요'**
  String get inquiryContentMinLength;

  /// No description provided for @submitInquiry.
  ///
  /// In ko, this message translates to:
  /// **'문의 등록'**
  String get submitInquiry;

  /// No description provided for @inquiryResponsePromise.
  ///
  /// In ko, this message translates to:
  /// **'문의하신 내용은 빠른 시일 내에 답변드리겠습니다.'**
  String get inquiryResponsePromise;

  /// No description provided for @alarmSound.
  ///
  /// In ko, this message translates to:
  /// **'알람 소리'**
  String get alarmSound;

  /// No description provided for @selectSoundCategory.
  ///
  /// In ko, this message translates to:
  /// **'어떤 스타일의 소리를 원하세요?'**
  String get selectSoundCategory;

  /// No description provided for @pingNotificationSound.
  ///
  /// In ko, this message translates to:
  /// **'Ping 알림음'**
  String get pingNotificationSound;

  /// No description provided for @pingNotificationSoundDesc.
  ///
  /// In ko, this message translates to:
  /// **'찔러보기/응원하기 알림 소리'**
  String get pingNotificationSoundDesc;

  /// No description provided for @currentSound.
  ///
  /// In ko, this message translates to:
  /// **'현재 소리'**
  String get currentSound;

  /// No description provided for @freeSounds.
  ///
  /// In ko, this message translates to:
  /// **'무료 소리'**
  String get freeSounds;

  /// No description provided for @premiumSounds.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 소리'**
  String get premiumSounds;

  /// No description provided for @premiumSoundsLocked.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄으로 업그레이드하면 모든 소리를 사용할 수 있어요'**
  String get premiumSoundsLocked;

  /// No description provided for @soundSelected.
  ///
  /// In ko, this message translates to:
  /// **'소리가 선택되었어요'**
  String get soundSelected;

  /// No description provided for @soundNotAvailable.
  ///
  /// In ko, this message translates to:
  /// **'아직 소리 파일이 준비되지 않았어요'**
  String get soundNotAvailable;

  /// No description provided for @alarmSoundDescription.
  ///
  /// In ko, this message translates to:
  /// **'알림 소리를 선택하세요'**
  String get alarmSoundDescription;

  /// No description provided for @soundCategoryAlarm.
  ///
  /// In ko, this message translates to:
  /// **'긴 알림'**
  String get soundCategoryAlarm;

  /// No description provided for @soundCategoryNotify.
  ///
  /// In ko, this message translates to:
  /// **'간단한 효과음'**
  String get soundCategoryNotify;

  /// No description provided for @soundCategoryAlarmDesc.
  ///
  /// In ko, this message translates to:
  /// **'멜로디형\n(5-15초)\n놓치면 안 되는 중요한 알람용'**
  String get soundCategoryAlarmDesc;

  /// No description provided for @soundCategoryNotifyDesc.
  ///
  /// In ko, this message translates to:
  /// **'짧은 효과음\n(2-5초)\n가볍게 확인할 리마인더용'**
  String get soundCategoryNotifyDesc;

  /// No description provided for @currentStreak.
  ///
  /// In ko, this message translates to:
  /// **'연속 스트릭'**
  String get currentStreak;

  /// No description provided for @achievementRate.
  ///
  /// In ko, this message translates to:
  /// **'달성률'**
  String get achievementRate;

  /// No description provided for @badgeCollected.
  ///
  /// In ko, this message translates to:
  /// **'뱃지 수집'**
  String get badgeCollected;

  /// No description provided for @longestStreak.
  ///
  /// In ko, this message translates to:
  /// **'최장: {days}일'**
  String longestStreak(int days);

  /// No description provided for @daysCount.
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String daysCount(int days);

  /// No description provided for @badgeEarned.
  ///
  /// In ko, this message translates to:
  /// **'뱃지 획득!'**
  String get badgeEarned;

  /// No description provided for @badgeNotYetEarned.
  ///
  /// In ko, this message translates to:
  /// **'아직 획득하지 않음'**
  String get badgeNotYetEarned;

  /// No description provided for @badgeEarnedOn.
  ///
  /// In ko, this message translates to:
  /// **'{date} 획득'**
  String badgeEarnedOn(String date);

  /// No description provided for @badgeProgress.
  ///
  /// In ko, this message translates to:
  /// **'진행률: {progress}/{target}'**
  String badgeProgress(int progress, int target);

  /// No description provided for @badgeProgressPercent.
  ///
  /// In ko, this message translates to:
  /// **'{percent}% 완료'**
  String badgeProgressPercent(int percent);

  /// No description provided for @badge_streak3_name.
  ///
  /// In ko, this message translates to:
  /// **'3일 연속'**
  String get badge_streak3_name;

  /// No description provided for @badge_streak3_desc.
  ///
  /// In ko, this message translates to:
  /// **'3일 연속 달성'**
  String get badge_streak3_desc;

  /// No description provided for @badge_streak7_name.
  ///
  /// In ko, this message translates to:
  /// **'일주일 불꽃'**
  String get badge_streak7_name;

  /// No description provided for @badge_streak7_desc.
  ///
  /// In ko, this message translates to:
  /// **'7일 연속 달성'**
  String get badge_streak7_desc;

  /// No description provided for @badge_streak30_name.
  ///
  /// In ko, this message translates to:
  /// **'한 달의 열정'**
  String get badge_streak30_name;

  /// No description provided for @badge_streak30_desc.
  ///
  /// In ko, this message translates to:
  /// **'30일 연속 달성'**
  String get badge_streak30_desc;

  /// No description provided for @badge_streak100_name.
  ///
  /// In ko, this message translates to:
  /// **'백일의 기적'**
  String get badge_streak100_name;

  /// No description provided for @badge_streak100_desc.
  ///
  /// In ko, this message translates to:
  /// **'100일 연속 달성'**
  String get badge_streak100_desc;

  /// No description provided for @badge_marathon_name.
  ///
  /// In ko, this message translates to:
  /// **'마라톤'**
  String get badge_marathon_name;

  /// No description provided for @badge_marathon_desc.
  ///
  /// In ko, this message translates to:
  /// **'365일 연속 달성!'**
  String get badge_marathon_desc;

  /// No description provided for @badge_comeback_name.
  ///
  /// In ko, this message translates to:
  /// **'컴백'**
  String get badge_comeback_name;

  /// No description provided for @badge_comeback_desc.
  ///
  /// In ko, this message translates to:
  /// **'스트릭 끊긴 후 다시 7일 달성'**
  String get badge_comeback_desc;

  /// No description provided for @badge_quickDraw_name.
  ///
  /// In ko, this message translates to:
  /// **'퀵 드로우'**
  String get badge_quickDraw_name;

  /// No description provided for @badge_quickDraw_desc.
  ///
  /// In ko, this message translates to:
  /// **'알림 5초 내 클릭'**
  String get badge_quickDraw_desc;

  /// No description provided for @badge_speedDemon_name.
  ///
  /// In ko, this message translates to:
  /// **'스피드 데몬'**
  String get badge_speedDemon_name;

  /// No description provided for @badge_speedDemon_desc.
  ///
  /// In ko, this message translates to:
  /// **'알림 후 30초 내 오픈 10회'**
  String get badge_speedDemon_desc;

  /// No description provided for @badge_quickResponse_name.
  ///
  /// In ko, this message translates to:
  /// **'빠른 응답'**
  String get badge_quickResponse_name;

  /// No description provided for @badge_quickResponse_desc.
  ///
  /// In ko, this message translates to:
  /// **'알림 후 3분 내 오픈 50회'**
  String get badge_quickResponse_desc;

  /// No description provided for @badge_morningGlory_name.
  ///
  /// In ko, this message translates to:
  /// **'모닝 글로리'**
  String get badge_morningGlory_name;

  /// No description provided for @badge_morningGlory_desc.
  ///
  /// In ko, this message translates to:
  /// **'오전 5~7시 클릭 5회'**
  String get badge_morningGlory_desc;

  /// No description provided for @badge_earlyBird_name.
  ///
  /// In ko, this message translates to:
  /// **'얼리버드'**
  String get badge_earlyBird_name;

  /// No description provided for @badge_earlyBird_desc.
  ///
  /// In ko, this message translates to:
  /// **'오전 7시 전 링크 오픈 10회'**
  String get badge_earlyBird_desc;

  /// No description provided for @badge_nightOwl_name.
  ///
  /// In ko, this message translates to:
  /// **'올빼미'**
  String get badge_nightOwl_name;

  /// No description provided for @badge_nightOwl_desc.
  ///
  /// In ko, this message translates to:
  /// **'밤 11시 이후 링크 오픈 10회'**
  String get badge_nightOwl_desc;

  /// No description provided for @badge_nightShift_name.
  ///
  /// In ko, this message translates to:
  /// **'야간 근무'**
  String get badge_nightShift_name;

  /// No description provided for @badge_nightShift_desc.
  ///
  /// In ko, this message translates to:
  /// **'자정~5시 사이 클릭 5회'**
  String get badge_nightShift_desc;

  /// No description provided for @badge_perfectWeek_name.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 일주일'**
  String get badge_perfectWeek_name;

  /// No description provided for @badge_perfectWeek_desc.
  ///
  /// In ko, this message translates to:
  /// **'일주일 100% 달성'**
  String get badge_perfectWeek_desc;

  /// No description provided for @badge_perfectMonth_name.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 한 달'**
  String get badge_perfectMonth_name;

  /// No description provided for @badge_perfectMonth_desc.
  ///
  /// In ko, this message translates to:
  /// **'한 달 100% 달성'**
  String get badge_perfectMonth_desc;

  /// No description provided for @badge_perfectionist_name.
  ///
  /// In ko, this message translates to:
  /// **'완벽주의자'**
  String get badge_perfectionist_name;

  /// No description provided for @badge_perfectionist_desc.
  ///
  /// In ko, this message translates to:
  /// **'달성률 95% 이상 (50회 이상)'**
  String get badge_perfectionist_desc;

  /// No description provided for @badge_firstCheer_name.
  ///
  /// In ko, this message translates to:
  /// **'첫 응원'**
  String get badge_firstCheer_name;

  /// No description provided for @badge_firstCheer_desc.
  ///
  /// In ko, this message translates to:
  /// **'첫 응원 보내기'**
  String get badge_firstCheer_desc;

  /// No description provided for @badge_cheerLeader_name.
  ///
  /// In ko, this message translates to:
  /// **'응원단장'**
  String get badge_cheerLeader_name;

  /// No description provided for @badge_cheerLeader_desc.
  ///
  /// In ko, this message translates to:
  /// **'응원 50회 보내기'**
  String get badge_cheerLeader_desc;

  /// No description provided for @badge_firstPoke_name.
  ///
  /// In ko, this message translates to:
  /// **'첫 찌르기'**
  String get badge_firstPoke_name;

  /// No description provided for @badge_firstPoke_desc.
  ///
  /// In ko, this message translates to:
  /// **'첫 찌르기 보내기'**
  String get badge_firstPoke_desc;

  /// No description provided for @badge_poker_name.
  ///
  /// In ko, this message translates to:
  /// **'찌르기 마스터'**
  String get badge_poker_name;

  /// No description provided for @badge_poker_desc.
  ///
  /// In ko, this message translates to:
  /// **'찌르기 50회 보내기'**
  String get badge_poker_desc;

  /// No description provided for @badge_socialButterfly_name.
  ///
  /// In ko, this message translates to:
  /// **'소셜 버터플라이'**
  String get badge_socialButterfly_name;

  /// No description provided for @badge_socialButterfly_desc.
  ///
  /// In ko, this message translates to:
  /// **'응원/찌르기 10회 받기'**
  String get badge_socialButterfly_desc;

  /// No description provided for @badge_firstLink_name.
  ///
  /// In ko, this message translates to:
  /// **'첫 링크'**
  String get badge_firstLink_name;

  /// No description provided for @badge_firstLink_desc.
  ///
  /// In ko, this message translates to:
  /// **'첫 링크 등록'**
  String get badge_firstLink_desc;

  /// No description provided for @badge_linkCollector_name.
  ///
  /// In ko, this message translates to:
  /// **'링크 수집가'**
  String get badge_linkCollector_name;

  /// No description provided for @badge_linkCollector_desc.
  ///
  /// In ko, this message translates to:
  /// **'링크 10개 등록'**
  String get badge_linkCollector_desc;

  /// No description provided for @badge_linkMaster_name.
  ///
  /// In ko, this message translates to:
  /// **'링크 마스터'**
  String get badge_linkMaster_name;

  /// No description provided for @badge_linkMaster_desc.
  ///
  /// In ko, this message translates to:
  /// **'링크 50개 등록'**
  String get badge_linkMaster_desc;

  /// No description provided for @badge_hotLink_name.
  ///
  /// In ko, this message translates to:
  /// **'핫 링크'**
  String get badge_hotLink_name;

  /// No description provided for @badge_hotLink_desc.
  ///
  /// In ko, this message translates to:
  /// **'내 링크 10명 이상 저장'**
  String get badge_hotLink_desc;

  /// No description provided for @badge_variety_name.
  ///
  /// In ko, this message translates to:
  /// **'다양성'**
  String get badge_variety_name;

  /// No description provided for @badge_variety_desc.
  ///
  /// In ko, this message translates to:
  /// **'5개 이상 다른 도메인 링크'**
  String get badge_variety_desc;

  /// No description provided for @badge_founder_name.
  ///
  /// In ko, this message translates to:
  /// **'파운더'**
  String get badge_founder_name;

  /// No description provided for @badge_founder_desc.
  ///
  /// In ko, this message translates to:
  /// **'앱 초기 사용자'**
  String get badge_founder_desc;

  /// No description provided for @badge_premium_name.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄'**
  String get badge_premium_name;

  /// No description provided for @badge_premium_desc.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 구독'**
  String get badge_premium_desc;

  /// No description provided for @badge_badgeCollector_name.
  ///
  /// In ko, this message translates to:
  /// **'뱃지 수집가'**
  String get badge_badgeCollector_name;

  /// No description provided for @badge_badgeCollector_desc.
  ///
  /// In ko, this message translates to:
  /// **'뱃지 10개 획득'**
  String get badge_badgeCollector_desc;

  /// No description provided for @badge_cloudSynced_name.
  ///
  /// In ko, this message translates to:
  /// **'클라우드 동기화'**
  String get badge_cloudSynced_name;

  /// No description provided for @badge_cloudSynced_desc.
  ///
  /// In ko, this message translates to:
  /// **'계정 연동으로 데이터 동기화'**
  String get badge_cloudSynced_desc;

  /// No description provided for @premiumSoundUnlock.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 소리'**
  String get premiumSoundUnlock;

  /// No description provided for @premiumSoundUnlockDesc.
  ///
  /// In ko, this message translates to:
  /// **'이 소리는 프리미엄 전용입니다.\n광고를 시청하거나 프리미엄에 가입하세요.'**
  String get premiumSoundUnlockDesc;

  /// No description provided for @watchAdToUnlock.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 사용하기'**
  String get watchAdToUnlock;

  /// No description provided for @upgradeToPremium.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 등록하기'**
  String get upgradeToPremium;

  /// No description provided for @adNotReady.
  ///
  /// In ko, this message translates to:
  /// **'광고를 준비 중입니다. 잠시 후 다시 시도해주세요.'**
  String get adNotReady;

  /// No description provided for @adWatchSuccess.
  ///
  /// In ko, this message translates to:
  /// **'광고 시청 완료! 소리가 적용되었습니다.'**
  String get adWatchSuccess;

  /// No description provided for @earnedBadges.
  ///
  /// In ko, this message translates to:
  /// **'획득한 배지'**
  String get earnedBadges;

  /// No description provided for @skip.
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get getStarted;

  /// No description provided for @done.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get done;

  /// No description provided for @send.
  ///
  /// In ko, this message translates to:
  /// **'보내기'**
  String get send;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @notSet.
  ///
  /// In ko, this message translates to:
  /// **'미설정'**
  String get notSet;

  /// No description provided for @inquiryDetail.
  ///
  /// In ko, this message translates to:
  /// **'문의 상세'**
  String get inquiryDetail;

  /// No description provided for @inquiryNotFound.
  ///
  /// In ko, this message translates to:
  /// **'문의를 찾을 수 없습니다'**
  String get inquiryNotFound;

  /// No description provided for @reply.
  ///
  /// In ko, this message translates to:
  /// **'답변'**
  String get reply;

  /// No description provided for @repliedOn.
  ///
  /// In ko, this message translates to:
  /// **'답변일: {date}'**
  String repliedOn(String date);

  /// No description provided for @linkPingTeam.
  ///
  /// In ko, this message translates to:
  /// **'LinkPing 팀'**
  String get linkPingTeam;

  /// No description provided for @waitingForReply.
  ///
  /// In ko, this message translates to:
  /// **'답변을 기다리고 있어요.\n답변이 등록되면 알림으로 알려드릴게요!'**
  String get waitingForReply;

  /// No description provided for @linkNotFound.
  ///
  /// In ko, this message translates to:
  /// **'링크를 찾을 수 없어요'**
  String get linkNotFound;

  /// No description provided for @linkLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'링크를 불러오는데 실패했어요'**
  String get linkLoadFailed;

  /// No description provided for @linkNotificationService.
  ///
  /// In ko, this message translates to:
  /// **'링크 알림 서비스'**
  String get linkNotificationService;

  /// No description provided for @timeEditable.
  ///
  /// In ko, this message translates to:
  /// **'시간 수정 가능'**
  String get timeEditable;

  /// No description provided for @lockedTimeDesc.
  ///
  /// In ko, this message translates to:
  /// **'공유자가 설정한 시간 그대로 알림을 받아요'**
  String get lockedTimeDesc;

  /// No description provided for @editableTimeDesc.
  ///
  /// In ko, this message translates to:
  /// **'저장 후 원하는 시간으로 변경할 수 있어요'**
  String get editableTimeDesc;

  /// No description provided for @openInApp.
  ///
  /// In ko, this message translates to:
  /// **'앱에서 열기'**
  String get openInApp;

  /// No description provided for @appRequiredMessage.
  ///
  /// In ko, this message translates to:
  /// **'앱이 설치되어 있어야 해요'**
  String get appRequiredMessage;

  /// No description provided for @openLinkInBrowser.
  ///
  /// In ko, this message translates to:
  /// **'브라우저에서 링크 열기'**
  String get openLinkInBrowser;

  /// No description provided for @viewCount.
  ///
  /// In ko, this message translates to:
  /// **'조회 {count}회'**
  String viewCount(int count);

  /// No description provided for @saveAndChangeTime.
  ///
  /// In ko, this message translates to:
  /// **'저장 후 원하는 시간으로 변경하여 알림 받기'**
  String get saveAndChangeTime;

  /// No description provided for @generatingShareLink.
  ///
  /// In ko, this message translates to:
  /// **'공유 링크 생성 중...'**
  String get generatingShareLink;

  /// No description provided for @onboarding1Title.
  ///
  /// In ko, this message translates to:
  /// **'링크를 저장하세요'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In ko, this message translates to:
  /// **'인스타, 유튜브, 틱톡...\n나중에 볼 링크를 저장해두세요'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In ko, this message translates to:
  /// **'딱 그 시간에 알림!'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In ko, this message translates to:
  /// **'원하는 시간에 알림을 받고\n저장한 링크를 바로 열어요'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In ko, this message translates to:
  /// **'장거리 연애 중?'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In ko, this message translates to:
  /// **'떨어져 있어도 같은 시간에\n넷플릭스 같이 보기'**
  String get onboarding3Desc;

  /// No description provided for @onboarding3Sub.
  ///
  /// In ko, this message translates to:
  /// **'매일 밤 10시, 우리만의 영화 시간'**
  String get onboarding3Sub;

  /// No description provided for @onboarding4Title.
  ///
  /// In ko, this message translates to:
  /// **'매일 성장하고 싶다면'**
  String get onboarding4Title;

  /// No description provided for @onboarding4Desc.
  ///
  /// In ko, this message translates to:
  /// **'아침 7시 TED 강연\n점심시간 영어 공부 유튜브'**
  String get onboarding4Desc;

  /// No description provided for @onboarding4Sub.
  ///
  /// In ko, this message translates to:
  /// **'루틴을 만들어보세요'**
  String get onboarding4Sub;

  /// No description provided for @onboarding5Title.
  ///
  /// In ko, this message translates to:
  /// **'친구와 함께하면'**
  String get onboarding5Title;

  /// No description provided for @onboarding5Desc.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상 같이 따라하기\n스터디 자료 공유하기'**
  String get onboarding5Desc;

  /// No description provided for @onboarding5Sub.
  ///
  /// In ko, this message translates to:
  /// **'함께하면 실천율 95%!'**
  String get onboarding5Sub;

  /// No description provided for @onboarding6Title.
  ///
  /// In ko, this message translates to:
  /// **'지금 시작하세요'**
  String get onboarding6Title;

  /// No description provided for @onboarding6Desc.
  ///
  /// In ko, this message translates to:
  /// **'무료로 2개까지 저장 가능\n프리미엄은 무제한!'**
  String get onboarding6Desc;

  /// No description provided for @loginRequired.
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요합니다'**
  String get loginRequired;

  /// No description provided for @referralCodeQuestion.
  ///
  /// In ko, this message translates to:
  /// **'친구에게 받은 초대 코드가 있나요?'**
  String get referralCodeQuestion;

  /// No description provided for @referralCodeHelperText.
  ///
  /// In ko, this message translates to:
  /// **'8자리 코드를 입력하세요'**
  String get referralCodeHelperText;

  /// No description provided for @southKorea.
  ///
  /// In ko, this message translates to:
  /// **'대한민국'**
  String get southKorea;

  /// No description provided for @poring.
  ///
  /// In ko, this message translates to:
  /// **'포링'**
  String get poring;

  /// No description provided for @poringBalance.
  ///
  /// In ko, this message translates to:
  /// **'포링 잔액'**
  String get poringBalance;

  /// No description provided for @poringEarn.
  ///
  /// In ko, this message translates to:
  /// **'포링 모으기'**
  String get poringEarn;

  /// No description provided for @poringEarnDescription.
  ///
  /// In ko, this message translates to:
  /// **'광고를 시청하면 포링을 받을 수 있어요.\n포링으로 기능을 잠금해제하세요!'**
  String get poringEarnDescription;

  /// No description provided for @poringDailyProgress.
  ///
  /// In ko, this message translates to:
  /// **'오늘 {count}/{max}'**
  String poringDailyProgress(int count, int max);

  /// No description provided for @poringWatchAd.
  ///
  /// In ko, this message translates to:
  /// **'광고 보기 (+1 포링)'**
  String get poringWatchAd;

  /// No description provided for @poringCooldown.
  ///
  /// In ko, this message translates to:
  /// **'다음 광고까지 {seconds}초'**
  String poringCooldown(int seconds);

  /// No description provided for @poringDailyLimitReached.
  ///
  /// In ko, this message translates to:
  /// **'오늘 일일 한도를 다 채웠어요! 내일 다시 오세요.'**
  String get poringDailyLimitReached;

  /// No description provided for @poringDailyLimitThanks.
  ///
  /// In ko, this message translates to:
  /// **'오늘 광고 {max}개를 모두 시청해주셨어요! 감사합니다!'**
  String poringDailyLimitThanks(int max);

  /// No description provided for @poringEarned.
  ///
  /// In ko, this message translates to:
  /// **'포링 +1!'**
  String get poringEarned;

  /// No description provided for @poringUnlock.
  ///
  /// In ko, this message translates to:
  /// **'포링으로 잠금해제'**
  String get poringUnlock;

  /// No description provided for @poringUnlockConfirm.
  ///
  /// In ko, this message translates to:
  /// **'포링 1개를 사용하여 잠금해제할까요?'**
  String get poringUnlockConfirm;

  /// No description provided for @poringNotEnough.
  ///
  /// In ko, this message translates to:
  /// **'포링이 부족합니다'**
  String get poringNotEnough;

  /// No description provided for @poringWatchAdToEarnAndUse.
  ///
  /// In ko, this message translates to:
  /// **'포링이 부족합니다. 광고를 보고 포링을 획득하세요'**
  String get poringWatchAdToEarnAndUse;

  /// No description provided for @poringSpent.
  ///
  /// In ko, this message translates to:
  /// **'포링 사용 완료!'**
  String get poringSpent;

  /// No description provided for @poringPremiumInfinite.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄: 무제한'**
  String get poringPremiumInfinite;

  /// No description provided for @referralAcceptedTitle.
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님이 초대에 응했습니다'**
  String referralAcceptedTitle(String nickname);

  /// No description provided for @referralBonusLink.
  ///
  /// In ko, this message translates to:
  /// **'보너스 링크 +1'**
  String get referralBonusLink;

  /// No description provided for @referralBonusPoring.
  ///
  /// In ko, this message translates to:
  /// **'포링 +{count}'**
  String referralBonusPoring(int count);

  /// No description provided for @poringRewardClaimed.
  ///
  /// In ko, this message translates to:
  /// **'추천 보상 포링 +{count} 수령!'**
  String poringRewardClaimed(int count);

  /// No description provided for @referralAcceptedMessage.
  ///
  /// In ko, this message translates to:
  /// **'초대가 수락되었습니다'**
  String get referralAcceptedMessage;

  /// No description provided for @addTimeWithPoring.
  ///
  /// In ko, this message translates to:
  /// **'알림 시간 추가하기'**
  String get addTimeWithPoring;

  /// No description provided for @poringCostConfirm.
  ///
  /// In ko, this message translates to:
  /// **'포링 1개가 소모됩니다'**
  String get poringCostConfirm;

  /// No description provided for @poringRequiredToSend.
  ///
  /// In ko, this message translates to:
  /// **'메시지를 보내려면 포링 1개가 필요합니다'**
  String get poringRequiredToSend;

  /// No description provided for @deleteTimeConfirm.
  ///
  /// In ko, this message translates to:
  /// **'추가된 알림 시간을 삭제하시겠습니까?'**
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
