import 'package:flutter/material.dart';
import 'package:simple_expense_tracking/domain_models/expense.dart';
import 'package:simple_expense_tracking/ui/history/transaction_card.dart';

class ExpenseCard extends StatelessWidget {
  final Expense _expense;
  final String _currencySymbol;
  final void Function(int) _onExpenseTapped;

  const ExpenseCard({
    super.key,
    required Expense expense,
    required String currencySymbol,
    required void Function(int) onExpenseTapped
  }) : _expense = expense, _currencySymbol = currencySymbol, _onExpenseTapped = onExpenseTapped;

  @override
  Widget build(BuildContext context) {
    return TransactionCard(
      title: _expense.title,
      icon: Icons.shopping_bag_outlined,
      date: _expense.date,
      currencySymbol: _currencySymbol,
      amount: _expense.amount,
      onExpenseTapped: () => _onExpenseTapped(_expense.id!)
    );
  }
}