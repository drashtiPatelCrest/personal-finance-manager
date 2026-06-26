/// Supported currency options for the application.
abstract final class CurrencyConstants {
  static const String defaultCurrencyCode = 'USD';

  static const List<CurrencyOption> supportedCurrencies = [
    CurrencyOption(code: 'USD', symbol: r'$', nameKey: 'settingsCurrencyUsd'),
    CurrencyOption(code: 'EUR', symbol: '€', nameKey: 'settingsCurrencyEur'),
    CurrencyOption(code: 'GBP', symbol: '£', nameKey: 'settingsCurrencyGbp'),
    CurrencyOption(code: 'INR', symbol: '₹', nameKey: 'settingsCurrencyInr'),
    CurrencyOption(code: 'JPY', symbol: '¥', nameKey: 'settingsCurrencyJpy'),
    CurrencyOption(code: 'CAD', symbol: r'CA$', nameKey: 'settingsCurrencyCad'),
    CurrencyOption(code: 'AUD', symbol: r'A$', nameKey: 'settingsCurrencyAud'),
  ];

  static CurrencyOption? findByCode(String code) {
    for (final currency in supportedCurrencies) {
      if (currency.code == code) {
        return currency;
      }
    }
    return null;
  }

  static String symbolForCode(String code) {
    return findByCode(code)?.symbol ?? r'$';
  }
}

class CurrencyOption {
  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.nameKey,
  });

  final String code;
  final String symbol;
  final String nameKey;
}
