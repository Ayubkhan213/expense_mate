// ignore_for_file: dead_code, unnecessary_null_comparison

import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/features/add_record/presentation/components/category_section/components/category_grid/components/category_bottom_sheet/components/button_component.dart';
import 'package:expense_mate/features/add_record/presentation/components/category_section/components/category_grid/components/category_bottom_sheet/components/debt_toggle.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'bloc/category_bottom_sheet_bloc.dart';
import 'bloc/category_bottom_sheet_event.dart';
import 'bloc/category_bottom_sheet_state.dart';

class CategoryBottomSheet {
  static void show(BuildContext context, CategoryHiveModel category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => CategoryBottomSheetBloc(category: category),
        child: _CategoryBottomSheetContent(category: category),
      ),
    );
  }
}

class _CategoryBottomSheetContent extends StatelessWidget {
  final CategoryHiveModel category;

  const _CategoryBottomSheetContent({required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBottomSheetBloc, CategoryBottomSheetState>(
      builder: (context, state) {
        final bloc = context.read<CategoryBottomSheetBloc>();

        return Container(
          // height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Debt Badge (Left side) - Always visible, changes on selection
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        // Toggle debt on/off
                        if (state.transactionType == TransactionType.expense) {
                          bloc.add(DebtToggled(DebtType.borrowed));
                        } else {
                          bloc.add(DebtToggled(DebtType.lent));
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: state.isDebt
                              ? (state.debtType == DebtType.borrowed
                                    ? Colors.red.withValues(alpha: 0.2)
                                    : Colors.green.withValues(alpha: 0.2))
                              : Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: state.isDebt
                                ? (state.debtType == DebtType.borrowed
                                      ? Colors.red
                                      : Colors.green)
                                : Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.transactionType == TransactionType.expense
                                  ? '💰'
                                  : '💸',
                              style: TextStyle(
                                fontSize: 12,
                                // opacity: state.isDebt ? 1.0 : 0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.transactionType == TransactionType.expense
                                  ? 'Borrowed'
                                  : 'Lent',
                              style: TextStyle(
                                color: state.isDebt
                                    ? (state.debtType == DebtType.borrowed
                                          ? Colors.red
                                          : Colors.green)
                                    : Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Spacer(),
                    Text(
                      state.display,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 2. Add payment method selector (before calculator buttons)
              // Payment Method Selector
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _PaymentMethodChip(
                      icon: Icons.money,
                      label: 'Cash',
                      selected: state.paymentMethod == PaymentMethod.cash,
                      onTap: () =>
                          bloc.add(PaymentMethodChanged(PaymentMethod.cash)),
                    ),
                    _PaymentMethodChip(
                      icon: Icons.credit_card,
                      label: 'Card',
                      selected: state.paymentMethod == PaymentMethod.card,
                      onTap: () =>
                          bloc.add(PaymentMethodChanged(PaymentMethod.card)),
                    ),
                    _PaymentMethodChip(
                      icon: Icons.account_balance,
                      label: 'Bank',
                      selected: state.paymentMethod == PaymentMethod.bank,
                      onTap: () =>
                          bloc.add(PaymentMethodChanged(PaymentMethod.bank)),
                    ),
                    _PaymentMethodChip(
                      icon: Icons.wallet,
                      label: 'Wallet',
                      selected: state.paymentMethod == PaymentMethod.wallet,
                      onTap: () =>
                          bloc.add(PaymentMethodChanged(PaymentMethod.wallet)),
                    ),
                  ],
                ),
              ),

              // Note field
              TextField(
                controller: TextEditingController(text: state.note),
                onChanged: (val) => bloc.add(NoteChanged(note: val)),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Note: Enter a note...',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.image, color: Colors.amber),
                    onPressed: () => bloc.add(ImagePicked()),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Expandable Debt Details Section
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: state.isDebt
                    ? Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.debtType == DebtType.borrowed
                                  ? '💰 Borrowed From'
                                  : '💸 Lent To',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Person Name Field
                            TextField(
                              controller: TextEditingController(
                                text: state.personName,
                              ),
                              onChanged: (val) =>
                                  bloc.add(PersonNameChanged(name: val)),
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Person name...',
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                filled: true,
                                fillColor: Colors.grey[900],
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Expected Return Date
                            GestureDetector(
                              onTap: () =>
                                  bloc.add(ExpectedReturnDatePressed(context)),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        state.expectedReturnDate != null
                                            ? 'Return by: ${DateFormat('dd MMM yyyy').format(state.expectedReturnDate!)}'
                                            : 'Set expected return date',
                                        style: TextStyle(
                                          color:
                                              state.expectedReturnDate != null
                                              ? Colors.white
                                              : Colors.white54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white54,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              state.isDebt ? const SizedBox(height: 2) : SizedBox(height: 8),

              // Calculator Buttons
              Row(
                children: [
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '7')),
                    text: '7',
                  ),
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '8')),
                    text: '8',
                  ),
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '9')),
                    text: '9',
                  ),
                  ButtonComponent(
                    onTap: () => bloc.add(DatePressed(context)),
                    text: state.selectedDateTime == null
                        ? 'Today'
                        : DateFormat('d/M/yy').format(state.selectedDateTime),
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '4')),
                    text: '4',
                  ),
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '5')),
                    text: '5',
                  ),
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '6')),
                    text: '6',
                  ),
                  ButtonComponent(
                    onTap: () => bloc.add(OperationPressed(operation: '+')),
                    color: Colors.orange,
                    text: '+',
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '1')),
                    text: '1',
                  ),
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '2')),
                    text: '2',
                  ),
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '3')),
                    text: '3',
                  ),
                  ButtonComponent(
                    color: Colors.orange,
                    onTap: () => bloc.add(OperationPressed(operation: '-')),
                    text: '-',
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '.')),
                    text: '.',
                  ),
                  ButtonComponent(
                    onTap: () => bloc.add(NumberPressed(number: '0')),
                    text: '0',
                  ),
                  ButtonComponent(
                    color: Colors.red,
                    onTap: () => bloc.add(ClearPressed()),
                    text: '⌫',
                  ),
                  state.operation.isNotEmpty
                      ? ButtonComponent(
                          color: Colors.orange,
                          onTap: () => bloc.add(EqualsPressed()),
                          text: '=',
                        )
                      : state.display != '0' && state.currentNumber.isNotEmpty
                      ? ButtonComponent(
                          color: Colors.green,
                          onTap: () {
                            // Submit transaction
                            // bloc.add(SubmitTransaction());
                            Navigator.pop(context);
                          },
                          text: '✓',
                        )
                      : ButtonComponent(
                          color: Colors.grey,
                          onTap: () {},
                          text: '✓',
                        ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

// // // Debt / Lent Toggle
// Row(
//   children: [
//     if (state.transactionType == TransactionType.expense)
//       DebtToggleButton(
//         type: DebtType.borrowed,
//         label: "Borrowed",
//         selectedType: state.debtType,
//         onTap: () => bloc.add(DebtToggled(DebtType.borrowed)),
//       ),

//     if (state.transactionType == TransactionType.income)
//       DebtToggleButton(
//         type: DebtType.lent,
//         label: "Lent",
//         selectedType: state.debtType,
//         onTap: () => bloc.add(DebtToggled(DebtType.lent)),
//       ),
//   ],
// ),

// Helper Widget
class _PaymentMethodChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.amber : Colors.grey[850],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.amber : Colors.grey[700]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.black : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.black : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
