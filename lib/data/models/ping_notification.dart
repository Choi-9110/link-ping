import 'package:cloud_firestore/cloud_firestore.dart';

/// 알림 타입
enum PingType {
  cheer, // 응원하기
  tease, // 약올리기
  inquiryReply, // 문의 답변
  linkDeleted, // 고정 알람 삭제됨
  modificationRequest, // 고정 알람 수정 요청
  modificationApproved, // 수정 승인됨 (전체)
  modificationRejected, // 수정 거부됨 (전체)
  modificationApplied, // 수정 적용됨 (개인 - 거절했지만 전체 승인됨)
  referralAccepted, // 추천 가입 수락됨
}

/// 앱 내 알림 (응원/약올리기/문의답변/링크수정요청)
class PingNotification {
  final String id;
  final PingType type;
  final String fromUid;
  final String fromNickname;
  final String urlTitle;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final String? inquiryId; // 문의 답변용
  final String? inquiryTitle; // 문의 답변용
  final String? modificationRequestId; // 수정 요청 ID
  final String? sharedLinkId; // 공유 링크 ID
  final String? linkId; // 로컬 링크 ID (알람 OFF용)
  final int? messageIndex; // 다국어 메시지 인덱스 (번역용)

  PingNotification({
    required this.id,
    required this.type,
    required this.fromUid,
    required this.fromNickname,
    required this.urlTitle,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.inquiryId,
    this.inquiryTitle,
    this.modificationRequestId,
    this.sharedLinkId,
    this.linkId,
    this.messageIndex,
  });

  factory PingNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    PingType type;
    final typeStr = data['type'] as String?;
    switch (typeStr) {
      case 'cheer':
        type = PingType.cheer;
        break;
      case 'inquiry_reply':
        type = PingType.inquiryReply;
        break;
      case 'link_deleted':
        type = PingType.linkDeleted;
        break;
      case 'modification_request':
        type = PingType.modificationRequest;
        break;
      case 'modification_approved':
        type = PingType.modificationApproved;
        break;
      case 'modification_rejected':
        type = PingType.modificationRejected;
        break;
      case 'modification_applied':
        type = PingType.modificationApplied;
        break;
      case 'referral_accepted':
      case 'referral_bonus': // 하위 호환
        type = PingType.referralAccepted;
        break;
      default:
        type = PingType.tease;
    }

    return PingNotification(
      id: doc.id,
      type: type,
      fromUid: data['fromUid'] ?? '',
      fromNickname: data['fromNickname'] ?? '',
      urlTitle: data['urlTitle'] ?? data['inquiryTitle'] ?? '',
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      inquiryId: data['inquiryId'] as String?,
      inquiryTitle: data['inquiryTitle'] as String?,
      modificationRequestId: data['modificationRequestId'] as String?,
      sharedLinkId: data['sharedLinkId'] as String?,
      linkId: data['linkId'] as String?,
      messageIndex: data['messageIndex'] as int?,
    );
  }

  Map<String, dynamic> toFirestore() {
    String typeStr;
    switch (type) {
      case PingType.cheer:
        typeStr = 'cheer';
        break;
      case PingType.inquiryReply:
        typeStr = 'inquiry_reply';
        break;
      case PingType.tease:
        typeStr = 'tease';
        break;
      case PingType.linkDeleted:
        typeStr = 'link_deleted';
        break;
      case PingType.modificationRequest:
        typeStr = 'modification_request';
        break;
      case PingType.modificationApproved:
        typeStr = 'modification_approved';
        break;
      case PingType.modificationRejected:
        typeStr = 'modification_rejected';
        break;
      case PingType.modificationApplied:
        typeStr = 'modification_applied';
        break;
      case PingType.referralAccepted:
        typeStr = 'referral_accepted';
        break;
    }

    return {
      'type': typeStr,
      'fromUid': fromUid,
      'fromNickname': fromNickname,
      'urlTitle': urlTitle,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      if (inquiryId != null) 'inquiryId': inquiryId,
      if (inquiryTitle != null) 'inquiryTitle': inquiryTitle,
      if (modificationRequestId != null) 'modificationRequestId': modificationRequestId,
      if (sharedLinkId != null) 'sharedLinkId': sharedLinkId,
      if (linkId != null) 'linkId': linkId,
      if (messageIndex != null) 'messageIndex': messageIndex,
    };
  }

  PingNotification copyWith({bool? isRead}) {
    return PingNotification(
      id: id,
      type: type,
      fromUid: fromUid,
      fromNickname: fromNickname,
      urlTitle: urlTitle,
      message: message,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      inquiryId: inquiryId,
      inquiryTitle: inquiryTitle,
      modificationRequestId: modificationRequestId,
      sharedLinkId: sharedLinkId,
      linkId: linkId,
      messageIndex: messageIndex,
    );
  }

  /// 현재 로케일에 맞는 메시지 가져오기
  String getLocalizedMessage(String langCode) {
    // messageIndex가 없으면 원본 메시지 반환
    if (messageIndex == null) return message;

    // 타입에 따라 번역된 메시지 반환
    if (type == PingType.cheer) {
      return PingMessages.getCheerMessageForLang(messageIndex!, langCode);
    } else if (type == PingType.tease) {
      return PingMessages.getTeaseMessageForLang(messageIndex!, langCode);
    }

    return message;
  }
}

