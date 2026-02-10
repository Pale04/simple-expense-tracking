import 'package:flutter/material.dart';
import '../../domain_models/income.dart';

class IncomeCard extends StatelessWidget {
  final Income _income;
  final void Function(int) _onCardTapped;

  const IncomeCard({
    super.key,
    required Income income,
    required void Function(int) onCardTapped}
      ) : _income = income, _onCardTapped = onCardTapped;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.onTertiary,
        onTap: () {
          _onCardTapped(_income.id!);
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
                    Text(_income.title),
                    Text(_income.date.millisecondsSinceEpoch.toString())
                  ],
                ),
              ),
              Text(
                "\$${_income.amount.toString()}",
              )
            ],
          ),
        ),
      ),
    );
  }
}