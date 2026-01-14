// import 'package:flutter/material.dart';

// class SplashFace extends StatefulWidget {
//   const SplashFace({Key? key}) : super(key: key);

//   @override
//   State<SplashFace> createState() => _SplashFaceState();
// }

// class _SplashFaceState extends State<SplashFace> with TickerProviderStateMixin {
//   late AnimationController _walletController;
//   late AnimationController _coinController;
//   late AnimationController _fadeController;

//   late Animation<double> _walletScale;
//   late Animation<double> _coinSlide;
//   late Animation<double> _coinRotation;
//   late Animation<double> _fadeIn;

//   @override
//   void initState() {
//     super.initState();

//     // Wallet animation controller
//     _walletController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     // Coin animation controller
//     _coinController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     // Fade controller
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     // Wallet scale animation
//     _walletScale = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _walletController, curve: Curves.elasticOut),
//     );

//     // Coin slide animation (from top)
//     _coinSlide = Tween<double>(begin: -100.0, end: 0.0).animate(
//       CurvedAnimation(parent: _coinController, curve: Curves.bounceOut),
//     );

//     // Coin rotation animation
//     _coinRotation = Tween<double>(begin: 0.0, end: 2.0).animate(
//       CurvedAnimation(parent: _coinController, curve: Curves.easeInOut),
//     );

//     // Fade in animation
//     _fadeIn = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

//     // Start animations sequentially
//     _startAnimations();
//   }

//   void _startAnimations() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _fadeController.forward();

//     await Future.delayed(const Duration(milliseconds: 200));
//     _walletController.forward();

//     await Future.delayed(const Duration(milliseconds: 400));
//     _coinController.forward();

//     // Navigate to next screen after animations complete
//     await Future.delayed(const Duration(milliseconds: 2500));
//     if (mounted) {
//       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
//     }
//   }

//   @override
//   void dispose() {
//     _walletController.dispose();
//     _coinController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF364A5E),
//       body: Center(
//         child: AnimatedBuilder(
//           animation: Listenable.merge([
//             _walletController,
//             _coinController,
//             _fadeController,
//           ]),
//           builder: (context, child) {
//             return FadeTransition(
//               opacity: _fadeIn,
//               child: SizedBox(
//                 width: 200,
//                 height: 200,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Wallet
//                     Transform.scale(
//                       scale: _walletScale.value,
//                       child: CustomPaint(
//                         size: const Size(200, 200),
//                         painter: WalletPainter(),
//                       ),
//                     ),
//                     // Coin
//                     Transform.translate(
//                       offset: Offset(0, _coinSlide.value),
//                       child: Transform.rotate(
//                         angle: _coinRotation.value * 3.14159,
//                         child: CustomPaint(
//                           size: const Size(80, 80),
//                           painter: CoinPainter(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class WalletPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     final center = Offset(size.width / 2, size.height / 2);

//     // Wallet body
//     final walletRect = RRect.fromRectAndRadius(
//       Rect.fromCenter(
//         center: Offset(center.dx, center.dy + 10),
//         width: 140,
//         height: 100,
//       ),
//       const Radius.circular(12),
//     );
//     canvas.drawRRect(walletRect, paint);

//     // Wallet clasp/button
//     final claspRect = RRect.fromRectAndRadius(
//       Rect.fromCenter(
//         center: Offset(center.dx + 50, center.dy + 10),
//         width: 30,
//         height: 50,
//       ),
//       const Radius.circular(15),
//     );
//     canvas.drawRRect(claspRect, paint);

//     // Clasp circle
//     canvas.drawCircle(
//       Offset(center.dx + 50, center.dy + 10),
//       8,
//       Paint()
//         ..color = const Color(0xFF364A5E)
//         ..style = PaintingStyle.fill,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// class CoinPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);

//     // Outer circle (white)
//     canvas.drawCircle(
//       center,
//       size.width / 2,
//       Paint()
//         ..color = Colors.white
//         ..style = PaintingStyle.fill,
//     );

//     // Inner circle (blue)
//     canvas.drawCircle(
//       center,
//       size.width / 2 - 8,
//       Paint()
//         ..color = const Color(0xFF364A5E)
//         ..style = PaintingStyle.fill,
//     );

//     // Draw dollar sign
//     final textPainter = TextPainter(
//       text: const TextSpan(
//         text: '\$',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 45,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//     );
//     textPainter.layout();
//     textPainter.paint(
//       canvas,
//       Offset(
//         center.dx - textPainter.width / 2,
//         center.dy - textPainter.height / 2,
//       ),
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // Usage in main.dart:
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Wallet App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const SplashFace(),
//     );
//   }
// }
import 'package:expense_mate/core/app_export.dart';

import 'dart:math' as math;

class SplashFace extends StatefulWidget {
  const SplashFace({super.key});

  @override
  State<SplashFace> createState() => _SplashFaceState();
}

