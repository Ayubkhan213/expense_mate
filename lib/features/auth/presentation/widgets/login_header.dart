import 'package:expense_mate/features/auth/presentation/component/toggle_button_component.dart';
import 'package:flutter/material.dart';
import 'package:expense_mate/features/auth/presentation/bloc/auth_state.dart';

class LoginHeader extends StatelessWidget {
  final AuthState state;
  final VoidCallback onToggle;

  const LoginHeader({super.key, required this.state, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ToggleButtonComponent(
                text: 'Login',
                icon: Icons.login_rounded,
                isSelected: !state.isQuickLogin,
                onTap: onToggle,
              ),
              const SizedBox(width: 4),
              ToggleButtonComponent(
                text: 'Quick Login',
                icon: Icons.pin_rounded,
                isSelected: state.isQuickLogin,
                onTap: onToggle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
