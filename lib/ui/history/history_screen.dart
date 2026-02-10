import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_expense_tracking/ui/history/expense_card.dart';
import 'package:simple_expense_tracking/ui/history/history_screen_view_model.dart';
import 'package:simple_expense_tracking/ui/history/income_card.dart';
import 'package:simple_expense_tracking/ui/shared/date_picker_form_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HistoryScreen extends StatefulWidget {
  final HistoryScreenViewModel _viewModel;

  const HistoryScreen({super.key, required HistoryScreenViewModel viewModel}) : _viewModel = viewModel;

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _dateController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      widget._viewModel.updateActualTab(_tabController.index);
    });

    String startDate = DateFormat('dd/MM/yyyy').format(widget._viewModel.dateRange[0]);
    String endDate = DateFormat('dd/MM/yyyy').format(widget._viewModel.dateRange[1]);
    _dateController.text = '$startDate - $endDate';
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            expandedHeight: 169.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: EdgeInsets.all(0),
              centerTitle: true,
              expandedTitleScale: 1.0,
              background: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsGeometry.directional(start: 10, top: 10, end: 10, bottom: 0),
                    child: DatePickerFormField(
                      controller: _dateController,
                      onDateSelected: (dateRange) {
                        if (widget._viewModel.actualTab == 0) {
                          widget._viewModel.getExpensesList(dateRange[0], dateRange[1]);
                        } else {
                          widget._viewModel.getIncomeList(dateRange[0], dateRange[1]);
                        }
                        String startDate = DateFormat('dd/MM/yyyy').format(dateRange[0]);
                        String endDate = DateFormat('dd/MM/yyyy').format(dateRange[1]);
                        _dateController.text = '$startDate - $endDate';
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedDates: widget._viewModel.dateRange,
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    tabs: const <Widget>[
                      Tab(
                        text: 'Expenses',
                      ),
                      Tab(
                        text: 'Income',
                      ),
                    ],
                  ),
                ],
              ),
              title: ListenableBuilder(
                listenable: widget._viewModel,
                builder: (context, child) {
                  return Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          widget._viewModel.actualTab == 0 ? Color(0xFFF76F33) : Color(0xFF2EA63E),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(widget._viewModel.actualTab == 0 ? Icons.trending_down_outlined : Icons.trending_up_outlined)
                      ],
                    ),
                  );
                }
              )
            )
          ),
          ListenableBuilder(
            listenable: widget._viewModel,
            builder: (context, child) {
              return SliverList.builder(
                itemCount: widget._viewModel.actualTab == 0 ? widget._viewModel.expensesList.length : widget._viewModel.incomeList.length,
                itemBuilder: (context, index) {
                  if(widget._viewModel.actualTab == 0) {
                    return ExpenseCard(
                      expense: widget._viewModel.expensesList[index],
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
                      }
                    );
                  } else {
                    return IncomeCard(
                      income: widget._viewModel.incomeList[index],
                      onCardTapped: (incomeId) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: const Text('Options'),
                              children: [
                                SimpleDialogOption(
                                  onPressed: () {
                                    widget._viewModel.deleteExpense(incomeId);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete'),
                                )
                              ],
                            );
                          }
                        );
                      }
                    );
                  }
                }
              );
            }
          )
        ],
      ),
    );
  }
}