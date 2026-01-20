import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import '../../data/repositories/expense/expense_repository.dart';

class SummaryScreenViewModel extends ChangeNotifier{
  final _logger = Logger('SummaryScreenViewModel');
  final ExpenseRepository _repository;

  double totalSpent = 0.0;

  SummaryScreenViewModel({required ExpenseRepository repository}) : _repository = repository {
    init();
  }

  Future<void> init() async {
    await getTotalSpent();
    notifyListeners();
  }

  Future<void> getTotalSpent() async {
    totalSpent = await _repository.getTotalSpent();
  }
}