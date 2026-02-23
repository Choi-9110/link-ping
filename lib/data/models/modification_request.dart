import 'package:cloud_firestore/cloud_firestore.dart';

/// 수정 요청 상태
enum ModificationStatus {
  pending, // 투표 진행 중
  approved, // 승인됨 (50% 이상)
  rejected, // 거부됨 (50% 미만)
  expired, // 만료됨 (24시간 경과)
}

/// 투표 상태
enum VoteStatus {
  pending, // 미응답
  approved, // 승인
  rejected, // 거절
}

/// 고정 알람 수정 요청
class ModificationRequest {
  final String id;
  final String sharedLinkId; // 원본 공유 링크 ID
  final String creatorUid; // 만든 사람 UID
  final String creatorNickname; // 만든 사람 닉네임
  final String linkTitle; // 링크 제목

  // 기존 값
  final int originalHour;
  final int originalMinute;
  final List<int> originalRepeatDays;

  // 요청된 변경 값
  final int newHour;
  final int newMinute;
  final List<int> newRepeatDays;

  final DateTime createdAt;
  final DateTime expiresAt; // 생성 후 24시간
  final ModificationStatus status;

  // 투표 현황: { 'uid': 'approved' | 'rejected' | 'pending' }
  final Map<String, String> votes;
  final List<String> voterUids; // 투표 대상자 UID 목록

  ModificationRequest({
    required this.id,
    required this.sharedLinkId,
    required this.creatorUid,
    required this.creatorNickname,
    required this.linkTitle,
    required this.originalHour,
    required this.originalMinute,
    required this.originalRepeatDays,
    required this.newHour,
    required this.newMinute,
    required this.newRepeatDays,
    required this.createdAt,
    required this.expiresAt,
    this.status = ModificationStatus.pending,
    required this.votes,
    required this.voterUids,
  });

  factory ModificationRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    ModificationStatus status;
    switch (data['status'] as String?) {
      case 'approved':
        status = ModificationStatus.approved;
        break;
      case 'rejected':
        status = ModificationStatus.rejected;
        break;
      case 'expired':
        status = ModificationStatus.expired;
        break;
      default:
        status = ModificationStatus.pending;
    }

    return ModificationRequest(
      id: doc.id,
      sharedLinkId: data['sharedLinkId'] ?? '',
      creatorUid: data['creatorUid'] ?? '',
      creatorNickname: data['creatorNickname'] ?? '',
      linkTitle: data['linkTitle'] ?? '',
      originalHour: data['originalHour'] ?? 0,
      originalMinute: data['originalMinute'] ?? 0,
      originalRepeatDays: List<int>.from(data['originalRepeatDays'] ?? []),
      newHour: data['newHour'] ?? 0,
      newMinute: data['newMinute'] ?? 0,
      newRepeatDays: List<int>.from(data['newRepeatDays'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: status,
      votes: Map<String, String>.from(data['votes'] ?? {}),
      voterUids: List<String>.from(data['voterUids'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    String statusStr;
    switch (status) {
      case ModificationStatus.approved:
        statusStr = 'approved';
        break;
      case ModificationStatus.rejected:
        statusStr = 'rejected';
        break;
      case ModificationStatus.expired:
        statusStr = 'expired';
        break;
      case ModificationStatus.pending:
        statusStr = 'pending';
        break;
    }

    return {
      'sharedLinkId': sharedLinkId,
      'creatorUid': creatorUid,
      'creatorNickname': creatorNickname,
      'linkTitle': linkTitle,
      'originalHour': originalHour,
      'originalMinute': originalMinute,
      'originalRepeatDays': originalRepeatDays,
      'newHour': newHour,
      'newMinute': newMinute,
      'newRepeatDays': newRepeatDays,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'status': statusStr,
      'votes': votes,
      'voterUids': voterUids,
    };
  }

  /// 만료 여부
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// 승인 수
  int get approvedCount => votes.values.where((v) => v == 'approved').length;

  /// 거절 수
  int get rejectedCount => votes.values.where((v) => v == 'rejected').length;

  /// 무응답 수
  int get pendingCount => votes.values.where((v) => v == 'pending').length;

  /// 응답한 사람 수
  int get respondedCount => approvedCount + rejectedCount;

  /// 총 투표자 수
  int get totalVoters => voterUids.length;

  /// 승인율 (응답자 기준)
  double get approvalRate {
    if (respondedCount == 0) return 0;
    return approvedCount / respondedCount;
  }

  /// 50% 이상 승인 여부
  bool get isApprovalReached => approvalRate >= 0.5;

  /// 시간 변경 문자열 (예: "07:00 → 08:00")
  String get timeChangeString {
    final oldTime = '${originalHour.toString().padLeft(2, '0')}:${originalMinute.toString().padLeft(2, '0')}';
    final newTime = '${newHour.toString().padLeft(2, '0')}:${newMinute.toString().padLeft(2, '0')}';
    return '$oldTime → $newTime';
  }

  ModificationRequest copyWith({
    ModificationStatus? status,
    Map<String, String>? votes,
  }) {
    return ModificationRequest(
      id: id,
      sharedLinkId: sharedLinkId,
      creatorUid: creatorUid,
      creatorNickname: creatorNickname,
      linkTitle: linkTitle,
      originalHour: originalHour,
      originalMinute: originalMinute,
      originalRepeatDays: originalRepeatDays,
      newHour: newHour,
      newMinute: newMinute,
      newRepeatDays: newRepeatDays,
      createdAt: createdAt,
      expiresAt: expiresAt,
      status: status ?? this.status,
      votes: votes ?? this.votes,
      voterUids: voterUids,
    );
  }
}
