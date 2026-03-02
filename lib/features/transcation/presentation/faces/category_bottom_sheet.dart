import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/common/custom_snackbar.dart';
import 'package:expense_mate/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/repository_imp/transcation_repository.dart';
import 'package:expense_mate/core/domain/use_cases/add_debt_payment_usecase.dart';
import 'package:expense_mate/core/domain/use_cases/add_debt_transcation_usecase.dart';
import 'package:expense_mate/core/domain/use_cases/add_debt_usecase.dart';
import 'package:expense_mate/core/domain/use_cases/add_transcation_usecase.dart';
import 'package:expense_mate/core/domain/use_cases/save_budget_transcation_usecase.dart';
import 'package:expense_mate/core/utils/enum.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail/budget_detail_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail/budget_detail_event.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_bloc.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_event.dart';
import 'package:expense_mate/features/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:expense_mate/features/home/presentation/bloc/home_bloc/home_event.dart';
import 'package:expense_mate/features/transcation/presentation/components/category_bottom_sheet/calculator_button.dart';
import 'package:expense_mate/features/transcation/presentation/components/category_bottom_sheet/debt_details_section.dart';
import 'package:expense_mate/features/transcation/presentation/components/category_bottom_sheet/display_section.dart';
import 'package:expense_mate/features/transcation/presentation/components/category_bottom_sheet/note_input_section.dart';
import 'package:expense_mate/features/transcation/presentation/components/category_bottom_sheet/payment_method_section.dart';
import 'package:intl/intl.dart';

import '../bloc/category_bottom_sheet_bloc/category_bottom_sheet_bloc.dart';
import '../bloc/category_bottom_sheet_bloc/category_bottom_sheet_event.dart';
import '../bloc/category_bottom_sheet_bloc/category_bottom_sheet_state.dart';

class CategoryBottomSheet {
  static void show(
    BuildContext context,
    CategoryHiveModel? category,
    TransactionSource flowType,
    BudgetModel? budgetModel,
    DebtModel? debtModel,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => CategoryBottomSheetBloc(
          category:
              category ??
              CategoryHiveModel(
                key: '',
                iconCode: 123,
                colorValue: 123,
                isIncome: false,
              ),
          saveBudgetTranscationUsecase: SaveBudgetTranscationUsecase(
            transactionRepository: TransactionRepositoryImp(
              localDataSource: TransactionLocalDataSourceImpl(),
            ),
          ),
          addDebtUsecase: AddDebtUsecase(
            transactionRepository: TransactionRepositoryImp(
              localDataSource: TransactionLocalDataSourceImpl(),
            ),
          ),
          addDebtPaymentUseCase: AddDebtPaymentUseCase(
            repository: TransactionRepositoryImp(
              localDataSource: TransactionLocalDataSourceImpl(),
            ),
          ),
          saveNormalTranscationUsecase: SaveNormalTranscationUsecase(
            transactionRepository: TransactionRepositoryImp(
              localDataSource: TransactionLocalDataSourceImpl(),
            ),
          ),
          saveDebtTranscationUsecase: SaveDebtTranscationUsecase(
            transactionRepository: TransactionRepositoryImp(
              localDataSource: TransactionLocalDataSourceImpl(),
            ),
          ),
        ),
        child: _CategoryBottomSheetContent(
          category:
              category ??
              CategoryHiveModel(
                key: '',
                iconCode: 123,
                colorValue: 123,
                isIncome: false,
              ),
          flowType: flowType,
          budgetModel: budgetModel,
          debtModel: debtModel,
        ),
      ),
    );
  }
}

class _CategoryBottomSheetContent extends StatelessWidget {
  final CategoryHiveModel category;
  final TransactionSource flowType;
  final BudgetModel? budgetModel;
  final DebtModel? debtModel;

