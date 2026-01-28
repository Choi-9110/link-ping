/// URL을 저장한 유저 정보
class SavedByUser {
  final String uid;
  final String nickname;

  SavedByUser({
    required this.uid,
    required this.nickname,
  });

  factory SavedByUser.fromMap(Map<String, dynamic> map) {
    return SavedByUser(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
    };
  }
}
