// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class FinancialSummaryCard extends StatelessWidget {
//   final double totalBalance;
//   final double totalIncome;
//   final double totalExpense;
//   final double totalDebtOwed;
//   final double totalDebtLent;

//   const FinancialSummaryCard({
//     super.key,
//     required this.totalBalance,
//     required this.totalIncome,
//     required this.totalExpense,
//     required this.totalDebtOwed,
//     required this.totalDebtLent,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;

//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: isDark
//               ? [
//                   colorScheme.surface,
//                   colorScheme.surface.withValues(alpha: 0.9),
//                 ]
//               : [
//                   colorScheme.primary,
//                   colorScheme.primary.withValues(alpha: 0.90),
//                 ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: isDark
//               ? colorScheme.primary.withValues(alpha: 0.5)
//               : colorScheme.secondary.withValues(alpha: 0.4),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: colorScheme.primary.withValues(alpha: 0.2),
//             blurRadius: 20,
//             offset: Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total Balance',
//                 style: TextStyle(
//                   color: isDark
//                       ? Colors.white.withValues(alpha: 0.9)
//                       : Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   shadows: isDark
//                       ? null
//                       : [
//                           Shadow(
//                             color: Colors.black.withValues(alpha: 0.2),
//                             offset: Offset(0, 1),
//                             blurRadius: 2,
//                           ),
//                         ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: isDark
//                       ? colorScheme.primary.withValues(alpha: 0.3)
//                       : Colors.white.withValues(alpha: 0.25),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: isDark
//                         ? colorScheme.primary.withValues(alpha: 0.6)
//                         : Colors.white.withValues(alpha: 0.6),
//                     width: 1.5,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.calendar_today,
//                       color: isDark ? colorScheme.primary : Colors.white,
//                       size: 14,
//                     ),
//                     SizedBox(width: 6),
//                     Text(
//                       DateFormat('MMMM yyyy').format(DateTime.now()),
//                       style: TextStyle(
//                         color: isDark ? colorScheme.primary : Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),

//           // Main Balance
//           Text(
//             '\$${totalBalance.toStringAsFixed(2)}',
//             style: TextStyle(
//               color: isDark ? Colors.white : Colors.white,
//               fontSize: 25,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -0.5,
//               shadows: isDark
//                   ? null
//                   : [
//                       Shadow(
//                         color: Colors.black.withValues(alpha: 0.25),
//                         offset: Offset(0, 2),
//                         blurRadius: 4,
//                       ),
//                     ],
//             ),
//           ),
//           SizedBox(height: 10),

//           // Stats Grid
//           Row(
//             children: [
//               Expanded(
//                 child: _StatItem(
//                   label: 'Income',
//                   amount: totalIncome,
//                   icon: Icons.arrow_downward,
//                   color: Color(0xFF10b981),
//                   isPositive: true,
//                   isDark: isDark,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _StatItem(
//                   label: 'Expense',
//                   amount: totalExpense,
//                   icon: Icons.arrow_upward,
//                   color: Color(0xFFef4444),
//                   isPositive: false,
//                   isDark: isDark,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: _StatItem(
//                   label: 'You Owe',
//                   amount: totalDebtOwed,
//                   icon: Icons.trending_down,
//                   color: Color(0xFFef4444),
//                   isPositive: false,
//                   isDark: isDark,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _StatItem(
//                   label: "You're Owed",
//                   amount: totalDebtLent,
//                   icon: Icons.trending_up,
//                   color: Color(0xFF10b981),
//                   isPositive: true,
//                   isDark: isDark,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatItem extends StatelessWidget {
//   final String label;
//   final double amount;
//   final IconData icon;
//   final Color color;
//   final bool isPositive;
//   final bool isDark;

