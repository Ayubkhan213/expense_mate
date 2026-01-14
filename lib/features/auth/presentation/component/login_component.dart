import 'package:expense_mate/core/app_export.dart';

class LoginComponent extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const LoginComponent({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: emailController,
            label: t.emailAddress,
            hint: t.enterEmail,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.enterEmailError;
              }
              if (!value.contains('@') || !value.contains('.')) {
                return t.invalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: passwordController,
            label: t.password,
            hint: t.enterYourPassword,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.enterPasswordError;
              }
              if (value.length < 6) {
                return t.passwordMinLength;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: Text(
                t.forgotPassword,
                style: TextStyle(
                  color: Color(0xFF6C5CE7),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          CustomButton(
            text: t.signIn,
            isLoading:
                context.watch<AuthBloc>().state.status == AuthStatus.loading,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  LoginWithEmailEvent(
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t.dontHaveAccount,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.signup);
                  },
                  child: Text(
                    t.signUp,
                    style: TextStyle(
                      color: Color(0xFF6C5CE7),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
