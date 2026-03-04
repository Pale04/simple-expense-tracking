import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain_models/category.dart';

class TransactionCard extends StatelessWidget {
  final String _title;
  final IconData _icon;
  final DateTime _date;
  final String _currencySymbol;
  final double _amount;
  final void Function() _onExpenseTapped;
  final Category? _category;

  const TransactionCard({
    super.key,
    required String title,
    required IconData icon,
    required DateTime date,
    required String currencySymbol,
    required double amount,
    required void Function() onExpenseTapped,
    Category? category
  }) : _title = title,
        _icon = icon,
        _date = date,
        _currencySymbol = currencySymbol,
        _amount = amount,
        _onExpenseTapped = onExpenseTapped,
        _category = category;

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
            spacing: 10,
            children: [
              Icon(_icon),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.labelLarge
                    ),
                    Row (
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM dd').format(_date),
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey),
                        ),
                        ? _category != null ? Container (
                          decoration: BoxDecoration(
                            color: Color(_category.color.hexCode),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          padding: EdgeInsetsGeometry.symmetric(vertical: 2, horizontal: 8),
                          child: Text(_category.name),
                        ) : null
                      ],
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