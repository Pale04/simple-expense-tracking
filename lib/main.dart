import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_expense_tracking/data/local_db.dart';
import 'package:simple_expense_tracking/data/repositories/category/category_repository.dart';
import 'package:simple_expense_tracking/data/repositories/category/category_repository_local.dart';
import 'package:simple_expense_tracking/data/repositories/expense/expense_repository.dart';
import 'package:simple_expense_tracking/data/repositories/expense/expense_repository_local.dart';
import 'package:simple_expense_tracking/data/repositories/income/income_repository.dart';
import 'package:simple_expense_tracking/data/repositories/income/income_repository_local.dart';
import 'package:simple_expense_tracking/data/repositories/settings/settings_repository.dart';
import 'package:simple_expense_tracking/routing/router.dart';
import 'package:simple_expense_tracking/ui/categories/categories_screen_view_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Database database = await initializeLocalDb();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //TODO: create a development main with this configuration exclusively
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) => print('[ROOT] ${record.message}'));

  Command.reportAllExceptions = true;
  Command.globalExceptionHandler = (ex, stack) {
    print(ex.toString());
    print(stack.toString());
  };

  runApp(
    MultiProvider(
      providers: [
        Provider<Database>(create: (context) =>  database),
        Provider<ExpenseRepository>(create: (context) => ExpenseRepositoryLocal(database: context.read()) as ExpenseRepository),
        Provider<IncomeRepository>(create: (context) => IncomeRepositoryLocal(database: context.read()) as IncomeRepository),
        Provider<SettingsRepository>(create: (context) => SettingsRepository(sharedPreferences: sharedPreferences)),
        Provider<CategoryRepository>(create: (context) => CategoryRepositoryLocal(database: context.read()) as CategoryRepository,)
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Simple Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff398259)
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.openSans(
            fontWeight: FontWeight.bold
          )
        )
      ),
      routerConfig: router(),
    );
  }
}