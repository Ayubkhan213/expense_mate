import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/app_export.dart';
import 'package:spendio/core/navigation/route_name.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/features/splah/presentation/bloc/splash_bloc.dart';
import 'package:spendio/features/splah/presentation/bloc/splash_state.dart';
import 'package:spendio/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Spendio Brand — FIXED colors, never changes with user theme
// ─────────────────────────────────────────────────────────────────────────────
class _B {
  _B._();
  static const bgDeep = Color(0xFF020617);
  static const bgMid = Color(0xFF0B1120);
  static const blue200 = Color(0xFFBFDBFE);
  static const blue300 = Color(0xFF93C5FD);
  static const blue400 = Color(0xFF60A5FA);
  static const blue500 = Color(0xFF3B82F6);
  static const blue900 = Color(0xFF1E3A8A);
  static const goldText = Color(0xFF92400E);
  static const gold = Color(0xFFF59E0B);
  static const goldLight = Color(0xFFFDE68A);
  static const goldDark = Color(0xFFD97706);
}

// ─────────────────────────────────────────────────────────────────────────────
//  The main splash face
// ─────────────────────────────────────────────────────────────────────────────
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

class _SplashViewState extends State<_SplashView> with TickerProviderStateMixin {
  late AnimationController _masterCtrl; // phase 1..4 (0..1)
  late AnimationController _loopCtrl; // float & pulse
  late AnimationController _particleCtrl; // orbit & dots
  late AnimationController _shimmerCtrl; // $ gloss

  // Rings
  late Animation<double> _r1Scale, _r2Scale, _r3Scale;
  late Animation<double> _r1Op, _r2Op, _r3Op;

  // Logo
  late Animation<double> _bgFade, _iconFade, _iconScale;
  late Animation<Offset> _iconSlide;

  // Coin
  late Animation<double> _coinFade, _coinScale, _coinY;

  // Text
  late Animation<double> _lineGrow, _nameFade, _tagFade, _dotsFade;
  late Animation<Offset> _nameSlide;

