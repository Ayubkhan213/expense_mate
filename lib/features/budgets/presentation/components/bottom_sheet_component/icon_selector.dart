// import 'package:expense_mate/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';

// class IconSelector extends StatelessWidget {
//   final List<IconData> icons;
//   final IconData selectedIcon;
//   final Color selectedColor;
//   final bool isDark;
//   final Function(IconData) onSelect;
//   final ColorScheme colorScheme;

//   const IconSelector({
//     super.key,
//     required this.icons,
//     required this.selectedIcon,
//     required this.selectedColor,
//     required this.isDark,
//     required this.onSelect,
//     required this.colorScheme,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _title(t.icon, colorScheme),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: icons.map((icon) {
//             final isSelected = icon == selectedIcon;
//             return GestureDetector(
//               onTap: () => onSelect(icon),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 width: 52,
//                 height: 52,
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? selectedColor.withOpacity(0.15)
//                       : (isDark ? colorScheme.surface : Colors.grey[100]),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: isSelected
//                         ? selectedColor
//                         : colorScheme.onSurface.withOpacity(0.1),
//                     width: 2,
//                   ),
//                 ),
//                 child: Icon(
//                   icon,
//                   size: 26,
//                   color: isSelected
//                       ? selectedColor
//                       : colorScheme.onSurface.withOpacity(0.6),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _title(String text, ColorScheme scheme) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: scheme.onSurface,
//       ),
//     );
//   }
// }
