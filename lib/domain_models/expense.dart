import 'package:intl/intl.dart';
import 'package:simple_expense_tracking/domain_models/category.dart';

class Expense {
  int? id;
  String title;
  double amount;
  DateTime date;
  Category category;

  Expense({
    this.id,
    required this.category,
    required this.title,
    required this.amount,
    required this.date
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'category_id': category.id
    };
  }

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
      category: Category.fromMap({
        'id': map['c_id'],
        'name': map['name'],
        'color': map['color']
      })
    );
  }
}