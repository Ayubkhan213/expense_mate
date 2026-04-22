import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/app_export.dart';
import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/utils/enum.dart';
import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_bloc.dart';
import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_event.dart';
import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_state.dart';
import 'package:spendio/features/transcation/presentation/components/category_section/category_grid.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:spendio/core/utils/translation_helper.dart';

class CategorySelector extends StatefulWidget {
  final BudgetModel? budgetModel;
  final TransactionSource flowType;
  const CategorySelector({super.key, this.budgetModel, required this.flowType});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // ── FIX: NEVER call context.read() in initState.
    // The widget is not yet in the tree so the BlocProvider above it cannot
    // be found, which throws "Bad state: Tried to read a provider that threw
    // during the creation of its value." and crashes every rebuild.
    //
    // Use addPostFrameCallback instead — fires after the first frame when the
    // widget IS in the tree and context.read() is safe.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TranscationBloc>().add(ClearSelectionEvent());
      }
    });

    final tabLength = widget.flowType == TransactionSource.budget ? 1 : 2;
    _tabController = TabController(length: tabLength, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l.searchHint,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              )
            : Text(
                widget.flowType == TransactionSource.budget
                    ? l.selectExpenseCategory
                    : l.selectCategory,
              ),
        centerTitle: !_isSearching,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _searchQuery = '';
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
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
              tabs: widget.flowType == TransactionSource.budget
                  ? [Tab(text: '${widget.budgetModel?.name ?? ''} Budget')]
                  : [Tab(text: l.income), Tab(text: l.expense)],
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

                final incomeCategories = (state.incomCategies ?? []).where((c) {
                  final localizedName = context.tr(c.key).toLowerCase();
                  return localizedName.contains(_searchQuery);
                }).toList();

                final expenseCategories = (state.expanceCategies ?? []).where((c) {
                  final localizedName = context.tr(c.key).toLowerCase();
                  return localizedName.contains(_searchQuery);
                }).toList();

                return TabBarView(
                  controller: _tabController,
                  children: widget.flowType == TransactionSource.budget
                      ? [
                          CategoryGrid(
                            categories: expenseCategories,
                            selectedCategories: state.selectedCategies ?? [],
                            flowType: TransactionSource.budget,
                            budgetModel: widget.budgetModel,
                          ),
                        ]
                      : [
                          CategoryGrid(
                            flowType: widget.flowType,
                            categories: incomeCategories,
                            selectedCategories: state.selectedCategies ?? [],
                          ),
                          CategoryGrid(
                            flowType: widget.flowType,
                            categories: expenseCategories,
                            selectedCategories: state.selectedCategies ?? [],
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
