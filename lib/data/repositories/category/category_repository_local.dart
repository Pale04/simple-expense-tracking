import 'package:logging/logging.dart';
import 'package:simple_expense_tracking/data/repositories/category/category_repository.dart';
import 'package:simple_expense_tracking/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import '../../../domain_models/category.dart';

class CategoryRepositoryLocal extends CategoryRepository {
  final Database _database;
  final _log = Logger('CategoryRepositoryLocal');

  CategoryRepositoryLocal({required Database database}) : _database = database;

  @override
  Future<int> addExpenseCategory(Category category) async {
    int id;
    try {
      id = await _database.insert(
        categoriesTableName,
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore
      );
    } on DatabaseException catch (error) {
      _log.warning('Expense category insertion failed', error);
      id = -1;
    }
    return id;
  }

  @override
  Future<bool> deleteExpenseCategory(int id) async {
    int rowsAffected = 0;

    try {
      rowsAffected = await _database.delete(
          categoriesTableName,
          where: 'id = ?',
          whereArgs: [id]
      );
    } on DatabaseException catch (error) {
      _log.warning('Expense Category deletion failed', error);
    }

    if (rowsAffected != 1) {
      _log.warning('Expense Category deletion executed with a bad result. Rows affected: $rowsAffected');
    }

    return rowsAffected == 1;
  }

  @override
  Future<List<Category>> getAllCategories() async {
    List<Map<String, Object?>?> queryResult;
    List<Category> expenseCategories = List.empty(growable: true);

    try {
      queryResult = await _database.query(
        categoriesTableName
      );
    } on DatabaseException catch (error) {
      _log.warning('Expense Categories query failed', error);
      return expenseCategories;
    }

    for (var category in queryResult) {
      expenseCategories.add(Category.fromMap(category!));
    }

    return expenseCategories;
  }

}