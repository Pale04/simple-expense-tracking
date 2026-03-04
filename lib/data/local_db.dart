import 'package:path/path.dart';
import 'package:simple_expense_tracking/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initializeLocalDb() async {
  return await openDatabase(
    join(await getDatabasesPath(), databaseName),
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE categories(
          id INTEGER PRIMARY KEY, 
          name TEXT NOT NULL, 
          color INTEGER NOT NULL
         )
      ''');
      await db.execute('''
        CREATE TABLE expenses(
          id INTEGER PRIMARY KEY, 
          title TEXT NOT NULL, 
          amount REAL NOT NULL, 
          date TEXT NOT NULL,
          category_id INTEGER NOT NULL,
          FOREIGN KEY (category_id) REFERENCES categories (id)
        )''');
      await db.execute('''
        CREATE TABLE income(
          id INTEGER PRIMARY KEY, 
          title TEXT NOT NULL, 
          amount REAL NOT NULL, 
          date TEXT NOT NULL
        )''');

      Batch batch = db.batch();
      batch.insert(categoriesTableName, {
        'id': 1,
        'name': 'Unknow',
        'color': 0
      });
      await batch.commit(noResult: true);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      //await deleteDatabase(join(await getDatabasesPath(), databaseName));
    },
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },
    version: 12,
  );
}