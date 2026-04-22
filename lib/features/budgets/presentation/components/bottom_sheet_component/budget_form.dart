// import 'package:spendio/core/app_export.dart';
// import 'package:spendio/core/common/app_textfield.dart';
// import 'package:spendio/core/common/form_action_button.dart';
// import 'package:spendio/features/budgets/presentation/bloc/budget/budget_bloc.dart';
// import 'package:spendio/features/budgets/presentation/bloc/budget/budget_event.dart';
// import 'package:spendio/features/budgets/presentation/bloc/budget_from/budget_form_bloc.dart';
// import 'package:spendio/features/budgets/presentation/bloc/budget_from/budget_form_event.dart';
// import 'package:spendio/features/budgets/presentation/components/bottom_sheet_component/budget_type_selection.dart';
// import 'package:spendio/features/budgets/presentation/components/bottom_sheet_component/color_selector.dart';
// import 'package:spendio/features/budgets/presentation/components/bottom_sheet_component/dart_range_selector.dart';
// import 'package:spendio/features/budgets/presentation/components/bottom_sheet_component/icon_selector.dart';
// import 'package:spendio/features/budgets/presentation/components/bottom_sheet_component/quick_category_selection.dart';
// import 'package:flutter/services.dart';

// class BudgetForm extends StatefulWidget {
//   final dynamic formState; // Replace with BudgetFormState

//   const BudgetForm({super.key, required this.formState});

//   @override
//   State<BudgetForm> createState() => _BudgetFormState();
// }

// class _BudgetFormState extends State<BudgetForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _amountController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = widget.formState.name ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;

//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Budget Type Selector
//           BudgetTypeSelector(
//             selectedType: widget.formState.selectedType,
//             accentColor: Theme.of(context).primaryColor,
//             onTypeChanged: (type) {
//               context.read<BudgetFormBloc>().add(BudgetFormTypeChanged(type));
//             },
//           ),
//           const SizedBox(height: 20),

//           // Quick Category Chips
//           QuickCategoryChips(
//             categories: widget.formState.currentCategories ?? [],
//             selectedCategory: widget.formState.selectedCategory,
//             accentColor: Theme.of(context).primaryColor,
//             onCategorySelected: (category) {
//               context.read<BudgetFormBloc>().add(
//                 BudgetFormCategorySelected(category),
//               );
//               _nameController.text = category;
//               context.read<BudgetFormBloc>().add(
//                 BudgetFormNameChanged(category),
//               );
//             },
//           ),
//           const SizedBox(height: 20),

//           // Name Field
//           AppTextField(
//             controller: _nameController,
//             label: 'Budget Name',
//             hint: 'e.g., Monthly Groceries',
//             icon: Icons.label_outline,
//             colorScheme: colorScheme,
//             isDark: isDark,
//             onChanged: (value) {
//               context.read<BudgetFormBloc>().add(BudgetFormNameChanged(value));
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter a budget name';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),

//           // Amount Field
//           AppTextField(
//             controller: _amountController,
//             label: 'Budget Amount',
//             hint: '0.00',
//             icon: Icons.attach_money,
//             colorScheme: colorScheme,
//             isDark: isDark,
//             keyboardType: TextInputType.number,
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//             ],
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter an amount';
//               }
//               if (double.tryParse(value) == null || double.parse(value) <= 0) {
//                 return 'Please enter a valid amount';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 20),

//           // Date Range Selector
//           DateRangeSelector(
//             startDate: widget.formState.startDate,
//             endDate: widget.formState.endDate,
//             durationInDays: widget.formState.durationInDays ?? 0,
//             onStartDateChanged: (date) {
//               context.read<BudgetFormBloc>().add(
//                 BudgetFormStartDateChanged(date),
//               );
//             },
//             onEndDateChanged: (date) {
//               context.read<BudgetFormBloc>().add(
//                 BudgetFormEndDateChanged(date),
//               );
//             },
//           ),
//           const SizedBox(height: 20),

//           // Customization Section
//           _buildCustomizationSection(colorScheme, isDark),

//           const SizedBox(height: 24),

//           // Action Buttons
//           FormActionButtons(
//             onCancel: () => Navigator.pop(context),
//             onSubmit: _submitBudget,
//             submitColor: widget.formState.selectedColor,
//             colorScheme: colorScheme,
//             submitText: 'Create Budget',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCustomizationSection(ColorScheme colorScheme, bool isDark) {
//     return Theme(
//       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//       child: ExpansionTile(
//         title: Text(
//           'Customize Appearance',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: colorScheme.onSurface,
//           ),
//         ),
//         tilePadding: EdgeInsets.zero,
//         children: [
//           const SizedBox(height: 12),
//           ColorSelector(
//             colors: widget.formState.colorOptions!,
//             selectedColor: widget.formState.selectedColor,
//             colorScheme: colorScheme,
//             onSelect: (color) {
//               context.read<BudgetFormBloc>().add(BudgetFormColorChanged(color));
//             },
//           ),

//           const SizedBox(height: 20),
//           IconSelector(
//             icons: widget.formState.iconOptions!,
//             selectedIcon: widget.formState.selectedIcon,
//             selectedColor: widget.formState.selectedColor,
//             isDark: isDark,
//             colorScheme: colorScheme,
//             onSelect: (icon) {
//               context.read<BudgetFormBloc>().add(BudgetFormIconChanged(icon));
//             },
//           ),
//           const SizedBox(height: 12),
//         ],
//       ),
//     );
//   }

//   void _submitBudget() {
//     if (_formKey.currentState!.validate()) {
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
