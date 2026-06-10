import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';

/// 웹 앱 소개 페이지
class WebIntroScreen extends StatelessWidget {
  const WebIntroScreen({super.key});

  // 컬러 테마에서 가져오기
  Color get _brandAccent => AppTheme.colorTheme.brandAccent;
  LinearGradient get _backgroundGradient => AppTheme.colorTheme.backgroundGradient;
  Color get _surfacePlaceholder => AppTheme.colorTheme.surfaceVariant;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 헤더
                _buildHeader(isWide),
                // 히어로 섹션
                _buildHeroSection(context, isWide),
                // 기능 소개
                _buildFeaturesSection(isWide),
                // 활용 예시 (Use Cases)
                _buildUseCasesSection(isWide),
                // 사용 방법
                _buildHowItWorksSection(isWide),
                // 다운로드 CTA
                _buildDownloadSection(context, isWide),
                // 푸터
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 48 : 24,
        vertical: 16,
      ),
      child: Row(
        children: [
          // 로고
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: _brandAccent.withValues(alpha: 0.3),
                  blurRadius: 15,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/app_icon.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: _surfacePlaceholder,
                  child: Icon(Icons.link, color: _brandAccent),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Linkku',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 80 : 48,
      ),
      child: Column(
        children: [
          // 앱 아이콘 (큰 버전)
          Container(
            width: isWide ? 160 : 120,
            height: isWide ? 160 : 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: _brandAccent.withValues(alpha: 0.4),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                'assets/app_icon.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: _surfacePlaceholder,
                  child: Icon(Icons.link, color: _brandAccent, size: 60),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // 타이틀
          Text(
            '매일 링크 알림을\n받아보세요',
            style: TextStyle(
              color: Colors.white,
              fontSize: isWide ? 48 : 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 서브타이틀
          Text(
            '정해진 시간에 중요한 링크를 열어보는\n가장 쉬운 습관 만들기',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isWide ? 20 : 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // 다운로드 버튼들
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildStoreButton(
                icon: Icons.apple,
                label: 'App Store',
                onTap: _openAppStore,
              ),
              _buildStoreButton(
                icon: Icons.android,
                label: 'Play Store',
                onTap: _openPlayStore,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.black87, size: 24),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(bool isWide) {
    final features = [
      {
        'icon': Icons.notifications_active,
        'title': '정시 알림',
        'desc': '원하는 시간에\n링크 알림을 받아요',
      },
      {
        'icon': Icons.repeat,
        'title': '반복 설정',
        'desc': '매일, 주중, 주말\n원하는 요일만 선택',
      },
      {
        'icon': Icons.people,
        'title': '친구와 공유',
        'desc': '좋은 링크는\n친구에게 공유해요',
      },
      {
        'icon': Icons.emoji_events,
        'title': '배지 수집',
        'desc': '습관을 이어가며\n배지를 모아요',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 48,
      ),
      child: Column(
        children: [
          const Text(
            '주요 기능',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: features.map((f) => _buildFeatureCard(
              icon: f['icon'] as IconData,
              title: f['title'] as String,
              desc: f['desc'] as String,
              isWide: isWide,
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String desc,
    required bool isWide,
  }) {
    return Container(
      width: isWide ? 200 : 150,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _brandAccent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: _brandAccent, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUseCasesSection(bool isWide) {
    // 테마에서 가져온 색상들 사용
    final colors = AppTheme.colorTheme;

    final useCases = [
      {
        'emoji': '💑',
        'title': '장거리 연애 커플',
        'desc': '떨어져 있어도 같은 시간에\n넷플릭스 같이 보기',
        'tag': '매일 밤 10시',
        'color': colors.tertiary, // 퍼플 계열
      },
      {
        'emoji': '📚',
        'title': '자기계발 루틴',
        'desc': '아침 TED 강연\n점심 영어 공부 영상',
        'tag': '매일 성장하기',
        'color': const Color(0xFF0984E3), // 블루
      },
      {
        'emoji': '🏋️',
        'title': '운동 버디',
        'desc': '친구와 같은 시간에\n홈트 영상 따라하기',
        'tag': '함께라서 가능해',
        'color': colors.secondary, // 민트
      },
      {
        'emoji': '👨‍👩‍👧',
        'title': '가족 교육',
        'desc': '아이에게 매일 정해진 시간에\n교육 콘텐츠 보여주기',
        'tag': '습관 만들기',
        'color': const Color(0xFFFDAE61), // 오렌지
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 48,
      ),
      color: _brandAccent.withValues(alpha: 0.1),
      child: Column(
        children: [
          const Text(
            '이런 분들이 사용해요',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: useCases.map((uc) => _buildUseCaseCard(
              emoji: uc['emoji'] as String,
              title: uc['title'] as String,
              desc: uc['desc'] as String,
              tag: uc['tag'] as String,
              color: uc['color'] as Color,
              isWide: isWide,
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUseCaseCard({
    required String emoji,
    required String title,
    required String desc,
    required String tag,
    required Color color,
    required bool isWide,
  }) {
    return Container(
      width: isWide ? 240 : 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection(bool isWide) {
    final steps = [
      {'num': '1', 'title': '링크 등록', 'desc': '알림 받고 싶은 링크를 등록해요'},
      {'num': '2', 'title': '시간 설정', 'desc': '원하는 시간과 요일을 선택해요'},
      {'num': '3', 'title': '알림 수신', 'desc': '정해진 시간에 알림이 와요'},
      {'num': '4', 'title': '습관 형성', 'desc': '매일 반복하며 습관을 만들어요'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 48,
      ),
      color: Colors.black.withValues(alpha: 0.2),
      child: Column(
        children: [
          const Text(
            '이렇게 사용해요',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 32,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: steps.map((s) => _buildStepItem(
              num: s['num'] as String,
              title: s['title'] as String,
              desc: s['desc'] as String,
              isWide: isWide,
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required String num,
    required String title,
    required String desc,
    required bool isWide,
  }) {
    return SizedBox(
      width: isWide ? 180 : 140,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _brandAccent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                num,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadSection(BuildContext context, bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 64,
      ),
      child: Column(
        children: [
          const Text(
            '지금 시작하세요',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '무료로 다운로드하고 습관을 만들어보세요',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildStoreButton(
                icon: Icons.apple,
                label: 'App Store',
                onTap: _openAppStore,
              ),
              _buildStoreButton(
                icon: Icons.android,
                label: 'Play Store',
                onTap: _openPlayStore,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: const Column(
        children: [
          Text(
            'Linkku',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '© 2025 Linkku. All rights reserved.',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _openAppStore() {
    // TODO: 실제 App Store URL로 변경
    launchUrl(Uri.parse('https://apps.apple.com/app/linkping/id000000000'));
  }

  void _openPlayStore() {
    // TODO: 실제 Play Store URL로 변경
    launchUrl(
      Uri.parse('https://play.google.com/store/apps/details?id=com.drevv.linkping'),
    );
  }
}
