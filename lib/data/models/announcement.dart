import 'package:cloud_firestore/cloud_firestore.dart';

/// 공지사항 모델 (Firestore에서 관리)
class Announcement {
  final String id;
  final String titleKo;
  final String titleEn;
  final String bodyKo;
  final String bodyEn;
  final String type; // 'notice', 'event', 'update'
  final bool isActive;
  final DateTime? createdAt;

  Announcement({
    required this.id,
    required this.titleKo,
    required this.titleEn,
    required this.bodyKo,
    required this.bodyEn,
    required this.type,
    required this.isActive,
    this.createdAt,
  });

  String title(bool isKorean) => isKorean ? titleKo : titleEn;
  String body(bool isKorean) => isKorean ? bodyKo : bodyEn;

  String get typeEmoji {
    switch (type) {
      case 'event':
        return '🎉';
      case 'update':
        return '🆕';
      default:
        return '📢';
    }
  }

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      titleKo: data['titleKo'] ?? '',
      titleEn: data['titleEn'] ?? '',
      bodyKo: data['bodyKo'] ?? '',
      bodyEn: data['bodyEn'] ?? '',
      type: data['type'] ?? 'notice',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
