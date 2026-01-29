import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보처리방침'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              theme,
              title: '1. 수집하는 개인정보',
              content: '''
LinkPing은 서비스 제공을 위해 다음 정보를 수집합니다:

• 닉네임: 사용자 식별 및 소셜 기능
• 이메일 주소: 구글 계정 연동 시 (선택)
• 링크 및 알림 설정: 서비스 핵심 기능
• 기기 식별자: 광고 제공 (AdMob)
''',
            ),
            _buildSection(
              theme,
              title: '2. 개인정보 이용 목적',
              content: '''
수집된 정보는 다음 목적으로 사용됩니다:

• 링크 알림 서비스 제공
• 사용자 간 소셜 기능 (응원, 찌르기)
• 배지 및 통계 시스템
• 맞춤형 광고 제공
• 서비스 개선 및 분석
''',
            ),
            _buildSection(
              theme,
              title: '3. 개인정보 보관 기간',
              content: '''
• 회원 탈퇴 시 즉시 삭제
• 게스트 데이터: 기기에만 저장, 앱 삭제 시 삭제
• 법령에 따른 보관이 필요한 경우 해당 기간 동안 보관
''',
            ),
            _buildSection(
              theme,
              title: '4. 제3자 제공',
              content: '''
LinkPing은 다음 서비스를 이용합니다:

• Firebase (Google): 인증, 데이터베이스
• Google AdMob: 광고 제공

이 서비스들의 개인정보처리방침:
• Google: https://policies.google.com/privacy
''',
            ),
            _buildSection(
              theme,
              title: '5. 이용자의 권리',
              content: '''
사용자는 다음 권리를 가집니다:

• 개인정보 열람 요청
• 개인정보 수정 요청
• 개인정보 삭제 요청 (회원 탈퇴)
• 광고 맞춤설정 거부 (기기 설정에서 가능)
''',
            ),
            _buildSection(
              theme,
              title: '6. 쿠키 및 추적 기술',
              content: '''
• 앱 내 쿠키는 사용하지 않습니다
• 광고 목적의 기기 식별자가 수집될 수 있습니다
• 기기 설정에서 광고 추적을 제한할 수 있습니다
''',
            ),
            _buildSection(
              theme,
              title: '7. 아동의 개인정보',
              content: '''
LinkPing은 만 14세 미만 아동의 개인정보를 수집하지 않습니다.
만 14세 미만임이 확인된 경우 해당 정보는 즉시 삭제됩니다.
''',
            ),
            _buildSection(
              theme,
              title: '8. 개인정보처리방침 변경',
              content: '''
본 방침은 2025년 1월 30일부터 시행됩니다.
변경 시 앱 내 공지를 통해 안내드립니다.
''',
            ),
            _buildSection(
              theme,
              title: '9. 문의',
              content: '''
개인정보 관련 문의:
• 이메일: support@linkping.app

※ 본 서비스는 대한민국 법률을 준수합니다.
''',
            ),
            const SizedBox(height: Spacing.xl),
            Center(
              child: Text(
                '최종 수정: 2025년 1월 30일',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            content.trim(),
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
