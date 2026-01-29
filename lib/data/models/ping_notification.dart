import 'package:cloud_firestore/cloud_firestore.dart';

/// 알림 타입
enum PingType {
  cheer, // 응원하기
  tease, // 약올리기
}

/// 앱 내 알림 (응원/약올리기)
class PingNotification {
  final String id;
  final PingType type;
  final String fromUid;
  final String fromNickname;
  final String urlTitle;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  PingNotification({
    required this.id,
    required this.type,
    required this.fromUid,
    required this.fromNickname,
    required this.urlTitle,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  factory PingNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PingNotification(
      id: doc.id,
      type: data['type'] == 'cheer' ? PingType.cheer : PingType.tease,
      fromUid: data['fromUid'] ?? '',
      fromNickname: data['fromNickname'] ?? '',
      urlTitle: data['urlTitle'] ?? '',
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type == PingType.cheer ? 'cheer' : 'tease',
      'fromUid': fromUid,
      'fromNickname': fromNickname,
      'urlTitle': urlTitle,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
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
    );
  }
}

/// 기본 메시지 (나중에 AI로 대체 가능)
class PingMessages {
  static const List<String> cheerMessages = [
    '파이팅! 오늘도 힘내세요 💪',
    '당신을 응원합니다! 🎉',
    '꾸준함이 최고예요! 👏',
    '오늘도 실천하는 당신, 멋져요! ⭐',
    '함께 성장해요! 🌱',
  ];

  static const List<String> teaseMessages = [
    '오늘 링크 클릭 안 했죠? 😏',
    '저는 벌써 했는데~ 😜',
    '혹시 까먹은 거 아니에요? 🤔',
    '자극 좀 받으세요~ 🔥',
    '저도 기다리고 있어요! ⏰',
    '아빠 이거 해야된다니까??',
    '이거도 못함 ?? ',
  ];

  static String getRandomCheerMessage() {
    return cheerMessages[(DateTime.now().millisecondsSinceEpoch %
        cheerMessages.length)];
  }

  static String getRandomTeaseMessage() {
    return teaseMessages[(DateTime.now().millisecondsSinceEpoch %
        teaseMessages.length)];
  }
}
