import 'package:flutter/cupertino.dart';
import 'package:simple_expense_tracking/data/repositories/category/category_repository.dart';
import '../../domain_models/category.dart';

class ExpenseRegistrationBottomSheetViewModel extends ChangeNotifier {
  final CategoryRepository _categoryRepository;

  List<Category> _categoriesList = [];
  late Category _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;

  List<Category> get categoriesList => _categoriesList;
  Category get selectedCategory => _selectedCategory;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  ExpenseRegistrationBottomSheetViewModel({required CategoryRepository categoryRepository}) : _categoryRepository = categoryRepository {
    getCategoriesList();
  }

  Future<void> getCategoriesList() async {
    _categoriesList = await _categoryRepository.getAllCategories();
    _selectedCategory = _categoriesList.first;
    _isLoading = false;
    notifyListeners();
  }

  void setSelectedCategory(Category? category) {
    _selectedCategory = category ?? _selectedCategory;
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
  }
}