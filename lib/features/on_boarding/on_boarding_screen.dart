import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/on_boading_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Get localized pages
  List<OnboardingModel> _getPages(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return [
      OnboardingModel(
        svgPath: 'assets/images/onboarding_1.svg',
        title: t.onboardingTitle1,
        description: t.onboardingDesc1,
      ),
      OnboardingModel(
        svgPath: 'assets/images/onboarding_2.svg',
        title: t.onboardingTitle2,
        description: t.onboardingDesc2,
      ),
      OnboardingModel(
        svgPath: 'assets/images/onboarding_3.svg',
        title: t.onboardingTitle3,
        description: t.onboardingDesc3,
      ),
      OnboardingModel(
        svgPath: 'assets/images/onboarding_4.svg',
        title: t.onboardingTitle4,
        description: t.onboardingDesc4,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final pages = _getPages(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => _navigateToHome(),
                  child: Text(
                    t.skip,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // PageView with SVG images
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: SvgPicture.asset(
                      pages[index].svgPath,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ),

            // Page indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: pages.length,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: const Color(0xFF1C0D82),
                dotColor: Colors.grey[300]!,
              ),
            ),

            const SizedBox(height: 32),

            // Title and description
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    Text(
                      pages[_currentPage].title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C0D82),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pages[_currentPage].description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  if (_currentPage > 0)
                    OutlinedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        side: const BorderSide(color: Color(0xFF1C0D82)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        t.back,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1C0D82),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 100),

                  // Next/Get Started button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == pages.length - 1) {
                        _navigateToHome();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C0D82),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage == pages.length - 1 ? t.getStarted : t.next,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(context, RouteName.home, (_) => false);
  }
}
