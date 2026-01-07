import 'package:expense_mate/core/app_export.dart';

class LoginFace extends StatefulWidget {
  const LoginFace({super.key});

  @override
  State<LoginFace> createState() => _LoginFaceState();
}

class _LoginFaceState extends State<LoginFace>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _animationController;
  late final Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleLoginMode(BuildContext context, AuthState state) {
    if (state.isAnimating) return;

    final bloc = context.read<AuthBloc>();
    bloc.add(ToggleLoginModeEvent());

    final animation = state.isQuickLogin
        ? _animationController.reverse
        : _animationController.forward;

    animation().then((_) {
      bloc.add(SetAnimatingEvent(false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (p, c) =>
          p.isQuickLogin != c.isQuickLogin || p.isAnimating != c.isAnimating,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const AuthLogo(),
                  const SizedBox(height: 32),

                  LoginHeader(
                    state: state,
                    onToggle: () => _toggleLoginMode(context, state),
                  ),

                  const SizedBox(height: 40),

                  LoginFlipCard(
                    animation: _flipAnimation,
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),

                  if (state.status == AuthStatus.error)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        state.errorMessage ?? 'Login failed',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
