import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

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
    Locale('ko'),
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
  /// **'운동하는민수'**
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
  /// **'링크 URL'**
  String get linkUrl;

  /// No description provided for @invalidUrl.
  ///
  /// In ko, this message translates to:
  /// **'올바른 URL을 입력하세요'**
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

  /// No description provided for @premiumBenefitsList.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 혜택:'**
  String get premiumBenefitsList;

  /// No description provided for @premiumBenefit1.
  ///
  /// In ko, this message translates to:
  /// **'무제한 링크 등록'**
  String get premiumBenefit1;

  /// No description provided for @premiumBenefit2.
  ///
  /// In ko, this message translates to:
  /// **'광고 제거'**
  String get premiumBenefit2;

  /// No description provided for @premiumPrice.
  ///
  /// In ko, this message translates to:
  /// **'월 \$2.99 / 평생 \$19.99'**
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
  /// **'무료 버전은 3개까지 등록할 수 있어요.\n프리미엄으로 업그레이드하면 무제한으로 등록할 수 있어요!'**
  String get linkLimitMessage;

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

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

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
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
