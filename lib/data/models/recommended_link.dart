import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore에서 관리하는 추천 링크 모델
/// 다국어 지원: titleKo/titleEn, descriptionKo/descriptionEn
class RecommendedLink {
  final String id;
  final String titleKo;
  final String titleEn;
  final String url;
  final String emoji;
  final String descriptionKo;
  final String descriptionEn;
  final String category; // 'exercise', 'health', 'mindset' 등
  final int order;
  final bool isActive;
  final DateTime? createdAt;

  RecommendedLink({
    required this.id,
    required this.titleKo,
    required this.titleEn,
    required this.url,
    required this.emoji,
    required this.descriptionKo,
    required this.descriptionEn,
    required this.category,
    required this.order,
    required this.isActive,
    this.createdAt,
  });

  /// 현재 언어에 맞는 제목
  String title(bool isKorean) => isKorean ? titleKo : titleEn;

  /// 현재 언어에 맞는 설명
  String description(bool isKorean) => isKorean ? descriptionKo : descriptionEn;

  factory RecommendedLink.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecommendedLink(
      id: doc.id,
      titleKo: data['titleKo'] ?? data['title'] ?? '',
      titleEn: data['titleEn'] ?? data['title'] ?? '',
      url: data['url'] ?? '',
      emoji: data['emoji'] ?? '⭐',
      descriptionKo: data['descriptionKo'] ?? data['description'] ?? '',
      descriptionEn: data['descriptionEn'] ?? data['description'] ?? '',
      category: data['category'] ?? 'other',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
