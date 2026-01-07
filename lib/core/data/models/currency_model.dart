import 'package:hive/hive.dart';

part 'currency_model.g.dart';

@HiveType(typeId: 14)
class CurrencyModel {
  @HiveField(0)
  final String code; // "USD", "PKR"

  @HiveField(1)
  final String name; // "US Dollar", "Pakistani Rupee"

  @HiveField(2)
  final String symbol; // "$", "₨"

  @HiveField(3)
  final String flag; // "🇺🇸", "🇵🇰"

  CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
  });
}

// Pre-defined currency list
class CurrencyList {
  static final List<CurrencyModel> currencies = [
    // Major Currencies
    CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '🇺🇸'),
    CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺'),
    CurrencyModel(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      flag: '🇬🇧',
    ),
    CurrencyModel(code: 'JPY', name: 'Japanese Yen', symbol: '¥', flag: '🇯🇵'),
    CurrencyModel(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', flag: '🇨🇳'),

    // South Asian Currencies
    CurrencyModel(
      code: 'PKR',
      name: 'Pakistani Rupee',
      symbol: '₨',
      flag: '🇵🇰',
    ),
    CurrencyModel(code: 'INR', name: 'Indian Rupee', symbol: '₹', flag: '🇮🇳'),
    CurrencyModel(
      code: 'BDT',
      name: 'Bangladeshi Taka',
      symbol: '৳',
      flag: '🇧🇩',
    ),
    CurrencyModel(
      code: 'LKR',
      name: 'Sri Lankan Rupee',
      symbol: 'Rs',
      flag: '🇱🇰',
    ),
    CurrencyModel(
      code: 'NPR',
      name: 'Nepalese Rupee',
      symbol: 'Rs',
      flag: '🇳🇵',
    ),

    // Middle Eastern Currencies
    CurrencyModel(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ', flag: '🇦🇪'),
    CurrencyModel(
      code: 'SAR',
      name: 'Saudi Riyal',
      symbol: 'ر.س',
      flag: '🇸🇦',
    ),
    CurrencyModel(
      code: 'QAR',
      name: 'Qatari Riyal',
      symbol: 'ر.ق',
      flag: '🇶🇦',
    ),
    CurrencyModel(
      code: 'KWD',
      name: 'Kuwaiti Dinar',
      symbol: 'د.ك',
      flag: '🇰🇼',
    ),
    CurrencyModel(
      code: 'OMR',
      name: 'Omani Rial',
      symbol: 'ر.ع.',
      flag: '🇴🇲',
    ),

    // Other Popular Currencies
    CurrencyModel(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: 'A\$',
      flag: '🇦🇺',
    ),
    CurrencyModel(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: 'C\$',
      flag: '🇨🇦',
    ),
    CurrencyModel(code: 'CHF', name: 'Swiss Franc', symbol: 'Fr', flag: '🇨🇭'),
    CurrencyModel(
      code: 'SGD',
      name: 'Singapore Dollar',
      symbol: 'S\$',
      flag: '🇸🇬',
    ),
    CurrencyModel(
      code: 'MYR',
      name: 'Malaysian Ringgit',
      symbol: 'RM',
      flag: '🇲🇾',
    ),
    CurrencyModel(code: 'THB', name: 'Thai Baht', symbol: '฿', flag: '🇹🇭'),
    CurrencyModel(
      code: 'IDR',
      name: 'Indonesian Rupiah',
      symbol: 'Rp',
      flag: '🇮🇩',
    ),
    CurrencyModel(
      code: 'PHP',
      name: 'Philippine Peso',
      symbol: '₱',
      flag: '🇵🇭',
    ),
    CurrencyModel(
      code: 'KRW',
      name: 'South Korean Won',
      symbol: '₩',
      flag: '🇰🇷',
    ),
    CurrencyModel(code: 'TRY', name: 'Turkish Lira', symbol: '₺', flag: '🇹🇷'),
    CurrencyModel(
      code: 'ZAR',
      name: 'South African Rand',
      symbol: 'R',
      flag: '🇿🇦',
    ),
    CurrencyModel(
      code: 'BRL',
      name: 'Brazilian Real',
      symbol: 'R\$',
      flag: '🇧🇷',
    ),
    CurrencyModel(
      code: 'MXN',
      name: 'Mexican Peso',
      symbol: 'Mex\$',
      flag: '🇲🇽',
    ),
    CurrencyModel(
      code: 'RUB',
      name: 'Russian Ruble',
      symbol: '₽',
      flag: '🇷🇺',
    ),
  ];

  static CurrencyModel? findByCode(String code) {
    try {
      return currencies.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }
}
