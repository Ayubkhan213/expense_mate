// // screens/forgot_password_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/auth_bloc.dart';
// import '../bloc/auth_event.dart';
// import '../bloc/auth_state.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/custom_button.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({Key? key}) : super(key: key);

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _codeController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _emailSent = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _codeController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _handleSendCode() {
//     if (_formKey.currentState!.validate()) {
//       context.read<AuthBloc>().add(
//         ForgotPasswordEvent(email: _emailController.text.trim()),
//       );
//     }
//   }

//   void _handleResetPassword() {
//     if (_formKey.currentState!.validate()) {
//       context.read<AuthBloc>().add(
//         ResetPasswordEvent(
//           email: _emailController.text.trim(),
//           newPassword: _newPasswordController.text,
//           verificationCode: _codeController.text,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           } else if (state is PasswordResetEmailSent) {
//             setState(() {
//               _emailSent = true;
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Verification code sent to your email'),
//                 backgroundColor: Color(0xFF10B981),
//               ),
//             );
//           } else if (state is PasswordResetSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Password reset successfully'),
//                 backgroundColor: Color(0xFF10B981),
//               ),
//             );
//             Navigator.pop(context);
//           }
//         },
//         builder: (context, state) {
//           final isLoading = state is AuthLoading;

//           return SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header
//                   const Text(
//                     'Forgot Password?',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     _emailSent
//                         ? 'Enter the verification code sent to your email'
//                         : "Don't worry! Enter your email and we'll send you a verification code",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFF6B7280),
//                     ),
//                   ),
//                   const SizedBox(height: 40),

//                   // Icon
//                   Center(
//                     child: Container(
//                       width: 120,
//                       height: 120,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF6C5CE7).withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.lock_reset,
//                         size: 60,
//                         color: Color(0xFF6C5CE7),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),

//                   // Form
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         if (!_emailSent) ...[
//                           // Email Input
//                           CustomTextField(
//                             controller: _emailController,
//                             label: 'Email',
//                             hint: 'Enter your email',
//                             prefixIcon: Icons.email_outlined,
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               if (!value.contains('@')) {
//                                 return 'Please enter a valid email';
//                               }
//                               return null;
//                             },
//                           ),
//                         ] else ...[
//                           // Verification Code Input
//                           CustomTextField(
//                             controller: _codeController,
//                             label: 'Verification Code',
//                             hint: 'Enter 6-digit code',
//                             prefixIcon: Icons.pin_outlined,
//                             keyboardType: TextInputType.number,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter the verification code';
//                               }
//                               if (value.length != 6) {
//                                 return 'Code must be 6 digits';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),

//                           // New Password
//                           CustomTextField(
//                             controller: _newPasswordController,
//                             label: 'New Password',
//                             hint: 'Enter new password',
//                             prefixIcon: Icons.lock_outline,
//                             obscureText: _obscurePassword,
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 size: 20,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscurePassword = !_obscurePassword;
//                                 });
//                               },
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter new password';
//                               }
//                               if (value.length < 6) {
//                                 return 'Password must be at least 6 characters';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),

//                           // Confirm Password
//                           CustomTextField(
//                             controller: _confirmPasswordController,
//                             label: 'Confirm Password',
//                             hint: 'Re-enter new password',
//                             prefixIcon: Icons.lock_outline,
//                             obscureText: _obscureConfirmPassword,
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscureConfirmPassword
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 size: 20,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscureConfirmPassword =
//                                       !_obscureConfirmPassword;
//                                 });
//                               },
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please confirm your password';
//                               }
//                               if (value != _newPasswordController.text) {
//                                 return 'Passwords do not match';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 32),

//                   // Submit Button
//                   CustomButton(
//                     text: _emailSent ? 'Reset Password' : 'Send Code',
//                     onPressed: _emailSent
//                         ? _handleResetPassword
//                         : _handleSendCode,
//                     isLoading: isLoading,
//                   ),

//                   // Resend Code
//                   if (_emailSent) ...[
//                     const SizedBox(height: 24),
//                     Center(
//                       child: TextButton(
//                         onPressed: isLoading ? null : _handleSendCode,
//                         child: const Text(
//                           'Resend Code',
//                           style: TextStyle(
//                             color: Color(0xFF6C5CE7),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],

//                   // Back to Login
//                   const SizedBox(height: 16),
//                   Center(
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: const [
//                           Icon(
//                             Icons.arrow_back,
//                             size: 18,
//                             color: Color(0xFF6B7280),
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             'Back to Login',
//                             style: TextStyle(
//                               color: Color(0xFF6B7280),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
