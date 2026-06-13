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
      'Envia animos a tus amigos sin preocuparte por los Pings';

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
  String get premiumBenefit4 => 'Pings ilimitados';

  @override
  String get premiumBenefit4Desc =>
      'Usa todas las funciones al instante, sin anuncios';

  @override
  String get premiumBenefit5 => 'Experiencia limpia sin anuncios';

  @override
  String get premiumBenefit5Desc => 'Sin banners ni anuncios de recompensa';

  @override
  String get premiumBenefit6 => 'Copia en la nube y sincronización';

  @override
  String get premiumBenefit6Desc =>
      'Cambia de teléfono y tus enlaces se restauran solos';

  @override
  String get premiumPrice => '\$2.99/mes - \$9.99/ano - \$29.99 de por vida';

  @override
  String get premiumLater => 'Despues';

  @override
  String get premiumBuy => 'Comprar';

  @override
  String get premiumMonthly => 'Mensual';

  @override
  String get premiumYearly => 'Anual';

  @override
  String get premiumLifetime => 'De por vida';

  @override
  String get premiumPurchaseSuccess => '¡Compra premium completada!';

  @override
  String get premiumPurchaseFailed => 'La compra falló. Inténtalo de nuevo.';

  @override
  String get premiumRestoreSuccess => '¡Compras restauradas con éxito!';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get storeNotAvailable => 'La tienda no está disponible';

  @override
  String get productsNotFound => 'No se pudieron cargar los productos';

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
  String get badgesAndStats => 'Logros y estadisticas';

  @override
  String get badgeCollection => 'Coleccion de logros';

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
  String get pingFreeRemaining => '1 toque gratis disponible';

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
  String get selectProfileEmoji => 'Elige tu emoji de perfil';

  @override
  String get profileEmoji => 'Emoji de perfil';

  @override
  String get changeEmoji => 'Cambiar emoji';

  @override
  String get profileEmojiDescription => 'Emoji de perfil que verán los demás';

  @override
  String get profileEmojiChanged => 'Emoji de perfil cambiado';

  @override
  String get myPhoneNumber => 'Mi número de teléfono';

  @override
  String get phoneNumberNotSet => 'Sin definir';

  @override
  String get editNickname => 'Editar apodo';

  @override
  String get enterNickname => 'Escribe tu apodo';

  @override
  String get pleaseEnterNickname => 'Escribe un apodo, por favor';

  @override
  String get minTwoChars => 'Necesitas al menos 2 caracteres';

  @override
  String get nicknameChanged => '¡Apodo cambiado!';

  @override
  String get checkingDuplicate => 'Comprobando...';

  @override
  String get nicknameAlreadyInUse => 'Ese apodo ya está en uso';

  @override
  String get invalidPhoneNumber => 'Introduce un número de teléfono válido';

  @override
  String get phoneNumberSaved => '¡Número de teléfono guardado!';

  @override
  String get phoneNumberDeleted => 'Número de teléfono eliminado';

  @override
  String get changeAccount => 'Cambiar de cuenta';

  @override
  String get changeAccountConfirm =>
      '¿Quieres cambiar a otra cuenta de Google?';

  @override
  String get change => 'Cambiar';

  @override
  String cheerReceivedFrom(String name) {
    return '¡$name te ha animado!';
  }

  @override
  String teaseReceivedFrom(String name) {
    return '¡$name te ha picado!';
  }

  @override
  String get inquiryReplyArrived => 'Llegó la respuesta a tu consulta';

  @override
  String get linkAlarmDeleted => 'Recordatorio de enlace eliminado';

  @override
  String get timeModificationRequest => 'Solicitud para cambiar la hora';

  @override
  String get modificationApproved => 'Cambio aprobado';

  @override
  String get modificationRejected => 'Cambio rechazado';

  @override
  String get alarmTurnedOff => 'El recordatorio se ha DESACTIVADO';

  @override
  String get approve => 'Aprobar';

  @override
  String get reject => 'Rechazar';

  @override
  String get approved => '¡Aprobado!';

  @override
  String get rejected => 'Rechazado.';

  @override
  String get voteFailed => 'No se pudo votar';

  @override
  String get tapToViewReply => 'Toca para ver la respuesta →';

  @override
  String get noResponseWarning =>
      'El recordatorio se DESACTIVARÁ si no respondes en 24 horas';

  @override
  String get inquiry => 'Consulta';

  @override
  String get googleAccountAlreadyLinked =>
      'Esta cuenta de Google ya está vinculada a otra cuenta';

  @override
  String get providerAlreadyLinked =>
      'Ya tienes una cuenta de Google vinculada';

  @override
  String get invalidCredential => 'Las credenciales no son válidas';

  @override
  String get networkError => 'Revisa tu conexión a internet';

  @override
  String get noInquiries => 'Todavía no hay consultas';

  @override
  String get inquiryHint => '¿Tienes alguna duda? ¡Escríbenos!';

  @override
  String get inquirySubmitted => 'Consulta enviada';

  @override
  String get inquirySubmitFailed => 'No se pudo enviar la consulta';

  @override
  String get inquiryTitle => 'Título';

  @override
  String get inquiryTitleHint => 'Escribe el título de tu consulta';

  @override
  String get inquiryTitleRequired => 'Escribe un título, por favor';

  @override
  String get inquiryContent => 'Contenido';

  @override
  String get inquiryContentHint => 'Cuéntanos tu consulta con detalle';

  @override
  String get inquiryContentRequired => 'Escribe el contenido, por favor';

  @override
  String get inquiryContentMinLength => 'Escribe al menos 10 caracteres';

  @override
  String get submitInquiry => 'Enviar consulta';

  @override
  String get inquiryResponsePromise =>
      'Responderemos a tu consulta lo antes posible.';

  @override
  String get alarmSound => 'Sonido de alarma';

  @override
  String get selectSoundCategory => '¿Qué estilo de sonido prefieres?';

  @override
  String get pingNotificationSound => 'Sonido de picar';

  @override
  String get pingNotificationSoundDesc =>
      'Sonido para las notificaciones de picar y animar';

  @override
  String get currentSound => 'Sonido actual';

  @override
  String get freeSounds => 'Sonidos gratis';

  @override
  String get premiumSounds => 'Sonidos premium';

  @override
  String get premiumSoundsLocked =>
      'Pásate a Premium para desbloquear todos los sonidos';

  @override
  String get soundSelected => '¡Sonido seleccionado!';

  @override
  String get soundNotAvailable => 'Este sonido todavía no está disponible';

  @override
  String get alarmSoundDescription => 'Elige tu sonido de notificación';

  @override
  String get soundCategoryAlarm => 'Alarma larga';

  @override
  String get soundCategoryNotify => 'Efecto rápido';

  @override
  String get soundCategoryAlarmDesc =>
      'Con melodía\n(5-15 s)\nPara alarmas que no te puedes perder';

  @override
  String get soundCategoryNotifyDesc =>
      'Efecto corto\n(2-5 s)\nPara recordatorios rápidos';

  @override
  String get currentStreak => 'Racha actual';

  @override
  String get achievementRate => 'Logro';

  @override
  String get badgeCollected => 'Logros';

  @override
  String longestStreak(int days) {
    return 'La más larga: $days días';
  }

  @override
  String daysCount(int days) {
    return '$days días';
  }

  @override
  String get badgeEarned => '¡NUEVO logro!';

  @override
  String get badgeNotYetEarned => 'Aún sin conseguir';

  @override
  String badgeEarnedOn(String date) {
    return 'Conseguido el $date';
  }

  @override
  String badgeProgress(int progress, int target) {
    return 'Progreso: $progress/$target';
  }

  @override
  String badgeProgressPercent(int percent) {
    return '$percent% completado';
  }

  @override
  String get badge_streak3_name => 'Racha de 3 días';

  @override
  String get badge_streak3_desc => 'Consigue 3 días seguidos';

  @override
  String get badge_streak7_name => 'Semana en llamas';

  @override
  String get badge_streak7_desc => 'Consigue 7 días seguidos';

  @override
  String get badge_streak30_name => 'Mes de pasión';

  @override
  String get badge_streak30_desc => 'Consigue 30 días seguidos';

  @override
  String get badge_streak100_name => 'Milagro de 100 días';

  @override
  String get badge_streak100_desc => 'Consigue 100 días seguidos';

  @override
  String get badge_marathon_name => 'Maratón';

  @override
  String get badge_marathon_desc => '¡Consigue 365 días seguidos!';

  @override
  String get badge_comeback_name => 'Regreso';

  @override
  String get badge_comeback_desc => 'Consigue 7 días tras perder la racha';

  @override
  String get badge_quickDraw_name => 'Disparo rápido';

  @override
  String get badge_quickDraw_desc =>
      'Pulsa en los 5 segundos tras la notificación';

  @override
  String get badge_speedDemon_name => 'Demonio de la velocidad';

  @override
  String get badge_speedDemon_desc => 'Abre en menos de 30 segundos 10 veces';

  @override
  String get badge_quickResponse_name => 'Respuesta rápida';

  @override
  String get badge_quickResponse_desc => 'Abre en menos de 3 minutos 50 veces';

  @override
  String get badge_morningGlory_name => 'Gloria mañanera';

  @override
  String get badge_morningGlory_desc =>
      'Pulsa entre las 5 y las 7 de la mañana 5 veces';

  @override
  String get badge_earlyBird_name => 'Madrugador';

  @override
  String get badge_earlyBird_desc =>
      'Abre enlaces antes de las 7 de la mañana 10 veces';

  @override
  String get badge_nightOwl_name => 'Búho nocturno';

  @override
  String get badge_nightOwl_desc =>
      'Abre enlaces después de las 11 de la noche 10 veces';

  @override
  String get badge_nightShift_name => 'Turno de noche';

  @override
  String get badge_nightShift_desc =>
      'Pulsa entre medianoche y las 5 de la mañana 5 veces';

  @override
  String get badge_perfectWeek_name => 'Semana perfecta';

  @override
  String get badge_perfectWeek_desc =>
      '100% de cumplimiento durante una semana';

  @override
  String get badge_perfectMonth_name => 'Mes perfecto';

  @override
  String get badge_perfectMonth_desc => '100% de cumplimiento durante un mes';

  @override
  String get badge_perfectionist_name => 'Perfeccionista';

  @override
  String get badge_perfectionist_desc =>
      '95% o más de cumplimiento (más de 50 veces)';

  @override
  String get badge_firstCheer_name => 'Primer ánimo';

  @override
  String get badge_firstCheer_desc => 'Envía tu primer ánimo';

  @override
  String get badge_cheerLeader_name => 'Animador';

  @override
  String get badge_cheerLeader_desc => 'Envía 50 ánimos';

  @override
  String get badge_firstPoke_name => 'Primer toque';

  @override
  String get badge_firstPoke_desc => 'Envía tu primer toque';

  @override
  String get badge_poker_name => 'Maestro del toque';

  @override
  String get badge_poker_desc => 'Envía 50 toques';

  @override
  String get badge_socialButterfly_name => 'Mariposa social';

  @override
  String get badge_socialButterfly_desc => 'Recibe 10 ánimos o toques';

  @override
  String get badge_firstLink_name => 'Primer enlace';

  @override
  String get badge_firstLink_desc => 'Registra tu primer enlace';

  @override
  String get badge_linkCollector_name => 'Coleccionista de enlaces';

  @override
  String get badge_linkCollector_desc => 'Registra 10 enlaces';

  @override
  String get badge_linkMaster_name => 'Maestro de enlaces';

  @override
  String get badge_linkMaster_desc => 'Registra 50 enlaces';

  @override
  String get badge_hotLink_name => 'Enlace popular';

  @override
  String get badge_hotLink_desc => 'Más de 10 personas guardaron tu enlace';

  @override
  String get badge_variety_name => 'Variedad';

  @override
  String get badge_variety_desc => 'Más de 5 enlaces de dominios distintos';

  @override
  String get badge_founder_name => 'Fundador';

  @override
  String get badge_founder_desc => 'Usuario inicial de la app';

  @override
  String get badge_premium_name => 'Premium';

  @override
  String get badge_premium_desc => 'Suscripción premium';

  @override
  String get badge_badgeCollector_name => 'Coleccionista de logros';

  @override
  String get badge_badgeCollector_desc => 'Consigue 10 logros';

  @override
  String get badge_cloudSynced_name => 'Sincronizado en la nube';

  @override
  String get badge_cloudSynced_desc =>
      'Sincroniza tus datos vinculando tu cuenta';

  @override
  String get premiumSoundUnlock => 'Sonido premium';

  @override
  String get premiumSoundUnlockDesc =>
      'Este sonido es solo premium.\nMira un anuncio o suscríbete a premium.';

  @override
  String get watchAdToUnlock => 'Ver anuncio para usar';

  @override
  String get upgradeToPremium => 'Conseguir Premium';

  @override
  String get adNotReady =>
      'El anuncio se está cargando. Inténtalo en un momento.';

  @override
  String get adWatchSuccess =>
      '¡Anuncio completado! El sonido ya está aplicado.';

  @override
  String get earnedBadges => 'Mis logros';

  @override
  String get skip => 'Saltar';

  @override
  String get next => 'Siguiente';

  @override
  String get getStarted => 'Empezar';

  @override
  String get done => 'Listo';

  @override
  String get send => 'Enviar';

  @override
  String get close => 'Cerrar';

  @override
  String get confirm => 'Aceptar';

  @override
  String get notSet => 'Sin definir';

  @override
  String get inquiryDetail => 'Detalles de la consulta';

  @override
  String get inquiryNotFound => 'No se encontró la consulta';

  @override
  String get reply => 'Respuesta';

  @override
  String repliedOn(String date) {
    return 'Respondida el: $date';
  }

  @override
  String get linkPingTeam => 'Equipo de Linkku';

  @override
  String get waitingForReply =>
      'Estamos preparando tu respuesta.\n¡Te avisaremos en cuanto esté lista!';

  @override
  String get linkNotFound => 'No se encontró el enlace';

  @override
  String get linkLoadFailed => 'No se pudo cargar el enlace';

  @override
  String get linkNotificationService => 'Servicio de notificación de enlaces';

  @override
  String get timeEditable => 'Puedes cambiar la hora';

  @override
  String get lockedTimeDesc =>
      'Recibirás las notificaciones a la hora que fijó quien lo compartió';

  @override
  String get editableTimeDesc => 'Podrás cambiar la hora después de guardar';

  @override
  String get openInApp => 'Abrir en la app';

  @override
  String get appRequiredMessage => 'Necesitas tener la app instalada';

  @override
  String get openLinkInBrowser => 'Abrir enlace en el navegador';

  @override
  String viewCount(int count) {
    return '$count vistas';
  }

  @override
  String get saveAndChangeTime => 'Guarda y cámbialo a la hora que prefieras';

  @override
  String get generatingShareLink => 'Creando enlace para compartir...';

  @override
  String get onboarding1Title => 'Guarda tus enlaces';

  @override
  String get onboarding1Desc =>
      'Instagram, YouTube, TikTok...\nGuarda enlaces para verlos más tarde';

  @override
  String get onboarding2Title => '¡Recibe el aviso justo a tiempo!';

  @override
  String get onboarding2Desc =>
      'Recibe notificaciones a la hora que prefieras\ny abre tus enlaces guardados al instante';

  @override
  String get onboarding3Title => '¿En una relación a distancia?';

  @override
  String get onboarding3Desc =>
      'Mirad Netflix juntos\na la misma hora, aunque estéis lejos';

  @override
  String get onboarding3Sub =>
      'Cada noche a las 22:00, nuestro momento de pelis';

  @override
  String get onboarding4Title => '¿Quieres crecer cada día?';

  @override
  String get onboarding4Desc =>
      'Una charla TED a las 7\nun vídeo de inglés a la hora de comer';

  @override
  String get onboarding4Sub => 'Crea tu rutina';

  @override
  String get onboarding5Title => 'Mejor con amigos';

  @override
  String get onboarding5Desc =>
      'Seguid vídeos de ejercicio juntos\nComparte material de estudio';

  @override
  String get onboarding5Sub => '¡95% de éxito cuando lo hacéis juntos!';

  @override
  String get onboarding6Title => 'Empieza ya';

  @override
  String get onboarding6Desc =>
      'Guarda hasta 2 enlaces gratis\n¡Premium para enlaces ilimitados!';

  @override
  String get loginRequired => 'Necesitas iniciar sesión';

  @override
  String get referralCodeQuestion =>
      '¿Un amigo te dio un código de invitación?';

  @override
  String get referralCodeHelperText => 'Introduce el código de 8 caracteres';

  @override
  String get southKorea => 'Corea del Sur';

  @override
  String get poring => 'Ping';

  @override
  String get poringBalance => 'Saldo Ping';

  @override
  String get poringEarn => 'Ganar Ping';

  @override
  String get poringEarnDescription =>
      'Mira anuncios para ganar Pings.\n¡Usa Pings para desbloquear funciones!';

  @override
  String poringDailyProgress(int count, int max) {
    return 'Hoy $count/$max';
  }

  @override
  String get poringWatchAd => 'Ver anuncio (+1 Ping)';

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
  String get poringEarned => '¡Ping +1!';

  @override
  String get poringUnlock => 'Desbloquear con Ping';

  @override
  String get poringUnlockConfirm => '¿Usar 1 Ping para desbloquear?';

  @override
  String get poringNotEnough => 'No hay suficientes Pings';

  @override
  String get poringWatchAdToEarnAndUse =>
      'No hay suficientes Pings. Mira un anuncio para ganar Pings';

  @override
  String get poringSpent => '¡Ping usado!';

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
    return 'Ping +$count';
  }

  @override
  String poringRewardClaimed(int count) {
    return '¡Recompensa: Ping +$count reclamado!';
  }

  @override
  String get referralAcceptedMessage => 'Invitación aceptada';

  @override
  String get addTimeWithPoring => 'Añadir hora de alarma';

  @override
  String get poringCostConfirm => 'Se usará 1 Ping';

  @override
  String get poringRequiredToSend =>
      'Se necesita 1 Ping para enviar un mensaje';

  @override
  String get deleteTimeConfirm => '¿Eliminar esta hora de alarma?';

  @override
  String get linkkuDexTitle => 'Dex de Linkku';

  @override
  String get linkkuDexCollect => 'Colecciona tus Linkku';

  @override
  String get linkkuDexComingHint => 'Nuevos amigos llegarán poco a poco.';

  @override
  String get linkkuDexDefault => 'Por defecto';

  @override
  String get linkkuDexComingSoon => 'Próximamente';

  @override
  String get linkkuDexSubtitle => 'El slime-alarma con campana';

  @override
  String get linkkuPersonality => 'Personalidad';

  @override
  String get linkkuTraitCaring => 'Cariñoso';

  @override
  String get linkkuTraitAttentive => 'Atento';

  @override
  String get linkkuPersonalityDesc =>
      'Un amigo cariñoso que nunca olvida tu hora.\nPronto cada Linkku tendrá su propia personalidad y hasta hablará distinto.';

  @override
  String get linkkuWhatsNext => 'Lo que viene';

  @override
  String get linkkuWhatsNextDesc =>
      'Criar, vestir y coleccionar nuevos amigos llegará paso a paso. 🥚';

  @override
  String get phoneSignIn => 'Iniciar sesión con teléfono';

  @override
  String get phoneEnterCode => 'Introduce el código';

  @override
  String get phoneEnterNumber => 'Introduce tu número';

  @override
  String get phoneNumberLabel => 'Número de teléfono';

  @override
  String get phoneSendCode => 'Enviar código';

  @override
  String get phoneConfirm => 'Confirmar';

  @override
  String get phoneChangeNumber => 'Cambiar número';

  @override
  String get phoneCodeSent => 'Código enviado';

  @override
  String get phoneSendFailed => 'No se pudo enviar el código';

  @override
  String get phoneVerifyFailed => 'Verificación fallida';

  @override
  String get phoneGenericError => 'Algo salió mal';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirm =>
      '¿Eliminar tu cuenta? Tu cuenta, enlaces, estadísticas y vídeos se eliminarán permanentemente. No se puede deshacer.';

  @override
  String get deleteAccountReauth =>
      'Por seguridad, inicia sesión de nuevo e inténtalo otra vez.';

  @override
  String get deleteAccountFailed =>
      'No se pudo eliminar la cuenta. Inténtalo más tarde.';

  @override
  String get ringModeTitle => '¿Cómo se conecta?';

  @override
  String get ringModeAllName => 'Ring grupal';

  @override
  String get ringModeAllDesc => 'Junto a todos los que tienen el enlace';

  @override
  String get ringModeChainName => 'Ring relevo';

  @override
  String get ringModeChainDesc =>
      'Junto a las personas con quienes compartiste';

  @override
  String get ringModeFixedNote => 'Esta elección queda fija para esta alarma';

  @override
  String get ringModeHelpTooltip => 'Detalles';

  @override
  String get ringModeHelpTitle => '¿Cuál es la diferencia?';

  @override
  String get ringModeHelpBody =>
      '🔗 Ring grupal\nA lo crea, lo comparte con B, B lo pasa a C\n→ A, B y C están en un mismo grupo.\nTodos ven y animan las pruebas de 3 segundos de los demás.\n\n🤝 Ring relevo\nPasado de A → B → C → D\n→ C solo ve a B (quien se lo dio) y a D (a quien se lo dio). A no aparece.\nTus pruebas solo las ven las personas con quienes intercambiaste directamente.\n\n💡 Cambia quién puede ver tus vídeos de prueba.\nFamilia y amigos cercanos = Ring relevo,\ngrupos y equipos = Ring grupal!';

  @override
  String get ringModeHelpOk => '¡Entendido!';

  @override
  String get ringBannerAll =>
      '🔗 Ring grupal — las pruebas las ven todos con este enlace';

  @override
  String get ringBannerChain =>
      '🤝 Ring relevo — las pruebas solo las ven con quienes compartes';

  @override
  String get shareAlreadySaved => 'Ya está guardada';

  @override
  String get shareNotFound => 'Enlace compartido no encontrado';

  @override
  String get shareDuplicateAlarm => 'Ya tienes esta alarma';

  @override
  String shareRepeatWeekly(int count) {
    return '$count veces/semana';
  }

  @override
  String get shareArrivedTitle => 'Llegó una alarma compartida 💌';

  @override
  String shareArrivedWith(String nickname) {
    return 'Recibe recordatorios junto a $nickname';
  }

  @override
  String get shareLater => 'Después';

  @override
  String get shareAddToMyAlarms => 'Añadir a mis alarmas';

  @override
  String get shareKeptInInbox =>
      '📥 Guardado en \"Enlaces compartidos\" de tu buzón';

  @override
  String get shareAddedTogether => '¡Alarma añadida! Juntos a la misma hora 🔔';

  @override
  String get shareAddFailed => 'No se pudo añadir';

  @override
  String get slotFullTitle => 'No quedan espacios de alarma';

  @override
  String get slotFullAdBody =>
      'Todos tus espacios gratuitos están en uso.\n¡Mira un anuncio para añadir esta alarma compartida!\n\n(Premium = ilimitado y sin anuncios ✨)';

  @override
  String get slotFullLater => 'Después';

  @override
  String get slotFullWatchAd => 'Ver anuncio y añadir';

  @override
  String get adNotCompleted => 'El anuncio no se completó';

  @override
  String inboxSectionTitle(int count) {
    return '📥 Enlaces compartidos ($count)';
  }

  @override
  String inboxFrom(String nickname, String time) {
    return 'De $nickname · ⏰ $time';
  }

  @override
  String get inboxDecline => 'Rechazar';

  @override
  String get inboxAdd => 'Añadir';

  @override
  String pingCheerToast(String nickname) {
    return '📣 ¡$nickname te animó!';
  }

  @override
  String pingPokeToast(String nickname) {
    return '👉 ¡$nickname te dio un toque!';
  }

  @override
  String get pingReferralToast => '🎁 ¡Un amigo se unió con tu código!';

  @override
  String get pingInquiryToast => '💬 Tu consulta recibió respuesta';

  @override
  String get pingGenericToast => '🔔 Nueva notificación';

  @override
  String get proofGalleryTitle => 'Galería de pruebas';

  @override
  String get proofLoadFailed => 'Error al cargar. Desliza para actualizar';

  @override
  String get proofNoSharedAlarms => 'Aún no hay alarmas compartidas';

  @override
  String get proofNoSharedAlarmsHint =>
      'Comparte un enlace con amigos y\nreúne aquí las pruebas de 3 segundos 💪';

  @override
  String proofLatest(String time) {
    return 'último $time';
  }

  @override
  String get proofNoneYet => 'Sin pruebas aún';

  @override
  String get proofRecordMine => 'Grabar prueba';

  @override
  String proofVerifyWindowClosed(int minutes) {
    return 'Solo puedes grabar una prueba dentro de los $minutes min tras la alarma';
  }

  @override
  String get proofMineBadge => 'Mío';

  @override
  String timeAgoMinutes(int count) {
    return 'hace $count min';
  }

  @override
  String timeAgoHours(int count) {
    return 'hace $count h';
  }

  @override
  String timeAgoDays(int count) {
    return 'hace $count días';
  }

  @override
  String get guestPurchaseTitle => 'Se requiere una cuenta';

  @override
  String get guestPurchaseBody =>
      'Para proteger tu compra entre dispositivos,\nvincula primero una cuenta de Google o Apple.\n\n¡Tus alarmas e historial se conservarán!';

  @override
  String get guestPurchaseLink => 'Vincular cuenta';

  @override
  String get lockedSlotTitle => 'Espacio de alarma bloqueado';

  @override
  String get lockedSlotSubtitle => 'Invita a un amigo +1 · Premium = ilimitado';

  @override
  String get dayChipLabels => 'L,M,X,J,V,S,D';

  @override
  String get cameraNotFound => 'Cámara no encontrada';

  @override
  String cameraInitFailed(String error) {
    return 'Fallo al iniciar cámara: $error';
  }

  @override
  String recordStartFailed(String error) {
    return 'Fallo al iniciar grabación: $error';
  }

  @override
  String recordStopFailed(String error) {
    return 'Fallo al detener grabación: $error';
  }

  @override
  String proofDeleteFailed(String error) {
    return 'Fallo al eliminar: $error';
  }

  @override
  String get shareRepeatDaily => 'Diario';
}
