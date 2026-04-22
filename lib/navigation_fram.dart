import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/navigation/bloc/nav_bloc.dart';
import 'package:spendio/core/navigation/bloc/nav_event.dart';
import 'package:spendio/core/navigation/bloc/nav_state.dart';
import 'package:spendio/core/navigation/route_name.dart';
import 'package:spendio/core/utils/enum.dart';
import 'package:spendio/features/analytics/presentation/faces/analytics_face.dart';
import 'package:spendio/features/budgets/presentation/faces/add_budget_bottomsheet.dart';
import 'package:spendio/features/budgets/presentation/faces/budget_face.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_state.dart';
import 'package:spendio/features/home/presentation/faces/home_face.dart';
import 'package:spendio/features/profile/presentation/faces/profile_face.dart';
import 'package:spendio/features/recurring/presentation/faces/recurring_category_selection.dart';
import 'package:spendio/features/recurring/presentation/faces/recurring_face.dart';
import 'package:spendio/l10n/app_localizations.dart';

class MainFrame extends StatelessWidget {
  MainFrame({super.key});

  final List<Widget> pages = [
    HomeFace(),
    const BudgetsFace(), // NEW: Budget tab
    const RecurringFace(),
    const AnalyticsFace(),
    const ProfileFace(),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => NavBloc(),
      child: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: pages[state.index],
            floatingActionButton: _buildFAB(context, state.index),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).colorScheme.surface,
              elevation: 10,
              child: SizedBox(
                height: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: t.home,
                      isActive: state.index == 0,
                      onTap: () =>
                          context.read<NavBloc>().add(ChangeTabEvent(0)),
                    ),
                    _NavItem(
                      icon: Icons.account_balance_wallet_rounded,
                      label: t.budgets,
                      isActive: state.index == 1,
                      onTap: () =>
                          context.read<NavBloc>().add(ChangeTabEvent(1)),
                    ),
                    _NavItem(
                      icon: Icons.autorenew_rounded,

                      label: t.recurring,
                      isActive: state.index == 2,
                      onTap: () =>
                          context.read<NavBloc>().add(ChangeTabEvent(2)),
                    ),
                    _NavItem(
                      icon: Icons.bar_chart_rounded,
                      label: t.analytics,
                      isActive: state.index == 3,
                      onTap: () =>
                          context.read<NavBloc>().add(ChangeTabEvent(3)),
                    ),
                    _NavItem(
                      icon: Icons.person_rounded,
                      label: t.profile,
                      isActive: state.index == 4,
                      onTap: () =>
                          context.read<NavBloc>().add(ChangeTabEvent(4)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context, int currentIndex) {
    final t = AppLocalizations.of(context)!;

    // HOME TAB - Dynamic FAB based on selected tab (Transactions/Debts)
    if (currentIndex == 0) {
      return BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final isTransactionsTab = state.selectedTab == HomeTab.transactions;

          return FloatingActionButton.extended(
            elevation: 10,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              if (isTransactionsTab) {
                // Navigate to Add Transaction screen
                Navigator.pushNamed(context, RouteName.addRecord);
              } else {
                // Show Add Debt bottom sheet
                Navigator.pushNamed(
                  context,
                  RouteName.addRecord,
                  arguments: {'flowType': TransactionSource.debt},
                );
              }
            },
            icon: const Icon(Icons.add, size: 24),
            label: Text(
              isTransactionsTab ? t.transactions : t.addDebt,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        },
      );
    }

    // BUDGETS TAB
    if (currentIndex == 1) {
      return FloatingActionButton.extended(
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _showCreateBudgetBottomSheet(context),
        icon: const Icon(Icons.add, size: 24),
        label: Text(
          t.budgets,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }
    // Recurring TAB
    if (currentIndex == 2) {
      return FloatingActionButton.extended(
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecurringCategorySelector()),
        ),

        // ... rest of your code
        icon: const Icon(Icons.add, size: 24),
        label: Text(
          t.recurring,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }
    if (currentIndex == 4) {
      return SizedBox.shrink();
    }
    if (currentIndex == 3) {
      return SizedBox.shrink();
    }
    // DEFAULT FAB for other tabs
    return FloatingActionButton.extended(
      elevation: 10,
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.pushNamed(context, RouteName.addRecord);
      },
      label: Text(
        t.transactions,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      icon: const Icon(Icons.add, size: 24),
    );
  }

  // Add this method to show Add Debt bottom sheet
  // void _showAddDebtBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => Container(
  //       height: MediaQuery.of(context).size.height * 0.9,
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).colorScheme.surface,
  //         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(20),
  //         child: Column(
  //           children: [
  //             // Drag Handle
  //             Container(
  //               margin: const EdgeInsets.only(bottom: 12),
  //               width: 40,
  //               height: 4,
  //               decoration: BoxDecoration(
  //                 color: Colors.grey.shade300,
  //                 borderRadius: BorderRadius.circular(2),
  //               ),
  //             ),
  //             const Text(
  //               'Add Debt',
  //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 20),
  //             // Add your debt form here
  //             const Expanded(
  //               child: Center(child: Text('Add Debt Form Coming Soon')),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// ==================== NAV ITEM ====================
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).primaryColor
        : Colors.grey.shade600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showCreateBudgetBottomSheet(BuildContext context) {
  // Just call this - it handles everything!
  AddBudgetBottomSheet.show(context);
}

// // ==================== CREATE BUDGET BOTTOM SHEET ====================
// void _showCreateBudgetBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) => const CreateBudgetBottomSheet(),
//   );
// }

// class CreateBudgetBottomSheet extends StatefulWidget {
//   const CreateBudgetBottomSheet({super.key});

//   @override
//   State<CreateBudgetBottomSheet> createState() =>
//       _CreateBudgetBottomSheetState();
// }

// class _CreateBudgetBottomSheetState extends State<CreateBudgetBottomSheet> {
//   BudgetType? selectedType;
//   final nameController = TextEditingController();
//   final amountController = TextEditingController();
//   DateTime? startDate;
//   DateTime? endDate;
//   String? selectedIcon;
//   Color selectedColor = Colors.blue;

//   final List<BudgetTypeOption> budgetTypes = [
//     BudgetTypeOption(
//       type: BudgetType.monthly,
//       title: 'Monthly Salary',
//       subtitle: 'Auto-sets 30 days period',
//       icon: '💰',
//       gradient: const LinearGradient(
//         colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
//       ),
//     ),
//     BudgetTypeOption(
//       type: BudgetType.project,
//       title: 'Wedding',
//       subtitle: 'Set custom dates for events',
//       icon: '💍',
//       gradient: const LinearGradient(
//         colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
//       ),
//     ),
//     BudgetTypeOption(
//       type: BudgetType.custom,
//       title: 'Custom Project',
//       subtitle: 'Any goal with custom timeline',
//       icon: '🎯',
//       gradient: const LinearGradient(
//         colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
//       ),
//     ),
//   ];

//   final List<IconOption> iconOptions = [
//     IconOption('💰', 'Money'),
//     IconOption('🏠', 'Home'),
//     IconOption('🚗', 'Car'),
//     IconOption('✈️', 'Travel'),
//     IconOption('💍', 'Wedding'),
//     IconOption('🎓', 'Education'),
//     IconOption('🏥', 'Health'),
//     IconOption('🎯', 'Goal'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.9,
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: Column(
//         children: [
//           // Drag Handle
//           Container(
//             margin: const EdgeInsets.only(top: 12),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           // Header
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const Expanded(
//                   child: Text(
//                     'Create Budget',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(width: 48), // Balance close button
//               ],
//             ),
//           ),
//           // Content
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Budget Type Selection
//                   const Text(
//                     'Select Budget Type',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 16),
//                   ...budgetTypes.map((option) => _buildTypeCard(option)),

//                   if (selectedType != null) ...[
//                     const SizedBox(height: 24),

//                     // Budget Name
//                     TextField(
//                       controller: nameController,
//                       decoration: InputDecoration(
//                         labelText: 'Budget Name',
//                         hintText: 'e.g., January Salary, My Wedding',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         prefixIcon: const Icon(Icons.edit),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Amount
//                     TextField(
//                       controller: amountController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: 'Budget Amount',
//                         hintText: '0',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         prefixIcon: const Icon(Icons.currency_rupee),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Date Selection
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildDateField(
//                             label: 'Start Date',
//                             date: startDate,
//                             onTap: () => _selectDate(true),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _buildDateField(
//                             label: 'End Date',
//                             date: endDate,
//                             onTap: () => _selectDate(false),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),

//                     // Icon Selection
//                     const Text(
//                       'Choose Icon',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Wrap(
//                       spacing: 12,
//                       runSpacing: 12,
//                       children: iconOptions.map((option) {
//                         final isSelected = selectedIcon == option.emoji;
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() => selectedIcon = option.emoji);
//                           },
//                           child: Container(
//                             width: 60,
//                             height: 60,
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? selectedColor.withOpacity(0.2)
//                                   : Colors.grey.shade100,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: isSelected
//                                     ? selectedColor
//                                     : Colors.transparent,
//                                 width: 2,
//                               ),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 option.emoji,
//                                 style: const TextStyle(fontSize: 28),
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     const SizedBox(height: 24),

//                     // Color Selection
//                     const Text(
//                       'Choose Color',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Wrap(
//                       spacing: 12,
//                       runSpacing: 12,
//                       children:
//                           [
//                             Colors.blue,
//                             Colors.green,
//                             Colors.orange,
//                             Colors.purple,
//                             Colors.red,
//                             Colors.teal,
//                             Colors.pink,
//                             Colors.indigo,
//                           ].map((color) {
//                             final isSelected = selectedColor == color;
//                             return GestureDetector(
//                               onTap: () {
//                                 setState(() => selectedColor = color);
//                               },
//                               child: Container(
//                                 width: 50,
//                                 height: 50,
//                                 decoration: BoxDecoration(
//                                   color: color,
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: isSelected
//                                         ? Colors.black
//                                         : Colors.transparent,
//                                     width: 3,
//                                   ),
//                                 ),
//                                 child: isSelected
//                                     ? const Icon(
//                                         Icons.check,
//                                         color: Colors.white,
//                                       )
//                                     : null,
//                               ),
//                             );
//                           }).toList(),
//                     ),
//                     const SizedBox(height: 32),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//           // Create Button
//           if (selectedType != null)
//             Container(
//               padding: const EdgeInsets.all(20),
//               child: ElevatedButton(
//                 onPressed: _createBudget,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: selectedColor,
//                   foregroundColor: Colors.white,
//                   minimumSize: const Size(double.infinity, 56),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 4,
//                 ),
//                 child: const Text(
//                   'Create Budget',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTypeCard(BudgetTypeOption option) {
//     final isSelected = selectedType == option.type;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedType = option.type;
//           selectedIcon = option.icon;

//           // Auto-set dates for monthly
//           if (option.type == BudgetType.monthly) {
//             startDate = DateTime.now();
//             endDate = DateTime.now().add(const Duration(days: 30));
//           }
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           gradient: isSelected ? option.gradient : null,
//           color: isSelected ? null : Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? Colors.transparent : Colors.grey.shade300,
//             width: 2,
//           ),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: option.gradient.colors.first.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Row(
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? Colors.white.withOpacity(0.2)
//                       : Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child: Text(
//                     option.icon,
//                     style: const TextStyle(fontSize: 32),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       option.title,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: isSelected ? Colors.white : Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       option.subtitle,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: isSelected
//                             ? Colors.white.withOpacity(0.8)
//                             : Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (isSelected)
//                 const Icon(Icons.check_circle, color: Colors.white, size: 28),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateField({
//     required String label,
//     required DateTime? date,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               date != null
//                   ? '${date.day}/${date.month}/${date.year}'
//                   : 'Select Date',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(bool isStart) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 3650)),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           startDate = picked;
//           // Auto-set end date if monthly
//           if (selectedType == BudgetType.monthly) {
//             endDate = picked.add(const Duration(days: 30));
//           }
//         } else {
//           endDate = picked;
//         }
//       });
//     }
//   }

//   void _createBudget() {
//     // Validate
//     if (nameController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please enter budget name')));
//       return;
//     }

//     if (amountController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter budget amount')),
//       );
//       return;
//     }

//     if (startDate == null || endDate == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please select dates')));
//       return;
//     }

//     // Create budget model here
//     // final budget = BudgetModel(...)
//     // Save to Hive

//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Budget created successfully!'),
//         backgroundColor: selectedColor,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     amountController.dispose();
//     super.dispose();
//   }
// }

// // ==================== HELPER CLASSES ====================
// class BudgetTypeOption {
//   final BudgetType type;
//   final String title;
//   final String subtitle;
//   final String icon;
//   final LinearGradient gradient;

//   BudgetTypeOption({
//     required this.type,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.gradient,
//   });
// }

// class IconOption {
//   final String emoji;
//   final String label;

//   IconOption(this.emoji, this.label);
// }

















//===================================== NEw  -------------------
// class MainFrame extends StatelessWidget {
//   MainFrame({super.key});

//   final List<Widget> pages = [
//     HomeFace(),
//     const BudgetsFace(),
//     const AnalyticsFace(),
//     const ProfileFace(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => NavBloc(),
//       child: BlocBuilder<NavBloc, NavState>(
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: Theme.of(context).colorScheme.surface,
//             // extendBody so page content flows under the floating bar
//             extendBody: true,
//             body: pages[state.index],
//             // ── No scaffold FAB — we use a Stack inside bottomNavigationBar ──
//             bottomNavigationBar: _SpendioBottomNav(currentIndex: state.index),
//           );
//         },
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // Premium Bottom Nav  —  floating bar + elevated FAB above it
// // ═══════════════════════════════════════════════════════════════
// class _SpendioBottomNav extends StatelessWidget {
//   final int currentIndex;
//   const _SpendioBottomNav({required this.currentIndex});

//   static const double _barHeight = 72.0;
//   static const double _fabSize = 58.0;
//   static const double _fabOffset = 28.0; // how much FAB sits above bar top
//   static const double _totalHeight = _barHeight + _fabOffset;

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final primary = Theme.of(context).primaryColor;

//     final barBg = isDark ? const Color(0xFF16161E) : Colors.white;
//     final bottomPadding = MediaQuery.of(context).padding.bottom;

//     return SizedBox(
//       height: _totalHeight + bottomPadding,
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.bottomCenter,
//         children: [
//           // ── Floating Bar ──────────────────────────────────────
//           Positioned(
//             left: 10,
//             right: 10,
//             bottom: bottomPadding - 10,
//             child: Container(
//               height: _barHeight,
//               decoration: BoxDecoration(
//                 color: barBg,
//                 borderRadius: BorderRadius.circular(26),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.55)
//                         : Colors.black.withOpacity(0.10),
//                     blurRadius: 32,
//                     spreadRadius: 0,
//                     offset: const Offset(0, 8),
//                   ),
//                   if (!isDark)
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.04),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   // Left: Home + Budgets
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _NavItem(
//                           icon: Icons.home_rounded,
//                           label: t.home,
//                           isActive: currentIndex == 0,
//                           onTap: () =>
//                               context.read<NavBloc>().add(ChangeTabEvent(0)),
//                         ),
//                         _NavItem(
//                           icon: Icons.account_balance_wallet_rounded,
//                           label: t.budgets,
//                           isActive: currentIndex == 1,
//                           onTap: () =>
//                               context.read<NavBloc>().add(ChangeTabEvent(1)),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Center gap — reserved for the FAB footprint
//                   const SizedBox(width: _fabSize + 16),

//                   // Right: Analytics + Profile
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _NavItem(
//                           icon: Icons.bar_chart_rounded,
//                           label: t.analytics,
//                           isActive: currentIndex == 2,
//                           onTap: () =>
//                               context.read<NavBloc>().add(ChangeTabEvent(2)),
//                         ),
//                         _NavItem(
//                           icon: Icons.person_rounded,
//                           label: t.profile,
//                           isActive: currentIndex == 3,
//                           onTap: () =>
//                               context.read<NavBloc>().add(ChangeTabEvent(3)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // ── Floating FAB — elevated above the bar ────────────
//           Positioned(
//             bottom:
//                 bottomPadding +
//                 (_barHeight / 2) -
//                 (_fabSize / 2) +
//                 _fabOffset -
//                 10,
//             child: _PremiumFAB(currentIndex: currentIndex, size: _fabSize),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // Premium FAB — floats above the bar with layered shadow ring
// // ═══════════════════════════════════════════════════════════════
// class _PremiumFAB extends StatefulWidget {
//   final int currentIndex;
//   final double size;
//   const _PremiumFAB({required this.currentIndex, required this.size});

//   @override
//   State<_PremiumFAB> createState() => _PremiumFABState();
// }

// class _PremiumFABState extends State<_PremiumFAB>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _ctrl;
//   late final Animation<double> _scaleAnim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//       lowerBound: 0.0,
//       upperBound: 1.0,
//     );
//     _scaleAnim = Tween<double>(
//       begin: 1.0,
//       end: 0.91,
//     ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   void _onTapDown(_) => _ctrl.forward();
//   void _onTapUp(_) => _ctrl.reverse();
//   void _onTapCancel() => _ctrl.reverse();

//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).primaryColor;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return GestureDetector(
//       onTapDown: _onTapDown,
//       onTapUp: _onTapUp,
//       onTapCancel: _onTapCancel,
//       onTap: () {
//         HapticFeedback.lightImpact();
//         _handleFABPress(context);
//       },
//       child: AnimatedBuilder(
//         animation: _scaleAnim,
//         builder: (_, child) =>
//             Transform.scale(scale: _scaleAnim.value, child: child),
//         child: Container(
//           width: widget.size,
//           height: widget.size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             // Outer glow ring
//             boxShadow: [
//               BoxShadow(
//                 color: primary.withOpacity(isDark ? 0.55 : 0.35),
//                 blurRadius: 22,
//                 spreadRadius: 1,
//                 offset: const Offset(0, 6),
//               ),
//               BoxShadow(
//                 color: primary.withOpacity(0.15),
//                 blurRadius: 6,
//                 spreadRadius: 0,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Container(
//             decoration: BoxDecoration(shape: BoxShape.circle, color: primary),
//             child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleFABPress(BuildContext context) {
//     switch (widget.currentIndex) {
//       case 0:
//         final homeState = context.read<HomeBloc>().state;
//         final isTransactions = homeState.selectedTab == HomeTab.transactions;
//         Navigator.pushNamed(
//           context,
//           RouteName.addRecord,
//           arguments: isTransactions
//               ? null
//               : {'flowType': TransactionSource.debt},
//         );
//         break;
//       case 1:
//         AddBudgetBottomSheet.show(context);
//         break;
//       default:
//         Navigator.pushNamed(context, RouteName.addRecord);
//         break;
//     }
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // Nav Item
// // ═══════════════════════════════════════════════════════════════
// class _NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isActive;
//   final VoidCallback onTap;

//   const _NavItem({
//     required this.icon,
//     required this.label,
//     required this.isActive,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).primaryColor;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final activeColor = primary;
//     final inactiveColor = isDark
//         ? Colors.white.withOpacity(0.28)
//         : const Color(0xFFB0B0C3);

//     final color = isActive ? activeColor : inactiveColor;

//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.selectionClick();
//         onTap();
//       },
//       behavior: HitTestBehavior.opaque,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 240),
//               curve: Curves.easeInOut,
//               padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
//               decoration: BoxDecoration(
//                 color: isActive
//                     ? primary.withOpacity(0.11)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: AnimatedScale(
//                 scale: isActive ? 1.10 : 1.0,
//                 duration: const Duration(milliseconds: 240),
//                 curve: Curves.easeOutBack,
//                 child: Icon(icon, color: color, size: 22),
//               ),
//             ),
//             const SizedBox(height: 3),
//             AnimatedDefaultTextStyle(
//               duration: const Duration(milliseconds: 240),
//               style: TextStyle(
//                 color: color,
//                 fontSize: 10,
//                 fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
//                 letterSpacing: isActive ? 0.4 : 0.1,
//               ),
//               child: Text(label),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }