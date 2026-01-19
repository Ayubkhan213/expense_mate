import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/utils/enum.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<TranscationBloc>().add(ClearSelectionEvent());

    final tabLength = widget.flowType == TransactionSource.budget ? 1 : 2;

    _tabController = TabController(length: tabLength, vsync: this);
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
      appBar: AppBar(
        title: Text(
          widget.flowType == TransactionSource.budget
              ? l.selectExpenseCategory
              : l.selectCategory,
        ),
        centerTitle: true,
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
              //  REMOVE SHADOW / SPLASH
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

                return TabBarView(
                  controller: _tabController,
                  children: widget.flowType == TransactionSource.budget
                      ? [
                          CategoryGrid(
                            categories: state.expanceCategies ?? [],
                            selectedCategories: state.selectedCategies ?? [],
                            flowType: TransactionSource.budget,
                            budgetModel: widget.budgetModel,
                          ),
                        ]
                      : [
                          CategoryGrid(
                            flowType: TransactionSource.normal,
                            categories: state.incomCategies ?? [],
                            selectedCategories: state.selectedCategies ?? [],
                          ),
                          CategoryGrid(
                            flowType: TransactionSource.normal,

                            categories: state.expanceCategies ?? [],
                            selectedCategories: state.selectedCategies ?? [],
                          ),
                        ],
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: BlocBuilder<AddRecordBloc, AddRecordState>(
          //     builder: (context, state) {
          //       return Column(
          //         children: [
          //           Row(
          //             children: [
          //               ModeButton(
          //                 active: state.isMultipleMode == false ? true : false,
          //                 onTap: () {
          //                   context.read<AddRecordBloc>().add(
          //                     ToggleSelectionTabs(isMultipleSelection: false),
          //                   );
          //                 },
          //                 text: l.single,
          //               ),

          //               const SizedBox(width: 12),
          //               ModeButton(
          //                 active: state.isMultipleMode == false ? false : true,
          //                 onTap: () {
          //                   context.read<AddRecordBloc>().add(
          //                     ToggleSelectionTabs(isMultipleSelection: true),
          //                   );
          //                 },
          //                 text: l.multiple,
          //               ),
          //             ],
          //           ),
          //           // if (selectedCategories.isNotEmpty)
          //           //   Padding(
          //           //     padding: const EdgeInsets.only(top: 12),
          //           //     child: Text(
          //           //       '${selectedCategories.length} ${l.categoriesSelected}',
          //           //     ),
          //           //   ),
          //         ],
          //       );
          //     },
          //   ),
          // ),

          // _buildBottomSection(l),
        ],
      ),
    );
  }
}

 // final List<CategoryItem> incomeCategories = [
  //   // Employment Income
  //   CategoryItem('salary', Icons.payment, const Color(0xFF4CAF50)),
  //   CategoryItem('bonus', Icons.stars, const Color(0xFFFFEB3B)),
  //   CategoryItem('commission', Icons.trending_up, const Color(0xFF8BC34A)),
  //   CategoryItem('tips', Icons.volunteer_activism, const Color(0xFF66BB6A)),

  //   // Business Income
  //   CategoryItem('business', Icons.business_center, const Color(0xFF2196F3)),
  //   CategoryItem('freelance', Icons.laptop_mac, const Color(0xFFFF9800)),
  //   CategoryItem('consulting', Icons.manage_accounts, const Color(0xFF03A9F4)),
  //   CategoryItem('selfEmployed', Icons.work, const Color(0xFF0288D1)),

  //   // Investment Income
  //   CategoryItem('investment', Icons.show_chart, const Color(0xFF9C27B0)),
  //   CategoryItem('dividends', Icons.account_balance, const Color(0xFFAB47BC)),
  //   CategoryItem('interest', Icons.savings, const Color(0xFFBA68C8)),
  //   CategoryItem('capitalGains', Icons.auto_graph, const Color(0xFFCE93D8)),
  //   CategoryItem(
  //     'cryptocurrency',
  //     Icons.currency_bitcoin,
  //     const Color(0xFFFF6F00),
  //   ),

  //   // Property Income
  //   CategoryItem('rental', Icons.home, const Color(0xFF795548)),
  //   CategoryItem('realEstate', Icons.domain, const Color(0xFF8D6E63)),
  //   CategoryItem('royalties', Icons.copyright, const Color(0xFFA1887F)),

  //   // Passive Income
  //   CategoryItem('pension', Icons.elderly, const Color(0xFF607D8B)),
  //   CategoryItem('socialSecurity', Icons.security, const Color(0xFF78909C)),
  //   CategoryItem('annuity', Icons.calendar_month, const Color(0xFF90A4AE)),
  //   CategoryItem(
  //     'trustFund',
  //     Icons.account_balance_wallet,
  //     const Color(0xFFB0BEC5),
  //   ),

  //   // Other Income
  //   CategoryItem('gift', Icons.card_giftcard, const Color(0xFFE91E63)),
  //   CategoryItem('inheritance', Icons.family_restroom, const Color(0xFFF06292)),
  //   CategoryItem('lottery', Icons.casino, const Color(0xFFF48FB1)),
  //   CategoryItem('refund', Icons.money_off, const Color(0xFF4DB6AC)),
  //   CategoryItem('cashback', Icons.attach_money, const Color(0xFF26A69A)),
  //   CategoryItem('award', Icons.emoji_events, const Color(0xFFFFD54F)),
  //   CategoryItem('grant', Icons.approval, const Color(0xFF81C784)),
  //   CategoryItem('scholarship', Icons.school, const Color(0xFF64B5F6)),
  //   CategoryItem('sideHustle', Icons.rocket_launch, const Color(0xFFFF7043)),
  //   CategoryItem('other', Icons.more_horiz, const Color(0xFF9E9E9E)),
  // ];

  // final List<CategoryItem> expenseCategories = [
  //   // Food & Dining
  //   CategoryItem('food', Icons.restaurant, const Color(0xFFFF5722)),
  //   CategoryItem('groceries', Icons.shopping_cart, const Color(0xFFFF7043)),
  //   CategoryItem('diningOut', Icons.restaurant_menu, const Color(0xFFFF6E40)),
  //   CategoryItem('fastFood', Icons.fastfood, const Color(0xFFFF9E80)),
  //   CategoryItem('cafe', Icons.local_cafe, const Color(0xFFFFAB91)),
  //   CategoryItem('delivery', Icons.delivery_dining, const Color(0xFFFFBCBC)),

  //   // Transportation
  //   CategoryItem('transport', Icons.directions_car, const Color(0xFF3F51B5)),
  //   CategoryItem('fuel', Icons.local_gas_station, const Color(0xFF5C6BC0)),
  //   CategoryItem('parking', Icons.local_parking, const Color(0xFF7986CB)),
  //   CategoryItem(
  //     'publicTransit',
  //     Icons.directions_bus,
  //     const Color(0xFF9FA8DA),
  //   ),
  //   CategoryItem('taxi/Uber', Icons.local_taxi, const Color(0xFFC5CAE9)),
  //   CategoryItem('carMaintenance', Icons.car_repair, const Color(0xFF536DFE)),
  //   CategoryItem('vehicleInsurance', Icons.car_crash, const Color(0xFF3D5AFE)),

  //   // Shopping
  //   CategoryItem('shopping', Icons.shopping_bag, const Color(0xFFE91E63)),
  //   CategoryItem('clothing', Icons.checkroom, const Color(0xFFF06292)),
  //   CategoryItem('electronics', Icons.devices, const Color(0xFFF48FB1)),
  //   CategoryItem('furniture', Icons.weekend, const Color(0xFFF8BBD0)),
  //   CategoryItem('cosmetics', Icons.face, const Color(0xFFFF4081)),
  //   CategoryItem('accessories', Icons.watch, const Color(0xFFC51162)),

  //   // Bills & Utilities
  //   CategoryItem('bills', Icons.receipt_long, const Color(0xFF009688)),
  //   CategoryItem('electricity', Icons.bolt, const Color(0xFF26A69A)),
  //   CategoryItem('water', Icons.water_drop, const Color(0xFF4DB6AC)),
  //   CategoryItem('gas', Icons.local_fire_department, const Color(0xFF80CBC4)),
  //   CategoryItem('internet', Icons.wifi, const Color(0xFFB2DFDB)),
  //   CategoryItem('phone', Icons.phone_android, const Color(0xFF00897B)),
  //   CategoryItem('streaming', Icons.live_tv, const Color(0xFF00796B)),

  //   // Housing
  //   CategoryItem('rent', Icons.house, const Color(0xFF795548)),
  //   CategoryItem('mortgage', Icons.home_work, const Color(0xFF8D6E63)),
  //   CategoryItem('propertyTax', Icons.request_quote, const Color(0xFFA1887F)),
  //   CategoryItem('homeRepair', Icons.construction, const Color(0xFFBCAAA4)),
  //   CategoryItem('hoaFees', Icons.apartment, const Color(0xFFD7CCC8)),

  //   // Health & Fitness
  //   CategoryItem('health', Icons.local_hospital, const Color(0xFFF44336)),
  //   CategoryItem('doctor', Icons.medical_services, const Color(0xFFEF5350)),
  //   CategoryItem('pharmacy', Icons.medication, const Color(0xFFE57373)),
  //   CategoryItem('dental', Icons.health_and_safety, const Color(0xFFEF9A9A)),
  //   CategoryItem('vision', Icons.visibility, const Color(0xFFFFCDD2)),
  //   CategoryItem('gym', Icons.fitness_center, const Color(0xFF4CAF50)),
  //   CategoryItem('yoga', Icons.self_improvement, const Color(0xFF66BB6A)),
  //   CategoryItem('sports', Icons.sports_basketball, const Color(0xFF81C784)),

  //   // Entertainment
  //   CategoryItem('entertainment', Icons.movie, const Color(0xFF9C27B0)),
  //   CategoryItem('movies', Icons.theaters, const Color(0xFFAB47BC)),
  //   CategoryItem('concerts', Icons.music_note, const Color(0xFFBA68C8)),
  //   CategoryItem('games', Icons.sports_esports, const Color(0xFFCE93D8)),
  //   CategoryItem('hobbies', Icons.palette, const Color(0xFFE1BEE7)),
  //   CategoryItem('books', Icons.menu_book, const Color(0xFF8E24AA)),
  //   CategoryItem('music', Icons.headphones, const Color(0xFF7B1FA2)),

  //   // Travel
  //   CategoryItem('travel', Icons.flight, const Color(0xFF00BCD4)),
  //   CategoryItem('hotel', Icons.hotel, const Color(0xFF26C6DA)),
  //   CategoryItem('flights', Icons.flight_takeoff, const Color(0xFF4DD0E1)),
  //   CategoryItem('vacation', Icons.beach_access, const Color(0xFF80DEEA)),
  //   CategoryItem('tours', Icons.tour, const Color(0xFFB2EBF2)),

  //   // Education
  //   CategoryItem('education', Icons.school, const Color(0xFF2196F3)),
  //   CategoryItem('tuition', Icons.account_balance, const Color(0xFF42A5F5)),
  //   // CategoryItem('books', Icons.import_contacts, const Color(0xFF64B5F6)),
  //   CategoryItem('courses', Icons.class_, const Color(0xFF90CAF9)),
  //   CategoryItem('supplies', Icons.create, const Color(0xFFBBDEFB)),

  //   // Insurance
  //   CategoryItem('insurance', Icons.security, const Color(0xFF607D8B)),
  //   CategoryItem(
  //     'healthInsurance',
  //     Icons.health_and_safety,
  //     const Color(0xFF78909C),
  //   ),
  //   CategoryItem('lifeInsurance', Icons.favorite, const Color(0xFF90A4AE)),
  //   CategoryItem('homeInsurance', Icons.cottage, const Color(0xFFB0BEC5)),

  //   // Personal Care
  //   CategoryItem(
  //     'personalCare',
  //     Icons.face_retouching_natural,
  //     const Color(0xFFFF9800),
  //   ),
  //   CategoryItem('haircut', Icons.content_cut, const Color(0xFFFFA726)),
  //   CategoryItem('spa', Icons.spa, const Color(0xFFFFB74D)),
  //   CategoryItem('skincare', Icons.clean_hands, const Color(0xFFFFCC80)),

  //   // Pets
  //   CategoryItem('pets', Icons.pets, const Color(0xFF8BC34A)),
  //   CategoryItem('petFood', Icons.set_meal, const Color(0xFF9CCC65)),
  //   CategoryItem('vet', Icons.local_hospital, const Color(0xFFAED581)),
  //   CategoryItem('petSupplies', Icons.shopping_basket, const Color(0xFFC5E1A5)),

  //   // Financial
  //   CategoryItem('savings', Icons.savings, const Color(0xFF673AB7)),
  //   CategoryItem('investment', Icons.trending_up, const Color(0xFF7E57C2)),
  //   CategoryItem('loanPayment', Icons.payment, const Color(0xFF9575CD)),
  //   CategoryItem('creditCard', Icons.credit_card, const Color(0xFFB39DDB)),
  //   CategoryItem('bankFees', Icons.account_balance, const Color(0xFFD1C4E9)),

  //   // Charity & Gifts
  //   CategoryItem('charity', Icons.volunteer_activism, const Color(0xFFE91E63)),
  //   CategoryItem('donation', Icons.loyalty, const Color(0xFFF06292)),
  //   CategoryItem('gifts', Icons.redeem, const Color(0xFFF48FB1)),

  //   // Kids
  //   CategoryItem('kids', Icons.child_care, const Color(0xFFFFEB3B)),
  //   CategoryItem(
  //     'childcare',
  //     Icons.baby_changing_station,
  //     const Color(0xFFFFF176),
  //   ),
  //   CategoryItem('toys', Icons.toys, const Color(0xFFFFF59D)),
  //   CategoryItem('activities', Icons.celebration, const Color(0xFFFFFDE7)),

  //   // Other
  //   CategoryItem('subscriptions', Icons.subscriptions, const Color(0xFF00BCD4)),
  //   CategoryItem('software', Icons.computer, const Color(0xFF26C6DA)),
  //   CategoryItem('maintenance', Icons.build, const Color(0xFF455A64)),
  //   CategoryItem('legal', Icons.gavel, const Color(0xFF37474F)),
  //   CategoryItem('tax', Icons.request_page, const Color(0xFF263238)),
  //   CategoryItem('other', Icons.more_horiz, const Color(0xFF9E9E9E)),
  // ];



  // // ================== INCOME ==================
  // final List<CategoryItem> incomeCategories = [
  //   CategoryItem('salary', Icons.payment, const Color(0xFF4CAF50)),
  //   CategoryItem('bonus', Icons.stars, const Color(0xFFFFEB3B)),
  //   CategoryItem('commission', Icons.trending_up, const Color(0xFF8BC34A)),
  //   CategoryItem('tips', Icons.volunteer_activism, const Color(0xFF66BB6A)),
  //   CategoryItem('business', Icons.business_center, const Color(0xFF2196F3)),
  //   CategoryItem('freelance', Icons.laptop_mac, const Color(0xFFFF9800)),
  //   CategoryItem('consulting', Icons.manage_accounts, const Color(0xFF03A9F4)),
  //   CategoryItem('selfEmployed', Icons.work, const Color(0xFF0288D1)),
  //   CategoryItem('investment', Icons.show_chart, const Color(0xFF9C27B0)),
  //   CategoryItem('dividends', Icons.account_balance, const Color(0xFFAB47BC)),
  //   CategoryItem('interest', Icons.savings, const Color(0xFFBA68C8)),
  //   CategoryItem('rental', Icons.home, const Color(0xFF795548)),
  //   CategoryItem('gift', Icons.card_giftcard, const Color(0xFFE91E63)),
  //   CategoryItem('refund', Icons.money_off, const Color(0xFF4DB6AC)),
  //   CategoryItem('otherIncome', Icons.more_horiz, const Color(0xFF9E9E9E)),
  // ];

  // // ================== EXPENSE ==================
  // final List<CategoryItem> expenseCategories = [
  //   CategoryItem('food', Icons.restaurant, const Color(0xFFFF5722)),
  //   CategoryItem('groceries', Icons.shopping_cart, const Color(0xFFFF7043)),
  //   CategoryItem('transport', Icons.directions_car, const Color(0xFF3F51B5)),
  //   CategoryItem('fuel', Icons.local_gas_station, const Color(0xFF5C6BC0)),
  //   CategoryItem('shopping', Icons.shopping_bag, const Color(0xFFE91E63)),
  //   CategoryItem('bills', Icons.receipt_long, const Color(0xFF009688)),
  //   CategoryItem('rent', Icons.house, const Color(0xFF795548)),
  //   CategoryItem('health', Icons.local_hospital, const Color(0xFFF44336)),
  //   CategoryItem('education', Icons.school, const Color(0xFF2196F3)),
  //   CategoryItem('travel', Icons.flight, const Color(0xFF00BCD4)),
  //   CategoryItem('insurance', Icons.security, const Color(0xFF607D8B)),
  //   CategoryItem('charity', Icons.volunteer_activism, const Color(0xFFE91E63)),
  //   CategoryItem('subscriptions', Icons.subscriptions, const Color(0xFF00BCD4)),
  //   CategoryItem('tax', Icons.request_page, const Color(0xFF263238)),
  //   CategoryItem('otherExpense', Icons.more_horiz, const Color(0xFF9E9E9E)),
  // ];

