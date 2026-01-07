import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/category_item_model.dart';

class Utils {
  final List<CategoryItem> incomeCategories = [
    // Employment Income
    CategoryItem('salary', Icons.payment, const Color(0xFF4CAF50)),
    CategoryItem('bonus', Icons.stars, const Color(0xFFFFEB3B)),
    CategoryItem('commission', Icons.trending_up, const Color(0xFF8BC34A)),
    CategoryItem('tips', Icons.volunteer_activism, const Color(0xFF66BB6A)),

    // Business Income
    CategoryItem('business', Icons.business_center, const Color(0xFF2196F3)),
    CategoryItem('freelance', Icons.laptop_mac, const Color(0xFFFF9800)),
    CategoryItem('consulting', Icons.manage_accounts, const Color(0xFF03A9F4)),
    CategoryItem('selfEmployed', Icons.work, const Color(0xFF0288D1)),

    // Investment Income
    CategoryItem('investment', Icons.show_chart, const Color(0xFF9C27B0)),
    CategoryItem('dividends', Icons.account_balance, const Color(0xFFAB47BC)),
    CategoryItem('interest', Icons.savings, const Color(0xFFBA68C8)),
    CategoryItem('capitalGains', Icons.auto_graph, const Color(0xFFCE93D8)),
    CategoryItem(
      'cryptocurrency',
      Icons.currency_bitcoin,
      const Color(0xFFFF6F00),
    ),

    // Property Income
    CategoryItem('rental', Icons.home, const Color(0xFF795548)),
    CategoryItem('realEstate', Icons.domain, const Color(0xFF8D6E63)),
    CategoryItem('royalties', Icons.copyright, const Color(0xFFA1887F)),

    // Passive Income
    CategoryItem('pension', Icons.elderly, const Color(0xFF607D8B)),
    CategoryItem('socialSecurity', Icons.security, const Color(0xFF78909C)),
    CategoryItem('annuity', Icons.calendar_month, const Color(0xFF90A4AE)),
    CategoryItem(
      'trustFund',
      Icons.account_balance_wallet,
      const Color(0xFFB0BEC5),
    ),

    // Other Income
    CategoryItem('gift', Icons.card_giftcard, const Color(0xFFE91E63)),
    CategoryItem('inheritance', Icons.family_restroom, const Color(0xFFF06292)),
    CategoryItem('lottery', Icons.casino, const Color(0xFFF48FB1)),
    CategoryItem('refund', Icons.money_off, const Color(0xFF4DB6AC)),
    CategoryItem('cashback', Icons.attach_money, const Color(0xFF26A69A)),
    CategoryItem('award', Icons.emoji_events, const Color(0xFFFFD54F)),
    CategoryItem('grant', Icons.approval, const Color(0xFF81C784)),
    CategoryItem('scholarship', Icons.school, const Color(0xFF64B5F6)),
    CategoryItem('sideHustle', Icons.rocket_launch, const Color(0xFFFF7043)),
    CategoryItem('other', Icons.more_horiz, const Color(0xFF9E9E9E)),
  ];

