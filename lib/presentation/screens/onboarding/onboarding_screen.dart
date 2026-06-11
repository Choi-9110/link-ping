import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/linkku_logo.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingPage> _getPages(AppLocalizations l10n) {
    // 테마 컬러 사용
    final colors = AppTheme.colorTheme;

    return [
      // 1. 기본 소개
      OnboardingPage(
        pixelEmojiAsset: 'assets/pixel_emojis/badge_link.webp',
        title: l10n.onboarding1Title,
        description: l10n.onboarding1Desc,
        backgroundColor: colors.tertiary, // 퍼플
      ),
      // 2. 알림 기능
      OnboardingPage(
        pixelEmojiAsset: 'assets/pixel_emojis/badge_sunrise.webp',
        title: l10n.onboarding2Title,
        description: l10n.onboarding2Desc,
        backgroundColor: colors.secondary, // 민트
      ),
      // 3. 활용 예시 - 커플
      OnboardingPage(
        pixelEmojiAsset: 'assets/pixel_emojis/face_love.webp',
        title: l10n.onboarding3Title,
        description: l10n.onboarding3Desc,
        subText: l10n.onboarding3Sub,
        backgroundColor: colors.primary, // 코랄
      ),
      // 4. 활용 예시 - 자기계발
      OnboardingPage(
        pixelEmojiAsset: 'assets/pixel_emojis/item_books.webp',
        title: l10n.onboarding4Title,
        description: l10n.onboarding4Desc,
        subText: l10n.onboarding4Sub,
        backgroundColor: colors.tertiary.withValues(alpha: 0.8), // 퍼플 변형
      ),
      // 5. 활용 예시 - 친구들과
      OnboardingPage(
        pixelEmojiAsset: 'assets/pixel_emojis/face_party.webp',
        title: l10n.onboarding5Title,
        description: l10n.onboarding5Desc,
        subText: l10n.onboarding5Sub,
        backgroundColor: colors.secondary.withValues(alpha: 0.8), // 민트 변형
      ),
      // 6. 시작하기 — 마지막 인상은 마스코트(스파크)로 브랜드 각인
      OnboardingPage(
        useMascot: true,
        title: l10n.onboarding6Title,
        description: l10n.onboarding6Desc,
        backgroundColor: colors.surface, // 다크 그레이
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext(int totalPages) {
    if (_currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _getPages(l10n);
    final page = pages[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              page.backgroundColor,
              page.backgroundColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 브랜드 락업 + Skip 버튼
              Padding(
                padding: const EdgeInsets.only(left: Spacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 컬러 배경 위에서도 또렷하게 읽히는 화이트 락업으로 각인
                    const LinkkuLockup(
                      variant: LinkkuLockupVariant.white,
                      height: 44,
                    ),
                    TextButton(
                      onPressed: _goToLogin,
                      child: Text(
                        l10n.skip,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),

              // 페이지 뷰
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Padding(
                      padding: const EdgeInsets.all(Spacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 마스코트(스파크) — 시작하기 페이지 브랜드 각인
                          if (page.useMascot)
                            const LinkkuSymbol(
                              variant: LinkkuSymbolVariant.spark,
                              size: 140,
                            )
                          // 픽셀 이모지
                          else if (page.pixelEmojiAsset != null)
                            Image.asset(
                              page.pixelEmojiAsset!,
                              width: 120,
                              height: 120,
                              filterQuality: FilterQuality.none,
                            )
                          else if (page.emoji != null)
                            Text(
                              page.emoji!,
                              style: const TextStyle(fontSize: 100),
                            ),
                          const SizedBox(height: Spacing.xl),
                          // 제목
                          Text(
                            page.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Spacing.md),
                          // 설명
                          Text(
                            page.description,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // 서브텍스트 (있는 경우)
                          if (page.subText != null) ...[
                            const SizedBox(height: Spacing.lg),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                page.subText!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 인디케이터
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: Spacing.xl),

              // 다음/시작 버튼
              Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: FilledButton(
                  onPressed: () => _onNext(pages.length),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: page.backgroundColor,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: Text(
                    _currentPage == pages.length - 1
                        ? l10n.getStarted
                        : l10n.next,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: Spacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String? emoji;
  final String? pixelEmojiAsset;

  /// true면 일러스트 자리에 마스코트(LinkkuSymbol)를 렌더링.
  final bool useMascot;
  final String title;
  final String description;
  final String? subText;
  final Color backgroundColor;

  OnboardingPage({
    this.emoji,
    this.pixelEmojiAsset,
    this.useMascot = false,
    required this.title,
    required this.description,
    this.subText,
    required this.backgroundColor,
  });
}
