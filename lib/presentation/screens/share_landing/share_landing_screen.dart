import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/shared_link.dart';
import '../../../services/firestore_service.dart';

class ShareLandingScreen extends StatefulWidget {
  final String shareId;

  const ShareLandingScreen({super.key, required this.shareId});

  @override
  State<ShareLandingScreen> createState() => _ShareLandingScreenState();
}

class _ShareLandingScreenState extends State<ShareLandingScreen> {
  SharedLink? _sharedLink;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSharedLink();
  }

  Future<void> _loadSharedLink() async {
    try {
      final link = await FirestoreService.instance.getSharedLink(widget.shareId);
      if (link != null) {
        // 조회수 증가
        await FirestoreService.instance.incrementShareViewCount(widget.shareId);
      }
      setState(() {
        _sharedLink = link;
        _isLoading = false;
        if (link == null) {
          _error = '링크를 찾을 수 없어요';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = '링크를 불러오는데 실패했어요';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _error != null
                  ? _buildErrorState()
                  : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.link_off,
            size: 80,
            color: Colors.white54,
          ),
          const SizedBox(height: 24),
          Text(
            _error!,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 32),
          _buildDownloadButton(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final link = _sharedLink!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: EdgeInsets.all(isWide ? 48 : 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // 로고
                _buildLogo(),
                const SizedBox(height: 48),
                // 공유 카드
                _buildShareCard(link),
                const SizedBox(height: 32),
                // 다운로드 버튼
                _buildDownloadButton(),
                const SizedBox(height: 16),
                // 웹에서 열기 버튼
                _buildOpenInBrowserButton(link),
                const SizedBox(height: 48),
                // 푸터
                _buildFooter(link),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // 글로우 이펙트가 있는 로고
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFe94560).withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/app_icon.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3250),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.link,
                  color: Color(0xFFe94560),
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'LinkPing',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '링크 알림 서비스',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildShareCard(SharedLink link) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 공유자 정보
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFe94560).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person,
                      color: Color(0xFFe94560),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${link.sharedBy}님이 공유',
                      style: const TextStyle(
                        color: Color(0xFFe94560),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 링크 제목
          Text(
            link.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // URL 미리보기
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.link,
                  color: Colors.white54,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    link.url,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 알림 시간
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.access_time,
                label: link.timeString,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.repeat,
                label: link.repeatString,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Column(
      children: [
        // 앱에서 열기 버튼 (메인)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _openInApp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFe94560),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: const Color(0xFFe94560).withValues(alpha: 0.5),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_rounded, size: 22),
                SizedBox(width: 8),
                Text(
                  '앱에서 저장하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 스토어 버튼들
        Row(
          children: [
            Expanded(
              child: _buildStoreButton(
                icon: Icons.apple,
                label: 'App Store',
                onTap: _openAppStore,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStoreButton(
                icon: Icons.android,
                label: 'Play Store',
                onTap: _openPlayStore,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStoreButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildOpenInBrowserButton(SharedLink link) {
    return TextButton(
      onPressed: () => _openUrl(link.url),
      child: const Text(
        '브라우저에서 링크 열기',
        style: TextStyle(
          color: Colors.white54,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildFooter(SharedLink link) {
    return Column(
      children: [
        Text(
          '조회 ${link.viewCount + 1}회',
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '매일 정해진 시간에 링크 알림을 받아보세요',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _openInApp() {
    // 딥링크로 앱 열기 시도
    final deepLink = 'linkping://share/${widget.shareId}';

    if (kIsWeb) {
      // 웹에서는 딥링크 시도 후 스토어로 이동
      _tryDeepLink(deepLink);
    } else {
      // 앱 내에서는 바로 저장 처리
      Navigator.pop(context, _sharedLink);
    }
  }

  Future<void> _tryDeepLink(String deepLink) async {
    final uri = Uri.parse(deepLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // 앱이 없으면 스토어로
      _showStoreDialog();
    }
  }

  void _showStoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'LinkPing 앱 설치',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '앱을 설치하고 링크 알림을 받아보세요!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openAppStore(); // iOS 우선
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFe94560),
            ),
            child: const Text('설치하기'),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openAppStore() {
    // TODO: 실제 App Store URL로 변경
    _openUrl('https://apps.apple.com/app/linkping/id000000000');
  }

  void _openPlayStore() {
    // TODO: 실제 Play Store URL로 변경
    _openUrl('https://play.google.com/store/apps/details?id=com.linkping.app');
  }
}
