import 'package:flutter/material.dart';
import 'package:simple_expense_tracking/ui/expenses_history/expenses_history_screen_view_model.dart';
import 'expense_card.dart';

class ExpensesHistoryScreen extends StatefulWidget {
  final ExpensesHistoryScreenViewModel _viewModel;

  const ExpensesHistoryScreen({super.key, required ExpensesHistoryScreenViewModel viewModel}) : _viewModel = viewModel;

  @override
  State<StatefulWidget> createState() => _ExpensesHistoryScreenState();
}

class _ExpensesHistoryScreenState extends State<ExpensesHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget._viewModel,
      builder: (context, child) {
        return ListView.builder(
          itemCount: widget._viewModel.expenses.length,
          itemBuilder: (context, i) {
            return ExpenseCard(
              expense: widget._viewModel.expenses[i],
              onExpenseTapped: (expenseId) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('Options'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            widget._viewModel.deleteExpense(expenseId);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'),
                        )
                      ],
                    );
                  }
                );
              },
            );
          }
        );
      }
    );
  }
}