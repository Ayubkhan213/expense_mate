import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/core/extension/responsive_extension.dart';
import 'package:spendio/core/navigation/route_name.dart';

import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/features/home/presentation/components/home_component/financial_summary_card.dart';
import 'package:spendio/features/home/presentation/components/home_component/home_tabbar.dart';
import 'package:spendio/features/home/presentation/faces/debt_list.dart';
import 'package:spendio/features/home/presentation/faces/transcation_list.dart';
import 'package:spendio/l10n/app_localizations.dart';

import '../bloc/home_bloc/home_bloc.dart';
import '../bloc/home_bloc/home_state.dart';
import '../bloc/home_bloc/home_event.dart';

class HomeFace extends StatelessWidget {
  const HomeFace({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.isLoading &&
            state.transactions.isEmpty &&
            state.debts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }

        if (state.error != null) {
          return Center(
            child: Text(
              //  Was: 'Error: ${state.error}'
              '${t.errorPrefix}: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(RefreshHomeData());
          },
          color: Colors.amber,
          backgroundColor: Colors.grey[900],
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildBalanceSliver(state, context, t),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              _buildStickyTabBar(state, context, t),
              _buildContent(state),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildBalanceSliver(
    HomeState state,
    BuildContext context,
    AppLocalizations t,
  ) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 320,
      elevation: 4,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final shrinkOffset = 320 - constraints.maxHeight;
          final collapsed = shrinkOffset > 100;

          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(),
            title: collapsed
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        //  Was: 'Balance: \$${state.totalBalance.toStringAsFixed(2)}'
                        '${t.balancePrefix}: ${CurrencyFormatter.format(state.totalBalance)}',
                        style: AppTextStyles.currencyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ).paddingOnly(top: 26.0),
                  )
                : null,
            background: FinancialSummaryCard(
              totalBalance: state.totalBalance,
              totalIncome: state.totalIncome,
              totalExpense: state.totalExpense,
              totalDebtOwed: state.totalDebtOwed,
              totalDebtLent: state.totalDebtLent,
            ),
          );
        },
      ),
    );
  }

  SliverPersistentHeader _buildStickyTabBar(
    HomeState state,
    BuildContext context,
    AppLocalizations t,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: _HomeTabBarDelegate(
        Column(
          children: [
            HomeTabBar(
              selectedTab: state.selectedTab,
              onTabChanged: (tab) {
                context.read<HomeBloc>().add(TabChanged(tab));
              },
            ),
            state.selectedTab == HomeTab.transactions
                ? Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          //  Was: 'Recent Transactions'
                          t.recentTransactions,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteName.allTranscation,
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                          ),
                          child: Text(
                            //  Was: 'View All →'
                            t.viewAll,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          //  Was: 'Active Debts'
                          t.activeDebts,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteName.allDebtTranscation,
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                          ),
                          child: Text(
                            //  Was: 'View All →'
                            t.viewAll,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildContent(HomeState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: state.selectedTab == HomeTab.transactions
            ? TransactionsList(transactions: state.transactions)
            : DebtsList(debts: state.debts),
      ),
    );
  }
}

class _HomeTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _HomeTabBarDelegate(this.child);

  @override
  double get minExtent => 102.0;

  @override
  double get maxExtent => 102.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: overlapsContent ? 2 : 0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
