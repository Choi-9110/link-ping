import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 랜덤 닉네임 생성기
class RandomNicknameGenerator {
  static final _random = Random();

  // 한국어 형용사
  static const _koAdjectives = [
    '앙큼한', '아찔한', '은근한', '싱그러운', '포근한',
    '아련한', '설레는', '나른한', '청량한', '몽글몽글',
    '반짝이는', '살랑살랑', '몽환적인', '아슬아슬', '두근두근',
    '새콤한', '달콤한', '시원한', '따스한', '고요한',
  ];

  // 한국어 월/계절
  static const _koMonths = [
    '1월의', '2월의', '3월의', '4월의', '5월의', '6월의',
    '7월의', '8월의', '9월의', '10월의', '11월의', '12월의',
    '봄날의', '여름의', '가을의', '겨울의', '새벽의', '한밤의',
  ];

  // 한국어 명사
  static const _koNouns = [
    '호랑이', '토끼', '여우', '고양이', '강아지',
    '종달새', '참새', '나비', '반딧불', '다람쥐',
    '봄비', '바람', '노을', '달빛', '별빛',
    '들꽃', '민들레', '벚꽃', '코스모스', '해바라기',
    '구름', '안개', '이슬', '무지개', '눈송이',
  ];

  // 영어 형용사
  static const _enAdjectives = [
    'Wandering', 'Dreamy', 'Misty', 'Gentle', 'Wild',
    'Silent', 'Drifting', 'Glowing', 'Sleepy', 'Curious',
    'Whispering', 'Dancing', 'Floating', 'Sparkling', 'Lazy',
    'Midnight', 'Golden', 'Silver', 'Velvet', 'Crystal',
  ];

  // 영어 시간/계절
  static const _enTimes = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
    'Spring', 'Summer', 'Autumn', 'Winter', 'Dawn', 'Twilight',
  ];

  // 영어 명사
  static const _enNouns = [
    'Tiger', 'Rabbit', 'Fox', 'Cat', 'Wolf',
    'Sparrow', 'Owl', 'Butterfly', 'Firefly', 'Deer',
    'Rain', 'Breeze', 'Sunset', 'Moonlight', 'Starlight',
    'Daisy', 'Lily', 'Cherry', 'Maple', 'Willow',
    'Cloud', 'Mist', 'Dew', 'Rainbow', 'Snowflake',
  ];

  /// 한국어 닉네임 생성 (예: "앙큼한 4월의 호랑이")
  static String generateKorean() {
    final adj = _koAdjectives[_random.nextInt(_koAdjectives.length)];
    final month = _koMonths[_random.nextInt(_koMonths.length)];
    final noun = _koNouns[_random.nextInt(_koNouns.length)];
    return '$adj $month $noun';
  }

  /// 영어 닉네임 생성 (예: "Wandering April Tiger")
  static String generateEnglish() {
    final adj = _enAdjectives[_random.nextInt(_enAdjectives.length)];
    final time = _enTimes[_random.nextInt(_enTimes.length)];
    final noun = _enNouns[_random.nextInt(_enNouns.length)];
    return '$adj $time $noun';
  }

  /// 기기 언어에 따라 닉네임 생성
  static String generate({bool isKorean = true}) {
    return isKorean ? generateKorean() : generateEnglish();
  }
}

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// 현재 사용자
  User? get currentUser => _auth.currentUser;

  /// 로그인 상태 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 로그인 여부
  bool get isLoggedIn => currentUser != null;

  /// 게스트 여부
  bool get isGuest => currentUser?.isAnonymous ?? false;

  /// Google 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google 로그인 플로우
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // 사용자가 취소함

      // 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase credential 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase 로그인
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Google 로그인 에러: $e');
      rethrow;
    }
  }

  /// 익명 로그인 (게스트 모드)
  Future<UserCredential?> signInAnonymously({bool isKorean = true}) async {
    try {
      final credential = await _auth.signInAnonymously();

      // 게스트 닉네임 생성 및 저장
      if (credential.user != null) {
        final settingsBox = Hive.box('settings');
        if (settingsBox.get('guestNickname') == null) {
          final nickname = RandomNicknameGenerator.generate(isKorean: isKorean);
          settingsBox.put('guestNickname', nickname);
        }
      }

      return credential;
    } catch (e) {
      print('익명 로그인 에러: $e');
      rethrow;
    }
  }

  /// 게스트 닉네임 가져오기
  String getGuestNickname() {
    final settingsBox = Hive.box('settings');
    return settingsBox.get('guestNickname', defaultValue: '게스트');
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
