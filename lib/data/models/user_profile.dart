import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String nickname;
  final String country;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String profileEmoji;
  final int bonusLinks; // 공유 보상으로 획득한 추가 링크 수 (최대 1)
  final String? referredBy; // 추천인 UID (가입 시 설정)
  final String? phoneNumber; // 내 전화번호 (tel: 알람용)
  final int pendingPoringReward; // 추천 보상 포링 (Firestore→Hive 브릿지)

  UserProfile({
    required this.uid,
    required this.nickname,
    required this.country,
    this.isPremium = false,
    required this.createdAt,
    this.updatedAt,
    this.profileEmoji = 'face_grinning',
    this.bonusLinks = 0,
    this.referredBy,
    this.phoneNumber,
    this.pendingPoringReward = 0,
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
      profileEmoji: data['profileEmoji'] ?? 'face_grinning',
      bonusLinks: data['bonusLinks'] ?? 0,
      referredBy: data['referredBy'],
      phoneNumber: data['phoneNumber'],
      pendingPoringReward: data['pendingPoringReward'] ?? 0,
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
      'profileEmoji': profileEmoji,
      'bonusLinks': bonusLinks,
      if (referredBy != null) 'referredBy': referredBy,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'pendingPoringReward': pendingPoringReward,
    };
  }

  /// 복사본 생성 (일부 필드 변경)
  UserProfile copyWith({
    String? nickname,
    String? country,
    bool? isPremium,
    DateTime? updatedAt,
    String? profileEmoji,
    int? bonusLinks,
    String? referredBy,
    String? phoneNumber,
    int? pendingPoringReward,
  }) {
    return UserProfile(
      uid: uid,
      nickname: nickname ?? this.nickname,
      country: country ?? this.country,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileEmoji: profileEmoji ?? this.profileEmoji,
      bonusLinks: bonusLinks ?? this.bonusLinks,
      referredBy: referredBy ?? this.referredBy,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pendingPoringReward: pendingPoringReward ?? this.pendingPoringReward,
    );
  }

  /// 총 사용 가능한 링크 수 계산
  int get totalLinksLimit {
    if (isPremium) return -1; // 무제한
    return 2 + bonusLinks; // 기본 2 + 보너스
  }
}
