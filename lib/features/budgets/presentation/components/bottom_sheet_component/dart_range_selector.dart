// import 'package:expense_mate/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class DateRangeSelector extends StatelessWidget {
//   final DateTime startDate;
//   final DateTime endDate;
//   final int durationInDays;
//   final Function(DateTime) onStartDateChanged;
//   final Function(DateTime) onEndDateChanged;

//   const DateRangeSelector({
//     super.key,
//     required this.startDate,
//     required this.endDate,
//     required this.durationInDays,
//     required this.onStartDateChanged,
//     required this.onEndDateChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;
//     final t = AppLocalizations.of(context)!;

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isDark
//             ? colorScheme.surface
//             : colorScheme.primary.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: colorScheme.primary.withValues(alpha: 0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.date_range, size: 20, color: colorScheme.primary),
//               const SizedBox(width: 8),
//               Text(
//                 t.duration,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: colorScheme.onSurface,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           Row(
//             children: [
//               Expanded(
//                 child: _DateButton(
//                   label: t.start,
//                   date: startDate,
//                   onTap: () => _selectDate(context, true),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: Icon(
//                   Icons.arrow_forward,
//                   color: colorScheme.primary,
//                   size: 20,
//                 ),
//               ),
//               Expanded(
//                 child: _DateButton(
//                   label: t.end,
//                   date: endDate,
//                   onTap: () => _selectDate(context, false),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             decoration: BoxDecoration(
//               color: colorScheme.primary.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.schedule, size: 14, color: colorScheme.primary),
//                 const SizedBox(width: 6),
//                 Text(
//                   '$durationInDays ${t.days}',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: colorScheme.primary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context, bool isStartDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isStartDate ? startDate : endDate,
//       firstDate: isStartDate ? DateTime.now() : startDate,
//       lastDate: DateTime.now().add(const Duration(days: 3650)),
//     );

//     if (picked != null) {
//       if (isStartDate) {
//         onStartDateChanged(picked);
//       } else {
//         onEndDateChanged(picked);
//       }
//     }
//   }
// }

// class _DateButton extends StatelessWidget {
//   final String label;
//   final DateTime date;
//   final VoidCallback onTap;

//   const _DateButton({
//     required this.label,
//     required this.date,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isDark ? colorScheme.background : Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: colorScheme.primary.withValues(alpha: 0.3),
//             width: 1,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 11,
//                 color: colorScheme.onSurface.withValues(alpha: 0.6),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               DateFormat('MMM dd, yyyy').format(date),
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: colorScheme.onSurface,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
