import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/extension/responsive_extension.dart';
import 'package:expense_mate/core/utils/enum.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_bloc.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_event.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_state.dart';
import 'package:expense_mate/features/home/presentation/components/debt_repayment/debt_summary_card.dart';
import 'package:expense_mate/features/home/presentation/components/debt_repayment/empty_payments_view.dart';
import 'package:expense_mate/features/home/presentation/components/debt_repayment/payment_list_item.dart';
import 'package:expense_mate/features/transcation/presentation/faces/category_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

class DebtTransactionRepayFace extends StatefulWidget {
  final DebtModel debtModel; // Replace with DebtModel

  const DebtTransactionRepayFace({super.key, required this.debtModel});

  @override
  State<DebtTransactionRepayFace> createState() =>
      _DebtTransactionRepayFaceState();
}

class _DebtTransactionRepayFaceState extends State<DebtTransactionRepayFace> {
  @override
  void initState() {
    super.initState();
    context.read<DebtRepaymentBloc>().add(
      LoadDebtPayments(debtModel: widget.debtModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocBuilder<DebtRepaymentBloc, DebtRepaymentState>(
        builder: (context, state) {
          if (state is DebtRepaymentLoading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          if (state is DebtRepaymentError) {
            return _buildErrorView(context, state.message);
          }

          if (state is DebtRepaymentLoaded) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final totalAmount = widget.debtModel.totalAmount ?? 0.0;
    final paidAmount = state.totalPaid ?? 0.0;
    final remainingAmount = state.remainingAmount ?? 0.0;
    final progress = totalAmount > 0 ? (paidAmount / totalAmount) : 0.0;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: Icon(Icons.arrow_back, color: Colors.black).tap(() {
            Navigator.pop(context);
          }),
          pinned: true,
          expandedHeight: 380,
          elevation: 0,
          backgroundColor: colorScheme.background,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final shrinkOffset = 380 - constraints.maxHeight;
              final collapsed = shrinkOffset > 200;

              return FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: collapsed
                    ? _buildCollapsedTitle(
                        context,
                        remainingAmount,
                        progress,
                        colorScheme,
                      )
                    : null,
                background: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: DebtSummaryCard(
                    debtName: widget.debtModel.debtType?.name ?? 'Debt',
                    totalAmount: totalAmount,
                    paidAmount: paidAmount,
                    remainingAmount: remainingAmount,
                  ),
                ),
              );
            },
          ),
        ),
        _buildPaymentHistoryHeader(context, state),
        _buildPaymentsList(context, state),
      ],
    );
  }

  Widget _buildCollapsedTitle(
    BuildContext context,
    double remainingAmount,
    double progress,
    ColorScheme colorScheme,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remaining: \$${_formatAmount(remainingAmount)}',
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ).alignCenter(),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: colorScheme.onSurface.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10b981)),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentHistoryHeader(BuildContext context, dynamic state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(
              'Payment History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                '${state.payments?.length ?? 0} payments',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentsList(BuildContext context, dynamic state) {
    final payments = state.payments ?? [];

    if (payments.isEmpty) {
      return const SliverFillRemaining(child: EmptyPaymentsView());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final payment = payments[index];
        return PaymentListItem(
          payment: payment,
          onDelete: () {
            // context.read<DebtRepaymentBloc>().add(
            //   DeleteDebtPayment(payment.id),
            // );
          },
        );
      }, childCount: payments.length),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return BlocBuilder<DebtRepaymentBloc, DebtRepaymentState>(
      builder: (context, state) {
        final canAddPayment =
            state is DebtRepaymentLoaded && (state.remainingAmount ?? 0) > 0;

        return FloatingActionButton.extended(
          onPressed: canAddPayment
              ? () {
                  CategoryBottomSheet.show(
                    context,
                    null,
                    TransactionSource.debt,
                    null,
                    widget.debtModel,
                  );
                }
              : null,
          icon: const Icon(Icons.add),
          label: const Text('Add Payment'),
          backgroundColor: canAddPayment
              ? null
              : Theme.of(context).disabledColor,
        );
      },
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return NumberFormat('#,##0').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }
}
