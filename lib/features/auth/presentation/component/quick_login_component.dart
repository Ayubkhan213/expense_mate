import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_mate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_mate/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_mate/features/auth/presentation/bloc/auth_state.dart';

class QuickLoginComponent extends StatelessWidget {
  const QuickLoginComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            t.enterPin,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            t.enterPinSubtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 36),

          /// PIN DOTS
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (p, c) => p.enteredPin != c.enteredPin,
            builder: (context, state) {
              return _PinDots(pin: state.enteredPin);
            },
          ),

          const SizedBox(height: 40),

          /// NUMBER PAD
          _NumberPad(),
        ],
      ),
    );
  }
}

/// ---------------- PIN DOTS ----------------
class _PinDots extends StatelessWidget {
  final String pin;
  const _PinDots({required this.pin});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isFilled = index < pin.length;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? const Color(0xFF6C5CE7) : Colors.transparent,
            border: Border.all(
              color: isFilled ? const Color(0xFF6C5CE7) : Colors.grey.shade400,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}

/// ---------------- NUMBER PAD ----------------
class _NumberPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        _NumberRow(numbers: ['1', '2', '3']),
        SizedBox(height: 18),
        _NumberRow(numbers: ['4', '5', '6']),
        SizedBox(height: 18),
        _NumberRow(numbers: ['7', '8', '9']),
        SizedBox(height: 18),
        _NumberRow(numbers: ['', '0', t.delete]),
      ],
    );
  }
}

class _NumberRow extends StatelessWidget {
  final List<String> numbers;
  const _NumberRow({required this.numbers});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((value) {
        if (value.isEmpty) {
          return const SizedBox(width: 72, height: 72);
        }

        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isDisabled =
                value != 'delete' && state.enteredPin.length >= 4;

            return GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                      if (value == 'delete') {
                        bloc.add(PinDigitDeletedEvent());
                      } else {
                        bloc.add(PinDigitEnteredEvent(value));
                      }
                    },
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: isDisabled ? 0.4 : 1,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value == 'delete'
                        ? Colors.transparent
                        : Colors.grey.shade100,
                    border: value == 'delete'
                        ? Border.all(color: Colors.grey.shade300, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: value == 'delete'
                        ? Icon(
                            Icons.backspace_outlined,
                            size: 24,
                            color: Colors.grey.shade700,
                          )
                        : Text(
                            value,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
