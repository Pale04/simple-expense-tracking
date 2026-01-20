import 'package:flutter/cupertino.dart';
import 'package:simple_expense_tracking/data/repositories/expense/expense_repository.dart';
import 'package:simple_expense_tracking/domain_models/expense.dart';

class ExpensesHistoryScreenViewModel extends ChangeNotifier {
  final ExpenseRepository _repository;
  List<Expense> expenses = List.empty();

  ExpensesHistoryScreenViewModel({required ExpenseRepository repository}) : _repository = repository {
    init();
  }

  Future<void> init() async {
    await getAllExpenses();
    notifyListeners();
  }

  Future<void> getAllExpenses() async {
    expenses = await _repository.getExpenses(DateTime.now(), 20);
  }

  Future<void> deleteExpense(int id) async {
    await _repository.deleteExpense(id);
    await getAllExpenses();
    notifyListeners();
  }
}