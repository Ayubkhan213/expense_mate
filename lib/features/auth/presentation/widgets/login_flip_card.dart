import 'dart:math' as math;
import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/common/custom_snackbar.dart';

class LoginFlipCard extends StatelessWidget {
  final Animation<double> animation;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginFlipCard({
    super.key,
    required this.animation,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        // WRONG PIN
        if (state.status == AuthStatus.unauthenticated &&
            state.errorMessage != null) {
          CustomSnackbar.showError(context, state.errorMessage!);
        }

        // ERROR
        if (state.status == AuthStatus.error && state.errorMessage != null) {
          CustomSnackbar.showError(context, state.errorMessage!);
        }

        // SUCCESS → HOME
        if (state.status == AuthStatus.authenticated) {
          CustomSnackbar.showSuccess(context, 'Login successful 🎉');

          Navigator.pushReplacementNamed(context, RouteName.home);
        }
      },
      child: AnimatedBuilder(
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
                ? const QuickLoginComponent()
                : LoginComponent(
                    formKey: formKey,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
          );
        },
      ),
    );
  }
}
