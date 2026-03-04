import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_expense_tracking/ui/expense_editing/expense_editing_form_view_model.dart';
import '../../domain_models/category.dart';
import '../shared/date_picker_form_field.dart';

class ExpenseEditingForm extends StatefulWidget {
  final ExpenseEditingFormViewModel _viewModel;

  const ExpenseEditingForm({super.key, required ExpenseEditingFormViewModel viewModel}) : _viewModel = viewModel;

  @override
  State<StatefulWidget> createState() => ExpenseEditingFormState();
}

class ExpenseEditingFormState extends State<ExpenseEditingForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    _dateController.text = DateFormat('dd/MM/yyyy').format(widget._viewModel.expense.date);
    _titleController.text = widget._viewModel.expense.title;
    _amountController.text = widget._viewModel.expense.amount.toString();
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
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 15),
      child: Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter a title' : null,
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Expense name',
                  border: OutlineInputBorder()
                )
              ),
              ListenableBuilder(
                listenable: widget._viewModel,
                builder: (context, child) {
                  if (widget._viewModel.categoriesLoading) {
                    return Text('Categories loading...');
                  }

                  return DropdownButtonFormField<Category>(
                    initialValue: widget._viewModel.expense.category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: widget._viewModel.categoriesList.map((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Row (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(category.name),
                            Icon(
                              Icons.circle,
                              color: Color(category.color.hexCode),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (selectedCategory) {
                      if (selectedCategory != null) {
                        widget._viewModel.expense.category = selectedCategory;
                      }
                    },
                    validator: (value) => value == null ? 'Select a category' : null,
                  );
                }
              ),
              DatePickerFormField(
                controller: _dateController,
                onDateSelected: (dateRange) {
                  widget._viewModel.expense.date = dateRange[0];
                  _dateController.text = DateFormat('dd/MM/yyyy').format(dateRange[0]);
                },
                initialSelectedDates: [widget._viewModel.expense.date],
              ),
              TextFormField(
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter an amount' : null,
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget._viewModel.expense.title = _titleController.text;
                    widget._viewModel.saveChanges();
                    Navigator.pop(context);
                  }
                },
                child: Text('Save changes'),
              ),
            ],
          )
      ),
    );
  }
}