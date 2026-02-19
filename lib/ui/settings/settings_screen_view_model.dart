import 'package:flutter/cupertino.dart';
import 'package:simple_expense_tracking/data/repositories/settings/settings_repository.dart';
import 'package:simple_expense_tracking/domain_models/currency.dart';

class SettingsScreenViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  late Currency currency;

  SettingsScreenViewModel({required SettingsRepository settingsRepository}) : _settingsRepository = settingsRepository {
    currency = settingsRepository.getCurrencySign();
  }

  void updateCurrency(Currency selectedCurrency) {
    if(selectedCurrency != currency) {
      _settingsRepository.updateCurrencySign(selectedCurrency);
      currency = selectedCurrency;
      notifyListeners();
    }
  }
}