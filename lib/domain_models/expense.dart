import 'package:intl/intl.dart';

class Expense {
  int? id;
  String title;
  double amount;
  DateTime date;

  Expense({this.id, required this.title, required this.amount, required this.date});

  Map<String, Object?> toMap() {
    var map = {
      'title': title,
      'amount': amount,
      'date': DateFormat('yyyy-MM-dd').format(date)
    };

    if (id != null) {
      map['id'] = id!;
    }

    return map;
  }

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String)
    );
  }
}