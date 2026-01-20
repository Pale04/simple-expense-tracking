import 'package:flutter/material.dart';
import 'package:simple_expense_tracking/domain_models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense _expense;
  final void Function(int) _onExpenseTapped;

  const ExpenseCard({super.key, required Expense expense, required void Function(int) onExpenseTapped}) : _expense = expense, _onExpenseTapped = onExpenseTapped;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.onTertiary,
        onTap: () {
          _onExpenseTapped(_expense.id!);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          child: Row(
            spacing: 8,
            children: [
              Icon(
                  Icons.attach_money_outlined
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(_expense.title),
                    Text(_expense.date.millisecondsSinceEpoch.toString())
                  ],
                ),
              ),
              Text(
                "\$${_expense.amount.toString()}",
              )
            ],
          ),
        ),
      ),
    );
  }
}