// import 'package:expense_mate/core/app_export.dart';

// class CategorySelector extends StatefulWidget {
//   const CategorySelector({Key? key}) : super(key: key);

//   @override
//   State<CategorySelector> createState() => _CategorySelectorState();
// }

// class _CategorySelectorState extends State<CategorySelector>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool isMultipleMode = false;
//   Set<String> selectedCategories = {};

// final List<CategoryItem> incomeCategories = [
//   // Employment Income
//   CategoryItem('Salary', Icons.payment, const Color(0xFF4CAF50)),
//   CategoryItem('Bonus', Icons.stars, const Color(0xFFFFEB3B)),
//   CategoryItem('Commission', Icons.trending_up, const Color(0xFF8BC34A)),
//   CategoryItem('Tips', Icons.volunteer_activism, const Color(0xFF66BB6A)),

//   // Business Income
//   CategoryItem('Business', Icons.business_center, const Color(0xFF2196F3)),
//   CategoryItem('Freelance', Icons.laptop_mac, const Color(0xFFFF9800)),
//   CategoryItem('Consulting', Icons.manage_accounts, const Color(0xFF03A9F4)),
//   CategoryItem('Self-Employed', Icons.work, const Color(0xFF0288D1)),

//   // Investment Income
//   CategoryItem('Investment', Icons.show_chart, const Color(0xFF9C27B0)),
//   CategoryItem('Dividends', Icons.account_balance, const Color(0xFFAB47BC)),
//   CategoryItem('Interest', Icons.savings, const Color(0xFFBA68C8)),
//   CategoryItem('Capital Gains', Icons.auto_graph, const Color(0xFFCE93D8)),
//   CategoryItem(
//     'Cryptocurrency',
//     Icons.currency_bitcoin,
//     const Color(0xFFFF6F00),
//   ),