//   const _StatItem({
//     required this.label,
//     required this.amount,
//     required this.icon,
//     required this.color,
//     required this.isPositive,
//     required this.isDark,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: isDark
//             ? Colors.white.withValues(alpha: 0.10)
//             : Colors.white.withValues(alpha: 0.22),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isDark
//               ? color.withValues(alpha: 0.4)
//               : Colors.white.withValues(alpha: 0.4),
//           width: 1.5,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: color.withValues(alpha: 0.2),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Icon(icon, color: color, size: 14),
//               ),
//               SizedBox(width: 6),
//               Expanded(
//                 child: Text(
//                   label,
//                   style: TextStyle(
//                     color: isDark
//                         ? Colors.white.withValues(alpha: 0.85)
//                         : Colors.white.withValues(alpha: 0.95),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     shadows: isDark
//                         ? null
//                         : [
//                             Shadow(
//                               color: Colors.black.withValues(alpha: 0.15),
//                               offset: Offset(0, 1),
//                               blurRadius: 2,
//                             ),
//                           ],
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             '${isPositive ? '+' : '-'}\$${_formatAmount(amount)}',
//             style: TextStyle(
//               color: color,
//               fontSize: 16,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -0.3,
//               shadows: [
//                 Shadow(
//                   color: isDark
//                       ? color.withValues(alpha: 0.4)
//                       : Colors.black.withValues(alpha: 0.2),
//                   offset: Offset(0, 1),
//                   blurRadius: 3,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatAmount(double amount) {
//     if (amount >= 1000) {
//       return NumberFormat('#,##0').format(amount.abs());
//     }
//     return NumberFormat('#,##0.00').format(amount.abs());
//   }
// }
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinancialSummaryCard extends StatelessWidget {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double totalDebtOwed;
  final double totalDebtLent;

  const FinancialSummaryCard({
    super.key,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalDebtOwed,
    required this.totalDebtLent,
  });

  /// Returns white or black depending on which has better contrast
  /// against the given background color.
  Color _contrastColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.35 ? Colors.black87 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // The card background: use primary in light, surface in dark
    final Color cardBg = isDark ? colorScheme.surface : colorScheme.primary;

    // Auto-contrast text color so it always reads well on any theme color
    final Color onCard = _contrastColor(cardBg);
    final Color onCardSubtle = onCard.withValues(alpha: 0.65);

    // Fixed semantic colors for income/expense — independent of theme
    const Color incomeColor = Color(0xFF10b981);
    const Color expenseColor = Color(0xFFef4444);

    // Border color
    final Color borderColor = isDark
        ? colorScheme.primary.withValues(alpha: 0.35)
        : onCard.withValues(alpha: 0.15);

    return Container(
      width: double.infinity,
      // Only round the BOTTOM corners
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  colorScheme.surface,
                  colorScheme.surface.withValues(alpha: 0.92),
                ]
              : [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.88),
                ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.30),
            blurRadius: 24,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            // ── Header Row ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.totalBalance,
                  style: TextStyle(
                    color: onCardSubtle,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                _MonthBadge(onCard: onCard, borderColor: borderColor),
              ],
            ),

            // const SizedBox(height: 5),

            // ── Balance Amount ───────────────────────────────────
            Text(
              '\$${NumberFormat('#,##0.00').format(totalBalance)}',
              style: TextStyle(
                color: onCard,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),

            const SizedBox(height: 0),

            // Subtle divider
            Divider(
              color: onCard.withValues(alpha: 0.12),
              height: 24,
              thickness: 1,
            ),

            // ── Income / Expense Row ─────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: t.income,
                    amount: totalIncome,
                    icon: Icons.arrow_downward_rounded,
                    accentColor: incomeColor,
                    prefix: '+',
                    onCard: onCard,
                    onCardSubtle: onCardSubtle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatItem(
                    label: t.expense,
                    amount: totalExpense,
                    icon: Icons.arrow_upward_rounded,
                    accentColor: expenseColor,
                    prefix: '-',
                    onCard: onCard,
                    onCardSubtle: onCardSubtle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Debt Row ─────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: t.youOwe,
                    amount: totalDebtOwed,
                    icon: Icons.trending_down_rounded,
                    accentColor: expenseColor,
                    prefix: '-',
                    onCard: onCard,
                    onCardSubtle: onCardSubtle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatItem(
                    label: t.youreOwed,
                    amount: totalDebtLent,
                    icon: Icons.trending_up_rounded,
                    accentColor: incomeColor,
                    prefix: '+',
                    onCard: onCard,
                    onCardSubtle: onCardSubtle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Month Badge
// ──────────────────────────────────────────────────────────────
class _MonthBadge extends StatelessWidget {
  final Color onCard;
  final Color borderColor;

  const _MonthBadge({required this.onCard, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: onCard.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: onCard.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, color: onCard, size: 12),
          const SizedBox(width: 5),
          Text(
            DateFormat('MMM yyyy').format(DateTime.now()),
            style: TextStyle(
              color: onCard,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Stat Item — Replace your existing _StatItem class with this
// ──────────────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color accentColor;
  final String prefix;
  final Color onCard;
  final Color onCardSubtle;

  const _StatItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.accentColor,
    required this.prefix,
    required this.onCard,
    required this.onCardSubtle,
  });

  String _formatAmount(double value) {
    if (value >= 1000) {
      return NumberFormat('#,##0').format(value.abs());
    }
    return NumberFormat('#,##0.00').format(value.abs());
  }

  @override
  Widget build(BuildContext context) {
    // Box background uses the accent color itself (green/red)
    // so text on top must ALWAYS be white or black — never the accent color again
    final Color boxBg = Colors.white.withValues(alpha: 0.2);
    final Color boxBorder = accentColor.withValues(alpha: 0.35);

    // Compute contrast color for text ON this specific box
    // Since box is a light tint of accentColor on top of the card,
    // we just use onCard (white or black) — it always contrasts both light and dark tints
    final Color amountTextColor = onCard;
    final Color labelTextColor = onCard.withValues(alpha: 0.70);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: boxBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: boxBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Label row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                  color: accentColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 13),
              ),

              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: labelTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Amount — always white/black (onCard), NEVER the accent color
          // This ensures green income text is visible even on a green theme card
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Small colored prefix indicator dot
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 5, top: 1),
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                '$prefix\$${_formatAmount(amount)}',
                style: TextStyle(
                  color: amountTextColor, // white or black — always readable
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
