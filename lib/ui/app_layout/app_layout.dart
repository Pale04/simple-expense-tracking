import 'package:flutter/material.dart';
import 'package:simple_expense_tracking/ui/expense_registration/expense_registration_bottom_sheet.dart';
import 'package:simple_expense_tracking/ui/app_layout/app_layout_view_model.dart';
import 'package:simple_expense_tracking/ui/income_registration/income_registration_bottom_sheet.dart';
import 'package:simple_expense_tracking/ui/shared/expandable_fab.dart';

class AppLayout extends StatefulWidget {
  final AppLayoutViewModel _viewModel;
  final Widget _child;

  const AppLayout({super.key, required AppLayoutViewModel viewModel, required Widget child}) : _viewModel = viewModel, _child = child;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello, Pale!',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: widget._child
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          widget._viewModel.changePage(index);
        },
        indicatorColor: Theme.of(context).colorScheme.tertiary,
        selectedIndex: widget._viewModel.page,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(
              Icons.receipt_long,
              color: Theme.of(context).colorScheme.onTertiary
            ),
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Summary'
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.payments_sharp,
              color: Theme.of(context).colorScheme.onTertiary
            ),
            icon: Icon(Icons.payments_outlined),
            label: 'History'
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 70,
        children: [
          ActionButton(
            onPressed: () {
              Future<bool?> registrationResult = showModalBottomSheet<bool>(
                enableDrag: false,
                useRootNavigator: true,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (BuildContext context) => IncomeRegistrationBottomSheet(onIncomeSaved: (income) => widget._viewModel.addIncome(income))
              );

              registrationResult.then((result) {
                if (result != null) {
                  _showSnackBar();
                }
              });
            },
            icon: const Icon(Icons.savings_outlined),
          ),
          ActionButton(
            onPressed: () {
              Future<bool?> registrationResult = showModalBottomSheet<bool>(
                enableDrag: false,
                useRootNavigator: true,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (BuildContext context) => ExpenseRegistrationBottomSheet(onExpenseSaved: (expense) => widget._viewModel.addExpense(expense))
              );

              registrationResult.then((result) {
                if (result != null) {
                  _showSnackBar();
                }
              });
            },
            icon: const Icon(Icons.money_off_outlined),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: false,
    );
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget._viewModel.message),
        duration: const Duration(milliseconds: 3000),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 12.0
        ),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}