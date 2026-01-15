import 'package:simple_expense_tracking/domain_models/expense.dart';

abstract class ExpenseRepository {
  Future<int> addExpense(Expense expense);
  Future<bool> updateExpense(Expense expense);
  Future<bool> deleteExpense(int id);
  Future<Expense?> getExpense(int id);
  Future<List<Expense>> getExpenses(DateTime? cursor, int pageSize);
  Future<double> getTotalSpent();
}