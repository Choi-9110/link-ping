import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/ping_notification.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/links_provider.dart';
import '../../../providers/user_provider.dart';
import '../../widgets/banner_ad_widget.dart';
import '../../widgets/share_accept_flow.dart';
import '../../widgets/toast_overlay.dart';
import '../home/home_screen.dart';
import '../bookmark/bookmark_screen.dart';
import '../verification/verification_gallery_screen.dart';
import '../verification/verification_prompt_dialog.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _cloudRestored = false; // 프리미엄 클라우드 복원 1회 실행 가드

  // 인앱 핑 토스트: 첫 로드(기존 알림)는 건너뛰고 새로 도착한 것만 띄운다
  bool _pingToastInit = false;
  String? _lastPingId;

  // 딥링크 수신 (linkping://share/{id}, https://.../s/{id})
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;
  final _handledShareIds = <String>{};

  final _screens = const [
    HomeScreen(),
    VerificationGalleryScreen(),
    BookmarkScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 첫 진입 시에도 보류된 인증이 있으면 노출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) VerificationPromptDialog.showIfPending(context);
    });
    _initDeepLinks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkSub?.cancel();
    super.dispose();
  }

  // ==================== 공유 링크 딥링크 수신 ====================

  /// 콜드 스타트(앱이 링크로 실행됨) + 웜 스타트(실행 중 링크 탭) 모두 처리
  Future<void> _initDeepLinks() async {
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) _handleIncomingUri(initial);
    } catch (_) {}
    _linkSub = _appLinks.uriLinkStream.listen(
      _handleIncomingUri,
      onError: (_) {},
    );
  }

  void _handleIncomingUri(Uri uri) {
    // linkping://share/{shareId}  (웹 랜딩의 "앱에서 열기")
    // https://linkping-prod.web.app/s/{shareId}  (유니버설 링크 — 추후)
    String? shareId;
    if (uri.scheme == 'linkping' && uri.host == 'share') {
      if (uri.pathSegments.isNotEmpty) shareId = uri.pathSegments.first;
    } else if (uri.pathSegments.length >= 2 && uri.pathSegments.first == 's') {
      shareId = uri.pathSegments[1];
    }
    if (shareId == null || shareId.isEmpty) return;
    if (!_handledShareIds.add(shareId)) return; // 같은 링크 중복 처리 방지

    final id = shareId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) promptSaveSharedLink(context, ref, id);
    });
  }

  /// 새 핑(응원/찌르기 등) 도착 시 인앱 토스트 "뿅"
  void _onPingArrived(PingNotification n) {
    final l10n = AppLocalizations.of(context)!;
    final String message;
    switch (n.type) {
      case PingType.cheer:
        message = l10n.pingCheerToast(n.fromNickname);
        break;
      case PingType.tease:
        message = l10n.pingPokeToast(n.fromNickname);
        break;
      case PingType.referralAccepted:
        message = l10n.pingReferralToast;
        break;
      case PingType.inquiryReply:
        message = l10n.pingInquiryToast;
        break;
      default:
        message = l10n.pingGenericToast;
    }
    ToastOverlay.show(context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userProfile = ref.watch(userProfileProvider);
    final isPremium = userProfile.value?.isPremium ?? false;

    // 새 알림 도착 감지 → 토스트 (첫 로드는 기준점만 기록)
    ref.listen(myNotificationsProvider, (previous, next) {
      final list = next.valueOrNull;
      if (list == null) return;
      final top = list.isEmpty ? null : list.first;
      if (!_pingToastInit) {
        _pingToastInit = true;
        _lastPingId = top?.id;
        return;
      }
      if (top != null && top.id != _lastPingId) {
        _lastPingId = top.id;
        final notification = top;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _onPingArrived(notification);
        });
      }
    });

    // 프리미엄 로그인 확인되면 클라우드 백업 → 로컬 복원 1회 실행
    if (isPremium && !_cloudRestored) {
      _cloudRestored = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(linksProvider.notifier).syncWithCloud();
      });
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 배너 광고 (프리미엄 사용자는 제외)
          if (!isPremium) const BannerAdWidget(),
          // 상단 구분선
          Container(
            height: 0.5,
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
          // 커스텀 네비게이션 바
          Container(
            color: colorScheme.surface,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
              top: 8,
            ),
            child: Row(
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.notifications_outlined,
                  activeIcon: Icons.notifications,
                  label: 'Linkku',
                  colorScheme: colorScheme,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.videocam_outlined,
                  activeIcon: Icons.videocam,
                  label: 'Proof',
                  colorScheme: colorScheme,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.bookmark_outline,
                  activeIcon: Icons.bookmark,
                  label: 'Bookmark',
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 아이콘 + 글로우 효과
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  size: 24,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              // 라벨
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  letterSpacing: isSelected ? 0.3 : 0,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
