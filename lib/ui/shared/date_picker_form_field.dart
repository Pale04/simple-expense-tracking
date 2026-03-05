import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerFormField extends StatelessWidget {
  final TextEditingController _controller;
  final void Function(List<DateTime>) _onDateSelected;
  final DateRangePickerSelectionMode _selectionMode;
  final List<DateTime> _initialSelectedDates;
  final DateRangePickerView _view;
  final Text? _label;
  final InputBorder? _border;
  
  const DatePickerFormField({
    super.key,
    required TextEditingController controller,
    required void Function(List<DateTime>) onDateSelected,
    required List<DateTime> initialSelectedDates,
    DateRangePickerSelectionMode selectionMode = DateRangePickerSelectionMode.single,
    DateRangePickerView view = DateRangePickerView.month,
    Text? label,
    InputBorder? border
  }) :  _controller = controller,
        _onDateSelected = onDateSelected,
        _selectionMode = selectionMode,
        _initialSelectedDates = initialSelectedDates,
        _view = view,
        _label = label,
        _border = border;
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => value == null || value.trim().isEmpty ? 'Enter a date' : null,
      controller: _controller,
      decoration: InputDecoration(
        label: _label,
        suffixIcon: Icon(Icons.calendar_today),
        border: _border
      ),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: SizedBox(
              height: 350,
              child: SfDateRangePicker(
                view: _view,
                allowViewNavigation: _view != DateRangePickerView.year,
                selectionMode: _selectionMode,
                backgroundColor: Colors.white,
                initialSelectedDate: _selectionMode == DateRangePickerSelectionMode.single ? _initialSelectedDates[0] : null,
                initialSelectedRange: _selectionMode == DateRangePickerSelectionMode.range ? PickerDateRange(_initialSelectedDates[0], _initialSelectedDates[1]) : null,
                showNavigationArrow: true,
                showActionButtons: true,
                onSubmit: (value) {
                  _initialSelectedDates.clear();

                  if (_selectionMode == DateRangePickerSelectionMode.single) {
                    _onDateSelected([value as DateTime]);
                    _initialSelectedDates.add(value);
                  } else if (_selectionMode == DateRangePickerSelectionMode.range) {
                    PickerDateRange dateRange = value as PickerDateRange;
                    _onDateSelected([dateRange.startDate!, dateRange.endDate!]);
                    _initialSelectedDates.add(dateRange.startDate!);
                    _initialSelectedDates.add(dateRange.endDate!);
                  }

                  Navigator.pop(context);
                },
                onCancel: () {
                  Navigator.pop(context);
                },
              ),
            )
          ),
        );
      },
      readOnly: true,
    );
  }
}