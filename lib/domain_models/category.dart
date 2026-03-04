import 'package:simple_expense_tracking/domain_models/identification_color.dart';

class Category {
  int? id;
  String name;
  IdentificationColor color;

  Category({
    this.id,
    required this.name,
    required this.color
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'color': IdentificationColor.values[color.index].index,
    };
  }

  factory Category.fromMap(Map<String, Object?> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      color: IdentificationColor.values[map['color'] as int],
    );
  }
}