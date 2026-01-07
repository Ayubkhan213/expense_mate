// // widgets/quick_login_card.dart
// import 'package:flutter/material.dart';
// import 'dart:io';

// class QuickLoginCard extends StatelessWidget {
//   final String userName;
//   final String email;
//   final String? profilePicturePath;
//   final VoidCallback onTap;
//   final bool showBiometricBadge;
//   final bool showPinBadge;

//   const QuickLoginCard({
//     Key? key,
//     required this.userName,
//     required this.email,
//     this.profilePicturePath,
//     required this.onTap,
//     this.showBiometricBadge = false,
//     this.showPinBadge = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey[200]!, width: 1.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Profile Picture/Avatar with Badge Stack
//             Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [
//                         const Color(0xFF6C5CE7).withOpacity(0.1),
//                         const Color(0xFFA29BFE).withOpacity(0.1),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     border: Border.all(
//                       color: const Color(0xFF6C5CE7).withOpacity(0.2),
//                       width: 2,
//                     ),
//                   ),
//                   child: CircleAvatar(
//                     radius: 36,
//                     backgroundColor: Colors.transparent,
//                     backgroundImage:
//                         profilePicturePath != null &&
//                             File(profilePicturePath!).existsSync()
//                         ? FileImage(File(profilePicturePath!))
//                         : null,
//                     child:
//                         profilePicturePath == null ||
//                             !File(profilePicturePath!).existsSync()
//                         ? Text(
//                             userName.isNotEmpty
//                                 ? userName[0].toUpperCase()
//                                 : '?',
//                             style: const TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF6C5CE7),
//                             ),
//                           )
//                         : null,
//                   ),
//                 ),

//                 // Badge for biometric or PIN
//                 if (showBiometricBadge || showPinBadge)
//                   Positioned(
//                     bottom: -2,
//                     right: -2,
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: showBiometricBadge
//                               ? [
//                                   const Color(0xFF10B981),
//                                   const Color(0xFF059669),
//                                 ]
//                               : [
//                                   const Color(0xFF6C5CE7),
//                                   const Color(0xFFA29BFE),
//                                 ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                         boxShadow: [
//                           BoxShadow(
//                             color:
//                                 (showBiometricBadge
//                                         ? const Color(0xFF10B981)
//                                         : const Color(0xFF6C5CE7))
//                                     .withOpacity(0.4),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         showBiometricBadge
//                             ? Icons.fingerprint
//                             : Icons.pin_outlined,
//                         size: 14,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 12),

//             // User Name
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 userName,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF1A1A1A),
//                   height: 1.2,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//               ),
//             ),

//             const SizedBox(height: 4),

//             // Email
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 email,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.grey[600],
//                   height: 1.2,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//               ),
//             ),

//             const SizedBox(height: 8),

//             // Tap indicator
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6C5CE7).withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.touch_app,
//                     size: 12,
//                     color: const Color(0xFF6C5CE7),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     'Tap to login',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: const Color(0xFF6C5CE7),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
