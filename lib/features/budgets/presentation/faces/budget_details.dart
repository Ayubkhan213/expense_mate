import 'package:spendio/core/common/custom_snackbar.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/navigation/route_name.dart';
import 'package:spendio/core/services/budget_pdf_service.dart';
import 'package:spendio/core/utils/enum.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_detail/budget_detail_bloc.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_detail/budget_detail_event.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_detail/budget_detail_state.dart';
import 'package:spendio/features/budgets/presentation/components/budget_detail/budget_card_summary.dart';
import 'package:spendio/features/budgets/presentation/components/budget_detail/budget_transcation_card.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetDetailsFace extends StatefulWidget {
  final BudgetModel budget;

  const BudgetDetailsFace({super.key, required this.budget});

  @override
  State<BudgetDetailsFace> createState() => _BudgetDetailsFaceState();
}

class _BudgetDetailsFaceState extends State<BudgetDetailsFace>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<BudgetDetailsBloc>().add(
      LoadBudgetDetailsEvent(widget.budget.id),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ✅ Reload when screen resumes (after returning from edit/other screens)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _reload();
    }
  }

  void _reload() {
    if (mounted) {
      context.read<BudgetDetailsBloc>().add(
        RefreshBudgetDetailsEvent(widget.budget.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocConsumer<BudgetDetailsBloc, BudgetDetailsState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state.status == BudgetDetailsStatus.loading &&
              state.transactions.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          if (state.status == BudgetDetailsStatus.error) {
            return _buildErrorView(context, state);
          }

          return _buildContent(context, state);
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  void _handleStateChanges(BuildContext context, BudgetDetailsState state) {
    if (state.status == BudgetDetailsStatus.error &&
        state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: const Color(0xFFef4444),
        ),
      );
    }
  }

  Widget _buildContent(BuildContext context, BudgetDetailsState state) {
    final totalAmount = state.budget?.totalAmount ?? widget.budget.totalAmount;
    final totalSpent = state.totalSpent;
    final remainingAmount = state.remainingAmount;
    final progressPercentage = state.progressPercentage;

    // ✅ RefreshIndicator wraps the CustomScrollView
    return RefreshIndicator(
      onRefresh: () async {
        context.read<BudgetDetailsBloc>().add(
          RefreshBudgetDetailsEvent(widget.budget.id),
        );
        // Wait briefly for reload
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: Theme.of(context).colorScheme.primary,
      child: CustomScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // ✅ always scrollable for pull-to-refresh
        slivers: [
          _buildSliverAppBar(
            context,
            totalAmount,
            totalSpent,
            remainingAmount,
            progressPercentage,
            state,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          _buildTransactionsList(context, state),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    double totalAmount,
    double totalSpent,
    double remainingAmount,
    double progressPercentage,
    BudgetDetailsState state,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOverBudget = remainingAmount < 0;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 280,
      stretch: false,
      collapsedHeight: 64,
      elevation: 0,
      backgroundColor: colorScheme.primary,
      automaticallyImplyLeading: false,
      actions: const [], // ✅ nothing here at all
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
                  child: BudgetSummaryCard(
                    budgetName: state.budget?.name ?? t.budgets,
                    totalAmount: totalAmount,
                    totalSpent: totalSpent,
                    remainingAmount: remainingAmount,
                    progressPercentage: progressPercentage,
                    availableHeight: current,
                    // ✅ pass the share callback down into the card
                    onShare: () async {
                      try {
                        await BudgetPdfService.exportAndShare(
                          context: context,
                          budget: widget.budget,
                          transactions: state.transactions,
                        );
                      } catch (e) {
                        if (context.mounted) {
                          AnimatedSnackbar.showError(
                            context,
                            'Export failed: $e',
                          );
                        }
                      }
                    },
                    canShare: state.transactions.isNotEmpty,
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
                    state, // ✅ pass state for share button
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
    BudgetDetailsState state, // ✅ added
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;
    final collapsedHeight = 64.0 + topPad;
    final t = AppLocalizations.of(context)!;

    return SizedBox(
      height: collapsedHeight,
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.only(top: topPad),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${t.remaining}: ${CurrencyFormatter.format(remainingAmount.abs())}',
                    style: TextStyle(
                      fontSize: 15,
                      color: isOverBudget
                          ? const Color(0xFFef4444)
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progressPercentage.clamp(0.0, 1.0),
                        minHeight: 5,
                        backgroundColor: colorScheme.onSurface.withValues(
                          alpha: 0.2,
                        ),
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
            // ✅ Share — uses state directly, no BlocBuilder needed
            IconButton(
              icon: Icon(
                Icons.ios_share_rounded,
                color: state.transactions.isEmpty
                    ? Colors.white38
                    : Colors.white,
                size: 20,
              ),
              tooltip: 'Export PDF',
              onPressed: state.transactions.isEmpty
                  ? null
                  : () async {
                      try {
                        await BudgetPdfService.exportAndShare(
                          context: context,
                          budget: widget.budget,
                          transactions: state.transactions,
                        );
                      } catch (e) {
                        if (context.mounted) {
                          AnimatedSnackbar.showError(
                            context,
                            'Export failed: $e',
                          );
                        }
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(
    BuildContext context,
    BudgetDetailsState state,
  ) {
    final transactions = state.filteredTransactions;

    if (transactions.isEmpty) {
      return _buildEmptyTransactions(context);
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => BudgetTransactionCard(
            transaction: transactions[index],
            budget: widget.budget,
            onTap: () {},
          ),
          childCount: transactions.length,
        ),
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

  Widget _buildErrorView(BuildContext context, BudgetDetailsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Color(0xFFef4444)),
          const SizedBox(height: 16),
          Text(
            state.errorMessage ?? t.anErrorOccurred,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<BudgetDetailsBloc>().add(
              LoadBudgetDetailsEvent(widget.budget.id),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    return SafeArea(
      child: FloatingActionButton.extended(
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
          ).then((_) {
            // ✅ Always reload when returning from add transaction screen
            if (mounted) {
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
      ),
    );
  }

}