/// 다국어 메시지 (언어별 매칭)
class PingMessages {
  /// 응원 메시지 - 각 인덱스가 동일한 의미
  static const Map<String, List<String>> cheerMessagesByLang = {
    'ko': [
      // 동기부여 & 격려
      '파이팅! 오늘도 힘내세요! 💪',
      '당신을 믿어요! 🌟',
      '작은 한 걸음도 소중해요! 👏',
      '정말 잘하고 있어요! ⭐',
      '꾸준함이 최고예요! 🔥',
      '오늘도 해내는 당신, 자랑스러워요! 🎉',
      '그 기세 유지해요! 🚀',
      '당신 덕분에 저도 힘이 나요! ✨',
      // 감동 & 지지
      '우리 함께 해요! 🤝',
      '당신의 노력이 정말 대단해요! 💖',
      '성장하는 모습에 저도 자극받아요! 🌱',
      '포기하지 마세요, 거의 다 왔어요! 🏆',
      '하루하루 최선을 다하는 당신, 멋져요! 💯',
      '오늘의 노력이 내일의 성공이에요! 🌅',
      // 친근한 응원
      '가자! 챔피언! 🥊',
      '당신은 최고예요! 🎸',
      '프로처럼 해내고 있어요! 😎',
      '가장 멋진 프로젝트는 바로 당신이에요! 💎',
      '미래의 당신이 지금의 당신에게 고마워할 거예요! 🙏',
    ],
    'en': [
      // Motivational & encouraging
      "You've got this! Keep going! 💪",
      "I believe in you! 🌟",
      "Every small step counts! 👏",
      "You're doing amazing! ⭐",
      "Consistency is key - you're nailing it! 🔥",
      "Proud of you for showing up! 🎉",
      "Keep that momentum going! 🚀",
      "You inspire me to do better! ✨",
      // Emotional support
      "We're in this together! 🤝",
      "Your dedication is incredible! 💖",
      "Seeing you grow motivates me too! 🌱",
      "Don't give up, you're so close! 🏆",
      "One day at a time - you're crushing it! 💯",
      "Your effort today = your success tomorrow! 🌅",
      // Friendly cheering
      "Let's go champ! 🥊",
      "You're a rockstar! 🎸",
      "Making progress like a boss! 😎",
      "The best project you'll ever work on is YOU! 💎",
      "Future you will thank present you! 🙏",
    ],
    'ja': [
      '頑張って！今日も応援してるよ！ 💪',
      'あなたを信じてる！ 🌟',
      '小さな一歩も大切だよ！ 👏',
      'すごく頑張ってるね！ ⭐',
      '継続は力なり！その調子！ 🔥',
      '今日も頑張ってるあなた、誇りに思う！ 🎉',
      'その勢いで行こう！ 🚀',
      'あなたのおかげで私も頑張れる！ ✨',
      '一緒に頑張ろう！ 🤝',
      'あなたの努力は本当にすごい！ 💖',
      '成長する姿に私も刺激を受けてる！ 🌱',
      '諦めないで、もう少しだよ！ 🏆',
      '毎日ベストを尽くすあなた、素敵！ 💯',
      '今日の努力が明日の成功に！ 🌅',
      '行くよ！チャンピオン！ 🥊',
      'あなたは最高！ 🎸',
      'プロみたいに頑張ってる！ 😎',
      '最高のプロジェクトはあなた自身！ 💎',
      '未来のあなたが今のあなたに感謝するよ！ 🙏',
    ],
    'zh': [
      '加油！今天也要努力！ 💪',
      '我相信你！ 🌟',
      '每一小步都很重要！ 👏',
      '你做得太棒了！ ⭐',
      '坚持就是胜利！ 🔥',
      '为今天努力的你感到骄傲！ 🎉',
      '保持这个势头！ 🚀',
      '你激励了我也要加油！ ✨',
      '我们一起加油！ 🤝',
      '你的付出真的很了不起！ 💖',
      '看到你成长我也受到激励！ 🌱',
      '别放弃，你快成功了！ 🏆',
      '每天都在努力的你，太棒了！ 💯',
      '今天的努力是明天的成功！ 🌅',
      '冲啊！冠军！ 🥊',
      '你是最棒的！ 🎸',
      '像专业人士一样在进步！ 😎',
      '最好的项目就是你自己！ 💎',
      '未来的你会感谢现在的你！ 🙏',
    ],
    'es': [
      '¡Tú puedes! ¡Sigue adelante! 💪',
      '¡Creo en ti! 🌟',
      '¡Cada pequeño paso cuenta! 👏',
      '¡Lo estás haciendo increíble! ⭐',
      '¡La constancia es la clave! 🔥',
      '¡Orgulloso de que sigas adelante! 🎉',
      '¡Mantén ese impulso! 🚀',
      '¡Me inspiras a ser mejor! ✨',
      '¡Estamos juntos en esto! 🤝',
      '¡Tu dedicación es increíble! 💖',
      '¡Verte crecer me motiva también! 🌱',
      '¡No te rindas, ya casi llegas! 🏆',
      '¡Un día a la vez - lo estás logrando! 💯',
      '¡Tu esfuerzo de hoy = tu éxito de mañana! 🌅',
      '¡Vamos campeón! 🥊',
      '¡Eres una estrella! 🎸',
      '¡Progresando como un profesional! 😎',
      '¡El mejor proyecto eres TÚ! 💎',
      '¡Tu yo del futuro te lo agradecerá! 🙏',
    ],
  };

