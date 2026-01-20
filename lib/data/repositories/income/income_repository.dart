import 'package:simple_expense_tracking/domain_models/income.dart';

abstract class IncomeRepository {
  Future<int> addIncome(Income income);
}