//   // Property Income
//   CategoryItem('Rental', Icons.home, const Color(0xFF795548)),
//   CategoryItem('Real Estate', Icons.domain, const Color(0xFF8D6E63)),
//   CategoryItem('Royalties', Icons.copyright, const Color(0xFFA1887F)),

//   // Passive Income
//   CategoryItem('Pension', Icons.elderly, const Color(0xFF607D8B)),
//   CategoryItem('Social Security', Icons.security, const Color(0xFF78909C)),
//   CategoryItem('Annuity', Icons.calendar_month, const Color(0xFF90A4AE)),
//   CategoryItem(
//     'Trust Fund',
//     Icons.account_balance_wallet,
//     const Color(0xFFB0BEC5),
//   ),

//   // Other Income
//   CategoryItem('Gift', Icons.card_giftcard, const Color(0xFFE91E63)),
//   CategoryItem('Inheritance', Icons.family_restroom, const Color(0xFFF06292)),
//   CategoryItem('Lottery', Icons.casino, const Color(0xFFF48FB1)),
//   CategoryItem('Refund', Icons.money_off, const Color(0xFF4DB6AC)),
//   CategoryItem('Cashback', Icons.attach_money, const Color(0xFF26A69A)),
//   CategoryItem('Award', Icons.emoji_events, const Color(0xFFFFD54F)),
//   CategoryItem('Grant', Icons.approval, const Color(0xFF81C784)),
//   CategoryItem('Scholarship', Icons.school, const Color(0xFF64B5F6)),
//   CategoryItem('Side Hustle', Icons.rocket_launch, const Color(0xFFFF7043)),
//   CategoryItem('Other', Icons.more_horiz, const Color(0xFF9E9E9E)),
// ];

