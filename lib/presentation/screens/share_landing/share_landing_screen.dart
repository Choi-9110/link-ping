import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/shared_link.dart';
import '../../../l10n/app_localizations.dart';
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

  // 컬러 테마에서 가져오기
  Color get _brandAccent => AppTheme.colorTheme.brandAccent;
  LinearGradient get _backgroundGradient => AppTheme.colorTheme.backgroundGradient;
  Color get _surfacePlaceholder => AppTheme.colorTheme.surfaceVariant;
  // 성공 상태 컬러 (민트/그린 계열)
  Color get _successColor => AppTheme.colorTheme.secondary;

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
          _error = 'linkNotFound';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'linkLoadFailed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _backgroundGradient,
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
    final l10n = AppLocalizations.of(context)!;
    final errorMessage = _error == 'linkNotFound' ? l10n.linkNotFound : l10n.linkLoadFailed;
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
            errorMessage,
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
    final l10n = AppLocalizations.of(context)!;
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
                color: _brandAccent.withValues(alpha: 0.4),
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
                  color: _surfacePlaceholder,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.link,
                  color: _brandAccent,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Linkku',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.linkNotificationService,
          style: const TextStyle(
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
                  color: _brandAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      color: _brandAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      Localizations.localeOf(context).languageCode == 'ko'
                          ? '${link.sharedBy}님이 공유'
                          : 'Shared by ${link.sharedBy}',
                      style: TextStyle(
                        color: _brandAccent,
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
          // 알림 시간 (공유자의 언어로 표시)
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.access_time,
                label: link.getTimeString(Localizations.localeOf(context).languageCode == 'ko'),
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.repeat,
                label: link.getRepeatString(Localizations.localeOf(context).languageCode == 'ko'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 잠금 상태 표시
          Builder(builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            final statusColor = link.isLocked ? _brandAccent : _successColor;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    link.isLocked ? Icons.lock : Icons.lock_open,
                    color: statusColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          link.isLocked ? l10n.timeLockedAlarm : l10n.timeEditable,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          link.isLocked
                              ? l10n.lockedTimeDesc
                              : l10n.editableTimeDesc,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // 앱에서 열기 버튼 (메인) - 딥링크 바로 시도
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _tryOpenApp,
            style: ElevatedButton.styleFrom(
              backgroundColor: _brandAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: _brandAccent.withValues(alpha: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.open_in_new, size: 22),
                const SizedBox(width: 8),
                Text(
                  l10n.openInApp,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 앱 없으면 설치 안내
        Text(
          l10n.appRequiredMessage,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
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
    final l10n = AppLocalizations.of(context)!;
    return TextButton(
      onPressed: () => _openUrl(link.url),
      child: Text(
        l10n.openLinkInBrowser,
        style: const TextStyle(
          color: Colors.white54,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildFooter(SharedLink link) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l10n.viewCount(link.viewCount + 1),
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          link.isLocked
              ? l10n.receivedSharedAlarmInfo(link.sharedBy)
              : l10n.saveAndChangeTime,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 앱 열기 시도 (딥링크 바로 실행)
  void _tryOpenApp() {
    final deepLink = 'linkping://share/${widget.shareId}';
    final uri = Uri.parse(deepLink);

    // 바로 딥링크 실행 시도 (canLaunchUrl 체크 안 함)
    launchUrl(uri, mode: LaunchMode.externalApplication);
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
    _openUrl('https://play.google.com/store/apps/details?id=com.drevv.linkping');
  }
}