  /// 약올리기 메시지 - 각 인덱스가 동일한 의미
  static const Map<String, List<String>> teaseMessagesByLang = {
    'ko': [
      // 가벼운 자극
      '혹시 까먹은 거 아니에요? 🤔',
      '저는 벌써 했는데~ 😜',
      '기다리고 있어요! ⏰',
      '저 혼자 두지 마세요! 😏',
      '거기 계세요? 여보세요? 📢',
      // 경쟁심 자극
      '저 이제 앞서가요~ 🏃‍♂️💨',
      '째깍째깍! 시간이 가요! ⏱️',
      '다들 하고 있는데... 👀',
      '저한테 질 거예요? 🏆',
      '진심이 아니었어요? 🤨',
      // 유머러스한 도발
      '링크가 외로워하고 있어요! 😢',
      '우리 할머니도 벌써 했을걸요? 👵',
      '폰 고장났어요? 📱💀',
      '걱정되기 시작하는데... 😬',
      '오늘은 변명 안 돼요! 🚫',
      // 도전적인 메시지
      '제가 틀렸다는 걸 증명해봐요! 💪',
      '실력 좀 보여줘요! 🔥',
      '진짜 오늘 안 할 거예요? 😤',
      '게으름 피우지 말아요! 🦥',
      '한번 해보시지! 👊',
      '생각만 하지 말고 행동해요! 🧠➡️💪',
    ],
    'en': [
      // Light teasing
      "Did you forget about this? 🤔",
      "I already did mine~ 😜",
      "Waiting for you to catch up! ⏰",
      "Don't leave me hanging! 😏",
      "Is this thing on? Hello? 📢",
      // Competitive spirit
      "I'm ahead of you now~ 🏃‍♂️💨",
      "Tick tock! Time's running! ⏱️",
      "Everyone else is doing it... 👀",
      "You're not gonna let me win, right? 🏆",
      "I thought you were serious about this! 🤨",
      // Humorous provocation
      "Your link is getting lonely! 😢",
      "Even my grandma would've clicked by now 👵",
      "Is your phone broken? 📱💀",
      "I'm starting to worry about you... 😬",
      "No excuses today! 🚫",
      // Challenging
      "Prove me wrong! 💪",
      "Show me what you've got! 🔥",
      "Are you really gonna skip today? 😤",
      "Come on, don't be lazy! 🦥",
      "I double dare you! 👊",
      "Less thinking, more doing! 🧠➡️💪",
    ],
    'ja': [
      '忘れてない？ 🤔',
      '私はもうやったよ～ 😜',
      '待ってるよ！ ⏰',
      '一人にしないで！ 😏',
      'もしもし？聞こえてる？ 📢',
      '私が先に行っちゃうよ～ 🏃‍♂️💨',
      'カチカチ！時間が過ぎてるよ！ ⏱️',
      'みんなやってるよ... 👀',
      '私に負けるつもり？ 🏆',
      '本気じゃなかったの？ 🤨',
      'リンクが寂しがってるよ！ 😢',
      'おばあちゃんでももうクリックしてるよ？ 👵',
      'スマホ壊れた？ 📱💀',
      'ちょっと心配になってきた... 😬',
      '今日は言い訳なしだよ！ 🚫',
      '私が間違ってること証明してみて！ 💪',
      '実力見せて！ 🔥',
      '本当に今日はやらないの？ 😤',
      'サボらないで！ 🦥',
      'やってみなよ！ 👊',
      '考えてないで行動して！ 🧠➡️💪',
    ],
    'zh': [
      '该不会忘了吧？ 🤔',
      '我已经做完了哦～ 😜',
      '在等你呢！ ⏰',
      '别丢下我一个人！ 😏',
      '有人吗？喂喂？ 📢',
      '我已经领先了哦～ 🏃‍♂️💨',
      '滴答滴答！时间在跑！ ⏱️',
      '大家都在做了... 👀',
      '你要输给我吗？ 🏆',
      '你不是认真的吗？ 🤨',
      '链接很孤单呢！ 😢',
      '连我奶奶都已经点了吧？ 👵',
      '手机坏了？ 📱💀',
      '开始担心你了... 😬',
      '今天没有借口！ 🚫',
      '证明我是错的！ 💪',
      '给我看看你的实力！ 🔥',
      '今天真的不做吗？ 😤',
      '别偷懒！ 🦥',
      '来挑战吧！ 👊',
      '少想多做！ 🧠➡️💪',
    ],
    'es': [
      '¿Lo olvidaste? 🤔',
      '¡Yo ya lo hice~ 😜',
      '¡Te estoy esperando! ⏰',
      '¡No me dejes colgado! 😏',
      '¿Hola? ¿Hay alguien ahí? 📢',
      '¡Ya te llevo ventaja~ 🏃‍♂️💨',
      '¡Tic tac! ¡El tiempo corre! ⏱️',
      'Todos los demás lo están haciendo... 👀',
      '¿Vas a dejar que te gane? 🏆',
      '¡Pensé que ibas en serio! 🤨',
      '¡Tu link se siente solo! 😢',
      '¡Hasta mi abuela ya habría hecho clic! 👵',
      '¿Se te rompió el teléfono? 📱💀',
      'Me estoy empezando a preocupar... 😬',
      '¡Hoy no hay excusas! 🚫',
      '¡Demuéstrame que estoy equivocado! 💪',
      '¡Muéstrame lo que tienes! 🔥',
      '¿De verdad te lo vas a saltar hoy? 😤',
      '¡Vamos, no seas perezoso! 🦥',
      '¡Te reto! 👊',
      '¡Menos pensar, más hacer! 🧠➡️💪',
    ],
  };

