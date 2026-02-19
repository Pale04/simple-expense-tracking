import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:simple_expense_tracking/data/repositories/settings/settings_repository.dart';
import '../../data/repositories/expense/expense_repository.dart';

class SummaryScreenViewModel extends ChangeNotifier{
  final _logger = Logger('SummaryScreenViewModel');
  final ExpenseRepository _expenseRepository;

  double totalSpent = 0.0;
  late String currency;

  SummaryScreenViewModel({
    required ExpenseRepository expenseRepository,
    required SettingsRepository settingsRepository
  }) : _expenseRepository = expenseRepository {
    init();
    currency = settingsRepository.getCurrencySign().name.toUpperCase();
  }

  Future<void> init() async {
    await getTotalSpent();
    notifyListeners();
  }

  Future<void> getTotalSpent() async {
    totalSpent = await _expenseRepository.getTotalSpent();
  }
}