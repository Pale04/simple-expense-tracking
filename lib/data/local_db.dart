import 'package:path/path.dart';
import 'package:simple_expense_tracking/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initializeLocalDb() async {
  return await openDatabase(
    join(await getDatabasesPath(), databaseName),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE expenses(id INTEGER PRIMARY KEY, title TEXT, amount REAL, date TEXT)',
      );
    },
    version: 1,
  );
}