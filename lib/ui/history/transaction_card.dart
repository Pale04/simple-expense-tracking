import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final String _title;
  final IconData _icon;
  final DateTime _date;
  final String _currencySymbol;
  final double _amount;
  final void Function() _onExpenseTapped;

  const TransactionCard({
    super.key,
    required String title,
    required IconData icon,
    required DateTime date,
    required String currencySymbol,
    required double amount,
    required void Function() onExpenseTapped
  }) : _title = title, _icon = icon, _date = date, _currencySymbol = currencySymbol, _amount = amount, _onExpenseTapped = onExpenseTapped;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 10),
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.onTertiary,
        onTap: _onExpenseTapped,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 8, 14, 8),
          child: Row(
            spacing: 8,
            children: [
              Icon(_icon),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.labelLarge
                    ),
                    Text(
                      DateFormat('dd/MMMM/yyyy').format(_date),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey),
                    )
                  ],
                ),
              ),
              Text(
                "$_currencySymbol ${_amount.toString()}",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}