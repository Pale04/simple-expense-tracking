import 'package:simple_expense_tracking/domain_models/income.dart';

abstract class IncomeRepository {
  Future<int> addIncome(Income income);
  Future<bool> deleteIncome(int id);
  Future<List<Income>> getIncomeByDateRange(DateTime from, DateTime to);
}