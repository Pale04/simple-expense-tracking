import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simple_expense_tracking/domain_models/expense.dart';
import 'package:simple_expense_tracking/ui/shared/app_bottom_sheet.dart';
import '../shared/date_picker_form_field.dart';

class ExpenseRegistrationBottomSheet extends StatelessWidget {
  final Future<void> Function(Expense) _onExpenseSaved;

  const ExpenseRegistrationBottomSheet({super.key, required Future<void> Function(Expense) onExpenseSaved}) : _onExpenseSaved = onExpenseSaved;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(child: _ExpenseRegistrationForm(onExpenseSaved: _onExpenseSaved));
  }
}

class _ExpenseRegistrationForm extends StatefulWidget {
  final Future<void> Function(Expense) _onExpenseSaved;

  const _ExpenseRegistrationForm({required Future<void> Function(Expense) onExpenseSaved}) : _onExpenseSaved = onExpenseSaved;

  @override
  State<_ExpenseRegistrationForm> createState() => _ExpenseRegistrationFormState();
}

class _ExpenseRegistrationFormState extends State<_ExpenseRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
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
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            validator: (value) => value == null || value.trim().isEmpty ? 'Enter a title' : null,
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'What did you pay?',
              fillColor: Colors.transparent,
            )
          ),
          Row(
            spacing: 14,
            children: [
              Expanded(
                flex: 5,
                child: DatePickerFormField(
                  controller: _dateController,
                  onDateSelected: (dateRange) {
                    _selectedDate = dateRange[0];
                    _dateController.text = DateFormat('dd/MM/yyyy').format(dateRange[0]);
                  },
                  initialSelectedDates: [_selectedDate],
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
                constraints: BoxConstraints(maxWidth: 50),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _saveExpense();
                    context.pop(true);
                  }
                },
                icon: Icon(Icons.add_circle_rounded)
              )
            ],
          )
        ],
      )
    );
  }

  Future<void> _saveExpense() async {
    final expense = Expense(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate
    );
    await widget._onExpenseSaved(expense);
  }
}