// final List<CategoryItem> expenseCategories = [
//   // Food & Dining
//   CategoryItem('Food', Icons.restaurant, const Color(0xFFFF5722)),
//   CategoryItem('Groceries', Icons.shopping_cart, const Color(0xFFFF7043)),
//   CategoryItem('Dining Out', Icons.restaurant_menu, const Color(0xFFFF6E40)),
//   CategoryItem('Fast Food', Icons.fastfood, const Color(0xFFFF9E80)),
//   CategoryItem('Cafe', Icons.local_cafe, const Color(0xFFFFAB91)),
//   CategoryItem('Delivery', Icons.delivery_dining, const Color(0xFFFFBCBC)),

//   // Transportation
//   CategoryItem('Transport', Icons.directions_car, const Color(0xFF3F51B5)),
//   CategoryItem('Fuel', Icons.local_gas_station, const Color(0xFF5C6BC0)),
//   CategoryItem('Parking', Icons.local_parking, const Color(0xFF7986CB)),
//   CategoryItem(
//     'Public Transit',
//     Icons.directions_bus,
//     const Color(0xFF9FA8DA),
//   ),
//   CategoryItem('Taxi/Uber', Icons.local_taxi, const Color(0xFFC5CAE9)),
//   CategoryItem('Car Maintenance', Icons.car_repair, const Color(0xFF536DFE)),
//   CategoryItem('Vehicle Insurance', Icons.car_crash, const Color(0xFF3D5AFE)),

