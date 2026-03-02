import 'package:expense_mate/core/utils/translation_helper.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_state.dart';
import 'package:expense_mate/features/budgets/presentation/components/bottom_sheet_component/budget_form.dart';
import 'package:expense_mate/features/budgets/presentation/components/bottom_sheet_component/budget_setting_row.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_state.dart';
import 'package:expense_mate/features/budgets/presentation/components/bottom_sheet_component/budget_compact_display.dart';
import 'package:expense_mate/features/budgets/presentation/components/bottom_sheet_component/budget_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBudgetBottomSheet extends StatelessWidget {
  const AddBudgetBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final presets = context.budgetCategoryPresets;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => BudgetFormBloc(categoryPresets: presets),
        child: const AddBudgetBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<BudgetFormBloc, BudgetFormState>(
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.background : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DragHandle(theme: theme),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Compact header: icon + name + amount display
                      BudgetCompactDisplay(state: state),
                      const SizedBox(height: 12),

                      // Type + Category in one row
                      BudgetSettingsRow(state: state),
                      const SizedBox(height: 8),

                      // Calculator pad (handles amount + name + dates + submit)
                      BudgetCalculator(state: state),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DragHandle extends StatelessWidget {
  final ThemeData theme;
  const _DragHandle({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 10, bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
// class AddBudgetBottomSheet extends StatelessWidget {
//   const AddBudgetBottomSheet({super.key});

//   static Future<void> show(BuildContext context) {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => BlocProvider(
//         create: (context) => BudgetFormBloc(),
//         child: const AddBudgetBottomSheet(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;

//     return BlocBuilder<BudgetFormBloc, BudgetFormState>(
//       builder: (context, formState) {
//         return Container(
//           decoration: BoxDecoration(
//             color: isDark ? colorScheme.background : Colors.white,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(top: 12, bottom: 8),
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: colorScheme.onSurface.withValues(alpha: 0.3),
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border(
//                         bottom: BorderSide(
//                           color: colorScheme.onSurface.withValues(alpha: 0.1),
//                           width: 1,
//                         ),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: colorScheme.primary.withValues(alpha: 0.15),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: colorScheme.primary.withValues(alpha: 0.3),
//                               width: 1.5,
//                             ),
//                           ),
//                           child: Icon(
//                             formState.selectedIcon,
//                             color: colorScheme.primary,
//                             size: 28,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           'Create Budget',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: colorScheme.onSurface,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: BudgetForm(formState: formState),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }





// import 'package:expense_mate/core/data/models/budget_model.dart';
// import 'package:expense_mate/features/budgets/presentation/bloc/budget_bloc.dart';
// import 'package:expense_mate/features/budgets/presentation/bloc/budget_event.dart';

// import 'package:expense_mate/features/budgets/presentation/bloc/budget_form_bloc.dart';
// import 'package:expense_mate/features/budgets/presentation/bloc/budget_form_event.dart';
// import 'package:expense_mate/features/budgets/presentation/bloc/budget_form_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';

// class AddBudgetBottomSheet extends StatelessWidget {
//   const AddBudgetBottomSheet({super.key});

//   static Future<void> show(BuildContext context) {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => BlocProvider(
//         create: (context) => BudgetFormBloc(),
//         child: const AddBudgetBottomSheet(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BudgetFormBloc, BudgetFormState>(
//       builder: (context, formState) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(top: 12),
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: formState.selectedColor.withValues(
//                               alpha: 0.1,
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Icon(
//                             formState.selectedIcon,
//                             color: formState.selectedColor,
//                             size: 28,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         const Text(
//                           'Create Budget',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: _BudgetForm(formState: formState),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // Budget Form Widget
// class _BudgetForm extends StatefulWidget {
//   final BudgetFormState formState;

//   const _BudgetForm({required this.formState});

//   @override
//   State<_BudgetForm> createState() => _BudgetFormState();
// }

// class _BudgetFormState extends State<_BudgetForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _amountController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = widget.formState.name;
//   }

//   @override
//   void didUpdateWidget(_BudgetForm oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.formState.name != oldWidget.formState.name) {
//       _nameController.text = widget.formState.name;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _BudgetTypeSelector(formState: widget.formState),
//           const SizedBox(height: 20),
//           _QuickCategoryChips(formState: widget.formState),
//           const SizedBox(height: 20),
//           _buildNameField(),
//           const SizedBox(height: 16),
//           _buildAmountField(),
//           const SizedBox(height: 20),
//           _DateRangeSelector(formState: widget.formState),
//           const SizedBox(height: 20),
//           _CustomizationSection(formState: widget.formState),
//           const SizedBox(height: 24),
//           _buildActionButtons(),
//         ],
//       ),
//     );
//   }

//   Widget _buildNameField() {
//     return TextFormField(
//       controller: _nameController,
//       onChanged: (value) {
//         context.read<BudgetFormBloc>().add(BudgetFormNameChanged(value));
//       },
//       decoration: InputDecoration(
//         labelText: 'Budget Name',
//         hintText: 'e.g., Monthly Groceries',
//         prefixIcon: const Icon(Icons.label),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Colors.grey[50],
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter a budget name';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildAmountField() {
//     return TextFormField(
//       controller: _amountController,
//       keyboardType: TextInputType.number,
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       decoration: InputDecoration(
//         labelText: 'Budget Amount',
//         hintText: '0',
//         prefixIcon: const Icon(Icons.attach_money),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Colors.grey[50],
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter an amount';
//         }
//         if (double.tryParse(value) == null || double.parse(value) <= 0) {
//           return 'Please enter a valid amount';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () => Navigator.pop(context),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text('Cancel'),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           flex: 2,
//           child: ElevatedButton(
//             onPressed: () => _submitBudget(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: widget.formState.selectedColor,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               'Create Budget',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _submitBudget() {
//     if (_formKey.currentState!.validate()) {
//       print(_nameController.text);
//       print(widget.formState.selectedType);
//       print(double.parse(_amountController.text));
//       print(widget.formState.startDate);
//       print(widget.formState.endDate);
//       print(widget.formState.selectedCategory);
//       print(widget.formState.selectedIcon.codePoint.toString());
//       print(widget.formState.selectedColor.value);
//       context.read<BudgetBloc>().add(
//         CreateBudgetEvent(
//           name: _nameController.text,
//           type: widget.formState.selectedType,
//           totalAmount: double.parse(_amountController.text),
//           startDate: widget.formState.startDate,
//           endDate: widget.formState.endDate,
//           category: widget.formState.selectedCategory,
//           icon: widget.formState.selectedIcon.codePoint.toString(),
//           colorCode: widget.formState.selectedColor.value,
//         ),
//       );

//       Navigator.pop(context);
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _amountController.dispose();
//     super.dispose();
//   }
// }

// // Budget Type Selector Widget
// class _BudgetTypeSelector extends StatelessWidget {
//   final BudgetFormState formState;

//   const _BudgetTypeSelector({required this.formState});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Budget Type',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             _buildTypeChip(
//               context,
//               BudgetType.monthly,
//               'Monthly',
//               Icons.calendar_month,
//             ),
//             const SizedBox(width: 8),
//             _buildTypeChip(context, BudgetType.project, 'Project', Icons.flag),
//             const SizedBox(width: 8),
//             _buildTypeChip(context, BudgetType.custom, 'Custom', Icons.tune),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildTypeChip(
//     BuildContext context,
//     BudgetType type,
//     String label,
//     IconData icon,
//   ) {
//     final isSelected = formState.selectedType == type;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           context.read<BudgetFormBloc>().add(BudgetFormTypeChanged(type));
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: isSelected ? formState.selectedColor : Colors.grey[100],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             children: [
//               Icon(
//                 icon,
//                 color: isSelected ? Colors.white : Colors.grey[600],
//                 size: 24,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : Colors.grey[600],
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
// }

// // Quick Category Chips Widget
// class _QuickCategoryChips extends StatelessWidget {
//   final BudgetFormState formState;

//   const _QuickCategoryChips({required this.formState});

//   @override
//   Widget build(BuildContext context) {
//     final categories = formState.currentCategories;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Quick Select',
//           style: TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: categories.map((category) {
//             final isSelected = formState.selectedCategory == category;
//             return GestureDetector(
//               onTap: () {
//                 context.read<BudgetFormBloc>().add(
//                   BudgetFormCategorySelected(category),
//                 );
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? formState.selectedColor.withOpacity(0.1)
//                       : Colors.grey[100],
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: isSelected
//                         ? formState.selectedColor
//                         : Colors.transparent,
//                     width: 1.5,
//                   ),
//                 ),
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     color: isSelected
//                         ? formState.selectedColor
//                         : Colors.grey[700],
//                     fontWeight: isSelected
//                         ? FontWeight.w600
//                         : FontWeight.normal,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }

// // Date Range Selector Widget
// class _DateRangeSelector extends StatelessWidget {
//   final BudgetFormState formState;

//   const _DateRangeSelector({required this.formState});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.date_range, size: 20, color: Colors.grey[600]),
//               const SizedBox(width: 8),
//               const Text(
//                 'Duration',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _DateButton(
//                   label: 'Start',
//                   date: formState.startDate,
//                   onTap: () => _selectDate(context, true),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Icon(Icons.arrow_forward, color: Colors.grey[400]),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _DateButton(
//                   label: 'End',
//                   date: formState.endDate,
//                   onTap: () => _selectDate(context, false),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '${formState.durationInDays} days',
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context, bool isStartDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isStartDate ? formState.startDate : formState.endDate,
//       firstDate: isStartDate ? DateTime.now() : formState.startDate,
//       lastDate: DateTime.now().add(const Duration(days: 3650)),
//     );

//     if (picked != null && context.mounted) {
//       if (isStartDate) {
//         context.read<BudgetFormBloc>().add(BudgetFormStartDateChanged(picked));
//       } else {
//         context.read<BudgetFormBloc>().add(BudgetFormEndDateChanged(picked));
//       }
//     }
//   }
// }

// // Date Button Widget
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
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey[300]!),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(fontSize: 11, color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               DateFormat('MMM dd, yyyy').format(date),
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Customization Section Widget
// class _CustomizationSection extends StatelessWidget {
//   final BudgetFormState formState;

//   const _CustomizationSection({required this.formState});

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: const Text('Customize Appearance (Optional)'),
//       tilePadding: EdgeInsets.zero,
//       children: [
//         const SizedBox(height: 8),
//         _ColorSelector(formState: formState),
//         const SizedBox(height: 16),
//         _IconSelector(formState: formState),
//       ],
//     );
//   }
// }

// // Color Selector Widget
// class _ColorSelector extends StatelessWidget {
//   final BudgetFormState formState;

//   const _ColorSelector({required this.formState});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Color',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 12,
//           children: formState.colorOptions.map((color) {
//             final isSelected = formState.selectedColor == color;
//             return GestureDetector(
//               onTap: () {
//                 context.read<BudgetFormBloc>().add(
//                   BudgetFormColorChanged(color),
//                 );
//               },
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: color,
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: isSelected ? Colors.black : Colors.transparent,
//                     width: 2,
//                   ),
//                 ),
//                 child: isSelected
//                     ? const Icon(Icons.check, color: Colors.white, size: 20)
//                     : null,
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }

// // Icon Selector Widget
// class _IconSelector extends StatelessWidget {
//   final BudgetFormState formState;

//   const _IconSelector({required this.formState});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Icon',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 12,
//           children: formState.iconOptions.map((icon) {
//             final isSelected = formState.selectedIcon == icon;
//             return GestureDetector(
//               onTap: () {
//                 context.read<BudgetFormBloc>().add(BudgetFormIconChanged(icon));
//               },
//               child: Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? formState.selectedColor.withOpacity(0.1)
//                       : Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: isSelected
//                         ? formState.selectedColor
//                         : Colors.transparent,
//                     width: 2,
//                   ),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: isSelected
//                       ? formState.selectedColor
//                       : Colors.grey[600],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }