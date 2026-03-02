import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/extension/responsive_extension.dart';
import 'package:expense_mate/core/navigation/route_name.dart';
import 'package:expense_mate/core/utils/enum.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail/budget_detail_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail/budget_detail_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail/budget_detail_state.dart';
import 'package:expense_mate/features/budgets/presentation/components/budget_detail/budget_card_summary.dart';
import 'package:expense_mate/features/budgets/presentation/components/budget_detail/budget_transcation_card.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetDetailsFace extends StatefulWidget {
  final BudgetModel budget; // Replace with BudgetModel

  const BudgetDetailsFace({super.key, required this.budget});

  @override
  State<BudgetDetailsFace> createState() => _BudgetDetailsFaceState();
}

class _BudgetDetailsFaceState extends State<BudgetDetailsFace> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetDetailsBloc>().add(
      LoadBudgetDetailsEvent(widget.budget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocConsumer<BudgetDetailsBloc, BudgetDetailsState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state.status.toString().contains('loading')) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          if (state.status.toString().contains('error')) {
            return _buildErrorView(context, state);
          }

          return _buildContent(context, state);
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  void _handleStateChanges(BuildContext context, dynamic state) {
    if (state.status.toString().contains('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'An error occurred'),
          backgroundColor: const Color(0xFFef4444),
        ),
      );
    }
  }

  Widget _buildContent(BuildContext context, dynamic state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalAmount = widget.budget.totalAmount ?? 0.0;
    final totalSpent = state.totalSpent ?? 0.0;
    final remainingAmount = state.remainingAmount ?? 0.0;
    final progressPercentage = state.progressPercentage ?? 0.0;

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(
          context,
          totalAmount,
          totalSpent,
          remainingAmount,
          progressPercentage,
        ),
        // _buildTransactionFilters(context, state),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        _buildTransactionsList(context, state),
      ],
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    double totalAmount,
    double totalSpent,
    double remainingAmount,
    double progressPercentage,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOverBudget = remainingAmount < 0;

    return SliverAppBar(
      // leading: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor)
      //     .tap(() {
      //       Navigator.pop(context);
      //     }),
      pinned: true,
      expandedHeight: 280,
      stretch: false,
      collapsedHeight: 64,
      elevation: 0,
      //  automaticallyImplyLeading: false,
      backgroundColor: colorScheme.background,

      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.refresh),
      //     onPressed: () {
      //       context.read<BudgetDetailsBloc>().add(
      //         RefreshBudgetDetailsEvent(widget.budget.id),
      //       );
      //     },
      //   ),
      //   IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      // ],
      // REPLACE the entire LayoutBuilder content:
      // In _buildSliverAppBar, wrap the entire LayoutBuilder return:
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final t = AppLocalizations.of(context)!;
          final current = constraints.maxHeight;
          final topPad = MediaQuery.of(context).padding.top;
          final collapsedHeight = 64.0 + topPad;
          final progress =
              ((260 - constraints.maxHeight) / (260 - collapsedHeight)).clamp(
                0.0,
                1.0,
              );

          final expandedOpacity = (1.0 - progress).clamp(0.0, 1.0);
          final collapsedOpacity = ((progress - 0.20) / 0.30).clamp(0.0, 1.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              if (expandedOpacity > 0)
                Opacity(
                  opacity: expandedOpacity,
                  child: BlocBuilder<BudgetDetailsBloc, BudgetDetailsState>(
                    builder: (context, state) {
                      return BudgetSummaryCard(
                        budgetName: state.budget?.name ?? t.budgets,
                        totalAmount:
                            state.budget?.totalAmount.toDouble() ?? 0.0,
                        totalSpent: state.budget?.spentAmount.toDouble() ?? 0.0,
                        remainingAmount:
                            (state.budget?.totalAmount.toDouble() ?? 0.0) -
                            (state.budget?.spentAmount.toDouble() ?? 0.0),
                        progressPercentage:
                            state.budget?.spentPercentage ?? 0.0,
                        availableHeight: current,
                      );
                    },
                  ),
                ),
              if (collapsedOpacity > 0)
                Opacity(
                  opacity: collapsedOpacity,
                  child: _buildCollapsedTitle(
                    context,
                    remainingAmount,
                    progressPercentage,
                    isOverBudget,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCollapsedTitle(
    BuildContext context,
    double remainingAmount,
    double progressPercentage,
    bool isOverBudget,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;
    final collapsedHeight = 64.0 + topPad; // ← exact collapsed bar height
    final t = AppLocalizations.of(context)!;
    return SizedBox(
      // ← constrain to collapsed height
      height: collapsedHeight,
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.only(top: topPad),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${t.remaining}: \$${_formatAmount(remainingAmount.abs())}',
              style: TextStyle(
                fontSize: 16,
                color: isOverBudget ? const Color(0xFFef4444) : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressPercentage.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: colorScheme.onSurface.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOverBudget
                        ? const Color(0xFFef4444)
                        : progressPercentage > 0.8
                        ? const Color(0xFFf59e0b)
                        : const Color(0xFF10b981),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Widget _buildTransactionFilters(BuildContext context, dynamic state) {
  //   return SliverToBoxAdapter(
  //     child: BudgetFilterChips(
  //       selectedFilter:
  //           state.selectedFilter?.toString().split('.').last ?? 'all',
  //       onFilterChanged: (filter) {
  //         // Convert string back to enum
  //         TransactionFilter? selectedFilter;
  //         switch (filter) {
  //           case 'all':
  //             selectedFilter = TransactionFilter.all;
  //             break;
  //           case 'thisWeek':
  //             selectedFilter = TransactionFilter.thisWeek;
  //             break;
  //           case 'thisMonth':
  //             selectedFilter = TransactionFilter.thisMonth;
  //             break;
  //           case 'custom':
  //             selectedFilter = TransactionFilter.custom;
  //             break;
  //         }

  //         if (selectedFilter != null) {
  //           context.read<BudgetDetailsBloc>().add(
  //             FilterBudgetTransactionsEvent(selectedFilter),
  //           );
  //         }
  //       },
  //       filterCounts: {
  //         'all': state.filteredTransactions?.length ?? 0,
  //         'thisWeek': 0,
  //         'thisMonth': 0,
  //         'custom': 0,
  //       },
  //     ),
  //   );
  // }

  Widget _buildTransactionsList(BuildContext context, dynamic state) {
    final transactions = state.filteredTransactions ?? [];

    if (transactions.isEmpty) {
      return _buildEmptyTransactions(context);
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return BudgetTransactionCard(
            transaction: transactions[index],
            onTap: () {
              // Navigate to transaction details
            },
          );
        }, childCount: transactions.length),
      ),
    );
  }

  Widget _buildEmptyTransactions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = AppLocalizations.of(context)!;
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: colorScheme.primary.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                t.noTransactionsYet,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.tapToAddTransaction,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, dynamic state) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: const Color(0xFFef4444)),
          const SizedBox(height: 16),
          Text(
            state.errorMessage ?? t.anErrorOccurred,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<BudgetDetailsBloc>().add(
                LoadBudgetDetailsEvent(widget.budget.id),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    return FloatingActionButton.extended(
      elevation: 4,
      backgroundColor: colorScheme.primary,
      onPressed: () {
        Navigator.pushNamed(
          context,
          RouteName.addRecord,
          arguments: {
            'flowType': TransactionSource.budget,
            'budget': widget.budget,
          },
        ).then((value) {
          if (value == true) {
            context.read<BudgetDetailsBloc>().add(
              RefreshBudgetDetailsEvent(widget.budget.id),
            );
          }
        });
      },
      icon: Icon(Icons.add, color: colorScheme.onPrimary),
      label: Text(
        t.addTransaction,
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return amount
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return amount.toStringAsFixed(2);
  }
}









// import 'package:expense_mate/core/app_export.dart';
// import 'package:expense_mate/core/data/models/budget_model.dart';
// import 'package:expense_mate/core/data/models/enums.dart';
// import 'package:expense_mate/core/data/models/transaction_model.dart';
// import 'package:expense_mate/core/utils/enum.dart';

// import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail_bloc.dart';
// import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail_event.dart';
// import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail_state.dart';

// import 'package:intl/intl.dart';

// class BudgetDetailsFace extends StatefulWidget {
//   final BudgetModel budget;

//   const BudgetDetailsFace({super.key, required this.budget});

//   @override
//   State<BudgetDetailsFace> createState() => _BudgetDetailsFaceState();
// }

// class _BudgetDetailsFaceState extends State<BudgetDetailsFace> {
//   @override
//   void initState() {
//     super.initState();
//     // Load budget details when screen opens
//     context.read<BudgetDetailsBloc>().add(
//       LoadBudgetDetailsEvent(widget.budget.id),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text(widget.budget.name),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               context.read<BudgetDetailsBloc>().add(
//                 RefreshBudgetDetailsEvent(widget.budget.id),
//               );
//             },
//           ),
//           IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
//         ],
//       ),
//       body: BlocConsumer<BudgetDetailsBloc, BudgetDetailsState>(
//         listener: (context, state) {
//           if (state.status == BudgetDetailsStatus.error) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.errorMessage ?? 'An error occurred'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state.status == BudgetDetailsStatus.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state.status == BudgetDetailsStatus.error) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(state.errorMessage ?? 'An error occurred'),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<BudgetDetailsBloc>().add(
//                         LoadBudgetDetailsEvent(widget.budget.id),
//                       );
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return CustomScrollView(
//             slivers: [
//               // Budget Summary Card
//               SliverToBoxAdapter(
//                 child: Container(
//                   margin: const EdgeInsets.all(16),
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Theme.of(context).primaryColor,
//                         Theme.of(context).primaryColor.withValues(alpha: 0.7),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Theme.of(
//                           context,
//                         ).primaryColor.withValues(alpha: 0.3),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Total Budget',
//                         style: TextStyle(color: Colors.white70, fontSize: 14),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Rs ${widget.budget.totalAmount.toStringAsFixed(0)}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: LinearProgressIndicator(
//                           value: state.progressPercentage,
//                           backgroundColor: Colors.white24,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             state.progressPercentage > 0.9
//                                 ? Colors.red
//                                 : Colors.white,
//                           ),
//                           minHeight: 8,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Spent',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'Rs ${state.totalSpent.toStringAsFixed(0)}',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               const Text(
//                                 'Remaining',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'Rs ${state.remainingAmount.toStringAsFixed(0)}',
//                                 style: TextStyle(
//                                   color: state.remainingAmount < 0
//                                       ? Colors.red.shade200
//                                       : Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Filter Chips
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         _FilterChip(
//                           label: 'All',
//                           isSelected:
//                               state.selectedFilter == TransactionFilter.all,
//                           onTap: () {
//                             context.read<BudgetDetailsBloc>().add(
//                               const FilterBudgetTransactionsEvent(
//                                 TransactionFilter.all,
//                               ),
//                             );
//                           },
//                         ),
//                         _FilterChip(
//                           label: 'This Week',
//                           isSelected:
//                               state.selectedFilter ==
//                               TransactionFilter.thisWeek,
//                           onTap: () {
//                             context.read<BudgetDetailsBloc>().add(
//                               const FilterBudgetTransactionsEvent(
//                                 TransactionFilter.thisWeek,
//                               ),
//                             );
//                           },
//                         ),
//                         _FilterChip(
//                           label: 'This Month',
//                           isSelected:
//                               state.selectedFilter ==
//                               TransactionFilter.thisMonth,
//                           onTap: () {
//                             context.read<BudgetDetailsBloc>().add(
//                               const FilterBudgetTransactionsEvent(
//                                 TransactionFilter.thisMonth,
//                               ),
//                             );
//                           },
//                         ),
//                         _FilterChip(
//                           label: 'Custom',
//                           isSelected:
//                               state.selectedFilter == TransactionFilter.custom,
//                           onTap: () {
//                             context.read<BudgetDetailsBloc>().add(
//                               const FilterBudgetTransactionsEvent(
//                                 TransactionFilter.custom,
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               const SliverToBoxAdapter(child: SizedBox(height: 16)),

//               // Transactions List
//               state.filteredTransactions.isEmpty
//                   ? SliverFillRemaining(
//                       child: Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.receipt_long_outlined,
//                               size: 64,
//                               color: Colors.grey[400],
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'No transactions yet',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.grey[600],
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Tap + to add your first transaction',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[500],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : SliverPadding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       sliver: SliverList(
//                         delegate: SliverChildBuilderDelegate((context, index) {
//                           final transaction = state.filteredTransactions[index];
//                           return _TransactionCard(transaction: transaction);
//                         }, childCount: state.filteredTransactions.length),
//                       ),
//                     ),

//               const SliverToBoxAdapter(child: SizedBox(height: 80)),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         elevation: 4,
//         backgroundColor: Theme.of(context).primaryColor,
//         onPressed: () {
//           Navigator.pushNamed(
//             context,
//             RouteName.addRecord,
//             arguments: {
//               'flowType': TransactionSource.budget,
//               'budget': widget.budget,
//             },
//           ).then((value) {
//             if (value == true) {
//               context.read<BudgetDetailsBloc>().add(
//                 RefreshBudgetDetailsEvent(widget.budget.id),
//               );
//             }
//           });
//         },
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: const Text(
//           'Add Transaction',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
// }

// class _FilterChip extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _FilterChip({
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(right: 8),
//       child: FilterChip(
//         label: Text(label),
//         selected: isSelected,
//         onSelected: (_) => onTap(),
//         backgroundColor: Colors.white,
//         selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
//         labelStyle: TextStyle(
//           color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
//           fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//         ),
//         side: BorderSide(
//           color: isSelected
//               ? Theme.of(context).primaryColor
//               : Colors.grey[300]!,
//         ),
//       ),
//     );
//   }
// }

// class _TransactionCard extends StatelessWidget {
//   final TransactionModel transaction;

//   const _TransactionCard({required this.transaction});

//   @override
//   Widget build(BuildContext context) {
//     // Get first item for display
//     final firstItem = transaction.items.isNotEmpty
//         ? transaction.items.first
//         : null;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () {
//             // Navigate to transaction detail
//           },

//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: _getIconColor().withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(_getIcon(), color: _getIconColor(), size: 24),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         firstItem?.category.toString() ?? 'Transaction',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),

//                       const SizedBox(height: 4),
//                       Text(
//                         '${transaction.paymentMethod.name} • ${DateFormat('MMM dd').format(transaction.date)}',
//                         style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       '${transaction.type == TransactionType.expense ? '-' : '+'} Rs ${transaction.totalAmount.toStringAsFixed(0)}',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: transaction.type == TransactionType.expense
//                             ? Colors.red
//                             : Colors.green,
//                       ),
//                     ),
//                     if (transaction.items.length > 1)
//                       Container(
//                         margin: const EdgeInsets.only(top: 4),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           '+${transaction.items.length - 1} more',
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getIcon() {
//     switch (transaction.paymentMethod) {
//       case PaymentMethod.cash:
//         return Icons.money;
//       case PaymentMethod.card:
//         return Icons.credit_card;
//       case PaymentMethod.bank:
//         return Icons.account_balance;
//       default:
//         return Icons.receipt;
//     }
//   }

//   Color _getIconColor() {
//     return transaction.type == TransactionType.expense
//         ? Colors.red
//         : Colors.green;
//   }
// }