//   // Shopping
//   CategoryItem('Shopping', Icons.shopping_bag, const Color(0xFFE91E63)),
//   CategoryItem('Clothing', Icons.checkroom, const Color(0xFFF06292)),
//   CategoryItem('Electronics', Icons.devices, const Color(0xFFF48FB1)),
//   CategoryItem('Furniture', Icons.weekend, const Color(0xFFF8BBD0)),
//   CategoryItem('Cosmetics', Icons.face, const Color(0xFFFF4081)),
//   CategoryItem('Accessories', Icons.watch, const Color(0xFFC51162)),

//   // Bills & Utilities
//   CategoryItem('Bills', Icons.receipt_long, const Color(0xFF009688)),
//   CategoryItem('Electricity', Icons.bolt, const Color(0xFF26A69A)),
//   CategoryItem('Water', Icons.water_drop, const Color(0xFF4DB6AC)),
//   CategoryItem('Gas', Icons.local_fire_department, const Color(0xFF80CBC4)),
//   CategoryItem('Internet', Icons.wifi, const Color(0xFFB2DFDB)),
//   CategoryItem('Phone', Icons.phone_android, const Color(0xFF00897B)),
//   CategoryItem('Streaming', Icons.live_tv, const Color(0xFF00796B)),

//   // Housing
//   CategoryItem('Rent', Icons.house, const Color(0xFF795548)),
//   CategoryItem('Mortgage', Icons.home_work, const Color(0xFF8D6E63)),
//   CategoryItem('Property Tax', Icons.request_quote, const Color(0xFFA1887F)),
//   CategoryItem('Home Repair', Icons.construction, const Color(0xFFBCAAA4)),
//   CategoryItem('HOA Fees', Icons.apartment, const Color(0xFFD7CCC8)),

