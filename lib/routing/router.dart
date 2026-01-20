import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_expense_tracking/routing/routes.dart';
import 'package:simple_expense_tracking/ui/app_layout/app_layout.dart';
import 'package:simple_expense_tracking/ui/app_layout/app_layout_view_model.dart';
import 'package:simple_expense_tracking/ui/expenses_history/expenses_history_screen.dart';
import 'package:simple_expense_tracking/ui/expenses_history/expenses_history_screen_view_model.dart';
import 'package:simple_expense_tracking/ui/summary_screen/summary_screen.dart';
import 'package:simple_expense_tracking/ui/summary_screen/summary_screen_view_model.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.summaryScreen,
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        final viewModel = AppLayoutViewModel(expenseRepository: context.read(), incomeRepository: context.read(), context: context);
        return AppLayout(viewModel: viewModel, child: child);
      },
      routes: [
        GoRoute(
          path: Routes.summaryScreen,
          builder: (context, _) => SummaryScreen(viewModel: SummaryScreenViewModel(repository: context.read()))
        ),
        GoRoute(
            path: Routes.expensesHistory,
            builder: (context, _) => ExpensesHistoryScreen(viewModel: ExpensesHistoryScreenViewModel(repository: context.read()))
        )
      ]
    )
  ]
);