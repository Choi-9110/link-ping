import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// 웹 앱 소개 페이지
class WebIntroScreen extends StatelessWidget {
  const WebIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
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
                  color: const Color(0xFFe94560).withValues(alpha: 0.3),
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
                  color: const Color(0xFF2D3250),
                  child: const Icon(Icons.link, color: Color(0xFFe94560)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'LinkPing',
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
                  color: const Color(0xFFe94560).withValues(alpha: 0.4),
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
                  color: const Color(0xFF2D3250),
                  child: const Icon(Icons.link, color: Color(0xFFe94560), size: 60),
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
              color: const Color(0xFFe94560).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFFe94560), size: 28),
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
              color: const Color(0xFFe94560),
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
      child: Column(
        children: [
          const Text(
            'LinkPing',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '© 2025 LinkPing. All rights reserved.',
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
    launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.linkping.app'));
  }
}
