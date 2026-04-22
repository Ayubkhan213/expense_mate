import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/app_export.dart';
import 'package:spendio/core/data/models/on_boading_model.dart';
import 'package:spendio/core/language/bloc/language_bloc.dart';
import 'package:spendio/core/navigation/route_name.dart';
import 'package:spendio/core/services/app_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spendio/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Asset path helper  (PNG)
// ─────────────────────────────────────────────────────────────────────────────
const _supportedCodes = {'en', 'ur', 'fr', 'ar'};

String _imagePath(int slideIndex, String langCode) {
  final code = _supportedCodes.contains(langCode) ? langCode : 'en';
  return 'assets/images/onboarding_${slideIndex + 1}_$code.png';
}

// ─────────────────────────────────────────────────────────────────────────────
// Per-slide accent colours
// ─────────────────────────────────────────────────────────────────────────────
const _slideAccents = [
  Color(0xFF4CAF82), // slide 1 – green
  Color(0xFF9B6FD4), // slide 2 – purple
  Color(0xFF3AAFA9), // slide 3 – teal
  Color(0xFF4CAF82), // slide 4 – green
];

const _bgDark = Color(0xFF0F1E28);
const _bgMid = Color(0xFF1A2F3A);

// ─────────────────────────────────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // ── state ──────────────────────────────────────────────────────────────
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ── animation controllers ───────────────────────────────────────────────
  late AnimationController _entranceCtrl;
  late Animation<double> _entranceFade;
  late Animation<Offset> _entranceSlide;

  late AnimationController _imageCtrl;
  late Animation<double> _imageScale;
  late Animation<double> _imageFade;

  late AnimationController _bgCtrl;
  late Animation<Color?> _bgAnim;
  Color _fromColor = _bgMid;
  Color _toColor = _bgMid;

  // ── lifecycle ───────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entranceCtrl.forward();
      _imageCtrl.forward();
    });
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _initAnimations() {
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entranceFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    );
    _entranceSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut));

    _imageCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _imageScale = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _imageCtrl, curve: Curves.elasticOut));
    _imageFade = CurvedAnimation(parent: _imageCtrl, curve: Curves.easeOut);

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _bgAnim = ColorTween(
      begin: _bgMid,
      end: _bgMid,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceCtrl.dispose();
    _imageCtrl.dispose();
    _bgCtrl.dispose();
    super.dispose();
  }

  // ── helpers ─────────────────────────────────────────────────────────────
  Color _accentForIndex(int i) =>
      i < _slideAccents.length ? _slideAccents[i] : _slideAccents.last;

  Color get _accent => _accentForIndex(_currentPage);

  // ── page changed ────────────────────────────────────────────────────────
  void _onPageChanged(int index) {
    _fromColor = _toColor;
    _toColor = _accentForIndex(index).withOpacity(0.08);
    _bgAnim = ColorTween(
      begin: _fromColor,
      end: _toColor,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));
    _bgCtrl
      ..reset()
      ..forward();
    _imageCtrl
      ..reset()
      ..forward();
    setState(() => _currentPage = index);
  }

  // ── navigation ───────────────────────────────────────────────────────────
  void _next(int total) {
    if (_currentPage == total - 1) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _prev() => _pageController.previousPage(
    duration: const Duration(milliseconds: 380),
    curve: Curves.easeInOutCubic,
  );

  Future<void> _finish() async {
    // Mark onboarding as seen — SplashBloc reads AppPrefs.onboardingSeen
    // on next launch so it knows to skip directly to Login (or Home if logged in)
    await AppPrefs.instance.setOnboardingSeen(true);
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, RouteName.login, (_) => false);
    }
  }

  // ── slide data ───────────────────────────────────────────────────────────
  List<OnboardingModel> _getPages(BuildContext ctx, String langCode) {
    final t = AppLocalizations.of(ctx)!;
    return List.generate(
      4,
      (i) => OnboardingModel(
        svgPath: _imagePath(i, langCode), // PNG path, named svgPath in model
        title: [
          t.onboardingTitle1,
          t.onboardingTitle2,
          t.onboardingTitle3,
          t.onboardingTitle4,
        ][i],
        description: [
          t.onboardingDesc1,
          t.onboardingDesc2,
          t.onboardingDesc3,
          t.onboardingDesc4,
        ][i],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // Read locale directly from BLoC — correct language user picked
    final langCode = context.watch<LanguageBloc>().state.locale;

    final t = AppLocalizations.of(context)!;
    final pages = _getPages(context, langCode);
    final size = MediaQuery.of(context).size;
    final isLast = _currentPage == pages.length - 1;

    return Scaffold(
      backgroundColor: _bgDark,
      body: AnimatedBuilder(
        animation: Listenable.merge([_bgCtrl, _entranceCtrl, _imageCtrl]),
        builder: (ctx, _) => Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _GlowPainter(accent: _accent, progress: _bgCtrl.value),
              ),
            ),
            Positioned.fill(child: CustomPaint(painter: const _GridPainter())),
            SafeArea(
              child: FadeTransition(
                opacity: _entranceFade,
                child: SlideTransition(
                  position: _entranceSlide,
                  child: Column(
                    children: [
                      _TopBar(
                        accent: _accent,
                        langCode: langCode,
                        skipLabel: t.skip,
                        onSkip: _finish,
                      ),
                      Expanded(
                        flex: 10,
                        child: _ImagePageView(
                          pages: pages,
                          currentPage: _currentPage,
                          pageController: _pageController,
                          imageScale: _imageScale,
                          imageFade: _imageFade,
                          accentForIndex: _accentForIndex,
                          onPageChanged: _onPageChanged,
                          screenSize: size,
                        ),
                      ),
                      _Dots(
                        controller: _pageController,
                        count: pages.length,
                        accent: _accent,
                      ),
                      const SizedBox(height: 20),
                      _TextSection(
                        pages: pages,
                        currentPage: _currentPage,
                        accent: _accent,
                      ),
                      const SizedBox(height: 24),
                      _NavRow(
                        currentPage: _currentPage,
                        isLast: isLast,
                        accent: _accent,
                        nextLabel: isLast ? t.getStarted : t.next,
                        backLabel: t.back,
                        onNext: () => _next(pages.length),
                        onPrev: _prev,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final Color accent;
  final String langCode;
  final String skipLabel;
  final VoidCallback onSkip;

  const _TopBar({
    required this.accent,
    required this.langCode,
    required this.skipLabel,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'ExpenseMate',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const Spacer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withOpacity(0.3)),
            ),
            child: Text(
              langCode.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                color: accent,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSkip,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Text(
                skipLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMAGE PAGE VIEW
// ─────────────────────────────────────────────────────────────────────────────
class _ImagePageView extends StatelessWidget {
  final List<OnboardingModel> pages;
  final int currentPage;
  final PageController pageController;
  final Animation<double> imageScale;
  final Animation<double> imageFade;
  final Color Function(int) accentForIndex;
  final ValueChanged<int> onPageChanged;
  final Size screenSize;

  const _ImagePageView({
    required this.pages,
    required this.currentPage,
    required this.pageController,
    required this.imageScale,
    required this.imageFade,
    required this.accentForIndex,
    required this.onPageChanged,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: PageView.builder(
        controller: pageController,
        onPageChanged: onPageChanged,
        itemCount: pages.length,
        itemBuilder: (ctx, index) {
          final isActive = index == currentPage;
          final accent = accentForIndex(index);
          return AnimatedScale(
            scale: isActive ? 1.0 : 0.92,
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  // Glow halo
                  Center(
                    child: Container(
                      width: screenSize.width * 0.65,
                      height: screenSize.width * 0.65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            accent.withOpacity(0.18),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // PNG image
                  Center(
                    child: isActive
                        ? ScaleTransition(
                            scale: imageScale,
                            child: FadeTransition(
                              opacity: imageFade,
                              child: _PngImage(
                                path: pages[index].svgPath,
                                size: screenSize,
                              ),
                            ),
                          )
                        : _PngImage(
                            path: pages[index].svgPath,
                            size: screenSize,
                          ),
                  ),

                  // "N / 4" chip
                  if (isActive)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: FadeTransition(
                        opacity: imageFade,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accent.withOpacity(0.3),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            '${index + 1} / ${pages.length}',
                            style: TextStyle(
                              fontSize: 11,
                              color: accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PNG IMAGE WIDGET  (no flutter_svg dependency)
// ─────────────────────────────────────────────────────────────────────────────
class _PngImage extends StatelessWidget {
  final String path;
  final Size size;
  const _PngImage({required this.path, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size.width * 0.82,
      height: size.width * 0.82,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: size.width * 0.82,
        height: size.width * 0.82,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            color: Colors.white.withOpacity(0.2),
            size: 48,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DOTS
// ─────────────────────────────────────────────────────────────────────────────
class _Dots extends StatelessWidget {
  final PageController controller;
  final int count;
  final Color accent;
  const _Dots({
    required this.controller,
    required this.count,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: ExpandingDotsEffect(
        dotHeight: 7,
        dotWidth: 7,
        expansionFactor: 3.5,
        spacing: 5,
        activeDotColor: accent,
        dotColor: Colors.white.withOpacity(0.18),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TEXT SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _TextSection extends StatelessWidget {
  final List<OnboardingModel> pages;
  final int currentPage;
  final Color accent;
  const _TextSection({
    required this.pages,
    required this.currentPage,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: Padding(
        key: ValueKey(currentPage),
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              pages[currentPage].title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.4,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              pages[currentPage].description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV ROW
// ─────────────────────────────────────────────────────────────────────────────
class _NavRow extends StatelessWidget {
  final int currentPage;
  final bool isLast;
  final Color accent;
  final String nextLabel;
  final String backLabel;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const _NavRow({
    required this.currentPage,
    required this.isLast,
    required this.accent,
    required this.nextLabel,
    required this.backLabel,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: currentPage > 0
                ? _BackBtn(key: const ValueKey('b'), onTap: onPrev)
                : const SizedBox(key: ValueKey('e'), width: 52, height: 52),
          ),
          const Spacer(),
          _NextBtn(
            label: nextLabel,
            accent: accent,
            isLast: isLast,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _BackBtn({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: const Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
        size: 22,
      ),
    ),
  );
}

class _NextBtn extends StatefulWidget {
  final String label;
  final Color accent;
  final bool isLast;
  final VoidCallback onTap;
  const _NextBtn({
    required this.label,
    required this.accent,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<_NextBtn> createState() => _NextBtnState();
}

class _NextBtnState extends State<_NextBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
  );
  late final Animation<double> _s = Tween(begin: 1.0, end: 0.96).animate(_c);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => _c.forward(),
    onTapUp: (_) {
      _c.reverse();
      widget.onTap();
    },
    onTapCancel: () => _c.reverse(),
    child: ScaleTransition(
      scale: _s,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 52,
        padding: EdgeInsets.symmetric(horizontal: widget.isLast ? 28 : 32),
        decoration: BoxDecoration(
          color: widget.accent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.accent.withOpacity(0.38),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                widget.label,
                key: ValueKey(widget.label),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                widget.isLast
                    ? Icons.rocket_launch_rounded
                    : Icons.arrow_forward_rounded,
                key: ValueKey(widget.isLast),
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// PAINTERS
// ─────────────────────────────────────────────────────────────────────────────
class _GlowPainter extends CustomPainter {
  final Color accent;
  final double progress;
  const _GlowPainter({required this.accent, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    void draw(Offset c, double r, double o) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [
              accent.withOpacity(o * progress.clamp(0.0, 1.0)),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: c, radius: r)),
      );
    }

    draw(Offset(size.width * 0.85, size.height * 0.12), size.width * 0.6, 0.13);
    draw(Offset(size.width * 0.10, size.height * 0.78), size.width * 0.5, 0.09);
  }

  @override
  bool shouldRepaint(_GlowPainter o) =>
      o.accent != accent || o.progress != progress;
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 0.8;
    for (double x = 0; x < size.width; x += 52) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 52) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}
