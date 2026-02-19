import 'package:flutter/material.dart';
import 'package:simple_expense_tracking/ui/history/transaction_card.dart';
import '../../domain_models/income.dart';

class IncomeCard extends StatelessWidget {
  final Income _income;
  final String _currencySymbol;
  final void Function(int) _onCardTapped;

  const IncomeCard({
    super.key,
    required Income income,
    required String currencySymbol,
    required void Function(int) onCardTapped
  }) : _income = income, _currencySymbol = currencySymbol, _onCardTapped = onCardTapped;

  @override
  Widget build(BuildContext context) {
    return TransactionCard(
        title: _income.title,
        icon: Icons.savings_outlined,
        date: _income.date,
        currencySymbol: _currencySymbol,
        amount: _income.amount,
        onExpenseTapped: () => _onCardTapped(_income.id!)
    );
  }
}