import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:simple_expense_tracking/data/repositories/income/income_repository.dart';
import 'package:simple_expense_tracking/data/repositories/settings/settings_repository.dart';
import 'package:simple_expense_tracking/domain_models/currency.dart';
import 'package:simple_expense_tracking/domain_models/expense.dart';
import 'package:simple_expense_tracking/domain_models/income.dart';
import '../../data/repositories/expense/expense_repository.dart';

class HistoryScreenViewModel extends ChangeNotifier {
  final _logger = Logger('HistoryScreenViewModel');
  final ExpenseRepository _expenseRepository;
  final IncomeRepository _incomeRepository;

  List<DateTime> dateRange = [DateTime.now(), DateTime.now()];
  int actualTab = 0;
  List<Expense> expensesList = List.empty();
  List<Income> incomeList = List.empty();
  late Currency currency;

  HistoryScreenViewModel({
    required ExpenseRepository expenseRepository,
    required IncomeRepository incomeRepository,
    required SettingsRepository settingsRepository
  }) : _expenseRepository = expenseRepository, _incomeRepository = incomeRepository {
    _expenseRepository.getExpensesByDatesRange(dateRange[0], dateRange[1])
      .then((list) {
        expensesList = list;
        notifyListeners();
      });

    currency = settingsRepository.getCurrencySign();
  }

  void updateActualTab(int tab) async {
    actualTab = tab;
    if (tab == 0) {
      expensesList = await _expenseRepository.getExpensesByDatesRange(dateRange[0], dateRange[1]);
    } else {
      incomeList = await _incomeRepository.getIncomeByDateRange(dateRange[0], dateRange[1]);
    }
    notifyListeners();
  }

  void getExpensesList(DateTime from, DateTime to) async {
    dateRange = [from, to];
    expensesList = await _expenseRepository.getExpensesByDatesRange(from, to);
    notifyListeners();
  }

  void getIncomeList(DateTime from, DateTime to) async {
    dateRange = [from, to];
    incomeList = await _incomeRepository.getIncomeByDateRange(from, to);
    notifyListeners();
  }

  void deleteExpense(expenseId) async {
    await _expenseRepository.deleteExpense(expenseId);
    getExpensesList(dateRange[0], dateRange[1]);
  }

  void deleteIncome(incomeId) async {
    await _incomeRepository.deleteIncome(incomeId);
    getIncomeList(dateRange[0], dateRange[1]);
  }
}