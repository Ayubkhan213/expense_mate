import 'package:expense_mate/features/add_record/presentation/components/category_section/category_selection_component.dart';
import 'package:flutter/material.dart';

class AddRecordFace extends StatelessWidget {
  const AddRecordFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: SafeArea(
        child: Column(
          children: [
            CategorySelector(),
            InkWell(
              onTap: () {
                CategorySelector();
              },
              child: Container(child: Center(child: Text('Add Reoport'))),
            ),
          ],
        ),
      ),
    );
  }
}