//   // Health & Fitness
//   CategoryItem('Health', Icons.local_hospital, const Color(0xFFF44336)),
//   CategoryItem('Doctor', Icons.medical_services, const Color(0xFFEF5350)),
//   CategoryItem('Pharmacy', Icons.medication, const Color(0xFFE57373)),
//   CategoryItem('Dental', Icons.health_and_safety, const Color(0xFFEF9A9A)),
//   CategoryItem('Vision', Icons.visibility, const Color(0xFFFFCDD2)),
//   CategoryItem('Gym', Icons.fitness_center, const Color(0xFF4CAF50)),
//   CategoryItem('Yoga', Icons.self_improvement, const Color(0xFF66BB6A)),
//   CategoryItem('Sports', Icons.sports_basketball, const Color(0xFF81C784)),

//   // Entertainment
//   CategoryItem('Entertainment', Icons.movie, const Color(0xFF9C27B0)),
//   CategoryItem('Movies', Icons.theaters, const Color(0xFFAB47BC)),
//   CategoryItem('Concerts', Icons.music_note, const Color(0xFFBA68C8)),
//   CategoryItem('Games', Icons.sports_esports, const Color(0xFFCE93D8)),
//   CategoryItem('Hobbies', Icons.palette, const Color(0xFFE1BEE7)),
//   CategoryItem('Books', Icons.menu_book, const Color(0xFF8E24AA)),
//   CategoryItem('Music', Icons.headphones, const Color(0xFF7B1FA2)),

