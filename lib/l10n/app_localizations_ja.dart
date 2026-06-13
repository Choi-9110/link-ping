// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Linkku';

  @override
  String get appSlogan => 'リンクを保存して、行動に移そう！';

  @override
  String get login => 'ログイン';

  @override
  String get loginWithGoogle => 'Googleでログイン';

  @override
  String get loginLoading => 'ログイン中...';

  @override
  String get loginLater => '後で';

  @override
  String get loginFailed => 'ログインに失敗しました';

  @override
  String get guestLoginFailed => 'ゲストログインに失敗しました';

  @override
  String get logout => 'ログアウト';

  @override
  String get logoutConfirm => 'ログアウトしますか？';

  @override
  String get guest => 'ゲスト';

  @override
  String get guestSyncMessage => 'Googleでログインしてデータを同期';

  @override
  String get profileSetup => 'プロフィール設定';

  @override
  String get profileSetupTitle => 'プロフィールを設定してください';

  @override
  String get profileSetupSubtitle => 'この情報は他のユーザーに表示されます';

  @override
  String get nickname => 'ニックネーム';

  @override
  String get nicknameHint => 'フィットネス太郎';

  @override
  String get nicknameRequired => 'ニックネームを入力してください';

  @override
  String get nicknameMinLength => '2文字以上で入力してください';

  @override
  String get nicknameMaxLength => '20文字以内で入力してください';

  @override
  String get country => '国';

  @override
  String get complete => '完了';

  @override
  String get profileSaveFailed => 'プロフィールの保存に失敗しました';

  @override
  String get home => 'ホーム';

  @override
  String get settings => '設定';

  @override
  String get notifications => '通知';

  @override
  String get addLink => 'リンクを追加';

  @override
  String get editLink => 'リンクを編集';

  @override
  String get deleteLink => '削除';

  @override
  String get deleteConfirm => 'このリンクを削除しますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get url => 'URL';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get urlRequired => 'URLを入力してください';

  @override
  String get urlInvalid => '有効なURLを入力してください';

  @override
  String get title => 'タイトル';

  @override
  String get titleHint => '毎日のワークアウト';

  @override
  String get titleRequired => 'タイトルを入力してください';

  @override
  String get notificationTime => '通知時間';

  @override
  String get repeatDays => '繰り返し曜日';

  @override
  String get selectRepeatDays => '繰り返す曜日を選択してください';

  @override
  String get sun => '日';

  @override
  String get mon => '月';

  @override
  String get tue => '火';

  @override
  String get wed => '水';

  @override
  String get thu => '木';

  @override
  String get fri => '金';

  @override
  String get sat => '土';

  @override
  String get sunday => '日曜日';

  @override
  String get monday => '月曜日';

  @override
  String get tuesday => '火曜日';

  @override
  String get wednesday => '水曜日';

  @override
  String get thursday => '木曜日';

  @override
  String get friday => '金曜日';

  @override
  String get saturday => '土曜日';

  @override
  String get everyday => '毎日';

  @override
  String get weekdays => '平日';

  @override
  String get weekends => '週末';

  @override
  String get repeat => '繰り返し';

  @override
  String get linkUrl => 'リンクまたは電話番号';

  @override
  String get linkUrlHint => 'google.com または 090-1234-5678';

  @override
  String get invalidUrl => '有効なURLまたは電話番号を入力してください';

  @override
  String get reminderTitle => 'リマインダーのタイトル';

  @override
  String get reminderTitleHint => 'ストレッチの時間！';

  @override
  String get enterTitle => 'タイトルを入力してください';

  @override
  String get reminderTime => 'リマインダー時間';

  @override
  String get addTime => '時間を追加';

  @override
  String get addTimePremium => '時間を追加（プレミアム）';

  @override
  String get premiumFeature => 'プレミアム機能';

  @override
  String get multiTimesPremiumMessage =>
      'プレミアムにアップグレードすると\n1つのリンクに複数の時間を設定できます！';

  @override
  String get linkAdded => 'リンクを追加しました';

  @override
  String get linkUpdated => 'リンクを更新しました';

  @override
  String get linkDeleted => 'リンクを削除しました';

  @override
  String get emptyStateTitle => 'まだリンクがありません';

  @override
  String get emptyStateSubtitle => '定期的にアクセスしたいリンクを追加しましょう';

  @override
  String get emptyStateButton => '最初のリンクを追加';

  @override
  String savedByCount(int count) {
    return '$count人が保存';
  }

  @override
  String get savedByTitle => 'このリンクを保存した人';

  @override
  String get noSavedUsers => 'まだ誰も保存していません';

  @override
  String get me => '自分';

  @override
  String get loadFailed => '読み込みに失敗しました';

  @override
  String get cheer => '応援';

  @override
  String get tease => 'つつく';

  @override
  String cheerSent(String nickname) {
    return '$nicknameさんを応援しました！';
  }

  @override
  String teaseSent(String nickname) {
    return '$nicknameさんをつつきました！';
  }

  @override
  String get sendFailed => '送信に失敗しました';

  @override
  String get cannotSendToSelf => '自分には送れません';

  @override
  String get noNotifications => 'まだ通知がありません';

  @override
  String get noNotificationsSubtitle => '誰かから応援やつつきが届くと\nここに表示されます';

  @override
  String get markAllRead => 'すべて既読にする';

  @override
  String get cheerReceived => 'さんが応援してくれました！';

  @override
  String get teaseReceived => 'さんがつついてきました！';

  @override
  String get notificationLoadFailed => '通知の読み込みに失敗しました';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(int minutes) {
    return '$minutes分前';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours時間前';
  }

  @override
  String daysAgo(int days) {
    return '$days日前';
  }

  @override
  String get profile => 'プロフィール';

  @override
  String get editProfile => 'プロフィールを編集';

  @override
  String get profileEditNotReady => 'プロフィール編集（準備中）';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get notificationPermission => '通知を許可';

  @override
  String get notificationTest => 'テスト通知';

  @override
  String get notificationTestSubtitle => 'テスト通知を送信';

  @override
  String get notificationTestSent => 'テスト通知を送信しました';

  @override
  String get notificationPermissionRequired => '通知の許可が必要です';

  @override
  String get premium => 'プレミアム';

  @override
  String get premiumActive => 'プレミアム利用中';

  @override
  String get premiumPurchase => 'プレミアムを購入';

  @override
  String get premiumBenefits => '無制限リンク、広告なし';

  @override
  String get premiumHeadline => '大切な瞬間を、見逃さないように';

  @override
  String get premiumSubtitle => '大切な人を制限なく応援しましょう';

  @override
  String get premiumBenefit1 => '無制限の応援＆つっつき';

  @override
  String get premiumBenefit1Desc => 'ピン不要で友達にすぐ応援を送れます';

  @override
  String get premiumBenefit2 => 'リンク無制限登録';

  @override
  String get premiumBenefit2Desc => '運動、勉強、電話…好きなだけ習慣を作りましょう';

  @override
  String get premiumBenefit3 => '追加アラーム時間が無制限';

  @override
  String get premiumBenefit3Desc => '1つのリンクに朝・昼・夜のアラームを自由に';

  @override
  String get premiumBenefit4 => 'ピン無制限';

  @override
  String get premiumBenefit4Desc => '広告なしで全ての機能をすぐに使えます';

  @override
  String get premiumBenefit5 => '広告なしのクリーンな体験';

  @override
  String get premiumBenefit5Desc => 'バナーもリワード広告もない綺麗な画面';

  @override
  String get premiumBenefit6 => 'クラウドバックアップ＆同期';

  @override
  String get premiumBenefit6Desc => '機種変更しても保存したリンクがそのまま復元されます';

  @override
  String get premiumPrice => '月額\$2.99 / 年額\$9.99 / 買い切り\$29.99';

  @override
  String get premiumLater => '後で';

  @override
  String get premiumBuy => '購入する';

  @override
  String get premiumMonthly => '月額';

  @override
  String get premiumYearly => '年額';

  @override
  String get premiumLifetime => '買い切り';

  @override
  String get premiumPurchaseSuccess => 'プレミアム購入完了！';

  @override
  String get premiumPurchaseFailed => '購入に失敗しました。再度お試しください。';

  @override
  String get premiumRestoreSuccess => '購入を復元しました！';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get storeNotAvailable => 'ストアを利用できません';

  @override
  String get productsNotFound => '商品を読み込めませんでした';

  @override
  String get retry => '再試行';

  @override
  String get premiumPaymentNotReady => '決済機能（準備中）';

  @override
  String get linkLimitReached => 'リンクの上限に達しました';

  @override
  String get linkLimitMessage => '無料版は2件まで登録できます。\n友達招待で+1件、プレミアムで無制限に！';

  @override
  String get linkLimitMessageBase => '無料版は2件まで登録できます。';

  @override
  String get inviteFriendForBonus => '友達を招待（+1件）';

  @override
  String get inviteFriendBonusDesc => '友達が登録するとボーナスリンクをゲット！';

  @override
  String get viewPremium => 'プレミアムを見る';

  @override
  String get account => 'アカウント';

  @override
  String get info => '情報';

  @override
  String get version => 'バージョン';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get privacyPolicyNotReady => 'プライバシーポリシー（準備中）';

  @override
  String get contact => 'お問い合わせ';

  @override
  String get contactNotReady => 'お問い合わせ（準備中）';

  @override
  String get openSourceLicenses => 'オープンソースライセンス';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get share => '共有';

  @override
  String get edit => '編集';

  @override
  String get copyLink => 'リンクをコピー';

  @override
  String get linkCopied => 'リンクをコピーしました';

  @override
  String shareMessage(String time, String url) {
    return '$timeに一緒にやろう！\n\n$url\n\nLinkkuで開く';
  }

  @override
  String get selectAction => 'アクションを選択';

  @override
  String get profileUpdated => 'プロフィールを更新しました';

  @override
  String get profileUpdateFailed => 'プロフィールの更新に失敗しました';

  @override
  String get accountLink => 'アカウント連携';

  @override
  String get accountLinked => 'アカウントを連携しました';

  @override
  String get accountLinkFailed => 'アカウント連携に失敗しました';

  @override
  String get kakao => 'KakaoTalk';

  @override
  String get kakaoLinkComingSoon => 'Kakao連携（準備中）';

  @override
  String get guestLinkInfo => 'アカウントを連携するとデータを同期できます';

  @override
  String get linked => '連携済み';

  @override
  String get link => '連携';

  @override
  String get setEndDate => '終了日を設定';

  @override
  String get endDateEnabled => 'この日に自動でリマインダーが停止します';

  @override
  String get endDateDisabled => '無期限で繰り返し（終了日なし）';

  @override
  String get selectEndDate => '終了日を選択';

  @override
  String get selectCheerMessage => '応援メッセージを選択';

  @override
  String get selectTeaseMessage => 'つつきメッセージを選択';

  @override
  String pingRateLimited(int minutes) {
    return '$minutes分後に再送信できます';
  }

  @override
  String get addTimeWithAd => '広告を見て時間を追加';

  @override
  String get watchAdToAddTime =>
      '広告を視聴するとリマインダー時間を追加できます。\nプレミアムユーザーは広告なしで無制限に追加可能！';

  @override
  String get watchAd => '広告を見る';

  @override
  String get adLoadFailed => '広告の読み込みに失敗しました';

  @override
  String get timeAddedSuccess => '時間を追加しました';

  @override
  String get inviteFriends => '友達を招待';

  @override
  String get inviteFriendsMessage => '友達を招待するとリンク枠が1つ増えます！';

  @override
  String get bonusLinkEarned => 'ボーナスリンクを獲得しました！';

  @override
  String get referralCode => '招待コード';

  @override
  String get copyReferralCode => '招待コードをコピー';

  @override
  String get referralCodeCopied => '招待コードをコピーしました';

  @override
  String get lockedTime => 'ロック中の時間';

  @override
  String get unlockTimeWithAd => '広告を見て解除';

  @override
  String get watchAdToUnlockTime =>
      '広告を視聴するとこのリマインダー時間を有効化できます。\nプレミアムユーザーはすべての時間が自動で有効になります！';

  @override
  String get timeUnlocked => 'リマインダー時間を解除しました';

  @override
  String get shareSettings => '共有設定';

  @override
  String get editable => '編集可能';

  @override
  String get recipientCanChangeTime => '受信者が時間を変更可能';

  @override
  String get timeLocked => '時間固定';

  @override
  String get shareAtThisTime => 'この時間で共有';

  @override
  String get category => 'カテゴリー';

  @override
  String get consentRequest => '同意リクエスト';

  @override
  String get consentRequestMessage => '受信者に変更の同意をリクエストします。';

  @override
  String get consentNote1 => '最大24時間かかる場合があります';

  @override
  String get consentNote2 => '同意が完了したらお知らせします';

  @override
  String get consentNote3 => '拒否された場合は元の時間が維持されます';

  @override
  String get requestConsent => '同意をリクエスト';

  @override
  String get timeLockedAlarm => '時間固定アラーム';

  @override
  String receivedSharedAlarmInfo(String nickname) {
    return '$nicknameさんから共有されたアラームです。\n通知時間と繰り返し曜日は変更できません。';
  }

  @override
  String get sharedToOthersInfo => '受信者も同じ時間に通知を受け取ります。\n時間を変更するには同意が必要です。';

  @override
  String get locked => 'ロック中';

  @override
  String get badgesAndStats => '実績 & 統計';

  @override
  String get badgeCollection => '実績コレクション';

  @override
  String streakDays(int days) {
    return '$days日連続';
  }

  @override
  String badgesEarned(int count) {
    return '$count個獲得';
  }

  @override
  String get accountSynced => 'アカウント連携済み';

  @override
  String get loginToSync => 'ログインしてデータを同期';

  @override
  String get termsOfService => '利用規約';

  @override
  String bonusStatus(int current, int max) {
    return 'ボーナス: $current/$max獲得';
  }

  @override
  String andMore(int count) {
    return '他$count件';
  }

  @override
  String get pingWindowClosed => 'アラームが鳴ってから5分以内のみ送信できます';

  @override
  String pingWindowActive(String time) {
    return '残り時間: $time';
  }

  @override
  String get pingFreeRemaining => '無料で1回送信可能';

  @override
  String get pingWatchAdForMore => '広告を見てもっと送る';

  @override
  String get premiumUnlimited => '無制限';

  @override
  String get watchAdToSendMore => '広告を見てもっと送る';

  @override
  String get watchAdDescription =>
      '無料ユーザーは1アラームにつき1人にのみ送信できます。\n広告を見て追加送信、またはプレミアムで無制限に！';

  @override
  String get selectProfileEmoji => 'プロフィール絵文字を選択';

  @override
  String get profileEmoji => 'プロフィール絵文字';

  @override
  String get changeEmoji => '絵文字を変更';

  @override
  String get profileEmojiDescription => '他のユーザーに表示される絵文字';

  @override
  String get profileEmojiChanged => 'プロフィール絵文字を変更しました';

  @override
  String get myPhoneNumber => '電話番号';

  @override
  String get phoneNumberNotSet => '未設定';

  @override
  String get editNickname => 'ニックネームを編集';

  @override
  String get enterNickname => 'ニックネームを入力';

  @override
  String get pleaseEnterNickname => 'ニックネームを入力してください';

  @override
  String get minTwoChars => '2文字以上で入力してください';

  @override
  String get nicknameChanged => 'ニックネームを変更しました';

  @override
  String get checkingDuplicate => '確認中...';

  @override
  String get nicknameAlreadyInUse => 'このニックネームは既に使用されています';

  @override
  String get invalidPhoneNumber => '有効な電話番号を入力してください';

  @override
  String get phoneNumberSaved => '電話番号を保存しました';

  @override
  String get phoneNumberDeleted => '電話番号を削除しました';

  @override
  String get changeAccount => 'アカウントを変更';

  @override
  String get changeAccountConfirm => '別のGoogleアカウントに変更しますか？';

  @override
  String get change => '変更';

  @override
  String cheerReceivedFrom(String name) {
    return '$nameさんが応援してくれました！';
  }

  @override
  String teaseReceivedFrom(String name) {
    return '$nameさんがつついてきました！';
  }

  @override
  String get inquiryReplyArrived => 'お問い合わせへの返信が届きました';

  @override
  String get linkAlarmDeleted => 'リンクアラームを削除しました';

  @override
  String get timeModificationRequest => '時間変更リクエスト';

  @override
  String get modificationApproved => '変更が承認されました';

  @override
  String get modificationRejected => '変更が拒否されました';

  @override
  String get alarmTurnedOff => 'アラームがOFFになりました';

  @override
  String get approve => '承認';

  @override
  String get reject => '拒否';

  @override
  String get approved => '承認しました！';

  @override
  String get rejected => '拒否しました。';

  @override
  String get voteFailed => '投票に失敗しました';

  @override
  String get tapToViewReply => 'タップして返信を見る →';

  @override
  String get noResponseWarning => '24時間以内に返答がない場合、アラームはOFFになります';

  @override
  String get inquiry => 'お問い合わせ';

  @override
  String get googleAccountAlreadyLinked => 'このGoogleアカウントは既に別のアカウントに連携されています';

  @override
  String get providerAlreadyLinked => 'Googleアカウントは既に連携されています';

  @override
  String get invalidCredential => '無効な認証情報です';

  @override
  String get networkError => 'ネットワーク接続を確認してください';

  @override
  String get noInquiries => 'お問い合わせはまだありません';

  @override
  String get inquiryHint => '質問がありますか？お問い合わせを送信してください！';

  @override
  String get inquirySubmitted => 'お問い合わせを送信しました';

  @override
  String get inquirySubmitFailed => 'お問い合わせの送信に失敗しました';

  @override
  String get inquiryTitle => 'タイトル';

  @override
  String get inquiryTitleHint => 'お問い合わせのタイトルを入力';

  @override
  String get inquiryTitleRequired => 'タイトルを入力してください';

  @override
  String get inquiryContent => '内容';

  @override
  String get inquiryContentHint => 'お問い合わせ内容を詳しくご記入ください';

  @override
  String get inquiryContentRequired => '内容を入力してください';

  @override
  String get inquiryContentMinLength => '10文字以上で入力してください';

  @override
  String get submitInquiry => 'お問い合わせを送信';

  @override
  String get inquiryResponsePromise => 'できるだけ早くご返信いたします。';

  @override
  String get alarmSound => 'アラーム音';

  @override
  String get selectSoundCategory => 'どんなスタイルの音がいいですか？';

  @override
  String get pingNotificationSound => '通知音';

  @override
  String get pingNotificationSoundDesc => 'つつきと応援の通知音';

  @override
  String get currentSound => '現在のサウンド';

  @override
  String get freeSounds => '無料サウンド';

  @override
  String get premiumSounds => 'プレミアムサウンド';

  @override
  String get premiumSoundsLocked => 'プレミアムで全てのサウンドを解放';

  @override
  String get soundSelected => 'サウンドを選択しました';

  @override
  String get soundNotAvailable => 'サウンドファイルはまだ利用できません';

  @override
  String get alarmSoundDescription => '通知音を選んでください';

  @override
  String get soundCategoryAlarm => 'ロングアラーム';

  @override
  String get soundCategoryNotify => 'クイックエフェクト';

  @override
  String get soundCategoryAlarmDesc => 'メロディアスな曲（5-15秒）・見逃せないアラームに！';

  @override
  String get soundCategoryNotifyDesc => '短いサウンド（2-5秒）・軽くチェックするリマインダーに！';

  @override
  String get currentStreak => '現在の連続日数';

  @override
  String get achievementRate => '達成率';

  @override
  String get badgeCollected => '実績';

  @override
  String longestStreak(int days) {
    return '最長: $days日';
  }

  @override
  String daysCount(int days) {
    return '$days日';
  }

  @override
  String get badgeEarned => '新しい実績獲得！';

  @override
  String get badgeNotYetEarned => 'まだ獲得していません';

  @override
  String badgeEarnedOn(String date) {
    return '$dateに獲得';
  }

  @override
  String badgeProgress(int progress, int target) {
    return '進捗: $progress/$target';
  }

  @override
  String badgeProgressPercent(int percent) {
    return '$percent%達成';
  }

  @override
  String get badge_streak3_name => '3日連続';

  @override
  String get badge_streak3_desc => '3日連続で達成';

  @override
  String get badge_streak7_name => '燃える1週間';

  @override
  String get badge_streak7_desc => '7日連続で達成';

  @override
  String get badge_streak30_name => '情熱の1ヶ月';

  @override
  String get badge_streak30_desc => '30日連続で達成';

  @override
  String get badge_streak100_name => '100日の奇跡';

  @override
  String get badge_streak100_desc => '100日連続で達成';

  @override
  String get badge_marathon_name => 'マラソン';

  @override
  String get badge_marathon_desc => '365日連続で達成！';

  @override
  String get badge_comeback_name => 'カムバック';

  @override
  String get badge_comeback_desc => '連続記録が途切れた後、7日連続で達成';

  @override
  String get badge_quickDraw_name => 'クイックドロー';

  @override
  String get badge_quickDraw_desc => '通知から5秒以内にクリック';

  @override
  String get badge_speedDemon_name => 'スピードデーモン';

  @override
  String get badge_speedDemon_desc => '30秒以内に10回オープン';

  @override
  String get badge_quickResponse_name => 'クイックレスポンス';

  @override
  String get badge_quickResponse_desc => '3分以内に50回オープン';

  @override
  String get badge_morningGlory_name => '朝顔';

  @override
  String get badge_morningGlory_desc => '午前5-7時に5回クリック';

  @override
  String get badge_earlyBird_name => '早起き鳥';

  @override
  String get badge_earlyBird_desc => '午前7時前に10回リンクを開く';

  @override
  String get badge_nightOwl_name => '夜更かしフクロウ';

  @override
  String get badge_nightOwl_desc => '午後11時以降に10回リンクを開く';

  @override
  String get badge_nightShift_name => 'ナイトシフト';

  @override
  String get badge_nightShift_desc => '深夜0時から午前5時の間に5回クリック';

  @override
  String get badge_perfectWeek_name => 'パーフェクトウィーク';

  @override
  String get badge_perfectWeek_desc => '1週間100%達成';

  @override
  String get badge_perfectMonth_name => 'パーフェクトマンス';

  @override
  String get badge_perfectMonth_desc => '1ヶ月100%達成';

  @override
  String get badge_perfectionist_name => '完璧主義者';

  @override
  String get badge_perfectionist_desc => '95%以上の達成率（50回以上）';

  @override
  String get badge_firstCheer_name => '初めての応援';

  @override
  String get badge_firstCheer_desc => '初めて応援を送る';

  @override
  String get badge_cheerLeader_name => 'チアリーダー';

  @override
  String get badge_cheerLeader_desc => '50回応援を送る';

  @override
  String get badge_firstPoke_name => '初めてのつつき';

  @override
  String get badge_firstPoke_desc => '初めてつつきを送る';

  @override
  String get badge_poker_name => 'つつきマスター';

  @override
  String get badge_poker_desc => '50回つつきを送る';

  @override
  String get badge_socialButterfly_name => 'ソーシャルバタフライ';

  @override
  String get badge_socialButterfly_desc => '応援/つつきを10回受け取る';

  @override
  String get badge_firstLink_name => '初めてのリンク';

  @override
  String get badge_firstLink_desc => '最初のリンクを登録';

  @override
  String get badge_linkCollector_name => 'リンクコレクター';

  @override
  String get badge_linkCollector_desc => '10個のリンクを登録';

  @override
  String get badge_linkMaster_name => 'リンクマスター';

  @override
  String get badge_linkMaster_desc => '50個のリンクを登録';

  @override
  String get badge_hotLink_name => 'ホットリンク';

  @override
  String get badge_hotLink_desc => 'あなたのリンクを10人以上が保存';

  @override
  String get badge_variety_name => 'バラエティ';

  @override
  String get badge_variety_desc => '5つ以上の異なるドメインのリンク';

  @override
  String get badge_founder_name => 'ファウンダー';

  @override
  String get badge_founder_desc => '初期ユーザー';

  @override
  String get badge_premium_name => 'プレミアム';

  @override
  String get badge_premium_desc => 'プレミアム登録';

  @override
  String get badge_badgeCollector_name => '実績コレクター';

  @override
  String get badge_badgeCollector_desc => '10個の実績を獲得';

  @override
  String get badge_cloudSynced_name => 'クラウド同期';

  @override
  String get badge_cloudSynced_desc => 'アカウント連携でデータを同期';

  @override
  String get premiumSoundUnlock => 'プレミアムサウンド';

  @override
  String get premiumSoundUnlockDesc =>
      'このサウンドはプレミアム専用です。\n広告を視聴するかプレミアムに登録してください。';

  @override
  String get watchAdToUnlock => '広告を見て使用';

  @override
  String get upgradeToPremium => 'プレミアムを取得';

  @override
  String get adNotReady => '広告を読み込み中です。しばらくしてから再度お試しください。';

  @override
  String get adWatchSuccess => '広告完了！サウンドが適用されました。';

  @override
  String get earnedBadges => '獲得した実績';

  @override
  String get skip => 'スキップ';

  @override
  String get next => '次へ';

  @override
  String get getStarted => '始める';

  @override
  String get done => '完了';

  @override
  String get send => '送信';

  @override
  String get close => '閉じる';

  @override
  String get confirm => '確認';

  @override
  String get notSet => '未設定';

  @override
  String get inquiryDetail => 'お問い合わせ詳細';

  @override
  String get inquiryNotFound => 'お問い合わせが見つかりません';

  @override
  String get reply => '返信';

  @override
  String repliedOn(String date) {
    return '返信日: $date';
  }

  @override
  String get linkPingTeam => 'Linkkuチーム';

  @override
  String get waitingForReply => '返信をお待ちください。\n返信が届いたらお知らせします！';

  @override
  String get linkNotFound => 'リンクが見つかりません';

  @override
  String get linkLoadFailed => 'リンクの読み込みに失敗しました';

  @override
  String get linkNotificationService => 'リンク通知サービス';

  @override
  String get timeEditable => '時間変更可能';

  @override
  String get lockedTimeDesc => '共有者が設定した時間に通知を受け取ります';

  @override
  String get editableTimeDesc => '保存後に時間を変更できます';

  @override
  String get openInApp => 'アプリで開く';

  @override
  String get appRequiredMessage => 'アプリのインストールが必要です';

  @override
  String get openLinkInBrowser => 'ブラウザでリンクを開く';

  @override
  String viewCount(int count) {
    return '閲覧数: $count';
  }

  @override
  String get saveAndChangeTime => '保存してお好みの時間に変更';

  @override
  String get generatingShareLink => '共有リンクを生成中...';

  @override
  String get onboarding1Title => 'リンクを保存';

  @override
  String get onboarding1Desc => 'Instagram、YouTube、TikTok...\n後で見るリンクを保存';

  @override
  String get onboarding2Title => '時間通りに通知！';

  @override
  String get onboarding2Desc => 'お好みの時間に通知を受け取り\n保存したリンクをすぐに開く';

  @override
  String get onboarding3Title => '遠距離恋愛中？';

  @override
  String get onboarding3Desc => '離れていても同じ時間に\n一緒にNetflixを見よう';

  @override
  String get onboarding3Sub => '毎晩10時、二人の映画タイム';

  @override
  String get onboarding4Title => '毎日成長したい？';

  @override
  String get onboarding4Desc => '朝7時のTEDトーク\n昼休みの英語学習動画';

  @override
  String get onboarding4Sub => 'ルーティンを作ろう';

  @override
  String get onboarding5Title => '友達と一緒に';

  @override
  String get onboarding5Desc => '一緒にワークアウト動画を見たり\n勉強資料を共有したり';

  @override
  String get onboarding5Sub => '一緒だと成功率95%！';

  @override
  String get onboarding6Title => '今すぐ始めよう';

  @override
  String get onboarding6Desc => '無料で2つまでリンク保存\nプレミアムで無制限！';

  @override
  String get loginRequired => 'ログインが必要です';

  @override
  String get referralCodeQuestion => '友達から招待コードをもらいましたか？';

  @override
  String get referralCodeHelperText => '8文字のコードを入力';

  @override
  String get southKorea => '韓国';

  @override
  String get poring => 'ピン';

  @override
  String get poringBalance => 'ピン残高';

  @override
  String get poringEarn => 'ピンを集める';

  @override
  String get poringEarnDescription => '広告を視聴してピンをゲット。\nピンで機能をアンロック！';

  @override
  String poringDailyProgress(int count, int max) {
    return '今日 $count/$max';
  }

  @override
  String get poringWatchAd => '広告を見る (+1ピン)';

  @override
  String poringCooldown(int seconds) {
    return '次の広告まで $seconds秒';
  }

  @override
  String get poringDailyLimitReached => '今日の上限に達しました！明日また来てください。';

  @override
  String poringDailyLimitThanks(int max) {
    return '今日は広告$max本を全て視聴していただきました！ありがとうございます！';
  }

  @override
  String get poringEarned => 'ピン +1！';

  @override
  String get poringUnlock => 'ピンでアンロック';

  @override
  String get poringUnlockConfirm => 'ピン1個を使ってアンロックしますか？';

  @override
  String get poringNotEnough => 'ピンが足りません';

  @override
  String get poringWatchAdToEarnAndUse => 'ピンが足りません。広告を見てピンを獲得しましょう';

  @override
  String get poringSpent => 'ピン使用完了！';

  @override
  String get poringPremiumInfinite => 'プレミアム：無制限';

  @override
  String referralAcceptedTitle(String nickname) {
    return '$nicknameさんが招待に応じました';
  }

  @override
  String get referralBonusLink => 'ボーナスリンク +1';

  @override
  String referralBonusPoring(int count) {
    return 'ピン +$count';
  }

  @override
  String poringRewardClaimed(int count) {
    return '紹介報酬 ピン +$count 受取！';
  }

  @override
  String get referralAcceptedMessage => '招待が承諾されました';

  @override
  String get addTimeWithPoring => '通知時間を追加する';

  @override
  String get poringCostConfirm => 'ピン1個が消費されます';

  @override
  String get poringRequiredToSend => 'メッセージを送るにはピン1個が必要です';

  @override
  String get deleteTimeConfirm => 'この通知時間を削除しますか？';

  @override
  String get linkkuDexTitle => 'Linkku図鑑';

  @override
  String get linkkuDexCollect => 'Linkkuを集めよう';

  @override
  String get linkkuDexComingHint => '新しい仲間が少しずつやってきます。';

  @override
  String get linkkuDexDefault => '基本';

  @override
  String get linkkuDexComingSoon => '近日登場';

  @override
  String get linkkuDexSubtitle => 'ベル付きのアラームスライム';

  @override
  String get linkkuPersonality => '性格';

  @override
  String get linkkuTraitCaring => 'やさしい';

  @override
  String get linkkuTraitAttentive => '気配り上手';

  @override
  String get linkkuPersonalityDesc =>
      '約束の時間を絶対に忘れないやさしい友だち。\nもうすぐそれぞれ性格がついて、あなたのLinkkuは話し方まで変わります。';

  @override
  String get linkkuWhatsNext => 'これから';

  @override
  String get linkkuWhatsNextDesc => '育てて、着せ替えて、新しい仲間を集める機能が少しずつやってきます。🥚';

  @override
  String get phoneSignIn => '電話番号でログイン';

  @override
  String get phoneEnterCode => '認証コードを入力';

  @override
  String get phoneEnterNumber => '電話番号を入力してください';

  @override
  String get phoneNumberLabel => '電話番号';

  @override
  String get phoneSendCode => 'コードを送信';

  @override
  String get phoneConfirm => '確認';

  @override
  String get phoneChangeNumber => '番号を変更';

  @override
  String get phoneCodeSent => '認証コードを送りました';

  @override
  String get phoneSendFailed => '認証コードの送信に失敗しました';

  @override
  String get phoneVerifyFailed => '認証に失敗しました';

  @override
  String get phoneGenericError => 'エラーが発生しました';

  @override
  String get deleteAccount => '退会（アカウント削除）';

  @override
  String get deleteAccountConfirm =>
      '本当に退会しますか？アカウント・リンク・統計・認証動画がすべて削除され、復元できません。';

  @override
  String get deleteAccountReauth => 'セキュリティのため、再ログイン後にもう一度お試しください。';

  @override
  String get deleteAccountFailed => '退会処理に失敗しました。しばらくしてからもう一度お試しください。';

  @override
  String get ringModeTitle => 'どうつなげますか？';

  @override
  String get ringModeAllName => 'みんなリング';

  @override
  String get ringModeAllDesc => 'リンクを持つ全員と一緒に';

  @override
  String get ringModeChainName => 'リレーリング';

  @override
  String get ringModeChainDesc => '共有した相手と一緒に';

  @override
  String get ringModeFixedNote => '一度決めるとこのアラームはずっと同じ方式です';

  @override
  String get ringModeHelpTooltip => '詳しい説明';

  @override
  String get ringModeHelpTitle => '何が違うの？';

  @override
  String get ringModeHelpBody =>
      '🔗 みんなリング\nAが作ってBへ、BがCへ渡すと\n→ A・B・C全員がひとつのグループに。\n全員がお互いの3秒認証を見て応援できます。\n\n🤝 リレーリング\nA → B → C → D の順で渡ると\n→ CにはB（くれた人）とD（渡した人）だけ見えます。Aは見えません。\n自分の3秒認証も直接やり取りした相手にだけ表示されます。\n\n💡 認証動画が誰に見えるかが変わります。\n家族や親しい友達と静かに = リレーリング、\nクルーや勉強会でみんなと = みんなリング！';

  @override
  String get ringModeHelpOk => 'わかった！';

  @override
  String get ringBannerAll => '🔗 みんなリング — リンクを持つ全員に認証が表示されます';

  @override
  String get ringBannerChain => '🤝 リレーリング — 共有した相手にだけ認証が表示されます';

  @override
  String get shareAlreadySaved => 'すでに保存済みのアラームです';

  @override
  String get shareNotFound => '共有リンクが見つかりません';

  @override
  String get shareDuplicateAlarm => '同じアラームがすでにあります';

  @override
  String shareRepeatWeekly(int count) {
    return '週$count回';
  }

  @override
  String get shareArrivedTitle => '共有アラームが届きました 💌';

  @override
  String shareArrivedWith(String nickname) {
    return '$nicknameさんと同じ時間に通知が届きます';
  }

  @override
  String get shareLater => 'あとで';

  @override
  String get shareAddToMyAlarms => 'マイアラームに追加';

  @override
  String get shareKeptInInbox => '📥 通知タブの「共有リンク」に保管しました';

  @override
  String get shareAddedTogether => 'アラームを追加しました！同じ時間に一緒に 🔔';

  @override
  String get shareAddFailed => '追加できませんでした';

  @override
  String get slotFullTitle => 'アラーム枠がいっぱいです';

  @override
  String get slotFullAdBody =>
      '無料のアラーム枠がすべて使用中です。\n広告を見るとこの共有アラームを追加できます！\n\n（プレミアムは広告なしで無制限 ✨）';

  @override
  String get slotFullLater => 'あとで';

  @override
  String get slotFullWatchAd => '広告を見て追加';

  @override
  String get adNotCompleted => '広告の視聴が完了しませんでした';

  @override
  String inboxSectionTitle(int count) {
    return '📥 共有リンク（$count）';
  }

  @override
  String inboxFrom(String nickname, String time) {
    return '$nicknameさんから · ⏰ $time';
  }

  @override
  String get inboxDecline => '拒否';

  @override
  String get inboxAdd => '追加';

  @override
  String pingCheerToast(String nickname) {
    return '📣 $nicknameさんが応援を送りました！';
  }

  @override
  String pingPokeToast(String nickname) {
    return '👉 $nicknameさんがつつきました！';
  }

  @override
  String get pingReferralToast => '🎁 友達があなたのコードで登録しました！';

  @override
  String get pingInquiryToast => '💬 お問い合わせに回答が届きました';

  @override
  String get pingGenericToast => '🔔 新しい通知が届きました';

  @override
  String get proofGalleryTitle => '認証ギャラリー';

  @override
  String get proofLoadFailed => '読み込めませんでした。引っ張って更新';

  @override
  String get proofNoSharedAlarms => 'まだ一緒の約束がありません';

  @override
  String get proofNoSharedAlarmsHint => 'リンクを友達に共有すると\nここでお互いの3秒認証を集められます 💪';

  @override
  String proofLatest(String time) {
    return '最新 $time';
  }

  @override
  String get proofNoneYet => 'まだ認証なし';

  @override
  String get proofRecordMine => '私も認証する';

  @override
  String proofVerifyWindowClosed(int minutes) {
    return 'アラームが鳴ってから$minutes分以内にだけ認証できます';
  }

  @override
  String get proofMineBadge => '自分';

  @override
  String timeAgoMinutes(int count) {
    return '$count分前';
  }

  @override
  String timeAgoHours(int count) {
    return '$count時間前';
  }

  @override
  String timeAgoDays(int count) {
    return '$count日前';
  }

  @override
  String get guestPurchaseTitle => 'アカウント連携が必要です';

  @override
  String get guestPurchaseBody =>
      '購入履歴を安全に保管するため、\n先にGoogleまたはAppleアカウントを連携してください。\n\n連携してもアラームや記録はそのまま残ります！';

  @override
  String get guestPurchaseLink => '連携しに行く';

  @override
  String get lockedSlotTitle => 'ロック中のアラーム枠';

  @override
  String get lockedSlotSubtitle => '友達招待で+1 · プレミアムは無制限';

  @override
  String get dayChipLabels => '月,火,水,木,金,土,日';

  @override
  String get cameraNotFound => 'カメラが見つかりません';

  @override
  String cameraInitFailed(String error) {
    return 'カメラ初期化に失敗: $error';
  }

  @override
  String recordStartFailed(String error) {
    return '録画開始に失敗: $error';
  }

  @override
  String recordStopFailed(String error) {
    return '録画停止に失敗: $error';
  }

  @override
  String proofDeleteFailed(String error) {
    return '削除に失敗: $error';
  }

  @override
  String get shareRepeatDaily => '毎日';
}
