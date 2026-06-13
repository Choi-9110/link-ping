import 'package:cloud_firestore/cloud_firestore.dart';

/// 인증 영상 (3초). Firestore 메타데이터.
/// 실제 영상 파일은 Firebase Storage에 저장.
/// expiresAt 도달 시 Firestore TTL 정책 + Storage Lifecycle Rule 로 자동 삭제.
class VerificationVideo {
  final String id;
  final String uploaderUid;
  final String uploaderNickname;
  final String uploaderProfileEmoji;

  /// 어느 공유 링크에 대한 인증인지 (private 알람이면 null)
  final String? sharedLinkId;

  /// 공유 체인의 뿌리 ID — 릴레이 링 노출 범위 계산용 (레거시 null)
  final String? rootShareId;

  /// Firebase Storage 경로 (verifications/{uploaderUid}/{id}.mp4)
  final String storagePath;

  /// 영상 다운로드 URL
  final String videoUrl;

  /// 썸네일 URL (첫 프레임)
  final String? thumbnailUrl;

  /// 영상 길이 (초)
  final int durationSeconds;

  /// 화질 (360 = 무료, 720 = 프리미엄)
  final int resolution;

  final DateTime createdAt;

  /// 7일 후 자동 삭제 시점 (Firestore TTL 필드)
  final DateTime expiresAt;

  /// 시청 카운트
  final int viewCount;

  /// 시청한 사용자 uid 목록 (프리미엄 "누가 봤지?" 기능용)
  final List<String> viewedByUids;

  /// 이 영상을 신고한 사용자 uid 목록
  final List<String> reportedByUids;

  /// 신고 누적으로 자동/수동 숨김 처리됨
  final bool isHidden;

  const VerificationVideo({
    required this.id,
    required this.uploaderUid,
    required this.uploaderNickname,
    required this.uploaderProfileEmoji,
    this.sharedLinkId,
    this.rootShareId,
    required this.storagePath,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.durationSeconds,
    required this.resolution,
    required this.createdAt,
    required this.expiresAt,
    this.viewCount = 0,
    this.viewedByUids = const [],
    this.reportedByUids = const [],
    this.isHidden = false,
  });

  factory VerificationVideo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VerificationVideo(
      id: doc.id,
      uploaderUid: data['uploaderUid'] as String? ?? '',
      uploaderNickname: data['uploaderNickname'] as String? ?? '',
      uploaderProfileEmoji:
          data['uploaderProfileEmoji'] as String? ?? 'face_grinning',
      sharedLinkId: data['sharedLinkId'] as String?,
      rootShareId: data['rootShareId'] as String?,
      storagePath: data['storagePath'] as String? ?? '',
      videoUrl: data['videoUrl'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String?,
      durationSeconds: (data['durationSeconds'] as num?)?.toInt() ?? 3,
      resolution: (data['resolution'] as num?)?.toInt() ?? 360,
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate() ??
          DateTime.now().add(const Duration(days: 7)),
      viewCount: (data['viewCount'] as num?)?.toInt() ?? 0,
      viewedByUids: List<String>.from(data['viewedByUids'] ?? const []),
      reportedByUids: List<String>.from(data['reportedByUids'] ?? const []),
      isHidden: data['isHidden'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uploaderUid': uploaderUid,
      'uploaderNickname': uploaderNickname,
      'uploaderProfileEmoji': uploaderProfileEmoji,
      if (sharedLinkId != null) 'sharedLinkId': sharedLinkId,
      if (rootShareId != null) 'rootShareId': rootShareId,
      'storagePath': storagePath,
      'videoUrl': videoUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'durationSeconds': durationSeconds,
      'resolution': resolution,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'viewCount': viewCount,
      'viewedByUids': viewedByUids,
      'reportedByUids': reportedByUids,
      'isHidden': isHidden,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// 신고 사유
enum VerificationReportReason {
  inappropriate, // 부적절한 내용
  spam, // 스팸/광고
  harassment, // 괴롭힘
  other, // 기타
}

extension VerificationReportReasonExtension on VerificationReportReason {
  String labelKo() {
    switch (this) {
      case VerificationReportReason.inappropriate:
        return '부적절한 내용';
      case VerificationReportReason.spam:
        return '스팸/광고';
      case VerificationReportReason.harassment:
        return '괴롭힘/혐오';
      case VerificationReportReason.other:
        return '기타';
    }
  }

  String labelEn() {
    switch (this) {
      case VerificationReportReason.inappropriate:
        return 'Inappropriate content';
      case VerificationReportReason.spam:
        return 'Spam / Ads';
      case VerificationReportReason.harassment:
        return 'Harassment / Hate';
      case VerificationReportReason.other:
        return 'Other';
    }
  }

  String label(bool isKorean) => isKorean ? labelKo() : labelEn();

  String get firestoreKey {
    switch (this) {
      case VerificationReportReason.inappropriate:
        return 'inappropriate';
      case VerificationReportReason.spam:
        return 'spam';
      case VerificationReportReason.harassment:
        return 'harassment';
      case VerificationReportReason.other:
        return 'other';
    }
  }
}
