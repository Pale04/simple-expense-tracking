import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_expense_tracking/domain_models/currency.dart';

class SettingsRepository {
  final SharedPreferences _sharedPreferences;

  const SettingsRepository({required sharedPreferences}) : _sharedPreferences = sharedPreferences;

  void updateCurrencySign(Currency currency) async {
    await _sharedPreferences.setInt('currency', currency.index);
  }

  Currency getCurrencySign() {
    Object? storedCurrencyIndex = _sharedPreferences.get('currency');
    int currencyIndex = 0;

    if (storedCurrencyIndex != null) {
      currencyIndex = storedCurrencyIndex as int;
    }

    return Currency.values[currencyIndex];
  }
}