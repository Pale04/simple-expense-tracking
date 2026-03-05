import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:simple_expense_tracking/data/repositories/settings/settings_repository.dart';
import 'package:simple_expense_tracking/domain_models/currency.dart';
import '../../data/repositories/expense/expense_repository.dart';
import '../../domain_models/expense.dart';

class SummaryScreenViewModel extends ChangeNotifier{
  final _logger = Logger('SummaryScreenViewModel');
  final ExpenseRepository _expenseRepository;

  double _totalSpent = 0.0;
  late Currency _currency;
  DateTime _statisticsDateSelected = DateTime.now().copyWith(day: 1);
  List<Expense> _monthExpenses = [];

  double get totalSpent => _totalSpent;
  Currency get currency => _currency;
  DateTime get statisticsDateSelected => _statisticsDateSelected;
  List<Expense> get monthExpenses => _monthExpenses;

  SummaryScreenViewModel({
    required ExpenseRepository expenseRepository,
    required SettingsRepository settingsRepository
  }) : _expenseRepository = expenseRepository {
    getTotalSpent();

    _getExpensesOfCurrentMonth();

    _currency = settingsRepository.getCurrencySign();
  }

  void getTotalSpent() async {
    _totalSpent = await _expenseRepository.getTotalSpent();
    notifyListeners();
  }

  void _getExpensesOfCurrentMonth() async {
    _monthExpenses = await _expenseRepository.getExpensesByDatesRange(_statisticsDateSelected, _statisticsDateSelected.copyWith(month: _statisticsDateSelected.month + 1).subtract(Duration(days: 1)));
    notifyListeners();
  }

  void setStatisticsDateSelected(DateTime dateSelected) {
    _statisticsDateSelected = dateSelected;
    _getExpensesOfCurrentMonth();
  }
}