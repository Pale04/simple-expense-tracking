import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:simple_expense_tracking/data/repositories/expense/expense_repository.dart';
import 'package:simple_expense_tracking/utils/constants.dart';
import 'package:simple_expense_tracking/domain_models/expense.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepositoryLocal extends ExpenseRepository {
  final Database _database;
  final _log = Logger('ExpenseRepositoryLocal');

  ExpenseRepositoryLocal({required Database database}) : _database = database;

  @override
  Future<int> addExpense(Expense expense) async {
    int id;
    try {
      id = await _database.insert(
        expensesTableName,
        expense.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore
      );
    } on DatabaseException catch (error) {
      _log.warning('Expense insertion failed', error);
      id = -1;
    }
    return id; 
  }
  
  @override
  Future<bool> deleteExpense(int id) async {
    int rowsAffected = 0;

    try {
      rowsAffected = await _database.delete(
        expensesTableName,
        where: 'id = ?',
        whereArgs: [id]
      );
    } on DatabaseException catch (error) {
      _log.warning('Expense deletion failed', error);
    }
    
    if (rowsAffected != 1) {
      _log.warning('Expense deletion executed with a bad result. Rows affected: $rowsAffected');
    } 

    return rowsAffected == 1;
  }
  
  @override
  Future<Expense?> getExpense(int id) async {
    List<Map<String, Object?>?> queryResult;
    Expense? expense;

    try {
      queryResult = await _database.query(
        expensesTableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } on DatabaseException catch (error) {
      _log.warning('Expense query falied', error);
      return expense;
    }

    if(queryResult.isNotEmpty && queryResult.firstOrNull != null) {
      expense = Expense.fromMap(queryResult.firstOrNull!);
    }

    return expense;
  }
  
  @override
  Future<bool> updateExpense(Expense expense) async {
    int rowsAffected = 0;

    try {
      rowsAffected = await _database.update(
        expensesTableName, 
        expense.toMap(),
        where: 'id = ?',
        whereArgs: [expense.id]
      );
    } on DatabaseException catch (error) {
      _log.warning('Expense update failed', error);
    }

    if (rowsAffected != 1) {
      _log.warning('Expense update executed with a bad result. Rows affected: $rowsAffected');
    } 

    return rowsAffected == 1;
  }

  @override
  Future<double> getTotalSpent() async {
    List<Map<String, Object?>?> queryResult;
    double total = 0.0;

    try {
      queryResult = await _database.rawQuery(
        'SELECT sum(amount) AS total FROM $expensesTableName'
      );
    } on DatabaseException catch (error) {
      _log.warning('Expenses sum failed', error);
      return total;
    }

    if(queryResult.isNotEmpty && queryResult.firstOrNull != null) {
      total = queryResult.firstOrNull!['total'] == null ? 0.0 : queryResult.firstOrNull!['total'] as double;
    }

    return total;
  }
  
  @override
  Future<List<Expense>> getExpenses(DateTime? cursor, int pageSize) async {
    List<Map<String, Object?>?> queryResult;
    List<Expense> expenses = List.empty(growable: true);

    try {
      queryResult = await _database.query(
        expensesTableName,
        where: 'date <= ?',
        whereArgs: [DateFormat('yyyy-MM-dd').format(cursor ?? DateTime.now())],
        orderBy: 'date',
        limit: pageSize
      );
    } on DatabaseException catch (error) {
      _log.warning('Expenses query failed', error);
      return expenses;
    }
    
    for (var expense in queryResult) {
      expenses.add(Expense.fromMap(expense!));
    }

    return expenses;
  }
}