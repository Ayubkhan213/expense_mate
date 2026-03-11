import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          Text(
            t.createAccount,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          Text(
            t.signUpToGetStarted,
            style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}
