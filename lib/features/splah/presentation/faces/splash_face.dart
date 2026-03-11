// lib/features/splah/presentation/pages/splash_face.dart

import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/features/splah/presentation/bloc/splash_bloc.dart';
import 'package:expense_mate/features/splah/presentation/bloc/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

class SplashFace extends StatelessWidget {
  const SplashFace({super.key});

  @override
  Widget build(BuildContext context) => const _SplashView();
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with TickerProviderStateMixin {
  late AnimationController _masterController;
  late AnimationController _loopController;
  late AnimationController _shimmerController;

  late Animation<double> _bgFade;
  late Animation<double> _ringScale1, _ringScale2, _ringScale3;
  late Animation<double> _ringOpacity1, _ringOpacity2, _ringOpacity3;
  late Animation<double> _iconScale, _iconFade;
  late Animation<Offset> _iconSlide;
  late Animation<double> _coinDropY, _coinScale, _coinFade;
  late Animation<double> _textFade, _taglineFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _pulseScale;
  late Animation<double> _orbitAngle;
  late Animation<double> _floatY;
  late Animation<double> _shimmerX;

  // ── FIX: track whether we've already navigated ────────────────────────────
  // Prevents double-navigation if BlocListener fires while we're mid-delay
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _buildEntryAnimations();
    _buildLoopAnimations();
    _startSequence();

    // ── FIX: check bloc state AFTER first frame ────────────────────────────
    // The bloc fires add(SplashCheckAuth()) in its constructor which may emit
    // BEFORE BlocListener is attached. By checking in postFrameCallback we
    // catch states that were already emitted before the listener was ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExistingState();
    });
  }

  // ── FIX: reads current bloc state and navigates if already resolved ────────
  void _checkExistingState() {
    final currentStatus = context.read<SplashBloc>().state.status;
    final isResolved =
        currentStatus != SplashStatus.checking &&
        currentStatus != SplashStatus.loggingOut;

    if (isResolved) {
      // Bloc already emitted a navigation state — schedule the navigation
      // after the minimum splash duration so the animation still plays
      _scheduleNavigation(currentStatus);
    }
    // If still checking, BlocListener will handle it when it emits
  }

  void _scheduleNavigation(SplashStatus status) {
    if (_hasNavigated) return;

    // Ensure splash shows for at least 2800ms total
    // _masterController takes 2400ms + 200ms delay = 2600ms
    // so 2800ms gives it time to finish nicely
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted || _hasNavigated) return;
      _hasNavigated = true;
      _navigate(status);
    });
  }

  void _navigate(SplashStatus status) {
    switch (status) {
      case SplashStatus.firstLaunch:
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.language,
          (_) => false,
          arguments: {'isFirstLaunch': true},
        );
        break;
      case SplashStatus.authenticated:
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.home,
          (_) => false,
        );
        break;
      case SplashStatus.unauthenticated:
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.login,
          (_) => false,
        );
        break;
      case SplashStatus.checking:
      case SplashStatus.loggingOut:
        break;
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    _loopController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _buildEntryAnimations() {
    _bgFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );
    _ringScale1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.05, 0.40, curve: Curves.easeOutCubic),
      ),
    );
    _ringOpacity1 =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.35), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 0.35, end: 0.15), weight: 60),
        ]).animate(
          CurvedAnimation(
            parent: _masterController,
            curve: const Interval(0.05, 0.55),
          ),
        );
    _ringScale2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.12, 0.50, curve: Curves.easeOutCubic),
      ),
    );
    _ringOpacity2 =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.25), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 0.25, end: 0.10), weight: 60),
        ]).animate(
          CurvedAnimation(
            parent: _masterController,
            curve: const Interval(0.12, 0.60),
          ),
        );
    _ringScale3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.20, 0.60, curve: Curves.easeOutCubic),
      ),
    );
    _ringOpacity3 =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.15), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 0.15, end: 0.06), weight: 60),
        ]).animate(
          CurvedAnimation(
            parent: _masterController,
            curve: const Interval(0.20, 0.65),
          ),
        );
    _iconScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.0,
              end: 1.08,
            ).chain(CurveTween(curve: Curves.easeOutBack)),
            weight: 70,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.08,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 30,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _masterController,
            curve: const Interval(0.18, 0.60),
          ),
        );
    _iconFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.18, 0.40, curve: Curves.easeOut),
      ),
    );
    _iconSlide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _masterController,
            curve: const Interval(0.18, 0.55, curve: Curves.easeOutCubic),
          ),
        );
    _coinDropY =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: -90.0,
              end: -6.0,
            ).chain(CurveTween(curve: Curves.easeInCubic)),
            weight: 55,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: -6.0,
              end: -14.0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: -14.0,
              end: -10.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 20,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _masterController,
            curve: const Interval(0.38, 0.82),
          ),
        );
    _coinScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.4,
              end: 1.15,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 65,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.15,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 35,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _masterController,
            curve: const Interval(0.38, 0.80),
          ),
        );
    _coinFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.38, 0.55, curve: Curves.easeOut),
      ),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.68, 0.88, curve: Curves.easeOut),
      ),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _masterController,
            curve: const Interval(0.68, 0.92, curve: Curves.easeOutCubic),
          ),
        );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.78, 1.00, curve: Curves.easeOut),
      ),
    );
  }

  void _buildLoopAnimations() {
    _pulseScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.easeInOut),
    );
    _orbitAngle = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _loopController, curve: Curves.linear));
    _floatY = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.easeInOut),
    );
    _shimmerX = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) _masterController.forward();
  }

  List<Color> _gradientColors(ColorScheme cs, bool isDark) {
    if (isDark) {
      return [
        Color.lerp(cs.surface, cs.primary, 0.12)!,
        cs.background,
        Color.lerp(cs.background, Colors.black, 0.40)!,
      ];
    }
    return [
      Color.lerp(cs.surface, cs.primary, 0.06)!,
      cs.background,
      Color.lerp(cs.background, cs.primary, 0.04)!,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final coinFace = isDark ? cs.secondary : cs.primary;
    final coinInner = isDark
        ? Color.lerp(cs.surface, cs.secondary, 0.20)!
        : Color.lerp(cs.background, cs.primary, 0.18)!;
    final walletColor = isDark ? Colors.white : cs.surface;
    final walletClaspBg = cs.background;
    final onWallet = isDark ? cs.background : cs.primary;
    final appNameColor = isDark ? Colors.white : cs.onSurface;
    final taglineColor = isDark
        ? Colors.white.withOpacity(0.52)
        : cs.primary.withOpacity(0.68);

    final List<Shadow> appNameShadows = isDark
        ? [
            Shadow(
              color: Colors.black.withOpacity(0.70),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
            Shadow(
              color: cs.primary.withOpacity(0.35),
              blurRadius: 22,
              offset: Offset.zero,
            ),
          ]
        : [
            Shadow(
              color: cs.primary.withOpacity(0.10),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ];

    final List<Shadow> taglineShadows = isDark
        ? [
            Shadow(
              color: Colors.black.withOpacity(0.55),
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ]
        : [];

    return BlocListener<SplashBloc, SplashState>(
      // ── FIX: listenWhen catches transitions FROM any state TO a nav state ──
      // Also handles the case where prev == curr (e.g. same status re-emitted)
      // by using the raw curr check instead of diff check
      listenWhen: (prev, curr) {
        final isNavState =
            curr.status != SplashStatus.checking &&
            curr.status != SplashStatus.loggingOut;
        // Fire if status changed OR if we get a nav state we haven't acted on
        return isNavState && prev.status != curr.status;
      },
      listener: (ctx, state) {
        // ── FIX: don't use async/await in listener — schedule instead ────────
        // Using async in listener causes context to go stale and mounted
        // checks to fail. Use Future.delayed with a captured status instead.
        final resolvedStatus = state.status;
        _scheduleNavigation(resolvedStatus);
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: Listenable.merge([
            _masterController,
            _loopController,
            _shimmerController,
          ]),
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: _gradientColors(cs, isDark),
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  // Grain
                  Positioned.fill(
                    child: Opacity(
                      opacity: isDark ? 0.03 : 0.015,
                      child: CustomPaint(painter: _NoisePainter()),
                    ),
                  ),

                  // Rings
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _ring(
                          _ringScale3.value,
                          _ringOpacity3.value,
                          220,
                          0.6,
                          cs.primary,
                          isDark,
                        ),
                        _ring(
                          _ringScale2.value,
                          _ringOpacity2.value,
                          155,
                          0.8,
                          cs.primary,
                          isDark,
                        ),
                        _ring(
                          _ringScale1.value,
                          _ringOpacity1.value,
                          100,
                          1.0,
                          cs.primary,
                          isDark,
                        ),
                      ],
                    ),
                  ),

                  // Orbiting particles
                  Center(
                    child: _OrbitingParticles(
                      angle: _orbitAngle.value,
                      color: cs.primary,
                      opacity: (_masterController.value - 0.5).clamp(0.0, 1.0),
                      isDark: isDark,
                    ),
                  ),

                  // Main content
                  Center(
                    child: FadeTransition(
                      opacity: _bgFade,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 240,
                            height: 240,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glow
                                Transform.scale(
                                  scale: _pulseScale.value,
                                  child: Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: cs.primary.withOpacity(
                                            isDark ? 0.22 : 0.12,
                                          ),
                                          blurRadius: 80,
                                          spreadRadius: 20,
                                        ),
                                        if (!isDark)
                                          BoxShadow(
                                            color: cs.primary.withOpacity(0.06),
                                            blurRadius: 120,
                                            spreadRadius: 40,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Wallet
                                Transform.translate(
                                  offset: Offset(0, _floatY.value * 0.4),
                                  child: SlideTransition(
                                    position: _iconSlide,
                                    child: FadeTransition(
                                      opacity: _iconFade,
                                      child: Transform.scale(
                                        scale: _iconScale.value,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Transform.translate(
                                              offset: Offset(
                                                isDark ? 5 : 4,
                                                isDark ? 10 : 8,
                                              ),
                                              child: Opacity(
                                                opacity: isDark ? 0.50 : 0.15,
                                                child: CustomPaint(
                                                  size: const Size(190, 190),
                                                  painter: _WalletPainter(
                                                    bodyColor: Colors.black,
                                                    claspBgColor: Colors.black,
                                                    accentColor: Colors.black,
                                                    shimmerValue: 0,
                                                    isDark: isDark,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            CustomPaint(
                                              size: const Size(190, 190),
                                              painter: _WalletPainter(
                                                bodyColor: walletColor,
                                                claspBgColor: walletClaspBg,
                                                accentColor: onWallet,
                                                shimmerValue: _shimmerX.value,
                                                isDark: isDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Coin
                                FadeTransition(
                                  opacity: _coinFade,
                                  child: Transform.translate(
                                    offset: Offset(
                                      0,
                                      _coinDropY.value + _floatY.value * 0.6,
                                    ),
                                    child: Transform.scale(
                                      scale: _coinScale.value,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 88,
                                            height: 88,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: coinFace.withOpacity(
                                                    isDark ? 0.50 : 0.30,
                                                  ),
                                                  blurRadius: 36,
                                                  spreadRadius: 8,
                                                ),
                                                BoxShadow(
                                                  color: coinFace.withOpacity(
                                                    isDark ? 0.20 : 0.12,
                                                  ),
                                                  blurRadius: 60,
                                                  spreadRadius: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Transform.translate(
                                            offset: const Offset(3, 6),
                                            child: Opacity(
                                              opacity: isDark ? 0.45 : 0.18,
                                              child: CustomPaint(
                                                size: const Size(76, 76),
                                                painter: _CoinPainter(
                                                  faceColor: Colors.black,
                                                  innerColor: Colors.black,
                                                  shimmerValue: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomPaint(
                                            size: const Size(76, 76),
                                            painter: _CoinPainter(
                                              faceColor: coinFace,
                                              innerColor: coinInner,
                                              shimmerValue: _shimmerX.value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          SlideTransition(
                            position: _textSlide,
                            child: FadeTransition(
                              opacity: _textFade,
                              child: Text(
                                l10n.splashAppName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isRtl ? 28 : 30,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: isRtl ? 0.0 : 0.6,
                                  height: 1.2,
                                  color: appNameColor,
                                  shadows: appNameShadows,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          FadeTransition(
                            opacity: _taglineFade,
                            child: Text(
                              l10n.splashTagline,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isRtl ? 13 : 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: isRtl ? 0.0 : 2.2,
                                height: 1.5,
                                color: taglineColor,
                                shadows: taglineShadows,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Loading dots
                  Positioned(
                    bottom: 56,
                    left: 0,
                    right: 0,
                    child: FadeTransition(
                      opacity: _taglineFade,
                      child: Center(
                        child: _LoadingDots(
                          color: cs.primary,
                          isDark: isDark,
                          progress: _loopController.value,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _ring(
    double scale,
    double opacity,
    double radius,
    double strokeWidth,
    Color color,
    bool isDark,
  ) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(opacity * (isDark ? 1.0 : 0.7)),
            width: strokeWidth,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Orbiting Particles
// ─────────────────────────────────────────────────────────────────────────────
class _OrbitingParticles extends StatelessWidget {
  final double angle;
  final Color color;
  final double opacity;
  final bool isDark;
  const _OrbitingParticles({
    required this.angle,
    required this.color,
    required this.opacity,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 340,
      child: CustomPaint(
        painter: _ParticlesPainter(
          angle: angle,
          color: color,
          opacity: opacity * (isDark ? 0.70 : 0.45),
        ),
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double angle;
  final Color color;
  final double opacity;
  _ParticlesPainter({
    required this.angle,
    required this.color,
    required this.opacity,
  });

  static const List<_ParticleDef> _particles = [
    _ParticleDef(orbitRadius: 118, size: 4.0, speed: 1.00, offset: 0.0),
    _ParticleDef(
      orbitRadius: 118,
      size: 2.5,
      speed: 1.00,
      offset: math.pi * 0.62,
    ),
    _ParticleDef(
      orbitRadius: 118,
      size: 3.0,
      speed: 1.00,
      offset: math.pi * 1.25,
    ),
    _ParticleDef(
      orbitRadius: 148,
      size: 2.0,
      speed: 0.70,
      offset: math.pi * 0.30,
    ),
    _ParticleDef(
      orbitRadius: 148,
      size: 3.0,
      speed: 0.70,
      offset: math.pi * 1.10,
    ),
    _ParticleDef(
      orbitRadius: 95,
      size: 2.0,
      speed: 1.35,
      offset: math.pi * 0.85,
    ),
    _ParticleDef(
      orbitRadius: 95,
      size: 1.5,
      speed: 1.35,
      offset: math.pi * 1.70,
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final p in _particles) {
      final a = angle * p.speed + p.offset;
      final pos = Offset(
        center.dx + p.orbitRadius * math.cos(a),
        center.dy + p.orbitRadius * math.sin(a),
      );
      canvas.drawCircle(
        pos,
        p.size,
        Paint()..color = color.withOpacity(opacity),
      );
      canvas.drawCircle(
        pos,
        p.size * 2.8,
        Paint()
          ..color = color.withOpacity(opacity * 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter old) =>
      old.angle != angle || old.opacity != opacity;
}

class _ParticleDef {
  final double orbitRadius;
  final double size;
  final double speed;
  final double offset;
  const _ParticleDef({
    required this.orbitRadius,
    required this.size,
    required this.speed,
    required this.offset,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading Dots
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingDots extends StatelessWidget {
  final Color color;
  final bool isDark;
  final double progress;
  const _LoadingDots({
    required this.color,
    required this.isDark,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final phase = (progress - i * 0.22) % 1.0;
        final scale = 0.6 + 0.6 * math.sin(phase * math.pi).clamp(0.0, 1.0);
        final dotOpacity = (0.3 + 0.7 * math.sin(phase * math.pi)).clamp(
          0.0,
          1.0,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(dotOpacity * (isDark ? 0.75 : 0.60)),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Noise Painter
// ─────────────────────────────────────────────────────────────────────────────
class _NoisePainter extends CustomPainter {
  static final _rng = math.Random(42);
  static List<Offset>? _dots;
  static List<double>? _sizes;
  static const int _count = 600;

  _NoisePainter() {
    if (_dots == null) {
      _dots = List.generate(
        _count,
        (_) => Offset(_rng.nextDouble(), _rng.nextDouble()),
      );
      _sizes = List.generate(_count, (_) => _rng.nextDouble() * 1.2 + 0.3);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < _count; i++) {
      canvas.drawCircle(
        Offset(_dots![i].dx * size.width, _dots![i].dy * size.height),
        _sizes![i],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_NoisePainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Wallet Painter
// ─────────────────────────────────────────────────────────────────────────────
class _WalletPainter extends CustomPainter {
  final Color bodyColor;
  final Color claspBgColor;
  final Color accentColor;
  final double shimmerValue;
  final bool isDark;

  _WalletPainter({
    required this.bodyColor,
    required this.claspBgColor,
    required this.accentColor,
    required this.shimmerValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 8;
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: 138, height: 96),
      const Radius.circular(14),
    );
    final bodyPaint = Paint()..style = PaintingStyle.fill;

    if (bodyColor != Colors.black) {
      final shimmerStop = ((shimmerValue + 1.5) / 3.0).clamp(0.0, 1.0);
      if (isDark) {
        final deepBase = Color.lerp(bodyColor, Colors.black, 0.55)!;
        final deepMid = Color.lerp(bodyColor, Colors.black, 0.35)!;
        bodyPaint.shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            deepBase,
            Colors.white.withOpacity(0.07),
            deepMid,
            Color.lerp(deepBase, Colors.black, 0.25)!,
          ],
          stops: [
            0.0,
            (shimmerStop - 0.12).clamp(0.0, 1.0),
            shimmerStop.clamp(0.0, 1.0),
            1.0,
          ],
        ).createShader(bodyRect.outerRect);
      } else {
        final deepBase = Color.lerp(bodyColor, Colors.black, 0.30)!;
        final deepMid = Color.lerp(bodyColor, Colors.black, 0.15)!;
        bodyPaint.shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            deepBase,
            Colors.white.withOpacity(0.10),
            deepMid,
            Color.lerp(deepBase, Colors.black, 0.20)!,
          ],
          stops: [
            0.0,
            (shimmerStop - 0.12).clamp(0.0, 1.0),
            shimmerStop.clamp(0.0, 1.0),
            1.0,
          ],
        ).createShader(bodyRect.outerRect);
      }
    } else {
      bodyPaint.color = Colors.black;
    }

    canvas.drawRRect(bodyRect, bodyPaint);
    if (bodyColor != Colors.black) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - 69, cy - 10, 138, 22),
          const Radius.circular(4),
        ),
        Paint()..color = Colors.white.withOpacity(isDark ? 0.07 : 0.12),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - 55, cy - 8, 20, 16),
          const Radius.circular(3),
        ),
        Paint()..color = Colors.white.withOpacity(isDark ? 0.18 : 0.28),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + 52, cy), width: 28, height: 48),
        const Radius.circular(14),
      ),
      bodyPaint,
    );
    if (bodyColor != Colors.black) {
      canvas.drawCircle(Offset(cx + 52, cy), 9, Paint()..color = claspBgColor);
      canvas.drawCircle(
        Offset(cx + 52, cy),
        4.5,
        Paint()..color = Colors.white.withOpacity(isDark ? 0.40 : 0.55),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - 69, cy - 48, 138, 2.5),
          const Radius.circular(14),
        ),
        Paint()..color = Colors.white.withOpacity(isDark ? 0.18 : 0.40),
      );
    }
  }

  @override
  bool shouldRepaint(_WalletPainter old) =>
      old.bodyColor != bodyColor ||
      old.shimmerValue != shimmerValue ||
      old.accentColor != accentColor ||
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Coin Painter
// ─────────────────────────────────────────────────────────────────────────────
class _CoinPainter extends CustomPainter {
  final Color faceColor;
  final Color innerColor;
  final double shimmerValue;

  _CoinPainter({
    required this.faceColor,
    required this.innerColor,
    required this.shimmerValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    final facePaint = Paint()..style = PaintingStyle.fill;

    if (faceColor != Colors.black) {
      final shimmerStop = ((shimmerValue + 1.5) / 3.0).clamp(0.0, 1.0);
      facePaint.shader = RadialGradient(
        center: Alignment((shimmerStop * 2 - 1) * 0.6, -0.4),
        radius: 1.0,
        colors: [
          Color.lerp(faceColor, Colors.white, 0.30)!,
          faceColor,
          Color.lerp(faceColor, Colors.black, 0.18)!,
        ],
        stops: const [0.0, 0.50, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    } else {
      facePaint.color = Colors.black;
    }

    canvas.drawCircle(Offset(cx, cy), r, facePaint);
    canvas.drawCircle(
      Offset(cx, cy),
      r - 7,
      Paint()
        ..color = innerColor
        ..style = PaintingStyle.fill,
    );

    if (faceColor != Colors.black) {
      final tp = TextPainter(
        text: TextSpan(
          text: '\$',
          style: TextStyle(
            color: Colors.white.withOpacity(0.92),
            fontSize: r * 0.90,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - r * 0.25, cy - r * 0.30),
          width: r * 0.55,
          height: r * 0.22,
        ),
        Paint()..color = Colors.white.withOpacity(0.28),
      );
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(_CoinPainter old) =>
      old.faceColor != faceColor ||
      old.shimmerValue != shimmerValue ||
      old.innerColor != innerColor;
}
