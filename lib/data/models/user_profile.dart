import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String nickname;
  final String country;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.uid,
    required this.nickname,
    required this.country,
    this.isPremium = false,
    required this.createdAt,
    this.updatedAt,
  });

  /// Firestore 문서에서 UserProfile 생성
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      nickname: data['nickname'] ?? '',
      country: data['country'] ?? '',
      isPremium: data['isPremium'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'nickname': nickname,
      'country': country,
      'isPremium': isPremium,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// 복사본 생성 (일부 필드 변경)
  UserProfile copyWith({
    String? nickname,
    String? country,
    bool? isPremium,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid,
      nickname: nickname ?? this.nickname,
      country: country ?? this.country,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