//   // Travel
//   CategoryItem('Travel', Icons.flight, const Color(0xFF00BCD4)),
//   CategoryItem('Hotel', Icons.hotel, const Color(0xFF26C6DA)),
//   CategoryItem('Flights', Icons.flight_takeoff, const Color(0xFF4DD0E1)),
//   CategoryItem('Vacation', Icons.beach_access, const Color(0xFF80DEEA)),
//   CategoryItem('Tours', Icons.tour, const Color(0xFFB2EBF2)),

//   // Education
//   CategoryItem('Education', Icons.school, const Color(0xFF2196F3)),
//   CategoryItem('Tuition', Icons.account_balance, const Color(0xFF42A5F5)),
//   CategoryItem('Books', Icons.import_contacts, const Color(0xFF64B5F6)),
//   CategoryItem('Courses', Icons.class_, const Color(0xFF90CAF9)),
//   CategoryItem('Supplies', Icons.create, const Color(0xFFBBDEFB)),

//   // Insurance
//   CategoryItem('Insurance', Icons.security, const Color(0xFF607D8B)),
//   CategoryItem(
//     'Health Insurance',
//     Icons.health_and_safety,
//     const Color(0xFF78909C),
//   ),
//   CategoryItem('Life Insurance', Icons.favorite, const Color(0xFF90A4AE)),
//   CategoryItem('Home Insurance', Icons.cottage, const Color(0xFFB0BEC5)),

//   // Personal Care
//   CategoryItem(
//     'Personal Care',
//     Icons.face_retouching_natural,
//     const Color(0xFFFF9800),
//   ),
//   CategoryItem('Haircut', Icons.content_cut, const Color(0xFFFFA726)),
//   CategoryItem('Spa', Icons.spa, const Color(0xFFFFB74D)),
//   CategoryItem('Skincare', Icons.clean_hands, const Color(0xFFFFCC80)),

//   // Pets
//   CategoryItem('Pets', Icons.pets, const Color(0xFF8BC34A)),
//   CategoryItem('Pet Food', Icons.set_meal, const Color(0xFF9CCC65)),
//   CategoryItem('Vet', Icons.local_hospital, const Color(0xFFAED581)),
//   CategoryItem(
//     'Pet Supplies',
//     Icons.shopping_basket,
//     const Color(0xFFC5E1A5),
//   ),

//   // Financial
//   CategoryItem('Savings', Icons.savings, const Color(0xFF673AB7)),
//   CategoryItem('Investment', Icons.trending_up, const Color(0xFF7E57C2)),
//   CategoryItem('Loan Payment', Icons.payment, const Color(0xFF9575CD)),
//   CategoryItem('Credit Card', Icons.credit_card, const Color(0xFFB39DDB)),
//   CategoryItem('Bank Fees', Icons.account_balance, const Color(0xFFD1C4E9)),

//   // Charity & Gifts
//   CategoryItem('Charity', Icons.volunteer_activism, const Color(0xFFE91E63)),
//   CategoryItem('Donation', Icons.loyalty, const Color(0xFFF06292)),
//   CategoryItem('Gifts', Icons.redeem, const Color(0xFFF48FB1)),