  // Continuous
  late Animation<double> _floatY, _pulseScale, _orbitAngle, _shimmerX;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // ── Controllers ───────────────────────────────────────────────────────
    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _loopCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _initAnimations();
    _startSequence();
    _checkExistingState();
  }

  void _initAnimations() {
    // Helpers
    Animation<double> fade(double s, double e) => Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _masterCtrl, curve: Interval(s, e)));

    Animation<Offset> slide(Offset b, double s, double e) =>
        Tween<Offset>(begin: b, end: Offset.zero).animate(
          CurvedAnimation(
            parent: _masterCtrl,
            curve: Interval(s, e, curve: Curves.easeOutCubic),
          ),
        );

    Animation<double> seq(double s, double e, List<(double, double, int)> pts) {
      final items = <TweenSequenceItem<double>>[];
      for (final p in pts) {
        items.add(
          TweenSequenceItem(
            tween: Tween(begin: p.$1, end: p.$2).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
            weight: p.$3.toDouble(),
          ),
        );
      }
      return TweenSequence<double>(items).animate(
        CurvedAnimation(parent: _masterCtrl, curve: Interval(s, e)),
      );
    }

    // ── Phase 1 (0–40 %): radial intro ───────────────────────────────────
    _bgFade = fade(0.0, 0.40);
    _r1Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.04, 0.38, curve: Curves.easeOutCubic),
      ),
    );
    _r1Op = seq(0.04, 0.55, [(0.0, 0.28, 40), (0.28, 0.10, 60)]);
    _r2Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.10, 0.46, curve: Curves.easeOutCubic),
      ),
    );
    _r2Op = seq(0.10, 0.60, [(0.0, 0.18, 40), (0.18, 0.06, 60)]);
    _r3Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.16, 0.54, curve: Curves.easeOutCubic),
      ),
    );
    _r3Op = seq(0.16, 0.65, [(0.0, 0.10, 40), (0.10, 0.04, 60)]);

    // ── Phase 2 (15–58 %): icon pop ───────────────────────────────────────
    _iconFade = fade(0.15, 0.38);
    _iconSlide = slide(const Offset(0, 0.08), 0.15, 0.52);
    _iconScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.0,
              end: 1.10,
            ).chain(CurveTween(curve: Curves.easeOutBack)),
            weight: 70,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.10,
              end: 1.00,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 30,
          ),
        ]).animate(
          CurvedAnimation(parent: _masterCtrl, curve: const Interval(0.15, 0.58)),
        );

    // ── Phase 3 (42–80 %): coin drop ──────────────────────────────────────
    _coinFade = fade(0.42, 0.58);
    _coinY =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: -110.0,
              end: -8.0,
            ).chain(CurveTween(curve: Curves.easeInCubic)),
            weight: 55,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: -8.0,
              end: -18.0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: -18.0,
              end: -12.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 20,
          ),
        ]).animate(
          CurvedAnimation(parent: _masterCtrl, curve: const Interval(0.42, 0.82)),
        );
    _coinScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.3,
              end: 1.15,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 65,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.15,
              end: 1.00,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 35,
          ),
        ]).animate(
          CurvedAnimation(parent: _masterCtrl, curve: const Interval(0.42, 0.80)),
        );

    // ── Phase 4 (65–100 %): text reveal ──────────────────────────────────
    _lineGrow = fade(0.65, 0.80);
    _nameFade = fade(0.68, 0.86);
    _nameSlide = slide(const Offset(0, 0.5), 0.68, 0.90);
    _tagFade = fade(0.78, 0.96);
    _dotsFade = fade(0.84, 1.00);

    // ── Loop ──────────────────────────────────────────────────────────────
    _floatY = Tween<double>(
      begin: -6.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: _loopCtrl, curve: Curves.easeInOut));
    _pulseScale = Tween<double>(
      begin: 0.93,
      end: 1.07,
    ).animate(CurvedAnimation(parent: _loopCtrl, curve: Curves.easeInOut));
    _orbitAngle = Tween<double>(
      begin: 0.0,
      end: math.pi * 2,
    ).animate(CurvedAnimation(parent: _particleCtrl, curve: Curves.linear));
    _shimmerX = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 120));
    if (mounted) _masterCtrl.forward();
  }

  void _checkExistingState() {
    final s = context.read<SplashBloc>().state.status;
    final resolved = s != SplashStatus.checking && s != SplashStatus.loggingOut;
    if (resolved) _scheduleNav(s);
  }

  void _scheduleNav(SplashStatus status) {
    if (_hasNavigated) return;
    Future.delayed(const Duration(milliseconds: 3000), () {
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
      case SplashStatus.authenticated:
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.home,
          (_) => false,
        );
      case SplashStatus.unauthenticated:
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.login,
          (_) => false,
        );
      case SplashStatus.checking:
      case SplashStatus.loggingOut:
        break;
    }
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    _loopCtrl.dispose();
    _particleCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listenWhen: (prev, curr) {
        final isNav =
            curr.status != SplashStatus.checking &&
            curr.status != SplashStatus.loggingOut;
        return isNav && prev.status != curr.status;
      },
      listener: (_, state) => _scheduleNav(state.status),
      child: Scaffold(
        backgroundColor: _B.bgDeep,
        body: AnimatedBuilder(
          animation: Listenable.merge([
            _masterCtrl,
            _loopCtrl,
            _particleCtrl,
            _shimmerCtrl,
          ]),
          builder: (context, _) => _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final h = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.15),
          radius: 1.4,
          colors: [Color(0xFF0F2550), _B.bgMid, _B.bgDeep],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.022,
              child: CustomPaint(painter: _NoisePainter()),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0, _floatY.value * 0.3 - h * 0.06),
              child: Transform.scale(
                scale: _pulseScale.value,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0x2E3B82F6),
                        Color(0x0F1D4ED8),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0, -h * 0.06),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _ring(220, _r3Scale.value, _r3Op.value, 0.5),
                  _ring(158, _r2Scale.value, _r2Op.value, 0.7),
                  _ring(104, _r1Scale.value, _r1Op.value, 1.0),
                ],
              ),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0, -h * 0.06),
              child: Opacity(
                opacity: (_masterCtrl.value - 0.45).clamp(0.0, 1.0),
                child: SizedBox(
                  width: 340,
                  height: 340,
                  child: CustomPaint(
                    painter: _ParticlesPainter(
                      angle: _orbitAngle.value,
                      opacity: 0.65,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _bgFade,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(0, _floatY.value * 0.45),
                          child: SlideTransition(
                            position: _iconSlide,
                            child: FadeTransition(
                              opacity: _iconFade,
                              child: Transform.scale(
                                scale: _iconScale.value,
                                child: _SpendioIcon(shimmerX: _shimmerX.value),
                              ),
                            ),
                          ),
                        ),
                        FadeTransition(
                          opacity: _coinFade,
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              _coinY.value + _floatY.value * 0.6,
                            ),
                            child: Transform.scale(
                              scale: _coinScale.value,
                              child: _OrbitingCoin(
                                angle: _orbitAngle.value,
                                radius: 72,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizeTransition(
                    sizeFactor: _lineGrow,
                    axis: Axis.horizontal,
                    child: Container(
                      width: 48,
                      height: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.transparent,
                            _B.blue300,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SlideTransition(
                    position: _nameSlide,
                    child: FadeTransition(
                      opacity: _nameFade,
                      child: ShaderMask(
                        shaderCallback: (b) => const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, _B.blue200],
                        ).createShader(b),
                        child: Text(
                          l10n.splashAppName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isRtl ? 36 : 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: isRtl ? 0 : -1.2,
                            height: 1.0,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _tagFade,
                    child: Text(
                      l10n.splashTagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isRtl ? 12 : 10.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: isRtl ? 0 : 2.8,
                        color: const Color(0xFF6B8FC4),
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 62,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _dotsFade,
              child: Center(child: _LoadingDots(progress: _particleCtrl.value)),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _dotsFade,
              child: const Center(
                child: Text(
                  'v1.0',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF1E3A5F),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ring(double r, double scale, double op, double sw) => Transform.scale(
    scale: scale,
    child: Container(
      width: r * 2,
      height: r * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _B.blue500.withOpacity(op), width: sw),
      ),
    ),
  );
}

class _SpendioIcon extends StatelessWidget {
  final double shimmerX;
  const _SpendioIcon({required this.shimmerX});

  @override
  Widget build(BuildContext context) {
    const s = 120.0;
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(s * 0.235),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF2563EB), _B.blue900],
          stops: [0.0, 0.50, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: _B.blue500.withOpacity(0.55),
            blurRadius: s * 0.55,
            spreadRadius: s * 0.04,
          ),
          BoxShadow(
            color: _B.blue900.withOpacity(0.40),
            blurRadius: s * 0.25,
            offset: Offset(0, s * 0.08),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: s * 0.44,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(s * 0.235),
                  topRight: Radius.circular(s * 0.235),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.20),
                    Colors.white.withOpacity(0.00),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: CustomPaint(
              size: Size(s * 0.52, s * 0.52),
              painter: _DollarPainter(shimmerX: shimmerX),
            ),
          ),
        ],
      ),
    );
  }
}

class _DollarPainter extends CustomPainter {
  final double shimmerX;
  _DollarPainter({required this.shimmerX});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final stop = ((shimmerX + 1.5) / 3.0).clamp(0.0, 1.0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = w * 0.115
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.88),
          Colors.white.withOpacity(0.18),
          Colors.white.withOpacity(0.96),
        ],
        stops: [0.0, (stop - 0.1).clamp(0.0, 1.0), stop.clamp(0.0, 1.0)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final top = Path()
      ..moveTo(cx + w * 0.28, cy - h * 0.10)
      ..cubicTo(
        cx + w * 0.32,
        cy - h * 0.35,
        cx - w * 0.30,
        cy - h * 0.42,
        cx - w * 0.28,
        cy - h * 0.14,
      )
      ..cubicTo(
        cx - w * 0.27,
        cy - h * 0.00,
        cx + w * 0.00,
        cy + h * 0.04,
        cx + w * 0.00,
        cy + h * 0.04,
      );
    canvas.drawPath(top, paint);

    final bot = Path()
      ..moveTo(cx - w * 0.00, cy + h * 0.04)
      ..cubicTo(
        cx + w * 0.00,
        cy + h * 0.04,
        cx + w * 0.28,
        cy + h * 0.08,
        cx + w * 0.28,
        cy + h * 0.18,
      )
      ..cubicTo(
        cx + w * 0.30,
        cy + h * 0.42,
        cx - w * 0.30,
        cy + h * 0.38,
        cx - w * 0.28,
        cy + h * 0.12,
      );
    canvas.drawPath(bot, paint);

    final stemPaint = Paint()
      ..color = Colors.white.withOpacity(0.65)
      ..strokeWidth = w * 0.075
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy - h * 0.50),
      Offset(cx, cy - h * 0.38),
      stemPaint,
    );
    canvas.drawLine(
      Offset(cx, cy + h * 0.38),
      Offset(cx, cy + h * 0.50),
      stemPaint,
    );
  }

  @override
  bool shouldRepaint(_DollarPainter o) => o.shimmerX != shimmerX;
}

