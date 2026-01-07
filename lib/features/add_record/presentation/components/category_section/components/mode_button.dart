import 'package:flutter/material.dart';

class ModeButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool active;
  final String text;
  const ModeButton({
    super.key,
    required this.active,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: active ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: active ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );

    //    _modeButton(
    //     l.single,
    //     state.isMultipleMode == false ? true : false,
    //     () {
    //       context.read<AddRecordBloc>().add(
    //         ToggleSelectionTabs(isMultipleSelection: false),
    //       );
    //     },
    //   ),
    // );
  }
}
