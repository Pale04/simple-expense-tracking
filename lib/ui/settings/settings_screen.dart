import 'package:flutter/material.dart';
import 'package:simple_expense_tracking/ui/settings/settings_screen_view_model.dart';
import '../../domain_models/currency.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsScreenViewModel _viewModel;

  const SettingsScreen({super.key, required SettingsScreenViewModel viewModel}) : _viewModel = viewModel;

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal:  8),
      child: Column(
        children: [
          Card(
            color: Theme.of(context).colorScheme.tertiary,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 8, 4, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 6,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Currency',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      ListenableBuilder(
                        listenable: widget._viewModel,
                        builder: (context, child) {
                          return Text(
                            '${widget._viewModel.currency.name.toUpperCase()} (${widget._viewModel.currency.symbol})',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
                          );
                        }
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            children: [
                              Container(
                                height: 160,
                                alignment: Alignment.center,
                                child: ListenableBuilder(
                                  listenable: widget._viewModel,
                                  builder: (context, child) {
                                    return RadioGroup<Currency>(
                                      groupValue: widget._viewModel.currency,
                                      onChanged: (Currency? value) => widget._viewModel.updateCurrency(value ?? widget._viewModel.currency),
                                      child: ListView.builder(
                                        itemCount: Currency.values.length,
                                        itemBuilder: (context, index) {
                                          return RadioListTile<Currency>(
                                            title: Text('${Currency.values[index].name.toUpperCase()} (${Currency.values[index].symbol})'),
                                            value: Currency.values[index],
                                          );
                                        }
                                      ),
                                    );
                                  }
                                )
                              )
                            ],
                          );
                        }
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}