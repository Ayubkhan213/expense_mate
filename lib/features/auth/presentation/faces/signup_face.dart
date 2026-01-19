import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/common/custom_snackbar.dart';
import 'package:expense_mate/features/auth/presentation/widgets/signup_header.dart';

class SignupFace extends StatefulWidget {
  const SignupFace({super.key});

  @override
  State<SignupFace> createState() => _SignupFaceState();
}

class _SignupFaceState extends State<SignupFace> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _handleSignUp(AuthState state) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpEvent(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          currency: state.selectedCurrency,
          pin: _pinController.text.trim().isEmpty
              ? null
              : _pinController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        /// SUCCESS
        if (state.status == AuthStatus.authenticated) {
          AnimatedSnackbar.showSuccess(
            context,
            'Account created successfully 🎉',
          );

          Navigator.pop(context); // back to login
        }

        /// ERROR
        if (state.status == AuthStatus.error) {
          AnimatedSnackbar.showError(
            context,
            state.errorMessage ?? 'Something went wrong',
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (p, c) =>
            p.obscurePassword != c.obscurePassword ||
            p.obscureConfirmPassword != c.obscureConfirmPassword ||
            p.selectedCurrency != c.selectedCurrency ||
            p.currencies != c.currencies ||
            p.status != c.status,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Back button
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),

                    const SizedBox(height: 16),

                    /// Logo
                    const AuthLogo(),

                    const SizedBox(height: 32),

                    /// Header
                    const SignupHeader(),

                    const SizedBox(height: 40),

                    /// Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            prefixIcon: Icons.person_outline,
                            validator: (v) => v == null || v.length < 3
                                ? 'Enter valid name'
                                : null,
                          ),

                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'Enter your email',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => v == null || !v.contains('@')
                                ? 'Enter valid email'
                                : null,
                          ),

                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _phoneController,
                            label: 'Phone Number (Optional)',
                            hint: 'Enter phone number',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 20),

                          /// Currency dropdown
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Preferred Currency',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: state.selectedCurrency,
                                    isExpanded: true,
                                    items: state.currencies.map((currency) {
                                      return DropdownMenuItem(
                                        value: currency.code,
                                        child: Text(
                                          '${currency.flag} ${currency.code} - ${currency.name}',
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        context.read<AuthBloc>().add(
                                          ChangeCurrencyEvent(value),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Enter password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: state.obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () => context.read<AuthBloc>().add(
                                TogglePasswordVisibility(),
                              ),
                            ),
                            validator: (v) => v != null && v.length >= 6
                                ? null
                                : 'Min 6 characters',
                          ),

                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            hint: 'Re-enter password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: state.obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () => context.read<AuthBloc>().add(
                                ToggleConfirmPasswordVisibility(),
                              ),
                            ),
                            validator: (v) => v == _passwordController.text
                                ? null
                                : 'Passwords do not match',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// PIN Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Login PIN',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Optional 4-digit PIN for faster login',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 12),

                        CustomTextField(
                          controller: _pinController,
                          label: 'PIN',
                          hint: '••••',
                          prefixIcon: Icons.pin_outlined,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          maxLines: 4,
                          validator: (v) {
                            if (v == null || v.isEmpty) return null; // optional
                            if (v.length != 4) return 'PIN must be 4 digits';
                            if (!RegExp(r'^\d{4}$').hasMatch(v)) {
                              return 'PIN must be numeric';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    ///  Sign up button with loader
                    CustomButton(
                      text: 'Sign Up',
                      isLoading: state.status == AuthStatus.loading,
                      onPressed: state.status == AuthStatus.loading
                          ? null
                          : () => _handleSignUp(state),
                    ),

                    const SizedBox(height: 24),

                    /// Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF6C5CE7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
