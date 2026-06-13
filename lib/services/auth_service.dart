import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
      print('Google 로그인 시작...');

      // Google 로그인 플로우
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('Google 계정 선택: ${googleUser?.email}');

      if (googleUser == null) {
        print('사용자가 로그인 취소함');
        return null; // 사용자가 취소함
      }

      // 인증 정보 가져오기
      print('인증 정보 가져오는 중...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('accessToken: ${googleAuth.accessToken != null}');
      print('idToken: ${googleAuth.idToken != null}');

      // Firebase credential 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase 로그인
      print('Firebase 로그인 중...');
      final result = await _auth.signInWithCredential(credential);
      print('Firebase 로그인 성공: ${result.user?.uid}');
      return result;
    } catch (e, stackTrace) {
      print('Google 로그인 에러: $e');
      print('스택 트레이스: $stackTrace');
      rethrow;
    }
  }

  /// Apple 로그인 (iOS 전용)
  Future<UserCredential?> signInWithApple() async {
    try {
      // nonce 생성 (보안)
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Apple 로그인 플로우
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Firebase credential 생성
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        // Apple authorizationCode 를 함께 넘겨야 Firebase가 검증 가능.
        // 빠지면 [firebase_auth/invalid-credential] Invalid OAuth response 발생.
        accessToken: appleCredential.authorizationCode,
      );

      // Firebase 로그인
      final result = await _auth.signInWithCredential(oauthCredential);

      // Apple은 최초 로그인 시에만 이름을 전달함 → displayName 업데이트
      if (result.user != null &&
          (result.user!.displayName == null || result.user!.displayName!.isEmpty)) {
        final fullName = [
          appleCredential.givenName,
          appleCredential.familyName,
        ].where((n) => n != null && n.isNotEmpty).join(' ');

        if (fullName.isNotEmpty) {
          await result.user!.updateDisplayName(fullName);
        }
      }

      return result;
    } catch (e) {
      print('Apple 로그인 에러: $e');
      rethrow;
    }
  }

  /// Apple 계정 연동 (게스트 → Apple)
  Future<UserCredential?> linkWithApple() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        // Apple authorizationCode 를 함께 넘겨야 Firebase가 검증 가능.
        // 빠지면 [firebase_auth/invalid-credential] Invalid OAuth response 발생.
        accessToken: appleCredential.authorizationCode,
      );

      return await user.linkWithCredential(oauthCredential);
    } catch (e) {
      print('Apple 연동 에러: $e');
      rethrow;
    }
  }

  /// 랜덤 nonce 생성
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// SHA256 해시
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 전화번호 인증 — SMS 발송 요청.
  /// [phoneNumber]는 E.164 형식(예: +821012345678).
  /// 코드 전송되면 [onCodeSent], 안드로이드 자동 인증 시 [onAutoVerified],
  /// 실패 시 [onFailed] 호출.
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException e) onFailed,
    void Function(UserCredential credential)? onAutoVerified,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // 안드로이드 자동 코드 인식
        if (onAutoVerified != null) {
          final result = await _auth.signInWithCredential(credential);
          onAutoVerified(result);
        }
      },
      verificationFailed: onFailed,
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// 전화번호 인증 — 입력한 SMS 코드로 로그인.
  Future<UserCredential> signInWithSmsCode({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
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

  /// 게스트 닉네임 저장하기
  Future<void> saveGuestNickname(String nickname) async {
    final settingsBox = Hive.box('settings');
    await settingsBox.put('guestNickname', nickname);
  }

  /// 게스트 프로필 이모지 가져오기
  String getGuestEmoji() {
    final settingsBox = Hive.box('settings');
    return settingsBox.get('guestEmoji', defaultValue: 'face_grinning');
  }

  /// 게스트 프로필 이모지 저장하기
  Future<void> saveGuestEmoji(String emoji) async {
    final settingsBox = Hive.box('settings');
    await settingsBox.put('guestEmoji', emoji);
  }

  /// 게스트 전화번호 가져오기
  String? getGuestPhoneNumber() {
    final settingsBox = Hive.box('settings');
    return settingsBox.get('guestPhoneNumber');
  }

  /// 게스트 전화번호 저장하기
  Future<void> saveGuestPhoneNumber(String? phoneNumber) async {
    final settingsBox = Hive.box('settings');
    if (phoneNumber == null) {
      await settingsBox.delete('guestPhoneNumber');
    } else {
      await settingsBox.put('guestPhoneNumber', phoneNumber);
    }
  }

  /// Google 계정 연동 (익명 계정 → Google 계정)
  Future<UserCredential?> linkWithGoogle() async {
    try {
      print('Google 연동 시작...');

      final user = currentUser;
      if (user == null) {
        print('현재 사용자 없음');
        return null;
      }
      print('현재 사용자: ${user.uid}');

      // Google 로그인 플로우
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('Google 계정 선택: ${googleUser?.email}');

      if (googleUser == null) {
        print('사용자가 연동 취소함');
        return null;
      }

      // 인증 정보 가져오기
      print('인증 정보 가져오는 중...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('accessToken: ${googleAuth.accessToken != null}');
      print('idToken: ${googleAuth.idToken != null}');

      // Firebase credential 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 기존 계정에 Google 연동
      print('계정 연동 중...');
      final result = await user.linkWithCredential(credential);
      print('연동 성공: ${result.user?.uid}');
      return result;
    } catch (e, stackTrace) {
      print('Google 연동 에러: $e');
      print('스택 트레이스: $stackTrace');
      rethrow;
    }
  }

  /// Google 연동 해제
  Future<void> unlinkGoogle() async {
    try {
      final user = currentUser;
      if (user == null) return;

      await user.unlink('google.com');
      await _googleSignIn.signOut();
      print('Google 연동 해제 완료');
    } catch (e) {
      print('Google 연동 해제 에러: $e');
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // ==================== 회원 탈퇴 ====================

  /// 탈퇴 전 재인증 필요 여부 사전 확인.
  /// Firebase 는 user.delete() 같은 민감 작업에 최근 로그인(약 5분)을 요구한다.
  /// 데이터를 먼저 지운 뒤 Auth 삭제가 거부되면 "데이터만 사라지고 계정은 남는"
  /// 어중간한 상태가 되므로, 데이터 삭제 전에 미리 던져서 막는다.
  void ensureRecentLoginForDeletion() {
    final user = _auth.currentUser;
    if (user == null || user.isAnonymous) return;

    final lastSignIn = user.metadata.lastSignInTime;
    if (lastSignIn != null &&
        DateTime.now().difference(lastSignIn) > const Duration(minutes: 5)) {
      throw FirebaseAuthException(code: 'requires-recent-login');
    }
  }

  /// Firebase Auth 계정 삭제. 클라우드 데이터 삭제(FirestoreService.deleteAllUserData)
  /// **후에** 호출할 것.
  Future<void> deleteAuthAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await user.delete();
  }
}
