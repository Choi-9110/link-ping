import 'dart:math';

/// 공유 메시지 서비스 - 바이럴 마케팅용 랜덤 메시지 생성
class ShareMessageService {
  static final _random = Random();

  /// 한국어 홍보 문구 리스트
  static const _koMessages = [
    // 자기계발/습관
    '저장만 하지 말고 실천하자! 💪',
    '오늘도 갓생 살자! 🔥',
    '매일 실천하는 습관, 링크핑으로 시작하자',
    '나중에 보려고 저장한 영상,\n진짜 볼 시간이야!',

    // 운동
    '오늘 운동 루틴 영상 같이 보자! 💪',
    '홈트 영상 저장만 해두고 안 봤지? \n이제 진짜 하자',
    '운동은 내일부터? \n혼자는힘들어? \n친구랑 내기해봐!! ',

    // 효도/연인
    '매일 밤 10시, 부모님께 전화하자 📞',
    '소중한 사람에게 매일 연락하는 습관',
    '효도 알람으로 매일 부모님 안부 챙기기',
    '연인에게 까먹지 않고 연락하는 비결 💕',

    // 학습
    '영어 공부 영상, 이제 진짜 보자 📚',
    '자기계발 콘텐츠 정해진 시간에 알림 받자',
    '배우고 싶었던 거, 링크핑으로 매일 조금씩',

    // 일반
    '링크 저장만 하고 안 보던 시절 끝! ✨',
    '저장 = 실천으로 만들어주는 앱',
    '같이 시작하자! 너도 링크핑 해봐',
  ];

  /// 영어 홍보 문구 리스트
  static const _enMessages = [
    // Self-improvement
    "Stop saving, start doing! 💪",
    "Time to be THAT girl/guy! 🔥",
    "Your saved links deserve to be watched",
    "No more 'Watch Later' guilt",

    // Fitness
    "Let's do that workout video together! 💪",
    "Finally watch those fitness videos you saved",
    "Your workout routine is waiting",

    // Calls/Family
    "Never forget to call Mom 📞",
    "Stay connected with loved ones daily",
    "Daily reminder to reach out to someone special 💕",

    // General
    "From saving to actually doing ✨",
    "Link it. Ping it. Do it.",
    "Join me on LinkPing!",
  ];

  /// 랜덤 홍보 메시지 가져오기
  static String getRandomMessage({bool isKorean = true}) {
    final messages = isKorean ? _koMessages : _enMessages;
    return messages[_random.nextInt(messages.length)];
  }

  /// 초대 공유 메시지 생성 (랜덤 문구 + 초대 코드)
  static String generateInviteMessage({
    required String referralCode,
    bool isKorean = true,
  }) {
    final randomMessage = getRandomMessage(isKorean: isKorean);

    if (isKorean) {
      return '''
$randomMessage

LinkPing 앱 설치하고 가입할 때
초대 코드 입력하면 보너스 링크 +1! 🎁

내 초대 코드: $referralCode

다운로드: https://linkping.app
''';
    } else {
      return '''
$randomMessage

Download LinkPing and enter my code
when signing up for a bonus link! 🎁

My invite code: $referralCode

Download: https://linkping.app
''';
    }
  }
}
