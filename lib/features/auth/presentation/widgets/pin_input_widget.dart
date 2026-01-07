// // widgets/pin_input.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class PinInput extends StatefulWidget {
//   final Function(String) onCompleted;
//   final int length;
//   final bool obscureText;
//   final double fieldWidth;
//   final double fieldHeight;
//   final Color? fillColor;
//   final Color? focusedBorderColor;
//   final VoidCallback? onChanged;

//   const PinInput({
//     Key? key,
//     required this.onCompleted,
//     this.length = 4,
//     this.obscureText = true,
//     this.fieldWidth = 60,
//     this.fieldHeight = 60,
//     this.fillColor,
//     this.focusedBorderColor,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   State<PinInput> createState() => _PinInputState();
// }

// class _PinInputState extends State<PinInput> {
//   final List<TextEditingController> _controllers = [];
//   final List<FocusNode> _focusNodes = [];
//   final List<bool> _filled = [];

//   @override
//   void initState() {
//     super.initState();
//     for (int i = 0; i < widget.length; i++) {
//       _controllers.add(TextEditingController());
//       _focusNodes.add(FocusNode());
//       _filled.add(false);
//     }

//     // Auto-focus first field
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_focusNodes.isNotEmpty) {
//         _focusNodes[0].requestFocus();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void _onChanged(String value, int index) {
//     setState(() {
//       _filled[index] = value.isNotEmpty;
//     });

//     if (value.isNotEmpty) {
//       // Move to next field
//       if (index < widget.length - 1) {
//         _focusNodes[index + 1].requestFocus();
//       } else {
//         // Last field, remove focus
//         _focusNodes[index].unfocus();
//       }
//     }

//     // Check if all fields are filled
//     final pin = _controllers.map((c) => c.text).join();
//     if (pin.length == widget.length) {
//       widget.onCompleted(pin);
//     }

//     // Call onChanged callback
//     if (widget.onChanged != null) {
//       widget.onChanged!();
//     }
//   }

//   void _onKeyEvent(RawKeyEvent event, int index) {
//     if (event is RawKeyDownEvent) {
//       if (event.logicalKey == LogicalKeyboardKey.backspace) {
//         if (_controllers[index].text.isEmpty && index > 0) {
//           // Move to previous field on backspace if current is empty
//           _focusNodes[index - 1].requestFocus();
//           _controllers[index - 1].clear();
//           setState(() {
//             _filled[index - 1] = false;
//           });
//         }
//       }
//     }
//   }

//   // Public method to clear PIN (can be called from parent)
//   void clearPin() {
//     for (var controller in _controllers) {
//       controller.clear();
//     }
//     setState(() {
//       for (int i = 0; i < _filled.length; i++) {
//         _filled[i] = false;
//       }
//     });
//     if (_focusNodes.isNotEmpty) {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (mounted && _focusNodes.isNotEmpty) {
//           _focusNodes[0].requestFocus();
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: List.generate(widget.length, (index) => _buildPinField(index)),
//     );
//   }

//   Widget _buildPinField(int index) {
//     return SizedBox(
//       width: widget.fieldWidth,
//       height: widget.fieldHeight,
//       child: RawKeyboardListener(
//         focusNode: FocusNode(),
//         onKey: (event) => _onKeyEvent(event, index),
//         child: TextField(
//           controller: _controllers[index],
//           focusNode: _focusNodes[index],
//           textAlign: TextAlign.center,
//           keyboardType: TextInputType.number,
//           maxLength: 1,
//           obscureText: widget.obscureText,
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1A1A1A),
//           ),
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           decoration: InputDecoration(
//             counterText: '',
//             filled: true,
//             fillColor: widget.fillColor ?? const Color(0xFFF5F5F5),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: _filled[index]
//                   ? BorderSide(
//                       color:
//                           (widget.focusedBorderColor ?? const Color(0xFF6C5CE7))
//                               .withOpacity(0.3),
//                       width: 2,
//                     )
//                   : BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: widget.focusedBorderColor ?? const Color(0xFF6C5CE7),
//                 width: 2,
//               ),
//             ),
//             contentPadding: const EdgeInsets.all(0),
//           ),
//           onChanged: (value) => _onChanged(value, index),
//         ),
//       ),
//     );
//   }
// }