class _SplashFaceState extends State<SplashFace> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _coinController;
  late AnimationController _glowController;
  late AnimationController _rotationController;

  late Animation<double> _walletScale;
  late Animation<double> _walletRotateX;
  late Animation<double> _coinSlide;
  late Animation<double> _coinScale;
  late Animation<double> _coinRotateY;
  late Animation<double> _glowPulse;
  late Animation<double> _backgroundRotation;

  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(CheckAuthStatusEvent());

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _coinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Wallet animations
    _walletScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.1,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.1,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_mainController);

    _walletRotateX = Tween<double>(begin: -0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Coin animations - entering the wallet
    _coinSlide = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -150.0,
          end: -20.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -20.0,
          end: 15.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 15.0,
          end: 10.0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 20,
      ),
    ]).animate(_coinController);

    _coinScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.5,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_coinController);

    _coinRotateY = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(parent: _coinController, curve: Curves.easeInOut),
    );

    _glowPulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _backgroundRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mainController.forward();
    _rotationController.repeat();

    await Future.delayed(const Duration(milliseconds: 800));
    _coinController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _coinController.dispose();
    _glowController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        // wait till splash animation finishes
        await Future.delayed(const Duration(milliseconds: 3000));
        if (!mounted) return;

        if (state.status == AuthStatus.authenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.onBoarding,
            (_) => false,
          );
        } else if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.onBoarding,
            (_) => false,
          );
        }
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: Listenable.merge([
            _mainController,
            _coinController,
            _glowController,
            _rotationController,
          ]),
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    const Color(0xFF4A5F7A),
                    const Color(0xFF364A5E),
                    const Color(0xFF2A3A4E),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  // Animated background circles
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BackgroundCirclesPainter(
                        rotation: _backgroundRotation.value,
                      ),
                    ),
                  ),
                  // Main content
                  Center(
                    child: SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow effect
                          Transform.scale(
                            scale: _glowPulse.value * 1.3,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 60,
                                    spreadRadius: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Wallet with 3D effect
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.002)
                              ..rotateX(_walletRotateX.value),
                            child: Transform.scale(
                              scale: _walletScale.value,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Wallet shadow for 3D depth
                                  Transform.translate(
                                    offset: const Offset(4, 8),
                                    child: Opacity(
                                      opacity: 0.3,
                                      child: CustomPaint(
                                        size: const Size(200, 200),
                                        painter: WalletPainter(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Main wallet
                                  CustomPaint(
                                    size: const Size(200, 200),
                                    painter: WalletPainter(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Coin with 3D rotation and entry animation
                          Transform.translate(
                            offset: Offset(0, _coinSlide.value),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.003)
                                ..rotateY(_coinRotateY.value * math.pi),
                              child: Transform.scale(
                                scale: _coinScale.value,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Coin glow
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.amber.withOpacity(
                                              0.4,
                                            ),
                                            blurRadius: 30,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Coin shadow for depth
                                    Transform.translate(
                                      offset: const Offset(3, 5),
                                      child: Opacity(
                                        opacity: 0.3,
                                        child: CustomPaint(
                                          size: const Size(80, 80),
                                          painter: CoinPainter(
                                            progress: _coinRotateY.value,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Main coin
                                    CustomPaint(
                                      size: const Size(80, 80),
                                      painter: CoinPainter(
                                        progress: _coinRotateY.value,
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class BackgroundCirclesPainter extends CustomPainter {
  final double rotation;

  BackgroundCirclesPainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withOpacity(0.05);

    final center = Offset(size.width / 2, size.height / 2);
    final angle = rotation * 2 * math.pi;

    for (int i = 1; i <= 4; i++) {
      final radius = (size.width / 3) * i / 2;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle * i / 2);
      canvas.translate(-center.dx, -center.dy);
      canvas.drawCircle(center, radius, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(BackgroundCirclesPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}

class WalletPainter extends CustomPainter {
  final Color color;

  WalletPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Wallet body with gradient effect
    final walletRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 10),
        width: 140,
        height: 100,
      ),
      const Radius.circular(12),
    );

    if (color == Colors.white) {
      final gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Colors.grey.shade100],
      );
      paint.shader = gradient.createShader(walletRect.outerRect);
    }

    canvas.drawRRect(walletRect, paint);

    // Wallet clasp/button
    final claspRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 50, center.dy + 10),
        width: 30,
        height: 50,
      ),
      const Radius.circular(15),
    );
    canvas.drawRRect(claspRect, paint);

    // Clasp circle with depth
    final claspPaint = Paint()
      ..color = color == Colors.white ? const Color(0xFF364A5E) : Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx + 50, center.dy + 10), 8, claspPaint);

    // Inner clasp circle for 3D effect
    if (color == Colors.white) {
      canvas.drawCircle(
        Offset(center.dx + 49, center.dy + 9),
        4,
        Paint()
          ..color = const Color(0xFF4A5F7A)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CoinPainter extends CustomPainter {
  final double progress;

  CoinPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final isBlack = progress % 2 > 0.5 && progress % 2 < 1.5;

    // Calculate 3D width based on rotation
    final width3D = (size.width / 2 * math.cos((progress % 2) * math.pi)).abs();

    // Outer ellipse (3D effect)
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width3D * 2, height: size.height),
      Paint()
        ..color = isBlack ? Colors.black : Colors.amber.shade300
        ..style = PaintingStyle.fill,
    );

    // Inner ellipse
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: (width3D - 8) * 2,
        height: size.height - 16,
      ),
      Paint()
        ..color = isBlack ? Colors.grey.shade900 : const Color(0xFF364A5E)
        ..style = PaintingStyle.fill,
    );

    // Only draw dollar sign when visible
    if (width3D > size.width / 6) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '\$',
          style: TextStyle(
            color: isBlack ? Colors.grey.shade700 : Colors.white,
            fontSize: 45 * (width3D / (size.width / 2)),
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2,
        ),
      );
    }

    // Add shine effect
    if (!isBlack && width3D > size.width / 4) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx - width3D / 3, center.dy - 10),
          width: width3D / 2,
          height: 15,
        ),
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(CoinPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
