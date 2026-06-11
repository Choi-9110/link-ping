import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/links_provider.dart';
import '../../../providers/user_provider.dart';
import '../../widgets/banner_ad_widget.dart';
import '../home/home_screen.dart';
import '../bookmark/bookmark_screen.dart';
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

  final _screens = const [
    HomeScreen(),
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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 알람 → 외부 URL 다녀온 직후 앱 복귀 시 인증 프롬프트
      if (mounted) VerificationPromptDialog.showIfPending(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userProfile = ref.watch(userProfileProvider);
    final isPremium = userProfile.value?.isPremium ?? false;

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
