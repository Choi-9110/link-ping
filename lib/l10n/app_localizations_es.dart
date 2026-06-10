// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Linkku';

  @override
  String get appSlogan => 'Guarda enlaces, pasa a la accion!';

  @override
  String get login => 'Iniciar sesion';

  @override
  String get loginWithGoogle => 'Continuar con Google';

  @override
  String get loginLoading => 'Iniciando sesion...';

  @override
  String get loginLater => 'Quiza despues';

  @override
  String get loginFailed => 'Error al iniciar sesion';

  @override
  String get guestLoginFailed => 'Error al iniciar como invitado';

  @override
  String get logout => 'Cerrar sesion';

  @override
  String get logoutConfirm => 'Seguro que quieres cerrar sesion?';

  @override
  String get guest => 'Invitado';

  @override
  String get guestSyncMessage =>
      'Inicia sesion con Google para sincronizar tus datos';

  @override
  String get profileSetup => 'Configurar perfil';

  @override
  String get profileSetupTitle => 'Configura tu perfil';

  @override
  String get profileSetupSubtitle =>
      'Esta informacion sera visible para otros usuarios';

  @override
  String get nickname => 'Apodo';

  @override
  String get nicknameHint => 'FitnessMiguel';

  @override
  String get nicknameRequired => 'Por favor ingresa un apodo';

  @override
  String get nicknameMinLength => 'Minimo 2 caracteres';

  @override
  String get nicknameMaxLength => 'Maximo 20 caracteres';

  @override
  String get country => 'Pais';

  @override
  String get complete => 'Listo';

  @override
  String get profileSaveFailed => 'Error al guardar el perfil';

  @override
  String get home => 'Inicio';

  @override
  String get settings => 'Ajustes';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get addLink => 'Agregar enlace';

  @override
  String get editLink => 'Editar enlace';

  @override
  String get deleteLink => 'Eliminar';

  @override
  String get deleteConfirm => 'Eliminar este enlace?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get url => 'URL';

  @override
  String get urlHint => 'https://ejemplo.com';

  @override
  String get urlRequired => 'Por favor ingresa una URL';

  @override
  String get urlInvalid => 'Por favor ingresa una URL valida';

  @override
  String get title => 'Titulo';

  @override
  String get titleHint => 'Rutina de ejercicio diaria';

  @override
  String get titleRequired => 'Por favor ingresa un titulo';

  @override
  String get notificationTime => 'Hora de notificacion';

  @override
  String get repeatDays => 'Dias de repeticion';

  @override
  String get selectRepeatDays => 'Por favor selecciona al menos un dia';

  @override
  String get sun => 'Dom';

  @override
  String get mon => 'Lun';

  @override
  String get tue => 'Mar';

  @override
  String get wed => 'Mie';

  @override
  String get thu => 'Jue';

  @override
  String get fri => 'Vie';

  @override
  String get sat => 'Sab';

  @override
  String get sunday => 'Domingo';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miercoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sabado';

  @override
  String get everyday => 'Diario';

  @override
  String get weekdays => 'Entre semana';

  @override
  String get weekends => 'Fines de semana';

  @override
  String get repeat => 'Repetir';

  @override
  String get linkUrl => 'Enlace o numero de telefono';

  @override
  String get linkUrlHint => 'google.com o +34612345678';

  @override
  String get invalidUrl => 'Por favor ingresa una URL o numero valido';

  @override
  String get reminderTitle => 'Titulo del recordatorio';

  @override
  String get reminderTitleHint => 'Hora de estirar!';

  @override
  String get enterTitle => 'Por favor ingresa un titulo';

  @override
  String get reminderTime => 'Hora del recordatorio';

  @override
  String get addTime => 'Agregar hora';

  @override
  String get addTimePremium => 'Agregar hora (Premium)';

  @override
  String get premiumFeature => 'Funcion Premium';

  @override
  String get multiTimesPremiumMessage =>
      'Actualiza a Premium para configurar\nmultiples horarios para un solo enlace!';

  @override
  String get linkAdded => 'Enlace agregado';

  @override
  String get linkUpdated => 'Enlace actualizado';

  @override
  String get linkDeleted => 'Enlace eliminado';

  @override
  String get emptyStateTitle => 'Aun no hay enlaces';

  @override
  String get emptyStateSubtitle =>
      'Agrega enlaces que quieras visitar regularmente';

  @override
  String get emptyStateButton => 'Agrega tu primer enlace';

  @override
  String savedByCount(int count) {
    return 'Guardado por $count';
  }

  @override
  String get savedByTitle => 'Personas que guardaron este enlace';

  @override
  String get noSavedUsers => 'Nadie lo ha guardado aun';

  @override
  String get me => 'Yo';

  @override
  String get loadFailed => 'Error al cargar';

  @override
  String get cheer => 'Animar';

  @override
  String get tease => 'Provocar';

  @override
  String cheerSent(String nickname) {
    return 'Animaste a $nickname!';
  }

  @override
  String teaseSent(String nickname) {
    return 'Provocaste a $nickname!';
  }

  @override
  String get sendFailed => 'Error al enviar';

  @override
  String get cannotSendToSelf => 'No puedes enviarte a ti mismo';

  @override
  String get noNotifications => 'Aun no hay notificaciones';

  @override
  String get noNotificationsSubtitle =>
      'Cuando alguien te anime o provoque,\naparecera aqui';

  @override
  String get markAllRead => 'Marcar todo como leido';

  @override
  String get cheerReceived => ' te animo!';

  @override
  String get teaseReceived => ' te provoco!';

  @override
  String get notificationLoadFailed => 'Error al cargar notificaciones';

  @override
  String get justNow => 'Ahora mismo';

  @override
  String minutesAgo(int minutes) {
    return 'Hace ${minutes}m';
  }

  @override
  String hoursAgo(int hours) {
    return 'Hace ${hours}h';
  }

  @override
  String daysAgo(int days) {
    return 'Hace ${days}d';
  }

  @override
  String get profile => 'Perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get profileEditNotReady => 'Editar perfil (proximamente)';

  @override
  String get notificationSettings => 'Notificaciones';

  @override
  String get notificationPermission => 'Permitir notificaciones';

  @override
  String get notificationTest => 'Probar notificacion';

  @override
  String get notificationTestSubtitle => 'Enviar una notificacion de prueba';

  @override
  String get notificationTestSent => 'Notificacion de prueba enviada';

  @override
  String get notificationPermissionRequired =>
      'Se requiere permiso de notificaciones';

  @override
  String get premium => 'Premium';

  @override
  String get premiumActive => 'Premium activo';

  @override
  String get premiumPurchase => 'Obtener Premium';

  @override
  String get premiumBenefits => 'Enlaces ilimitados, sin anuncios';

  @override
  String get premiumHeadline => 'No te pierdas ningun momento importante';

  @override
  String get premiumSubtitle => 'Anima a tus seres queridos sin limites';

  @override
  String get premiumBenefit1 => 'Animos y bromas ilimitados';

  @override
  String get premiumBenefit1Desc =>
      'Envia animos a tus amigos sin preocuparte por los Porings';

  @override
  String get premiumBenefit2 => 'Enlaces ilimitados';

  @override
  String get premiumBenefit2Desc =>
      'Ejercicio, estudio, llamadas... crea todos los habitos que quieras';

  @override
  String get premiumBenefit3 => 'Tiempos de alarma ilimitados';

  @override
  String get premiumBenefit3Desc =>
      'Configura alarmas de manana, tarde y noche libremente';

  @override
  String get premiumBenefit4 => 'Porings ilimitados';

  @override
  String get premiumBenefit4Desc =>
      'Usa todas las funciones al instante, sin anuncios';

  @override
  String get premiumBenefit5 => 'Experiencia limpia sin anuncios';

  @override
  String get premiumBenefit5Desc => 'Sin banners ni anuncios de recompensa';

  @override
  String get premiumBenefit6 => 'Todos los sonidos premium';

  @override
  String get premiumBenefit6Desc =>
      'Empieza tu dia con tu tono de alarma favorito';

  @override
  String get premiumPrice => '\$2.99/mes - \$9.99/ano - \$29.99 de por vida';

  @override
  String get premiumLater => 'Despues';

  @override
  String get premiumBuy => 'Comprar';

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
  String get retry => 'Reintentar';

  @override
  String get premiumPaymentNotReady => 'Pagos (proximamente)';

  @override
  String get linkLimitReached => 'Limite de enlaces alcanzado';

  @override
  String get linkLimitMessage =>
      'Los usuarios gratuitos pueden guardar hasta 2 enlaces.\nInvita amigos para +1, o actualiza a Premium para ilimitados!';

  @override
  String get linkLimitMessageBase =>
      'Los usuarios gratuitos pueden guardar hasta 2 enlaces.';

  @override
  String get inviteFriendForBonus => 'Invitar amigos (+1 enlace)';

  @override
  String get inviteFriendBonusDesc =>
      'Obtiene un enlace extra cuando un amigo se una!';

  @override
  String get viewPremium => 'Ver Premium';

  @override
  String get account => 'Cuenta';

  @override
  String get info => 'Informacion';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Politica de privacidad';

  @override
  String get privacyPolicyNotReady => 'Politica de privacidad (proximamente)';

  @override
  String get contact => 'Contactanos';

  @override
  String get contactNotReady => 'Contacto (proximamente)';

  @override
  String get openSourceLicenses => 'Licencias de codigo abierto';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Si';

  @override
  String get no => 'No';

  @override
  String get share => 'Compartir';

  @override
  String get edit => 'Editar';

  @override
  String get copyLink => 'Copiar enlace';

  @override
  String get linkCopied => 'Enlace copiado';

  @override
  String shareMessage(String time, String url) {
    return 'Unete a mi a las $time!\n\n$url\n\nAbrir en Linkku';
  }

  @override
  String get selectAction => 'Elige una accion';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get profileUpdateFailed => 'Error al actualizar el perfil';

  @override
  String get accountLink => 'Vincular cuenta';

  @override
  String get accountLinked => 'Cuenta vinculada';

  @override
  String get accountLinkFailed => 'Error al vincular cuenta';

  @override
  String get kakao => 'KakaoTalk';

  @override
  String get kakaoLinkComingSoon => 'Vinculacion con Kakao (proximamente)';

  @override
  String get guestLinkInfo =>
      'Vincula tu cuenta para sincronizar datos entre dispositivos';

  @override
  String get linked => 'Vinculado';

  @override
  String get link => 'Vincular';

  @override
  String get setEndDate => 'Establecer fecha de fin';

  @override
  String get endDateEnabled => 'Los recordatorios se detendran en esta fecha';

  @override
  String get endDateDisabled => 'Se repite siempre (sin fecha de fin)';

  @override
  String get selectEndDate => 'Seleccionar fecha de fin';

  @override
  String get selectCheerMessage => 'Elige un mensaje de animo';

  @override
  String get selectTeaseMessage => 'Elige un mensaje provocador';

  @override
  String pingRateLimited(int minutes) {
    return 'Puedes enviar de nuevo en $minutes minutos';
  }

  @override
  String get addTimeWithAd => 'Ver anuncio para agregar hora';

  @override
  String get watchAdToAddTime =>
      'Ve un anuncio corto para agregar otro horario.\nLos usuarios Premium pueden agregar horarios sin anuncios!';

  @override
  String get watchAd => 'Ver anuncio';

  @override
  String get adLoadFailed => 'Error al cargar el anuncio';

  @override
  String get timeAddedSuccess => 'Hora agregada';

  @override
  String get inviteFriends => 'Invitar amigos';

  @override
  String get inviteFriendsMessage =>
      'Invita un amigo y obtiene 1 enlace extra!';

  @override
  String get bonusLinkEarned => 'Ganaste un enlace extra!';

  @override
  String get referralCode => 'Codigo de referido';

  @override
  String get copyReferralCode => 'Copiar codigo';

  @override
  String get referralCodeCopied => 'Codigo copiado';

  @override
  String get lockedTime => 'Hora bloqueada';

  @override
  String get unlockTimeWithAd => 'Ver anuncio para desbloquear';

  @override
  String get watchAdToUnlockTime =>
      'Ve un anuncio para activar este horario.\nLos usuarios Premium tienen todos los horarios activados!';

  @override
  String get timeUnlocked => 'Horario desbloqueado';

  @override
  String get shareSettings => 'Configuracion de compartir';

  @override
  String get editable => 'Editable';

  @override
  String get recipientCanChangeTime => 'El destinatario puede cambiar la hora';

  @override
  String get timeLocked => 'Hora fija';

  @override
  String get shareAtThisTime => 'Compartir a esta hora exacta';

  @override
  String get category => 'Categoria';

  @override
  String get consentRequest => 'Solicitud de consentimiento';

  @override
  String get consentRequestMessage =>
      'Solicitar consentimiento de modificacion a los destinatarios.';

  @override
  String get consentNote1 => 'Puede tardar hasta 24 horas';

  @override
  String get consentNote2 => 'Se te notificara cuando se complete';

  @override
  String get consentNote3 => 'Se mantendra la hora original si se rechaza';

  @override
  String get requestConsent => 'Solicitar consentimiento';

  @override
  String get timeLockedAlarm => 'Alarma con hora fija';

  @override
  String receivedSharedAlarmInfo(String nickname) {
    return 'Compartido por $nickname.\nNo se puede cambiar la hora ni los dias de repeticion.';
  }

  @override
  String get sharedToOthersInfo =>
      'Los destinatarios tambien recibiran notificaciones a esta hora.\nSe requiere consentimiento para cambiar la hora.';

  @override
  String get locked => 'Bloqueado';

  @override
  String get badgesAndStats => 'Insignias y estadisticas';

  @override
  String get badgeCollection => 'Coleccion de insignias';

  @override
  String streakDays(int days) {
    return 'Racha de $days dias';
  }

  @override
  String badgesEarned(int count) {
    return '$count obtenidas';
  }

  @override
  String get accountSynced => 'Cuenta sincronizada';

  @override
  String get loginToSync => 'Inicia sesion para sincronizar';

  @override
  String get termsOfService => 'Terminos de servicio';

  @override
  String bonusStatus(int current, int max) {
    return 'Bonus: $current/$max obtenidos';
  }

  @override
  String andMore(int count) {
    return '+$count mas';
  }

  @override
  String get pingWindowClosed =>
      'Solo puedes enviar dentro de 5 minutos despues de tu alarma';

  @override
  String pingWindowActive(String time) {
    return 'Tiempo restante: $time';
  }

  @override
  String get pingFreeRemaining => '1 ping gratis disponible';

  @override
  String get pingWatchAdForMore => 'Ver anuncio para enviar mas';

  @override
  String get premiumUnlimited => 'Ilimitado';

  @override
  String get watchAdToSendMore => 'Ver anuncio para enviar mas';

  @override
  String get watchAdDescription =>
      'Los usuarios gratuitos pueden enviar 1 ping por ventana de alarma.\n¡Ve un anuncio para enviar mas, o actualiza a Premium para ilimitado!';

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
  String get poringBalance => 'Saldo Poring';

  @override
  String get poringEarn => 'Ganar Poring';

  @override
  String get poringEarnDescription =>
      'Mira anuncios para ganar Porings.\n¡Usa Porings para desbloquear funciones!';

  @override
  String poringDailyProgress(int count, int max) {
    return 'Hoy $count/$max';
  }

  @override
  String get poringWatchAd => 'Ver anuncio (+1 Poring)';

  @override
  String poringCooldown(int seconds) {
    return 'Siguiente anuncio en ${seconds}s';
  }

  @override
  String get poringDailyLimitReached =>
      '¡Limite diario alcanzado! Vuelve manana.';

  @override
  String poringDailyLimitThanks(int max) {
    return '¡Has visto los $max anuncios de hoy! ¡Gracias!';
  }

  @override
  String get poringEarned => '¡Poring +1!';

  @override
  String get poringUnlock => 'Desbloquear con Poring';

  @override
  String get poringUnlockConfirm => '¿Usar 1 Poring para desbloquear?';

  @override
  String get poringNotEnough => 'No hay suficientes Porings';

  @override
  String get poringWatchAdToEarnAndUse =>
      'No hay suficientes Porings. Mira un anuncio para ganar Porings';

  @override
  String get poringSpent => '¡Poring usado!';

  @override
  String get poringPremiumInfinite => 'Premium: Ilimitado';

  @override
  String referralAcceptedTitle(String nickname) {
    return '$nickname aceptó tu invitación';
  }

  @override
  String get referralBonusLink => 'Enlace bonus +1';

  @override
  String referralBonusPoring(int count) {
    return 'Poring +$count';
  }

  @override
  String poringRewardClaimed(int count) {
    return '¡Recompensa: Poring +$count reclamado!';
  }

  @override
  String get referralAcceptedMessage => 'Invitación aceptada';

  @override
  String get addTimeWithPoring => 'Añadir hora de alarma';

  @override
  String get poringCostConfirm => 'Se usará 1 Poring';

  @override
  String get poringRequiredToSend =>
      'Se necesita 1 Poring para enviar un mensaje';

  @override
  String get deleteTimeConfirm => '¿Eliminar esta hora de alarma?';
}
