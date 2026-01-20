import 'package:logging/logging.dart';
import 'package:simple_expense_tracking/data/repositories/income/income_repository.dart';
import 'package:simple_expense_tracking/utils/constants.dart';
import 'package:simple_expense_tracking/domain_models/income.dart';
import 'package:sqflite/sqflite.dart';

class IncomeRepositoryLocal extends IncomeRepository {
  final Database _database;
  final _log = Logger('IncomeRepositoryLocal');

  IncomeRepositoryLocal({required Database database}) : _database = database;

  @override
  Future<int> addIncome(Income income) async {
    int id;
    try {
      id = await _database.insert(
          incomesTableName,
          income.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore
      );
    } on DatabaseException catch (error) {
      _log.warning('Income insertion failed', error);
      id = -1;
    }
    return id;
  }
}