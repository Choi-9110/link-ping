import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('이용약관'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              theme,
              title: '제1조 (목적)',
              content: '''
본 약관은 LinkPing(이하 "서비스")의 이용과 관련하여 서비스 제공자와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
''',
            ),
            _buildSection(
              theme,
              title: '제2조 (정의)',
              content: '''
① "서비스"란 LinkPing 앱을 통해 제공되는 링크 알림 및 관련 기능을 말합니다.
② "이용자"란 본 약관에 동의하고 서비스를 이용하는 자를 말합니다.
③ "게스트"란 계정 연동 없이 서비스를 이용하는 자를 말합니다.
④ "회원"이란 구글 계정 등을 연동하여 서비스를 이용하는 자를 말합니다.
''',
            ),
            _buildSection(
              theme,
              title: '제3조 (약관의 효력)',
              content: '''
① 본 약관은 서비스 화면에 게시하거나 기타 방법으로 공지함으로써 효력이 발생합니다.
② 서비스 제공자는 필요한 경우 약관을 변경할 수 있으며, 변경된 약관은 공지 후 효력이 발생합니다.
③ 변경된 약관에 동의하지 않는 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다.
''',
            ),
            _buildSection(
              theme,
              title: '제4조 (서비스 이용)',
              content: '''
① 서비스는 무료로 제공되며, 일부 프리미엄 기능은 유료로 제공될 수 있습니다.
② 이용자는 다음 행위를 하여서는 안 됩니다:
  - 타인의 정보를 도용하는 행위
  - 서비스 운영을 방해하는 행위
  - 불법적이거나 부당한 목적으로 서비스를 이용하는 행위
  - 타인에게 불쾌감을 주는 내용을 전송하는 행위
③ 위반 시 서비스 이용이 제한될 수 있습니다.
''',
            ),
            _buildSection(
              theme,
              title: '제5조 (서비스 내용)',
              content: '''
서비스는 다음 기능을 제공합니다:

① 링크 알림: 설정한 시간에 링크 알림 발송
② 소셜 기능: 다른 이용자에게 응원/찌르기 전송
③ 배지 시스템: 활동에 따른 배지 획득
④ 공유 기능: 링크 설정을 다른 사람과 공유

서비스 내용은 개선을 위해 변경될 수 있습니다.
''',
            ),
            _buildSection(
              theme,
              title: '제6조 (프리미엄 서비스)',
              content: '''
① 프리미엄 서비스 구매 시 다음 혜택이 제공됩니다:
  - 광고 제거
  - 무제한 링크 등록
② 결제는 앱스토어/플레이스토어 정책을 따릅니다.
③ 환불은 각 스토어 정책에 따릅니다.
''',
            ),
            _buildSection(
              theme,
              title: '제7조 (지적재산권)',
              content: '''
① 서비스에 포함된 모든 콘텐츠의 저작권은 서비스 제공자에게 있습니다.
② 이용자가 등록한 링크 및 콘텐츠의 권리는 해당 이용자에게 있습니다.
③ 이용자는 서비스를 통해 얻은 정보를 서비스 제공자의 승인 없이 상업적으로 이용할 수 없습니다.
''',
            ),
            _buildSection(
              theme,
              title: '제8조 (면책조항)',
              content: '''
① 서비스 제공자는 천재지변, 시스템 장애 등 불가항력적 사유로 인한 서비스 중단에 대해 책임지지 않습니다.
② 이용자가 등록한 링크의 내용 및 적법성에 대한 책임은 이용자에게 있습니다.
③ 서비스 제공자는 이용자 간 분쟁에 대해 개입하지 않으며 책임지지 않습니다.
④ 알림 미발송, 지연 등으로 인한 손해에 대해 책임지지 않습니다.
''',
            ),
            _buildSection(
              theme,
              title: '제9조 (서비스 중단)',
              content: '''
① 서비스 제공자는 다음 경우 서비스를 일시적으로 중단할 수 있습니다:
  - 시스템 점검 및 업데이트
  - 천재지변 및 국가비상사태
  - 기타 불가피한 사유
② 서비스 중단 시 사전 공지하며, 긴급한 경우 사후 공지할 수 있습니다.
''',
            ),
            _buildSection(
              theme,
              title: '제10조 (계정 탈퇴)',
              content: '''
① 이용자는 언제든지 서비스 내에서 탈퇴할 수 있습니다.
② 탈퇴 시 모든 데이터는 삭제되며 복구되지 않습니다.
③ 게스트 이용자는 앱 삭제 시 데이터가 삭제됩니다.
''',
            ),
            _buildSection(
              theme,
              title: '제11조 (분쟁 해결)',
              content: '''
① 서비스 이용과 관련한 분쟁은 상호 협의하여 해결합니다.
② 협의가 이루어지지 않을 경우 대한민국 법률에 따라 관할 법원에서 해결합니다.
''',
            ),
            _buildSection(
              theme,
              title: '부칙',
              content: '''
본 약관은 2025년 1월 30일부터 시행됩니다.
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
