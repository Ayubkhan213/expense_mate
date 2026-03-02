// import 'package:flutter/material.dart';

// class BudgetFilterChips extends StatelessWidget {
//   final String selectedFilter;
//   final Function(String) onFilterChanged;
//   final Map<String, int> filterCounts;

//   const BudgetFilterChips({
//     super.key,
//     required this.selectedFilter,
//     required this.onFilterChanged,
//     required this.filterCounts,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             _buildFilterChip(
//               context,
//               label: 'Active',
//               value: 'active',
//               icon: Icons.trending_up,
//               count: filterCounts['active'] ?? 0,
//             ),
//             const SizedBox(width: 8),
//             _buildFilterChip(
//               context,
//               label: 'Expired',
//               value: 'expired',
//               icon: Icons.event_busy,
//               count: filterCounts['expired'] ?? 0,
//             ),
//             const SizedBox(width: 8),
//             _buildFilterChip(
//               context,
//               label: 'Archived',
//               value: 'archived',
//               icon: Icons.archive,
//               count: filterCounts['archived'] ?? 0,
//             ),
//             const SizedBox(width: 8),
//             _buildFilterChip(
//               context,
//               label: 'All',
//               value: 'all',
//               icon: Icons.list,
//               count: filterCounts['all'] ?? 0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterChip(
//     BuildContext context, {
//     required String label,
//     required String value,
//     required IconData icon,
//     required int count,
//   }) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;
//     final isSelected = selectedFilter == value;

//     return GestureDetector(
//       onTap: () => onFilterChanged(value),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? colorScheme.primary
//               : (isDark ? colorScheme.surface : Colors.white),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected
//                 ? colorScheme.primary
//                 : colorScheme.onSurface.withValues(alpha: 0.2),
//             width: 1.5,
//           ),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: colorScheme.primary.withValues(alpha: 0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               size: 16,
//               color: isSelected
//                   ? colorScheme.onPrimary
//                   : colorScheme.onSurface.withValues(alpha: 0.7),
//             ),
//             const SizedBox(width: 6),
//             Text(
//               '$label ($count)',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
//                 color: isSelected
//                     ? colorScheme.onPrimary
//                     : colorScheme.onSurface,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
