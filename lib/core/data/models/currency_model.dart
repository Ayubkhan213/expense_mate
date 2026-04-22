import 'package:spendio/core/domain/entity/currency_entity.dart';

class CurrencyModel extends CurrencyEntity {
  const CurrencyModel({
    required super.code,
    required super.name,
    required super.symbol,
    required super.flag,
  });

  factory CurrencyModel.fromMap(Map<String, dynamic> map) => CurrencyModel(
    code: map['code'] as String,
    name: map['name'] as String,
    symbol: map['symbol'] as String,
    flag: map['flag'] as String,
  );

  Map<String, dynamic> toMap() => {
    'code': code,
    'name': name,
    'symbol': symbol,
    'flag': flag,
  };

  factory CurrencyModel.fromEntity(CurrencyEntity e) =>
      CurrencyModel(code: e.code, name: e.name, symbol: e.symbol, flag: e.flag);
}

// ── Pre-defined currency list ─────────────────────────────────────────────────
class CurrencyList {
  static final List<CurrencyModel> currencies = [
    // Major Currencies
    const CurrencyModel(
      code: 'USD',
      name: 'US Dollar',
      symbol: '\$',
      flag: '🇺🇸',
    ),
    const CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺'),
    const CurrencyModel(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      flag: '🇬🇧',
    ),
    const CurrencyModel(
      code: 'JPY',
      name: 'Japanese Yen',
      symbol: '¥',
      flag: '🇯🇵',
    ),
    const CurrencyModel(
      code: 'CNY',
      name: 'Chinese Yuan',
      symbol: '¥',
      flag: '🇨🇳',
    ),

    // South Asian Currencies
    const CurrencyModel(
      code: 'PKR',
      name: 'Pakistani Rupee',
      symbol: '₨',
      flag: '🇵🇰',
    ),
    const CurrencyModel(
      code: 'INR',
      name: 'Indian Rupee',
      symbol: '₹',
      flag: '🇮🇳',
    ),
    const CurrencyModel(
      code: 'BDT',
      name: 'Bangladeshi Taka',
      symbol: '৳',
      flag: '🇧🇩',
    ),
    const CurrencyModel(
      code: 'LKR',
      name: 'Sri Lankan Rupee',
      symbol: 'Rs',
      flag: '🇱🇰',
    ),
    const CurrencyModel(
      code: 'NPR',
      name: 'Nepalese Rupee',
      symbol: 'Rs',
      flag: '🇳🇵',
    ),

    // Middle Eastern Currencies
    const CurrencyModel(
      code: 'AED',
      name: 'UAE Dirham',
      symbol: 'د.إ',
      flag: '🇦🇪',
    ),
    const CurrencyModel(
      code: 'SAR',
      name: 'Saudi Riyal',
      symbol: 'ر.س',
      flag: '🇸🇦',
    ),
    const CurrencyModel(
      code: 'QAR',
      name: 'Qatari Riyal',
      symbol: 'ر.ق',
      flag: '🇶🇦',
    ),
    const CurrencyModel(
      code: 'KWD',
      name: 'Kuwaiti Dinar',
      symbol: 'د.ك',
      flag: '🇰🇼',
    ),
    const CurrencyModel(
      code: 'OMR',
      name: 'Omani Rial',
      symbol: 'ر.ع.',
      flag: '🇴🇲',
    ),

    // Other Popular Currencies
    const CurrencyModel(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: 'A\$',
      flag: '🇦🇺',
    ),
    const CurrencyModel(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: 'C\$',
      flag: '🇨🇦',
    ),
    const CurrencyModel(
      code: 'CHF',
      name: 'Swiss Franc',
      symbol: 'Fr',
      flag: '🇨🇭',
    ),
    const CurrencyModel(
      code: 'SGD',
      name: 'Singapore Dollar',
      symbol: 'S\$',
      flag: '🇸🇬',
    ),
    const CurrencyModel(
      code: 'MYR',
      name: 'Malaysian Ringgit',
      symbol: 'RM',
      flag: '🇲🇾',
    ),
    const CurrencyModel(
      code: 'THB',
      name: 'Thai Baht',
      symbol: '฿',
      flag: '🇹🇭',
    ),
    const CurrencyModel(
      code: 'IDR',
      name: 'Indonesian Rupiah',
      symbol: 'Rp',
      flag: '🇮🇩',
    ),
    const CurrencyModel(
      code: 'PHP',
      name: 'Philippine Peso',
      symbol: '₱',
      flag: '🇵🇭',
    ),
    const CurrencyModel(
      code: 'KRW',
      name: 'South Korean Won',
      symbol: '₩',
      flag: '🇰🇷',
    ),
    const CurrencyModel(
      code: 'TRY',
      name: 'Turkish Lira',
      symbol: '₺',
      flag: '🇹🇷',
    ),
    const CurrencyModel(
      code: 'ZAR',
      name: 'South African Rand',
      symbol: 'R',
      flag: '🇿🇦',
    ),
    const CurrencyModel(
      code: 'BRL',
      name: 'Brazilian Real',
      symbol: 'R\$',
      flag: '🇧🇷',
    ),
    const CurrencyModel(
      code: 'MXN',
      name: 'Mexican Peso',
      symbol: 'Mex\$',
      flag: '🇲🇽',
    ),
    const CurrencyModel(
      code: 'RUB',
      name: 'Russian Ruble',
      symbol: '₽',
      flag: '🇷🇺',
    ),
  ];

  static CurrencyModel? findByCode(String code) {
    try {
      return currencies.firstWhere((c) => c.code == code);
    } catch (_) {
      return null;
    }
  }
}
