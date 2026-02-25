import 'package:flutter/cupertino.dart';
import '../../data/repositories/category/category_repository.dart';
import '../../domain_models/category.dart';

class CategoriesScreenViewModel extends ChangeNotifier {
  final CategoryRepository _repository;

  List<Category> expenseCategories = List.empty();

  CategoriesScreenViewModel({required CategoryRepository repository}) : _repository = repository {
    getCategories();
  }

  void getCategories() async {
    expenseCategories = await _repository.getAllCategories();
    notifyListeners();
  }

  void addCategory(Category category) async {
    await _repository.addExpenseCategory(category);
    getCategories();
  }

  void deleteCategory(int id) async {
    await _repository.deleteExpenseCategory(id);
    getCategories();
  }
}