class _OrbitingCoin extends StatelessWidget {
  final double angle;
  final double radius;
  const _OrbitingCoin({required this.angle, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(radius * math.cos(angle), radius * math.sin(angle)),
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: Alignment(-0.3, -0.4),
            radius: 0.85,
            colors: [_B.goldLight, _B.gold, _B.goldDark],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xB3FBBF24),
              blurRadius: 14,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            CurrencyFormatter.symbol,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: _B.goldText,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double angle;
  final double opacity;
  static const _p = [
    (r: 120.0, sz: 3.5, spd: 1.00, off: 0.00),
    (r: 120.0, sz: 2.2, spd: 1.00, off: 2.09),
    (r: 120.0, sz: 2.8, spd: 1.00, off: 4.19),
    (r: 152.0, sz: 1.8, spd: 0.65, off: 1.05),
    (r: 152.0, sz: 2.8, spd: 0.65, off: 3.67),
    (r: 92.0, sz: 1.8, spd: 1.40, off: 2.67),
    (r: 92.0, sz: 1.4, spd: 1.40, off: 5.34),
    (r: 172.0, sz: 1.4, spd: 0.42, off: 0.78),
    (r: 172.0, sz: 1.8, spd: 0.42, off: 3.92),
  ];

  _ParticlesPainter({required this.angle, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    for (final p in _p) {
      final a = angle * p.spd + p.off;
      final pos = Offset(c.dx + p.r * math.cos(a), c.dy + p.r * math.sin(a));
      canvas.drawCircle(
        pos,
        p.sz,
        Paint()..color = _B.blue300.withOpacity(opacity * 0.85),
      );
      canvas.drawCircle(
        pos,
        p.sz * 3.2,
        Paint()
          ..color = _B.blue400.withOpacity(opacity * 0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter o) =>
      o.angle != angle || o.opacity != opacity;
}

class _LoadingDots extends StatelessWidget {
  final double progress;
  const _LoadingDots({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final phase = (progress - i * 0.20) % 1.0;
        final scale = 0.55 + 0.65 * math.sin(phase * math.pi).clamp(0.0, 1.0);
        final op = (0.25 + 0.75 * math.sin(phase * math.pi)).clamp(0.0, 1.0);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _B.blue400.withOpacity(op * 0.80),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _NoisePainter extends CustomPainter {
  static final _rng = math.Random(42);
  static final _dots = List.generate(
    800,
    (_) => Offset(_rng.nextDouble(), _rng.nextDouble()),
  );
  static final _sizes = List.generate(
    800,
    (_) => _rng.nextDouble() * 1.0 + 0.2,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white;
    for (var i = 0; i < _dots.length; i++) {
      canvas.drawCircle(
        Offset(_dots[i].dx * size.width, _dots[i].dy * size.height),
        _sizes[i],
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_NoisePainter _) => false;
}
