import 'package:cloud_firestore/cloud_firestore.dart';

/// 문의 상태
enum InquiryStatus {
  pending,  // 대기중
  answered, // 답변완료
}

/// 문의 모델
class Inquiry {
  final String id;
  final String userId;
  final String userNickname;
  final String title;
  final String content;
  final InquiryStatus status;
  final DateTime createdAt;
  final String? adminReply;
  final DateTime? repliedAt;

  const Inquiry({
    required this.id,
    required this.userId,
    required this.userNickname,
    required this.title,
    required this.content,
    required this.status,
    required this.createdAt,
    this.adminReply,
    this.repliedAt,
  });

  /// 상태 문자열
  String get statusString {
    switch (status) {
      case InquiryStatus.pending:
        return '대기중';
      case InquiryStatus.answered:
        return '답변완료';
    }
  }

  /// Firestore에서 읽기
  factory Inquiry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Inquiry(
      id: doc.id,
      userId: data['userId'] as String,
      userNickname: data['userNickname'] as String? ?? '익명',
      title: data['title'] as String,
      content: data['content'] as String,
      status: data['status'] == 'answered'
          ? InquiryStatus.answered
          : InquiryStatus.pending,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      adminReply: data['adminReply'] as String?,
      repliedAt: (data['repliedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Firestore에 저장
  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'userNickname': userNickname,
    'title': title,
    'content': content,
    'status': status == InquiryStatus.answered ? 'answered' : 'pending',
    'createdAt': FieldValue.serverTimestamp(),
    'adminReply': adminReply,
    'repliedAt': repliedAt != null ? Timestamp.fromDate(repliedAt!) : null,
  };
}