  /// 발신자 언어로 표시할 메시지 목록
  static List<String> get cheerMessages =>
      cheerMessagesByLang['en'] ?? [];

  static List<String> get teaseMessages =>
      teaseMessagesByLang['en'] ?? [];

  /// 특정 언어의 응원 메시지 목록
  static List<String> getCheerMessages(String langCode) {
    return cheerMessagesByLang[langCode] ?? cheerMessagesByLang['en']!;
  }

  /// 특정 언어의 약올리기 메시지 목록
  static List<String> getTeaseMessages(String langCode) {
    return teaseMessagesByLang[langCode] ?? teaseMessagesByLang['en']!;
  }

  /// 메시지 인덱스로 다른 언어 버전 가져오기
  static String getCheerMessageForLang(int index, String targetLang) {
    final messages = cheerMessagesByLang[targetLang] ?? cheerMessagesByLang['en']!;
    if (index >= 0 && index < messages.length) {
      return messages[index];
    }
    return messages[0];
  }

  static String getTeaseMessageForLang(int index, String targetLang) {
    final messages = teaseMessagesByLang[targetLang] ?? teaseMessagesByLang['en']!;
    if (index >= 0 && index < messages.length) {
      return messages[index];
    }
    return messages[0];
  }

  /// 메시지 텍스트로 인덱스 찾기 (어떤 언어든)
  static int? findCheerMessageIndex(String message) {
    for (final entry in cheerMessagesByLang.entries) {
      final index = entry.value.indexOf(message);
      if (index != -1) return index;
    }
    return null;
  }

  static int? findTeaseMessageIndex(String message) {
    for (final entry in teaseMessagesByLang.entries) {
      final index = entry.value.indexOf(message);
      if (index != -1) return index;
    }
    return null;
  }

  /// 메시지를 대상 언어로 번역
  static String translateCheerMessage(String message, String targetLang) {
    final index = findCheerMessageIndex(message);
    if (index != null) {
      return getCheerMessageForLang(index, targetLang);
    }
    return message; // 찾지 못하면 원본 반환
  }

  static String translateTeaseMessage(String message, String targetLang) {
    final index = findTeaseMessageIndex(message);
    if (index != null) {
      return getTeaseMessageForLang(index, targetLang);
    }
    return message; // 찾지 못하면 원본 반환
  }

  static String getRandomCheerMessage() {
    final messages = cheerMessagesByLang['en']!;
    return messages[(DateTime.now().millisecondsSinceEpoch % messages.length)];
  }

  static String getRandomTeaseMessage() {
    final messages = teaseMessagesByLang['en']!;
    return messages[(DateTime.now().millisecondsSinceEpoch % messages.length)];
  }
}
