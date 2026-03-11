import 'package:expense_mate/core/data/models/debt_model.dart';

import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/core/utils/enum.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_bloc.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_event.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_state.dart';
import 'package:expense_mate/features/home/presentation/components/debt_repayment/empty_payments_view.dart';
import 'package:expense_mate/features/home/presentation/components/debt_repayment/payment_list_item.dart';
import 'package:expense_mate/features/transcation/presentation/faces/category_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DebtTransactionRepayFace extends StatefulWidget {
  final DebtModel debtModel;

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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.colorScheme.background
          : const Color(0xFFF2F4F8),
      body: BlocBuilder<DebtRepaymentBloc, DebtRepaymentState>(
        builder: (context, state) {
          if (state is DebtRepaymentLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 2.5,
              ),
            );
          }
          if (state is DebtRepaymentError) {
            return _ErrorView(message: state.message);
          }
          if (state is DebtRepaymentLoaded) {
            return _buildContent(context, state, isDark);
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DebtRepaymentLoaded state,
    bool isDark,
  ) {
    final totalAmount = widget.debtModel.totalAmount ?? 0.0;
    final paidAmount = state.totalPaid ?? 0.0;
    final remainingAmount = state.remainingAmount ?? 0.0;
    final progress = totalAmount > 0
        ? (paidAmount / totalAmount).clamp(0.0, 1.0)
        : 0.0;
    final isPaidOff = remainingAmount <= 0;

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        // ── Hero SliverAppBar ──
        _DebtSliverAppBar(
          debtModel: widget.debtModel,
          totalAmount: totalAmount,
          paidAmount: paidAmount,
          remainingAmount: remainingAmount,
          progress: progress,
          isPaidOff: isPaidOff,
          isDark: isDark,
        ),

        // ── Payment History Header ──
        SliverPersistentHeader(
          pinned: true,
          delegate: _PaymentHistoryHeaderDelegate(
            paymentCount: state.payments?.length ?? 0,
            isDark: isDark,
          ),
        ),
        // ── Payments List ──
        _buildPaymentsList(context, state),

        const SliverToBoxAdapter(child: SizedBox(height: 510)),
      ],
    );
  }

  Widget _buildPaymentsList(BuildContext context, DebtRepaymentLoaded state) {
    final payments = state.payments ?? [];

    if (payments.isEmpty) {
      return const SliverFillRemaining(child: EmptyPaymentsView());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) =>
              PaymentListItem(payment: payments[index], onDelete: () {}),
          childCount: payments.length,
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return BlocBuilder<DebtRepaymentBloc, DebtRepaymentState>(
      builder: (context, state) {
        final canAdd =
            state is DebtRepaymentLoaded && (state.remainingAmount ?? 0) > 0;
        final primary = Theme.of(context).colorScheme.primary;

        return GestureDetector(
          onTap: canAdd
              ? () => CategoryBottomSheet.show(
                  context,
                  null,
                  TransactionSource.debt,
                  null,
                  widget.debtModel,
                )
              : null,
          child: AnimatedOpacity(
            opacity: canAdd ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 220),
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(27),
                boxShadow: canAdd
                    ? [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.38),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Add Payment',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PaymentHistoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int paymentCount;
  final bool isDark;

  _PaymentHistoryHeaderDelegate({
    required this.paymentCount,
    required this.isDark,
  });

  static const double _height = 52.0;

  @override
  double get minExtent => _height;
  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: isDark ? theme.colorScheme.background : const Color(0xFFF2F4F8),
      elevation: overlapsContent ? 3 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: SizedBox(
        height: _height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              Text(
                'Payment History',
                style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '$paymentCount payments',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_PaymentHistoryHeaderDelegate old) =>
      old.paymentCount != paymentCount || old.isDark != isDark;
}

// ─────────────────────────────────────────
// Hero SliverAppBar
// ─────────────────────────────────────────
class _DebtSliverAppBar extends StatelessWidget {
  final DebtModel debtModel;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final double progress;
  final bool isPaidOff;
  final bool isDark;

  const _DebtSliverAppBar({
    required this.debtModel,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.progress,
    required this.isPaidOff,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final topPad = MediaQuery.of(context).padding.top;
    final collapsedHeight = 64.0 + topPad;
    const expandedHeight = 310.0;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: 64,
      pinned: true,
      stretch: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final current = constraints.maxHeight;
          final scrollProgress =
              ((expandedHeight - current) / (expandedHeight - collapsedHeight))
                  .clamp(0.0, 1.0);

          final expandedOpacity = (1.0 - scrollProgress).clamp(0.0, 1.0);
          final collapsedOpacity = ((scrollProgress - 0.20) / 0.30).clamp(
            0.0,
            1.0,
          );

          return ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (expandedOpacity > 0)
                  Opacity(
                    opacity: expandedOpacity,
                    child: _ExpandedHeader(
                      debtModel: debtModel,
                      totalAmount: totalAmount,
                      paidAmount: paidAmount,
                      remainingAmount: remainingAmount,
                      progress: progress,
                      isPaidOff: isPaidOff,
                      primary: primary,
                      topPad: topPad,
                      availableHeight: current,
                    ),
                  ),
                if (collapsedOpacity > 0)
                  Opacity(
                    opacity: collapsedOpacity,
                    child: _CollapsedHeader(
                      primary: primary,
                      topPad: topPad,
                      debtModel: debtModel,
                      remainingAmount: remainingAmount,
                      progress: progress,
                      isPaidOff: isPaidOff,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Expanded header ──
class _ExpandedHeader extends StatelessWidget {
  final DebtModel debtModel;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final double progress;
  final bool isPaidOff;
  final Color primary;
  final double topPad;
  final double availableHeight;

  const _ExpandedHeader({
    required this.debtModel,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.progress,
    required this.isPaidOff,
    required this.primary,
    required this.topPad,
    required this.availableHeight,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isPaidOff
        ? const Color(0xFF10b981)
        : progress > 0.8
        ? const Color(0xFFf59e0b)
        : const Color(0xFF10b981);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primary.withValues(alpha: 0.85)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        height: availableHeight,
        child: OverflowBox(
          maxHeight: double.infinity,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: topPad),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: [
                      _IconBtn(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ── Debt name + type ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              debtModel.debtType?.name ?? 'Debt',
                              style: AppTextStyles.h2.copyWith(
                                color: Colors.white,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isPaidOff
                                  ? 'Fully paid off 🎉'
                                  : '${(progress * 100).toStringAsFixed(0)}% repaid',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isPaidOff ? 'Cleared' : 'Active',
                              style: AppTextStyles.overline.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ── Summary card ──
                _DebtSummaryInline(
                  totalAmount: totalAmount,
                  paidAmount: paidAmount,
                  remainingAmount: remainingAmount,
                  progress: progress,
                  isPaidOff: isPaidOff,
                  accentColor: accentColor,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Collapsed header ──
class _CollapsedHeader extends StatelessWidget {
  final Color primary;
  final double topPad;
  final DebtModel debtModel;
  final double remainingAmount;
  final double progress;
  final bool isPaidOff;

  const _CollapsedHeader({
    required this.primary,
    required this.topPad,
    required this.debtModel,
    required this.remainingAmount,
    required this.progress,
    required this.isPaidOff,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isPaidOff
        ? const Color(0xFF10b981)
        : progress > 0.8
        ? const Color(0xFFf59e0b)
        : const Color(0xFF10b981);

    return Container(
      color: primary,
      padding: EdgeInsets.only(top: topPad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 4),
          _IconBtn(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  debtModel.debtType?.name ?? 'Debt',
                  style: AppTextStyles.h5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  isPaidOff
                      ? 'Fully paid off'
                      : 'Remaining: \$${_fmt(remainingAmount)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Mini progress bar
          SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  String _fmt(double amount) {
    if (amount >= 1000) return NumberFormat('#,##0').format(amount);
    return NumberFormat('#,##0.00').format(amount);
  }
}

// ── Inline summary card ──
class _DebtSummaryInline extends StatelessWidget {
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final double progress;
  final bool isPaidOff;
  final Color accentColor;

  const _DebtSummaryInline({
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.progress,
    required this.isPaidOff,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: remaining + % label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remaining',
                    style: AppTextStyles.captionSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${_fmt(remainingAmount.abs())}',
                    style: AppTextStyles.currencyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'of \$${_fmt(totalAmount)}',
                    style: AppTextStyles.captionSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPaidOff
                          ? 'Paid off!'
                          : '${(progress * 100).toStringAsFixed(0)}% repaid',
                      style: AppTextStyles.overline.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),

          const SizedBox(height: 14),

          // Pills
          Row(
            children: [
              _Pill(
                label: 'Paid',
                value: '\$${_fmt(paidAmount)}',
                icon: Icons.check_circle_outline_rounded,
              ),
              const SizedBox(width: 10),
              _Pill(
                label: 'Total Debt',
                value: '\$${_fmt(totalAmount)}',
                icon: Icons.account_balance_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double amount) {
    if (amount >= 1000) return NumberFormat('#,##0').format(amount);
    return NumberFormat('#,##0.00').format(amount);
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _Pill({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white.withValues(alpha: 0.75)),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.overline.copyWith(
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
              Text(
                value,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 60,
            color: Colors.red.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
