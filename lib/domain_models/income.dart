import 'package:intl/intl.dart';

class Income {
  int? id;
  String title;
  double amount;
  DateTime date;

  Income({
    this.id,
    required this.title,
    required this.amount,
    required this.date
  });

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

  factory Income.fromMap(Map<String, Object?> map) {
    return Income(
        id: map['id'] as int?,
        title: map['title'] as String,
        amount: map['amount'] as double,
        date: DateTime.parse(map['date'] as String)
    );
  }
}