  const _CategoryBottomSheetContent({
    required this.category,
    required this.flowType,
    this.budgetModel,
    this.debtModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final showDebtToggle =
        flowType != TransactionSource.budget &&
        flowType != TransactionSource.normal &&
        debtModel == null;

    return BlocConsumer<CategoryBottomSheetBloc, CategoryBottomSheetState>(
      listener: _handleTransactionStatus,
      builder: (context, state) {
        final bloc = context.read<CategoryBottomSheetBloc>();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? colorScheme.background : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(colorScheme),
              const SizedBox(height: 8),

              DisplaySection(
                display: state.display,
                isDebt: state.isDebt,
                debtType: state.debtType,
                transactionType: state.transactionType,
                showDebtToggle: showDebtToggle,
                alignRight: flowType == TransactionSource.budget,
                onDebtToggle: () => _handleDebtToggle(bloc, state),
              ),
              const SizedBox(height: 8),

              PaymentMethodSelector(
                selectedMethod: state.paymentMethod,
                onMethodChanged: (method) =>
                    bloc.add(PaymentMethodChanged(method)),
              ),
              const SizedBox(height: 8),

              NoteInputField(
                note: state.note,
                onNoteChanged: (note) => bloc.add(NoteChanged(note: note)),
                onImagePick: () => bloc.add(ImagePicked()),
              ),
              const SizedBox(height: 8),

              DebtDetailsSection(
                isDebt: state.isDebt,
                debtType: state.debtType,
                personName: state.personName ?? '',
                expectedReturnDate: state.expectedReturnDate,
                onPersonNameChanged: (name) =>
                    bloc.add(PersonNameChanged(name: name)),
                onDatePressed: () =>
                    bloc.add(ExpectedReturnDatePressed(context)),
              ),
              state.isDebt
                  ? const SizedBox(height: 2)
                  : const SizedBox(height: 8),

              _buildCalculatorGrid(context, state, bloc),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(ColorScheme colorScheme) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildCalculatorGrid(
    BuildContext context,
    CategoryBottomSheetState state,
    CategoryBottomSheetBloc bloc,
  ) {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            CalculatorButton(
              text: '7',
              onTap: () => bloc.add(NumberPressed(number: '7')),
            ),
            CalculatorButton(
              text: '8',
              onTap: () => bloc.add(NumberPressed(number: '8')),
            ),
            CalculatorButton(
              text: '9',
              onTap: () => bloc.add(NumberPressed(number: '9')),
            ),
            CalculatorButton(
              text: state.selectedDateTime == null
                  ? t.today
                  : DateFormat('d/M/yy').format(state.selectedDateTime),
              onTap: () => bloc.add(DatePressed(context)),
            ),
          ],
        ),
        Row(
          children: [
            CalculatorButton(
              text: '4',
              onTap: () => bloc.add(NumberPressed(number: '4')),
            ),
            CalculatorButton(
              text: '5',
              onTap: () => bloc.add(NumberPressed(number: '5')),
            ),
            CalculatorButton(
              text: '6',
              onTap: () => bloc.add(NumberPressed(number: '6')),
            ),
            CalculatorButton(
              text: '+',
              color: Colors.orange,
              onTap: () => bloc.add(OperationPressed(operation: '+')),
            ),
          ],
        ),
        Row(
          children: [
            CalculatorButton(
              text: '1',
              onTap: () => bloc.add(NumberPressed(number: '1')),
            ),
            CalculatorButton(
              text: '2',
              onTap: () => bloc.add(NumberPressed(number: '2')),
            ),
            CalculatorButton(
              text: '3',
              onTap: () => bloc.add(NumberPressed(number: '3')),
            ),
            CalculatorButton(
              text: '-',
              color: Colors.orange,
              onTap: () => bloc.add(OperationPressed(operation: '-')),
            ),
          ],
        ),
        Row(
          children: [
            CalculatorButton(
              text: '.',
              onTap: () => bloc.add(NumberPressed(number: '.')),
            ),
            CalculatorButton(
              text: '0',
              onTap: () => bloc.add(NumberPressed(number: '0')),
            ),
            CalculatorButton(
              text: '⌫',
              color: Colors.red,
              onTap: () => bloc.add(ClearPressed()),
            ),
            _buildActionButton(state, bloc),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    CategoryBottomSheetState state,
    CategoryBottomSheetBloc bloc,
  ) {
    if (state.operation.isNotEmpty) {
      return CalculatorButton(
        text: '=',
        color: Colors.orange,
        onTap: () => bloc.add(EqualsPressed()),
      );
    } else if (state.display != '0' && state.currentNumber.isNotEmpty) {
      return CalculatorButton(
        text: '✓',
        color: Colors.green,
        onTap: () => _handleSubmit(bloc),
      );
    } else {
      return CalculatorButton(text: '✓', color: Colors.grey, onTap: () {});
    }
  }

  void _handleDebtToggle(
    CategoryBottomSheetBloc bloc,
    CategoryBottomSheetState state,
  ) {
    if (state.transactionType == TransactionType.expense) {
      bloc.add(DebtToggled(DebtType.borrowed));
    } else {
      bloc.add(DebtToggled(DebtType.lent));
    }
  }

  void _handleSubmit(CategoryBottomSheetBloc bloc) {
    if (flowType == TransactionSource.budget) {
      bloc.add(SaveBudgetTransaction(budgetModel: budgetModel!));
    } else if (flowType == TransactionSource.normal) {
      bloc.add(SaveNormalTransaction());
    } else if (flowType == TransactionSource.debt && debtModel == null) {
      bloc.add(SaveDebtTransaction());
    } else if (flowType == TransactionSource.debt && debtModel != null) {
      bloc.add(SaveDebtPayment(debtModel: debtModel!));
    }
  }

  void _handleTransactionStatus(
    BuildContext context,
    CategoryBottomSheetState state,
  ) {
    if (state.transactionStatus == TransactionStatus.success) {
      AnimatedSnackbar.showSuccess(context, 'Transaction saved successfully!');
      if (budgetModel != null) {
        context.read<BudgetBloc>().add(LoadBudgetsEvent());
        context.read<BudgetDetailsBloc>().add(
          LoadBudgetDetailsEvent(budgetModel!.id),
        );
      }
      if (debtModel == null) {
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        context.read<DebtRepaymentBloc>().add(
          LoadDebtPayments(debtModel: debtModel!),
        );
      }

      context.read<CategoryBottomSheetBloc>().add(ResetTransactionStatus());
      context.read<HomeBloc>().add(LoadHomeData());
    } else if (state.transactionStatus == TransactionStatus.error) {
      AnimatedSnackbar.showError(
        context,
        state.errorMessage ?? 'Failed to save transaction',
      );
      context.read<CategoryBottomSheetBloc>().add(ResetTransactionStatus());
    }
  }
}
// // ignore_for_file: dead_code, unnecessary_null_comparison

// import 'package:expense_mate/core/app_export.dart';
// import 'package:expense_mate/core/common/custom_snackbar.dart';
// import 'package:expense_mate/core/data/data_sources/local/transcation_local_data_source.dart';
// import 'package:expense_mate/core/data/models/budget_model.dart';
// import 'package:expense_mate/core/data/models/debt_model.dart';
// import 'package:expense_mate/core/data/models/enums.dart';
// import 'package:expense_mate/core/data/repository_imp/transcation_repository.dart';
// import 'package:expense_mate/core/domain/use_cases/add_debt_payment_usecase.dart';
// import 'package:expense_mate/core/domain/use_cases/add_debt_usecase.dart';
// import 'package:expense_mate/core/domain/use_cases/save_budget_transcation_usecase.dart';

// import 'package:expense_mate/core/utils/enum.dart';
// import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_bloc.dart';
// import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_event.dart';
// import 'package:expense_mate/features/home/presentation/bloc/home_bloc/home_bloc.dart';
// import 'package:expense_mate/features/home/presentation/bloc/home_bloc/home_event.dart';
// import 'package:expense_mate/features/transcation/presentation/components/category_bottom_sheet/button_component.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import '../bloc/category_bottom_sheet_bloc/category_bottom_sheet_bloc.dart';
// import '../bloc/category_bottom_sheet_bloc/category_bottom_sheet_event.dart';
// import '../bloc/category_bottom_sheet_bloc/category_bottom_sheet_state.dart';

// class CategoryBottomSheet {
//   static void show(
//     BuildContext context,
//     CategoryHiveModel? category,
//     TransactionSource flowType,
//     BudgetModel? budgetmodel,
//     DebtModel? debtModel,
//   ) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => BlocProvider(
//         create: (_) => CategoryBottomSheetBloc(
//           category:
//               category ??
//               CategoryHiveModel(
//                 key: '',
//                 iconCode: 123,
//                 colorValue: 123,
//                 isIncome: false,
//               ),
//           saveBudgetTranscationUsecase: SaveBudgetTranscationUsecase(
//             transactionRepository: TransactionRepositoryImp(
//               localDataSource: TransactionLocalDataSourceImpl(),
//             ),
//           ),
//           addDebtUsecase: AddDebtUsecase(
//             transactionRepository: TransactionRepositoryImp(
//               localDataSource: TransactionLocalDataSourceImpl(),
//             ),
//           ),
//           addDebtPaymentUseCase: AddDebtPaymentUseCase(
//             repository: TransactionRepositoryImp(
//               localDataSource: TransactionLocalDataSourceImpl(),
//             ),
//           ),
//         ),
//         child: _CategoryBottomSheetContent(
//           category:
//               category ??
//               CategoryHiveModel(
//                 key: '',
//                 iconCode: 123,
//                 colorValue: 123,
//                 isIncome: false,
//               ),
//           flowType: flowType,
//           budgetModel: budgetmodel,
//           debtModel: debtModel,
//         ),
//       ),
//     );
//   }
// }

// class _CategoryBottomSheetContent extends StatelessWidget {
//   final CategoryHiveModel category;
//   final TransactionSource flowType;
//   final BudgetModel? budgetModel;
//   final DebtModel? debtModel;

//   const _CategoryBottomSheetContent({
//     required this.category,
//     required this.flowType,
//     this.budgetModel,
//     this.debtModel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CategoryBottomSheetBloc, CategoryBottomSheetState>(
//       builder: (context, state) {
//         final bloc = context.read<CategoryBottomSheetBloc>();

//         return Container(
//           // height: MediaQuery.of(context).size.height * 0.8,
//           padding: const EdgeInsets.all(16),
//           decoration: const BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Display
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10.0,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[900],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: flowType == TransactionSource.budget
//                       ? MainAxisAlignment.end
//                       : MainAxisAlignment.start,
//                   children: [
//                     if (flowType != TransactionSource.budget &&
//                         flowType != TransactionSource.normal &&
//                         debtModel == null) ...[
//                       // Debt Badge (Left side)
//                       GestureDetector(
//                         onTap: () {
//                           HapticFeedback.lightImpact();
//                           if (state.transactionType ==
//                               TransactionType.expense) {
//                             bloc.add(DebtToggled(DebtType.borrowed));
//                           } else {
//                             bloc.add(DebtToggled(DebtType.lent));
//                           }
//                         },
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: state.isDebt
//                                 ? (state.debtType == DebtType.borrowed
//                                       ? Colors.red.withValues(alpha: 0.2)
//                                       : Colors.green.withValues(alpha: 0.2))
//                                 : Colors.grey.withValues(alpha: 0.2),
//                             borderRadius: BorderRadius.circular(6),
//                             border: Border.all(
//                               color: state.isDebt
//                                   ? (state.debtType == DebtType.borrowed
//                                         ? Colors.red
//                                         : Colors.green)
//                                   : Colors.grey,
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             // mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 state.transactionType == TransactionType.expense
//                                     ? '💰'
//                                     : '💸',
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 state.transactionType == TransactionType.expense
//                                     ? 'Borrowed'
//                                     : 'Lent',
//                                 style: TextStyle(
//                                   color: state.isDebt
//                                       ? (state.debtType == DebtType.borrowed
//                                             ? Colors.red
//                                             : Colors.green)
//                                       : Colors.grey,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                     ],

//                     // Amount display
//                     Text(
//                       state.display,
//                       textAlign: flowType == TransactionSource.budget
//                           ? TextAlign.right
//                           : TextAlign.left,
//                       style: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // 2. Add payment method selector (before calculator buttons)
//               // Payment Method Selector
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     _PaymentMethodChip(
//                       icon: Icons.money,
//                       label: 'Cash',
//                       selected: state.paymentMethod == PaymentMethod.cash,
//                       onTap: () =>
//                           bloc.add(PaymentMethodChanged(PaymentMethod.cash)),
//                     ),
//                     _PaymentMethodChip(
//                       icon: Icons.credit_card,
//                       label: 'Card',
//                       selected: state.paymentMethod == PaymentMethod.card,
//                       onTap: () =>
//                           bloc.add(PaymentMethodChanged(PaymentMethod.card)),
//                     ),
//                     _PaymentMethodChip(
//                       icon: Icons.account_balance,
//                       label: 'Bank',
//                       selected: state.paymentMethod == PaymentMethod.bank,
//                       onTap: () =>
//                           bloc.add(PaymentMethodChanged(PaymentMethod.bank)),
//                     ),
//                     _PaymentMethodChip(
//                       icon: Icons.wallet,
//                       label: 'Wallet',
//                       selected: state.paymentMethod == PaymentMethod.wallet,
//                       onTap: () =>
//                           bloc.add(PaymentMethodChanged(PaymentMethod.wallet)),
//                     ),
//                   ],
//                 ),
//               ),

//               // Note field
//               TextField(
//                 controller: TextEditingController(text: state.note),
//                 onChanged: (val) => bloc.add(NoteChanged(note: val)),
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   hintText: 'Note: Enter a note...',
//                   hintStyle: TextStyle(color: Colors.white54),
//                   filled: true,
//                   fillColor: Colors.grey[850],
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.image, color: Colors.amber),
//                     onPressed: () => bloc.add(ImagePicked()),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),

//               // Expandable Debt Details Section
//               AnimatedSize(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 child: state.isDebt
//                     ? Container(
//                         margin: const EdgeInsets.only(top: 8),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[850],
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.amber, width: 1),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               state.debtType == DebtType.borrowed
//                                   ? '💰 Borrowed From'
//                                   : '💸 Lent To',
//                               style: const TextStyle(
//                                 color: Colors.amber,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),

//                             // Person Name Field
//                             TextField(
//                               controller: TextEditingController(
//                                 text: state.personName,
//                               ),
//                               onChanged: (val) =>
//                                   bloc.add(PersonNameChanged(name: val)),
//                               style: const TextStyle(color: Colors.white),
//                               decoration: InputDecoration(
//                                 hintText: 'Person name...',
//                                 hintStyle: const TextStyle(
//                                   color: Colors.white54,
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.grey[900],
//                                 prefixIcon: const Icon(
//                                   Icons.person,
//                                   color: Colors.amber,
//                                   size: 20,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 8,
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                   borderSide: BorderSide.none,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),

//                             // Expected Return Date
//                             GestureDetector(
//                               onTap: () =>
//                                   bloc.add(ExpectedReturnDatePressed(context)),
//                               child: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[900],
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.calendar_today,
//                                       color: Colors.amber,
//                                       size: 20,
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Text(
//                                         state.expectedReturnDate != null
//                                             ? 'Return by: ${DateFormat('dd MMM yyyy').format(state.expectedReturnDate!)}'
//                                             : 'Set expected return date',
//                                         style: TextStyle(
//                                           color:
//                                               state.expectedReturnDate != null
//                                               ? Colors.white
//                                               : Colors.white54,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ),
//                                     const Icon(
//                                       Icons.arrow_forward_ios,
//                                       color: Colors.white54,
//                                       size: 16,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : const SizedBox.shrink(),
//               ),
//               state.isDebt ? const SizedBox(height: 2) : SizedBox(height: 8),

//               // Calculator Buttons
//               Row(
//                 children: [
//                   ButtonComponent(
//                     onTap: () => bloc.add(NumberPressed(number: '7')),
//                     text: '7',
//                   ),
//                   ButtonComponent(
//                     onTap: () => bloc.add(NumberPressed(number: '8')),
//                     text: '8',
//                   ),
//                   ButtonComponent(
//                     onTap: () => bloc.add(NumberPressed(number: '9')),
//                     text: '9',
//                   ),
//                   ButtonComponent(
//                     onTap: () => bloc.add(DatePressed(context)),
//                     text: state.selectedDateTime == null
//                         ? 'Today'
//                         : DateFormat('d/M/yy').format(state.selectedDateTime),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   ButtonComponent(
//                     onTap: () => bloc.add(NumberPressed(number: '4')),
//                     text: '4',
//                   ),
//                   ButtonComponent(
//                     onTap: () => bloc.add(NumberPressed(number: '5')),
//                     text: '5',
//                   ),
//                   ButtonComponent(
//                     onTap: () => bloc.add(NumberPressed(number: '6')),
//                     text: '6',
//                   ),
//                   ButtonComponent(
//                     onTap: () => bloc.add(OperationPressed(operation: '+')),
//                     color: Colors.orange,
//                     text: '+',
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   ButtonComponent(
//                     onTap: () => bloc.add(NumberPressed(number: '1')),
//                     text: '1',
//                   ),
//                   ButtonComponent(
//                     onTap: () => bloc.add(NumberPressed(number: '2')),
//                     text: '2',
//                   ),
//                   ButtonComponent(
//                     onTap: () => bloc.add(NumberPressed(number: '3')),
//                     text: '3',
//                   ),
//                   ButtonComponent(
//                     color: Colors.orange,
//                     onTap: () => bloc.add(OperationPressed(operation: '-')),
//                     text: '-',
//                   ),
//                 ],
//               ),
//               // Wrap your widget with BlocListener to listen for changes in the transaction status
//               BlocListener<CategoryBottomSheetBloc, CategoryBottomSheetState>(
//                 listener: (context, state) {
//                   if (state.transactionStatus == TransactionStatus.success) {
//                     AnimatedSnackbar.showSuccess(
//                       context,
//                       'Transaction saved successfully!',
//                       // onDismissed: () => Navigator.pop(context),
//                     );
//                     if (debtModel == null) {
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                     }
//                     if (debtModel != null) {
//                       Navigator.pop(context);
//                       context.read<DebtRepaymentBloc>().add(
//                         LoadDebtPayments(debtModel: debtModel!),
//                       );
//                     }

//                     //  Reset status after showing success
//                     context.read<CategoryBottomSheetBloc>().add(
//                       ResetTransactionStatus(),
//                     );
//                     context.read<HomeBloc>().add(LoadHomeData());
//                   } else if (state.transactionStatus ==
//                       TransactionStatus.error) {
//                     AnimatedSnackbar.showError(
//                       context,
//                       state.errorMessage ?? 'Failed to save transaction',
//                     );
//                     //  Reset status after showing error
//                     context.read<CategoryBottomSheetBloc>().add(
//                       ResetTransactionStatus(),
//                     );
//                   }
//                 },
//                 child: Row(
//                   children: [
//                     ButtonComponent(
//                       onTap: () => bloc.add(NumberPressed(number: '.')),
//                       text: '.',
//                     ),
//                     ButtonComponent(
//                       onTap: () => bloc.add(NumberPressed(number: '0')),
//                       text: '0',
//                     ),
//                     ButtonComponent(
//                       color: Colors.red,
//                       onTap: () => bloc.add(ClearPressed()),
//                       text: '⌫',
//                     ),
//                     state.operation.isNotEmpty
//                         ? ButtonComponent(
//                             color: Colors.orange,
//                             onTap: () => bloc.add(EqualsPressed()),
//                             text: '=',
//                           )
//                         : state.display != '0' && state.currentNumber.isNotEmpty
//                         ? ButtonComponent(
//                             color: Colors.green,
//                             onTap: () {
//                               if (flowType == TransactionSource.budget) {
//                                 bloc.add(
//                                   SaveBudgetTransaction(
//                                     budgetId: budgetModel!.id,
//                                   ),
//                                 );
//                               } else if (flowType == TransactionSource.normal) {
//                                 bloc.add(SaveNormalTransaction());
//                               } else if (flowType == TransactionSource.debt &&
//                                   debtModel == null) {
//                                 bloc.add(SaveDebtTransaction());
//                               } else if (flowType == TransactionSource.debt) {
//                                 bloc.add(
//                                   SaveDebtPayment(debtModel: debtModel!),
//                                 );
//                               }
//                             },
//                             text: '✓',
//                           )
//                         : ButtonComponent(
//                             color: Colors.grey,
//                             onTap: () {
//                               // if (flowType == TransactionSource.budget) {
//                               //   print(
//                               //     context
//                               //         .read<CategoryBottomSheetBloc>()
//                               //         .state
//                               //         .display,
//                               //   );
//                               //   print(
//                               //     context
//                               //         .read<CategoryBottomSheetBloc>()
//                               //         .state
//                               //         .note,
//                               //   );
//                               //   print(
//                               //     context
//                               //         .read<CategoryBottomSheetBloc>()
//                               //         .state
//                               //         .paymentMethod
//                               //         .name,
//                               //   );
//                               //   print(
//                               //     context
//                               //         .read<CategoryBottomSheetBloc>()
//                               //         .state
//                               //         .selectedDateTime,
//                               //   );
//                               //   print(
//                               //     context
//                               //         .read<CategoryBottomSheetBloc>()
//                               //         .state
//                               //         .selectedImage,
//                               //   );
//                               //   print(
//                               //     context
//                               //         .read<CategoryBottomSheetBloc>()
//                               //         .state
//                               //         .category
//                               //         .key,
//                               //   );
//                               // }
//                             },
//                             text: '✓',
//                           ),
//                   ],
//                 ),
//               ),

//               // Row(
//               //   children: [
//               //     ButtonComponent(
//               //       onTap: () => bloc.add(NumberPressed(number: '.')),
//               //       text: '.',
//               //     ),
//               //     ButtonComponent(
//               //       onTap: () => bloc.add(NumberPressed(number: '0')),
//               //       text: '0',
//               //     ),
//               //     ButtonComponent(
//               //       color: Colors.red,
//               //       onTap: () => bloc.add(ClearPressed()),
//               //       text: '⌫',
//               //     ),
//               //     state.operation.isNotEmpty
//               //         ? ButtonComponent(
//               //             color: Colors.orange,
//               //             onTap: () => bloc.add(EqualsPressed()),
//               //             text: '=',
//               //           )
//               //         : state.display != '0' && state.currentNumber.isNotEmpty
//               //         ? ButtonComponent(
//               //             color: Colors.green,
//               //             onTap: () {
//               //               if (flowType == TransactionSource.budget) {
//               //                 print(
//               //                   context
//               //                       .read<CategoryBottomSheetBloc>()
//               //                       .state
//               //                       .display,
//               //                 );
//               //                 print(
//               //                   context
//               //                       .read<CategoryBottomSheetBloc>()
//               //                       .state
//               //                       .note,
//               //                 );
//               //                 print(
//               //                   context
//               //                       .read<CategoryBottomSheetBloc>()
//               //                       .state
//               //                       .paymentMethod
//               //                       .name,
//               //                 );
//               //                 print(
//               //                   context
//               //                       .read<CategoryBottomSheetBloc>()
//               //                       .state
//               //                       .selectedDateTime,
//               //                 );
//               //                 print(
//               //                   context
//               //                       .read<CategoryBottomSheetBloc>()
//               //                       .state
//               //                       .selectedImage,
//               //                 );
//               //                 print(
//               //                   context
//               //                       .read<CategoryBottomSheetBloc>()
//               //                       .state
//               //                       .category
//               //                       .key,
//               //                 );
//               //               }
//               //               // print(
//               //               //   context
//               //               //       .read<CategoryBottomSheetBloc>()
//               //               //       .state
//               //               //       .category
//               //               //       .key,
//               //               // );
//               //               // print(
//               //               //   context
//               //               //       .read<CategoryBottomSheetBloc>()
//               //               //       .state
//               //               //       .display,
//               //               // );
//               //               // print(
//               //               //   context
//               //               //       .read<CategoryBottomSheetBloc>()
//               //               //       .state
//               //               //       .note,
//               //               // );
//               //               // print(
//               //               //   context
//               //               //       .read<CategoryBottomSheetBloc>()
//               //               //       .state
//               //               //       .paymentMethod
//               //               //       .name,
//               //               // );
//               //               // print(
//               //               //   context
//               //               //       .read<CategoryBottomSheetBloc>()
//               //               //       .state
//               //               //       .selectedDateTime,
//               //               // );
//               //               // print(
//               //               //   context
//               //               //               .read<CategoryBottomSheetBloc>()
//               //               //               .state
//               //               //               .debtType !=
//               //               //           null
//               //               //       ? context
//               //               //             .read<CategoryBottomSheetBloc>()
//               //               //             .state
//               //               //             .debtType!
//               //               //             .name
//               //               //       : null,
//               //               // );
//               //               // print(
//               //               //   context
//               //               //       .read<CategoryBottomSheetBloc>()
//               //               //       .state
//               //               //       .personName,
//               //               // );
//               //               // print(
//               //               //   context
//               //               //       .read<CategoryBottomSheetBloc>()
//               //               //       .state
//               //               //       .personName,
//               //               // );
//               //               // print(
//               //               //   context
//               //               //       .read<CategoryBottomSheetBloc>()
//               //               //       .state
//               //               //       .selectedImage,
//               //               // );

//               //               // Submit transaction
//               //               // bloc.add(SubmitTransaction());
//               //               // Navigator.pop(context);
//               //             },
//               //             text: '✓',
//               //           )
//               //         : ButtonComponent(
//               //             color: Colors.grey,
//               //             onTap: () {},
//               //             text: '✓',
//               //           ),
//               //   ],
//               // ),
//               const SizedBox(height: 12),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // // // Debt / Lent Toggle
// // Row(
// //   children: [
// //     if (state.transactionType == TransactionType.expense)
// //       DebtToggleButton(
// //         type: DebtType.borrowed,
// //         label: "Borrowed",
// //         selectedType: state.debtType,
// //         onTap: () => bloc.add(DebtToggled(DebtType.borrowed)),
// //       ),

// //     if (state.transactionType == TransactionType.income)
// //       DebtToggleButton(
// //         type: DebtType.lent,
// //         label: "Lent",
// //         selectedType: state.debtType,
// //         onTap: () => bloc.add(DebtToggled(DebtType.lent)),
// //       ),
// //   ],
// // ),

// // Helper Widget
// class _PaymentMethodChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const _PaymentMethodChip({
//     required this.icon,
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: selected ? Colors.amber : Colors.grey[850],
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: selected ? Colors.amber : Colors.grey[700]!,
//             width: 1,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               size: 16,
//               color: selected ? Colors.black : Colors.white70,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: selected ? Colors.black : Colors.white70,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
