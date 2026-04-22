import 'package:intl/intl.dart';
import 'package:spendio/core/data/models/currency_model.dart';
import 'package:spendio/core/services/app_prefs.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formats an amount using the user's preferred currency symbol.
  /// Example: "$ 1,234.56" or "₨ 1,234.56"
  static String format(double amount, {int decimalDigits = 2}) {
    final currencyCode = AppPrefs.instance.userCurrency;
    final currency = CurrencyList.findByCode(currencyCode);
    final symbol = currency?.symbol ?? r'$';

    final formatter = NumberFormat.currency(
      symbol: '$symbol ',
      decimalDigits: decimalDigits,
    );

    return formatter.format(amount);
  }

  /// Returns only the currency symbol for the current user.
  static String get symbol {
    final currencyCode = AppPrefs.instance.userCurrency;
    final currency = CurrencyList.findByCode(currencyCode);
    return currency?.symbol ?? r'$';
  }
}
