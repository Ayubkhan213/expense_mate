import 'package:expense_mate/core/extension/responsive_extension.dart';
import 'package:expense_mate/features/home/presentation/components/home_component/transcation_card.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {
  final List<dynamic> transactions; // Replace with List<TransactionModel>

  const TransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (transactions.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 8),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         'Recent Transactions',
        //         style: TextStyle(
        //           color: colorScheme.primary,
        //           fontSize: 16,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       TextButton(
        //         onPressed: () {
        //           // Navigate to all transactions
        //         },
        //         style: TextButton.styleFrom(
        //           foregroundColor: colorScheme.primary,
        //         ),
        //         child: Text(
        //           'View All →',
        //           style: TextStyle(
        //             color: colorScheme.primary,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        ...transactions.map((transaction) {
          return TransactionCard(transaction: transaction);
        }).toList(),
        200.h.sh,
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.2),
          ),
          SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start tracking your expenses',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
