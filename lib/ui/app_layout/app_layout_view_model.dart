import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:simple_expense_tracking/data/repositories/expense/expense_repository.dart';
import 'package:simple_expense_tracking/data/repositories/income/income_repository.dart';
import 'package:simple_expense_tracking/domain_models/expense.dart';
import 'package:simple_expense_tracking/routing/routes.dart';
import 'package:simple_expense_tracking/domain_models/income.dart';

class AppLayoutViewModel extends ChangeNotifier {
  final _logger = Logger('HomeScreenViewModel');
  final BuildContext _context;
  final ExpenseRepository _expenseRepository;
  final IncomeRepository _incomeRepository;

  String message = '';
  int page = 0;

  AppLayoutViewModel({
    required ExpenseRepository expenseRepository,
    required IncomeRepository incomeRepository,
    required context}
  ) : _expenseRepository = expenseRepository, _incomeRepository = incomeRepository, _context = context {
    final String location = GoRouterState.of(context).uri.path;
    if (location == Routes.summaryScreen) {
      page = 0;
    } else {
      page = 1;
    }
  }

  void changePage(int page) {
    switch (page) {
      case 0:
        GoRouter.of(_context).go(Routes.summaryScreen);
      case 1:
        GoRouter.of(_context).go(Routes.expensesHistory);
    }
  }

  Future<void> addExpense(Expense expense) async {
    int result = await _expenseRepository.addExpense(expense);
    message = result != 0 ? 'Expense saved successfully' : 'An error occurred. Please attempt again later';
    notifyListeners();
  }
  
  Future<void> addIncome(Income income) async {
    int result = await _incomeRepository.addIncome(income);
    message = result != 0 ? 'Income saved successfully' : 'An error occurred. Please attempt again later';
    notifyListeners();
  }
}