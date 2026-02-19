// import 'package:expense_mate/features/home/presentation/components/home_component/financial_summary_card.dart';
// import 'package:expense_mate/features/home/presentation/components/home_component/home_tabbar.dart';
// import 'package:expense_mate/features/home/presentation/faces/debt_list.dart';
// import 'package:expense_mate/features/home/presentation/faces/transcation_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/home_bloc/home_bloc.dart';
// import '../bloc/home_bloc/home_state.dart';
// import '../bloc/home_bloc/home_event.dart';

// class HomeFace extends StatelessWidget {
//   const HomeFace({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         if (state.isLoading) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.amber),
//           );
//         }

//         if (state.error != null) {
//           return Center(
//             child: Text(
//               'Error: ${state.error}',
//               style: const TextStyle(color: Colors.red),
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: () async {
//             context.read<HomeBloc>().add(RefreshHomeData());
//           },
//           color: Colors.amber,
//           backgroundColor: Colors.grey[900],
//           child: CustomScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             slivers: [
//               _buildBalanceSliver(state),
//               _buildStickyTabBar(state, context),
//               _buildContent(state),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   SliverAppBar _buildBalanceSliver(HomeState state) {
//     return SliverAppBar(
//       pinned: true,
//       expandedHeight: 340,
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       backgroundColor: Colors.white,
//       flexibleSpace: LayoutBuilder(
//         builder: (context, constraints) {
//           final shrinkOffset = 320 - constraints.maxHeight;
//           final collapsed = shrinkOffset > 200;

//           return FlexibleSpaceBar(
//             titlePadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 8,
//             ),
//             title: collapsed
//                 ? Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Balance: \$${state.totalBalance.toStringAsFixed(2)}',
//                       style: const TextStyle(fontSize: 18, color: Colors.black),
//                     ),
//                   )
//                 : null,
//             background: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 4.0,
//                 vertical: 12.0,
//               ),
//               child: FinancialSummaryCard(
//                 totalBalance: state.totalBalance,
//                 totalIncome: state.totalIncome,
//                 totalExpense: state.totalExpense,
//                 totalDebtOwed: state.totalDebtOwed,
//                 totalDebtLent: state.totalDebtLent,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   SliverPersistentHeader _buildStickyTabBar(
//     HomeState state,
//     BuildContext context,
//   ) {
//     return SliverPersistentHeader(
//       pinned: true,
//       delegate: _HomeTabBarDelegate(
//         Column(
//           children: [
//             HomeTabBar(
//               selectedTab: state.selectedTab,
//               onTabChanged: (tab) {
//                 context.read<HomeBloc>().add(TabChanged(tab));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   SliverToBoxAdapter _buildContent(HomeState state) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: state.selectedTab == HomeTab.transactions
//             ? TransactionsList(transactions: state.transactions)
//             : DebtsList(debts: state.debts),
//       ),
//     );
//   }
// }

// class _HomeTabBarDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;

//   _HomeTabBarDelegate(this.child);

//   @override
//   double get minExtent => kToolbarHeight;

//   @override
//   double get maxExtent => kToolbarHeight;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Material(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       elevation: overlapsContent ? 2 : 0,
//       child: SizedBox(height: kToolbarHeight, child: child),
//     );
//   }

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }
import 'package:expense_mate/core/extension/responsive_extension.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/features/home/presentation/components/home_component/financial_summary_card.dart';
import 'package:expense_mate/features/home/presentation/components/home_component/home_tabbar.dart';
import 'package:expense_mate/features/home/presentation/faces/debt_list.dart';
import 'package:expense_mate/features/home/presentation/faces/transcation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc/home_bloc.dart';
import '../bloc/home_bloc/home_state.dart';
import '../bloc/home_bloc/home_event.dart';

class HomeFace extends StatelessWidget {
  const HomeFace({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }

        if (state.error != null) {
          return Center(
            child: Text(
              'Error: ${state.error}',
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
              _buildBalanceSliver(state, context),
              SliverToBoxAdapter(child: SizedBox(height: 12)),
              _buildStickyTabBar(state, context),
              _buildContent(state),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildBalanceSliver(HomeState state, BuildContext context) {
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
            titlePadding: const EdgeInsets.symmetric(
              // horizontal: 16,
              // vertical: 8,
            ),
            title: collapsed
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Balance: \$${state.totalBalance.toStringAsFixed(2)}',
                        style: AppTextStyles.currencyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ).paddingOnly(top: 26.0),
                  )
                : null,
            // NO horizontal padding — card fills full width
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
                    padding: EdgeInsets.only(left: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to all transactions
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                          ),
                          child: Text(
                            'View All →',
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
                    padding: EdgeInsets.only(left: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Active Debts',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                          ),
                          child: Text(
                            'View All →',
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
  double get minExtent => 102.0; // ← fix

  @override
  double get maxExtent => 102.0; // ← fix

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: overlapsContent ? 2 : 0,
      child: child, // ← removed SizedBox wrapper
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