//   // Kids
//   CategoryItem('Kids', Icons.child_care, const Color(0xFFFFEB3B)),
//   CategoryItem(
//     'Childcare',
//     Icons.baby_changing_station,
//     const Color(0xFFFFF176),
//   ),
//   CategoryItem('Toys', Icons.toys, const Color(0xFFFFF59D)),
//   CategoryItem('Activities', Icons.celebration, const Color(0xFFFFFDE7)),

//   // Other
//   CategoryItem('Subscriptions', Icons.subscriptions, const Color(0xFF00BCD4)),
//   CategoryItem('Software', Icons.computer, const Color(0xFF26C6DA)),
//   CategoryItem('Maintenance', Icons.build, const Color(0xFF455A64)),
//   CategoryItem('Legal', Icons.gavel, const Color(0xFF37474F)),
//   CategoryItem('Tax', Icons.request_page, const Color(0xFF263238)),
//   CategoryItem('Other', Icons.more_horiz, const Color(0xFF9E9E9E)),
// ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         selectedCategories.clear();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void toggleCategory(String category) {
//     setState(() {
//       if (isMultipleMode) {
//         if (selectedCategories.contains(category)) {
//           selectedCategories.remove(category);
//         } else {
//           selectedCategories.add(category);
//         }
//       } else {
//         if (selectedCategories.contains(category)) {
//           selectedCategories.clear();
//         } else {
//           selectedCategories = {category};
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Text(
//           'Select Category',
//           style: TextStyle(
//             color: Color(0xFF2D3748),
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF5F7FA),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: TabBar(
//               controller: _tabController,
//               indicator: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               labelColor: const Color(0xFF2D3748),
//               unselectedLabelColor: const Color(0xFF718096),
//               labelStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//               tabs: const [
//                 Tab(text: 'Income'),
//                 Tab(text: 'Expense'),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildCategoryGrid(incomeCategories),
//                 _buildCategoryGrid(expenseCategories),
//               ],
//             ),
//           ),
//           _buildBottomSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryGrid(List<CategoryItem> categories) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(20),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         childAspectRatio: 0.85,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//       ),
//       itemCount: categories.length,
//       itemBuilder: (context, index) {
//         final category = categories[index];
//         final isSelected = selectedCategories.contains(category.name);

//         return GestureDetector(
//           onTap: () => toggleCategory(category.name),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 width: 64,
//                 height: 64,
//                 decoration: BoxDecoration(
//                   color: isSelected ? category.color : Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: isSelected
//                           ? category.color.withOpacity(0.3)
//                           : Colors.black.withOpacity(0.05),
//                       blurRadius: isSelected ? 12 : 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   category.icon,
//                   size: 32,
//                   color: isSelected ? Colors.white : category.color,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 category.name,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                   color: isSelected
//                       ? const Color(0xFF2D3748)
//                       : const Color(0xFF718096),
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBottomSection() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildModeButton('Single', !isMultipleMode, () {
//                   setState(() {
//                     isMultipleMode = false;
//                     if (selectedCategories.length > 1) {
//                       selectedCategories = {selectedCategories.first};
//                     }
//                   });
//                 }),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildModeButton('Multiple', isMultipleMode, () {
//                   setState(() {
//                     isMultipleMode = true;
//                   });
//                 }),
//               ),
//             ],
//           ),
//           if (selectedCategories.isNotEmpty) ...[
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF5F7FA),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.check_circle,
//                     color: Color(0xFF4CAF50),
//                     size: 20,
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       '${selectedCategories.length} ${selectedCategories.length == 1 ? 'category' : 'categories'} selected: ${selectedCategories.join(', ')}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Color(0xFF2D3748),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildModeButton(String label, bool isActive, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           color: isActive ? const Color(0xFF2196F3) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isActive ? const Color(0xFF2196F3) : const Color(0xFFE2E8F0),
//             width: 2,
//           ),
//           boxShadow: isActive
//               ? [
//                   BoxShadow(
//                     color: const Color(0xFF2196F3).withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ]
//               : [],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isActive ? Icons.radio_button_checked : Icons.radio_button_off,
//               color: isActive ? Colors.white : const Color(0xFF718096),
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: isActive ? Colors.white : const Color(0xFF718096),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CategoryItem {
//   final String name;
//   final IconData icon;
//   final Color color;

//   CategoryItem(this.name, this.icon, this.color);
// }