  final List<CategoryItem> expenseCategories = [
    // Food & Dining
    CategoryItem('food', Icons.restaurant, const Color(0xFFFF5722)),
    CategoryItem('groceries', Icons.shopping_cart, const Color(0xFFFF7043)),
    CategoryItem('diningOut', Icons.restaurant_menu, const Color(0xFFFF6E40)),
    CategoryItem('fastFood', Icons.fastfood, const Color(0xFFFF9E80)),
    CategoryItem('cafe', Icons.local_cafe, const Color(0xFFFFAB91)),
    CategoryItem('delivery', Icons.delivery_dining, const Color(0xFFFFBCBC)),

    // Transportation
    CategoryItem('transport', Icons.directions_car, const Color(0xFF3F51B5)),
    CategoryItem('fuel', Icons.local_gas_station, const Color(0xFF5C6BC0)),
    CategoryItem('parking', Icons.local_parking, const Color(0xFF7986CB)),
    CategoryItem(
      'publicTransit',
      Icons.directions_bus,
      const Color(0xFF9FA8DA),
    ),
    CategoryItem('taxi/Uber', Icons.local_taxi, const Color(0xFFC5CAE9)),
    CategoryItem('carMaintenance', Icons.car_repair, const Color(0xFF536DFE)),
    CategoryItem('vehicleInsurance', Icons.car_crash, const Color(0xFF3D5AFE)),

    // Shopping
    CategoryItem('shopping', Icons.shopping_bag, const Color(0xFFE91E63)),
    CategoryItem('clothing', Icons.checkroom, const Color(0xFFF06292)),
    CategoryItem('electronics', Icons.devices, const Color(0xFFF48FB1)),
    CategoryItem('furniture', Icons.weekend, const Color(0xFFF8BBD0)),
    CategoryItem('cosmetics', Icons.face, const Color(0xFFFF4081)),
    CategoryItem('accessories', Icons.watch, const Color(0xFFC51162)),

    // Bills & Utilities
    CategoryItem('bills', Icons.receipt_long, const Color(0xFF009688)),
    CategoryItem('electricity', Icons.bolt, const Color(0xFF26A69A)),
    CategoryItem('water', Icons.water_drop, const Color(0xFF4DB6AC)),
    CategoryItem('gas', Icons.local_fire_department, const Color(0xFF80CBC4)),
    CategoryItem('internet', Icons.wifi, const Color(0xFFB2DFDB)),
    CategoryItem('phone', Icons.phone_android, const Color(0xFF00897B)),
    CategoryItem('streaming', Icons.live_tv, const Color(0xFF00796B)),

    // Housing
    CategoryItem('rent', Icons.house, const Color(0xFF795548)),
    CategoryItem('mortgage', Icons.home_work, const Color(0xFF8D6E63)),
    CategoryItem('propertyTax', Icons.request_quote, const Color(0xFFA1887F)),
    CategoryItem('homeRepair', Icons.construction, const Color(0xFFBCAAA4)),
    CategoryItem('hoaFees', Icons.apartment, const Color(0xFFD7CCC8)),

    // Health & Fitness
    CategoryItem('health', Icons.local_hospital, const Color(0xFFF44336)),
    CategoryItem('doctor', Icons.medical_services, const Color(0xFFEF5350)),
    CategoryItem('pharmacy', Icons.medication, const Color(0xFFE57373)),
    CategoryItem('dental', Icons.health_and_safety, const Color(0xFFEF9A9A)),
    CategoryItem('vision', Icons.visibility, const Color(0xFFFFCDD2)),
    CategoryItem('gym', Icons.fitness_center, const Color(0xFF4CAF50)),
    CategoryItem('yoga', Icons.self_improvement, const Color(0xFF66BB6A)),
    CategoryItem('sports', Icons.sports_basketball, const Color(0xFF81C784)),

    // Entertainment
    CategoryItem('entertainment', Icons.movie, const Color(0xFF9C27B0)),
    CategoryItem('movies', Icons.theaters, const Color(0xFFAB47BC)),
    CategoryItem('concerts', Icons.music_note, const Color(0xFFBA68C8)),
    CategoryItem('games', Icons.sports_esports, const Color(0xFFCE93D8)),
    CategoryItem('hobbies', Icons.palette, const Color(0xFFE1BEE7)),
    CategoryItem('books', Icons.menu_book, const Color(0xFF8E24AA)),
    CategoryItem('music', Icons.headphones, const Color(0xFF7B1FA2)),

    // Travel
    CategoryItem('travel', Icons.flight, const Color(0xFF00BCD4)),
    CategoryItem('hotel', Icons.hotel, const Color(0xFF26C6DA)),
    CategoryItem('flights', Icons.flight_takeoff, const Color(0xFF4DD0E1)),
    CategoryItem('vacation', Icons.beach_access, const Color(0xFF80DEEA)),
    CategoryItem('tours', Icons.tour, const Color(0xFFB2EBF2)),

    // Education
    CategoryItem('education', Icons.school, const Color(0xFF2196F3)),
    CategoryItem('tuition', Icons.account_balance, const Color(0xFF42A5F5)),
    // CategoryItem('books', Icons.import_contacts, const Color(0xFF64B5F6)),
    CategoryItem('courses', Icons.class_, const Color(0xFF90CAF9)),
    CategoryItem('supplies', Icons.create, const Color(0xFFBBDEFB)),

    // Insurance
    CategoryItem('insurance', Icons.security, const Color(0xFF607D8B)),
    CategoryItem(
      'healthInsurance',
      Icons.health_and_safety,
      const Color(0xFF78909C),
    ),
    CategoryItem('lifeInsurance', Icons.favorite, const Color(0xFF90A4AE)),
    CategoryItem('homeInsurance', Icons.cottage, const Color(0xFFB0BEC5)),

    // Personal Care
    CategoryItem(
      'personalCare',
      Icons.face_retouching_natural,
      const Color(0xFFFF9800),
    ),
    CategoryItem('haircut', Icons.content_cut, const Color(0xFFFFA726)),
    CategoryItem('spa', Icons.spa, const Color(0xFFFFB74D)),
    CategoryItem('skincare', Icons.clean_hands, const Color(0xFFFFCC80)),

    // Pets
    CategoryItem('pets', Icons.pets, const Color(0xFF8BC34A)),
    CategoryItem('petFood', Icons.set_meal, const Color(0xFF9CCC65)),
    CategoryItem('vet', Icons.local_hospital, const Color(0xFFAED581)),
    CategoryItem('petSupplies', Icons.shopping_basket, const Color(0xFFC5E1A5)),

    // Financial
    CategoryItem('savings', Icons.savings, const Color(0xFF673AB7)),
    CategoryItem('investment', Icons.trending_up, const Color(0xFF7E57C2)),
    CategoryItem('loanPayment', Icons.payment, const Color(0xFF9575CD)),
    CategoryItem('creditCard', Icons.credit_card, const Color(0xFFB39DDB)),
    CategoryItem('bankFees', Icons.account_balance, const Color(0xFFD1C4E9)),

    // Charity & Gifts
    CategoryItem('charity', Icons.volunteer_activism, const Color(0xFFE91E63)),
    CategoryItem('donation', Icons.loyalty, const Color(0xFFF06292)),
    CategoryItem('gifts', Icons.redeem, const Color(0xFFF48FB1)),

    // Kids
    CategoryItem('kids', Icons.child_care, const Color(0xFFFFEB3B)),
    CategoryItem(
      'childcare',
      Icons.baby_changing_station,
      const Color(0xFFFFF176),
    ),
    CategoryItem('toys', Icons.toys, const Color(0xFFFFF59D)),
    CategoryItem('activities', Icons.celebration, const Color(0xFFFFFDE7)),

    // Other
    CategoryItem('subscriptions', Icons.subscriptions, const Color(0xFF00BCD4)),
    CategoryItem('software', Icons.computer, const Color(0xFF26C6DA)),
    CategoryItem('maintenance', Icons.build, const Color(0xFF455A64)),
    CategoryItem('legal', Icons.gavel, const Color(0xFF37474F)),
    CategoryItem('tax', Icons.request_page, const Color(0xFF263238)),
    CategoryItem('other', Icons.more_horiz, const Color(0xFF9E9E9E)),
  ];
}
