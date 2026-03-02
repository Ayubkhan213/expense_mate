// import 'package:expense_mate/core/data/models/budget_model.dart';
// import 'package:expense_mate/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';

// class BudgetTypeSelector extends StatelessWidget {
//   final dynamic selectedType;
//   final Color accentColor;
//   final Function(dynamic) onTypeChanged;

//   const BudgetTypeSelector({
//     super.key,
//     required this.selectedType,
//     required this.accentColor,
//     required this.onTypeChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final t = AppLocalizations.of(context)!; // ✅

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           t.budgetType, // ✅ was 'Budget Type'
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: colorScheme.onSurface,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             _buildTypeChip(
//               context,
//               t.monthly,
//               t.monthly,
//               Icons.calendar_month,
//               colorScheme,
//             ), //
//             const SizedBox(width: 8),
//             _buildTypeChip(
//               context,
//               t.project,

//               t.project,
//               Icons.flag,
//               colorScheme,
//             ), // ✅
//             const SizedBox(width: 8),
//             _buildTypeChip(
//               context,
//               t.custom,
//               t.custom,
//               Icons.tune,
//               colorScheme,
//             ), //
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildTypeChip(
//     BuildContext context,
//     String typeStr,
//     String label,
//     IconData icon,
//     ColorScheme colorScheme,
//   ) {
//     final isSelected = selectedType.toString().toLowerCase().contains(typeStr);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () => onTypeChanged(_getBudgetType(typeStr)),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? accentColor
//                 : (isDark ? colorScheme.surface : Colors.grey[100]),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: isSelected
//                   ? accentColor
//                   : colorScheme.onSurface.withValues(alpha: 0.1),
//               width: 1.5,
//             ),
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: accentColor.withValues(alpha: 0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Column(
//             children: [
//               Icon(
//                 icon,
//                 color: isSelected
//                     ? Colors.white
//                     : colorScheme.onSurface.withValues(alpha: 0.6),
//                 size: 24,
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 label, //  already translated, passed from build()
//                 style: TextStyle(
//                   color: isSelected
//                       ? Colors.white
//                       : colorScheme.onSurface.withValues(alpha: 0.6),
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   dynamic _getBudgetType(String type) {
//     switch (type) {
//       case 'monthly':
//         return BudgetType.monthly;
//       case 'project':
//         return BudgetType.project;
//       case 'custom':
//         return BudgetType.custom;
//       default:
//         return BudgetType.custom;
//     }
//   }
// }
