// 링꾸 기본 스모크 테스트.
// (이전의 flutter create 기본 카운터 테스트는 이 앱과 무관해 교체함)
import 'package:flutter_test/flutter_test.dart';
import 'package:linkping/services/auth_service.dart';

void main() {
  test('RandomNicknameGenerator는 비어있지 않은 닉네임을 만든다', () {
    expect(RandomNicknameGenerator.generateKorean(), isNotEmpty);
    expect(RandomNicknameGenerator.generateEnglish(), isNotEmpty);
    expect(RandomNicknameGenerator.generate(isKorean: true), isNotEmpty);
    expect(RandomNicknameGenerator.generate(isKorean: false), isNotEmpty);
  });
}
