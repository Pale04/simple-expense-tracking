import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:simple_expense_tracking/data/local_db.dart';
import 'package:simple_expense_tracking/data/repositories/expense/expense_repository.dart';
import 'package:simple_expense_tracking/data/repositories/expense/expense_repository_local.dart';
import 'package:simple_expense_tracking/data/repositories/income/income_repository.dart';
import 'package:simple_expense_tracking/data/repositories/income/income_repository_local.dart';
import 'package:simple_expense_tracking/routing/router.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Database database = await initializeLocalDb();

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