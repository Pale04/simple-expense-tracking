import '../../../domain_models/category.dart';

abstract class CategoryRepository {
  Future<int> addExpenseCategory(Category category);
  Future<bool> deleteExpenseCategory(int id);
  Future<List<Category>> getAllCategories();
}