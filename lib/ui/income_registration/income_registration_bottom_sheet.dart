import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simple_expense_tracking/domain_models/income.dart';
import 'package:simple_expense_tracking/ui/shared/app_bottom_sheet.dart';

class IncomeRegistrationBottomSheet extends StatelessWidget {
  final Future<void> Function(Income) _onIncomeSaved;

  const IncomeRegistrationBottomSheet({super.key, required Future<void> Function(Income) onIncomeSaved}) : _onIncomeSaved = onIncomeSaved;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(child: _IncomeRegistrationForm(onIncomeSaved: _onIncomeSaved));
  }
}

class _IncomeRegistrationForm extends StatefulWidget {
  final Future<void> Function(Income) _onIncomeSaved;

  const _IncomeRegistrationForm({required Future<void> Function(Income) onIncomeSaved}) : _onIncomeSaved = onIncomeSaved;

  @override
  State<_IncomeRegistrationForm> createState() => _IncomeRegistrationFormState();
}

class _IncomeRegistrationFormState extends State<_IncomeRegistrationForm> {
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
            validator: (value) => value == null || value.trim().isEmpty ? 'Enter a concept' : null,
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Source of your income',
              fillColor: Colors.transparent,
            )
          ),
          Row(
            spacing: 14,
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) => value == null || value.trim().isEmpty ? 'Enter a date' : null,
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today)
                  ),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime.now()
                    );
                    if (pickedDate != null) {
                      _selectedDate = pickedDate;
                      _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                    }
                  },
                  readOnly: true,
                ),
              ),
              Expanded(
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
                    await _saveIncome();
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

  Future<void> _saveIncome() async {
    final income = Income(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      date: _selectedDate
    );
    await widget._onIncomeSaved(income);
  }
}