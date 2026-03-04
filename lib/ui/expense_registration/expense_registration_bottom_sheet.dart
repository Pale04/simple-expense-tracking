import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simple_expense_tracking/domain_models/category.dart';
import 'package:simple_expense_tracking/domain_models/expense.dart';
import 'package:simple_expense_tracking/ui/expense_registration/expense_registration_bottom_sheet_view_model.dart';
import 'package:simple_expense_tracking/ui/shared/app_bottom_sheet.dart';
import '../shared/date_picker_form_field.dart';

class ExpenseRegistrationBottomSheet extends StatefulWidget {
  final Future<void> Function(Expense) _onExpenseSaved;
  final ExpenseRegistrationBottomSheetViewModel _viewModel;

  const ExpenseRegistrationBottomSheet({
    super.key,
    required Future<void> Function(Expense) onExpenseSaved,
    required ExpenseRegistrationBottomSheetViewModel viewModel,
  }) : _onExpenseSaved = onExpenseSaved, _viewModel = viewModel;

  @override
  State<ExpenseRegistrationBottomSheet> createState() => _ExpenseRegistrationBottomSheetState();
}

class _ExpenseRegistrationBottomSheetState extends State<ExpenseRegistrationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    _dateController.text = DateFormat('dd/MM/yyyy').format(widget._viewModel.selectedDate);
    super.initState();

  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              spacing: 14,
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) => value == null || value.trim().isEmpty ? 'Enter a title' : null,
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'What did you pay?',
                      fillColor: Colors.transparent,
                    )
                  )
                ),
                IconButton.filledTonal(
                  constraints: BoxConstraints(maxWidth: 55),
                  onPressed: () async {
                    Category? selection = await showDialog<Category>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Select a category"),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                return Scrollbar(
                                  child: SingleChildScrollView(
                                    child: ListenableBuilder(
                                      listenable: widget._viewModel,
                                      builder: (builder, child) {
                                        if (widget._viewModel.isLoading) {
                                          return Text('Charging options..');
                                        }

                                        return RadioGroup(
                                          groupValue: widget._viewModel.selectedCategory,
                                          onChanged: (Category? value) {;
                                            Navigator.pop(context, value);
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: widget._viewModel.categoriesList.map((category) {
                                              return RadioListTile<Category>(
                                                title: Text(category.name),
                                                value: category,
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      }
                                    )
                                  )
                                );
                              },
                            ),
                          ),
                        );
                      }
                    );

                    if (selection != null) {
                      widget._viewModel.setSelectedCategory(selection);
                    }
                  },
                  icon: Icon(Icons.sell_rounded)
                ),
              ],
            ),
            Row(
              spacing: 14,
              children: [
                Expanded(
                  flex: 5,
                  child: DatePickerFormField(
                    controller: _dateController,
                    onDateSelected: (dateRange) {
                      widget._viewModel.setSelectedDate(dateRange[0]);
                      _dateController.text = DateFormat('dd/MM/yyyy').format(dateRange[0]);
                    },
                    initialSelectedDates: [widget._viewModel.selectedDate],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    validator: (value) => value == null || value.trim().isEmpty ? 'Enter an amount' : null,
                    controller: _amountController,
                    decoration: InputDecoration(
                      hintText: 'Amount'
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton.filledTonal(
                  constraints: BoxConstraints(maxWidth: 55),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _saveExpense();
                      context.pop(true);
                    }
                  },
                  icon: Icon(Icons.send_and_archive_rounded)
                )
              ],
            ),
          ],
        )
      ),
    );
  }

  Future<void> _saveExpense() async {
    final expense = Expense(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      date: widget._viewModel.selectedDate,
      category: widget._viewModel.selectedCategory
    );
    print(expense.category.name);
    await widget._onExpenseSaved(expense);
  }
}