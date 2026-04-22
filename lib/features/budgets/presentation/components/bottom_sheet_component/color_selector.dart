// import 'package:spendio/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';

// class ColorSelector extends StatelessWidget {
//   final List<Color> colors;
//   final Color selectedColor;
//   final Function(Color) onSelect;
//   final ColorScheme colorScheme;

//   const ColorSelector({
//     super.key,
//     required this.colors,
//     required this.selectedColor,
//     required this.onSelect,
//     required this.colorScheme,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _title(t.color, colorScheme),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: colors.map((color) {
//             final isSelected = color == selectedColor;
//             return GestureDetector(
//               onTap: () => onSelect(color),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: color,
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: isSelected
//                         ? colorScheme.onSurface
//                         : Colors.transparent,
//                     width: 3,
//                   ),
//                   boxShadow: isSelected
//                       ? [
//                           BoxShadow(
//                             color: color.withOpacity(0.4),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ]
//                       : null,
//                 ),
//                 child: isSelected
//                     ? const Icon(Icons.check, color: Colors.white)
//                     : null,
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
