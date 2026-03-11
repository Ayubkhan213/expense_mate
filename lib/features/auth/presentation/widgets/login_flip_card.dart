// lib/features/auth/presentation/component/login_flip_card.dart

import 'dart:math' as math;

import 'package:expense_mate/features/auth/presentation/component/login_component.dart';
import 'package:expense_mate/features/auth/presentation/component/quick_login_component.dart';
import 'package:flutter/material.dart';

class LoginFlipCard extends StatelessWidget {
  final Animation<double> animation;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Color primary;
  final bool isDark;

  const LoginFlipCard({
    super.key,
    required this.animation,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.primary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final angle = animation.value * math.pi;
        final isUnder = angle > math.pi / 2;
        final value = isUnder ? math.pi - angle : angle;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(value),
          child: isUnder
              ? QuickLoginComponent(primary: primary, isDark: isDark)
              : LoginComponent(
                  formKey: formKey,
                  emailController: emailController,
                  passwordController: passwordController,
                  primary: primary,
                  isDark: isDark,
                ),
        );
      },
    );
  }
}
