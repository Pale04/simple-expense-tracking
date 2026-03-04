import 'package:flutter/material.dart';
import 'package:simple_expense_tracking/data/repositories/category/category_repository.dart';
import 'package:simple_expense_tracking/data/repositories/expense/expense_repository.dart';
import '../../domain_models/category.dart';
import '../../domain_models/expense.dart';

class ExpenseEditingFormViewModel extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;
  final CategoryRepository _categoryRepository;

  late Expense _expense;
  List<Category> _categoriesList = [];
  bool _categoriesLoading = true;

  Expense get expense => _expense;
  List<Category> get categoriesList => _categoriesList;
  bool get categoriesLoading => _categoriesLoading;

  ExpenseEditingFormViewModel({
    required ExpenseRepository expenseRepository,
    required CategoryRepository categoryRepository,
    required Expense expense
  }) : _expenseRepository = expenseRepository, _categoryRepository = categoryRepository {
    _expense = expense;
    getCategoriesList();
  }

  void getCategoriesList() async {
    _categoriesList = await _categoryRepository.getAllCategories();
    _categoriesList.removeWhere((category) => category.id == _expense.category.id);
    _categoriesList.insert(0, expense.category);
    _categoriesLoading = false;
    notifyListeners();
  }

  void saveChanges() {
    _expenseRepository.updateExpense(_expense);
  }
}