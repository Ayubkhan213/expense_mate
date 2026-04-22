import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/app_export.dart';
import 'package:spendio/features/recurring/presentation/component/recurring_category/recurring_category_grid.dart';
import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_bloc.dart';
import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_event.dart';
import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_state.dart';
import 'package:spendio/l10n/app_localizations.dart';

class RecurringCategorySelector extends StatefulWidget {
  const RecurringCategorySelector({super.key});

  @override
  State<RecurringCategorySelector> createState() =>
      _RecurringCategorySelectorState();
}

class _RecurringCategorySelectorState extends State<RecurringCategorySelector>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<TranscationBloc>().add(ClearSelectionEvent());
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.selectCategory), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              dividerColor: Colors.transparent,
              labelColor: Theme.of(context).scaffoldBackgroundColor,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              tabs: [
                Tab(text: l.income),
                Tab(text: l.expense),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<TranscationBloc, TranscationState>(
              builder: (context, state) {
                if (state.status == TranscationStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == TranscationStatus.error) {
                  return Center(child: Text(state.errorMessage.toString()));
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    RecurringCategoryGrid(
                      categories: state.incomCategies ?? [],
                      isIncome: true,
                    ),
                    RecurringCategoryGrid(
                      categories: state.expanceCategies ?? [],
                      isIncome: false,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
