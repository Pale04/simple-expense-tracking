import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_expense_tracking/ui/summary_screen/statistics_doughnut_chart.dart';
import 'package:simple_expense_tracking/ui/summary_screen/summary_screen_view_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../shared/date_picker_form_field.dart';

class SummaryScreen extends StatefulWidget {
  final SummaryScreenViewModel _viewModel;

  const SummaryScreen({super.key, required SummaryScreenViewModel viewModel}) : _viewModel = viewModel;

  @override
  State<StatefulWidget> createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    _dateController.text = DateFormat('MMMM yyyy').format(widget._viewModel.statisticsDateSelected);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            spacing: 25,
            children: [
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        'Total spent',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      ListenableBuilder(
                        listenable: widget._viewModel,
                        builder: (context, child) {
                          return RichText(
                            text: TextSpan(
                              text: "${widget._viewModel.currency.symbol} ",
                              style: Theme.of(context).textTheme.headlineMedium,
                              children: [
                                TextSpan(
                                  text: widget._viewModel.totalSpent.toString(),
                                  style: Theme.of(context).textTheme.displaySmall
                                ),
                                TextSpan(text: '  '),
                                TextSpan(
                                  text: widget._viewModel.currency.name.toUpperCase(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                )
                              ]
                            ),
                          );
                        }
                      )
                    ],
                  ),
                ),
              ),
              Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListenableBuilder(
                    listenable: widget._viewModel,
                    builder: (context, child) {
                      return Text(
                        "During ${DateFormat('MMMM').format(widget._viewModel.statisticsDateSelected)} of ${DateFormat('yyyy').format(widget._viewModel.statisticsDateSelected)} you've spent on:",
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      );
                    }
                  ),
                  ListenableBuilder(
                    listenable: widget._viewModel,
                    builder: (context, _) => StatisticsDoughnutChart(expensesList: widget._viewModel.monthExpenses)
                  ),
                  DatePickerFormField(
                    controller: _dateController,
                    onDateSelected: (dateRange) {
                      widget._viewModel.setStatisticsDateSelected(dateRange[0]);
                      _dateController.text = DateFormat('MMMM yyyy').format(dateRange[0]);
                    },
                    initialSelectedDates: [widget._viewModel.statisticsDateSelected],
                    view: DateRangePickerView.year,
                    label: Text('Change the month'),
                    border: OutlineInputBorder(),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}