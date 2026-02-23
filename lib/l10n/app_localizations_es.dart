// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'LinkPing';

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
    return 'Unete a mi a las $time!\n\n$url\n\nAbrir en LinkPing';
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
  String get soundCategoryAlarmDesc => '멜로디형 (5-15초) · 절대 놓치면 안 되는 중요한 알람에!';

  @override
  String get soundCategoryNotifyDesc => '짧은 효과음 (2-5초) · 가볍게 확인하고 넘어갈 리마인더에!';

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
