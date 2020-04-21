
import 'category_entity.dart';

class RecordEntity {
  final String id;
  final double amount;
  final String description;
  // final CategoryEntity category;
  final DateTime date;
  final bool isExpense;

  RecordEntity(this.id, this.amount, this.description, this.date,
      this.isExpense);

  @override
  int get hashCode =>
      id.hashCode ^
      amount.hashCode ^
      description.hashCode ^
      // category.hashCode ^
      date.hashCode ^
      isExpense.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          description == other.description &&
          // category == other.category &&
          date == other.date &&
          isExpense == other.isExpense;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      // 'category': category,
      'date': date.millisecondsSinceEpoch,
      'isExpense': isExpense,
    };
  }

  @override
  String toString() {
    return 'RecordEntity{id: $id, amount: $amount, description: $description, date: ${date.millisecondsSinceEpoch}, isExpense: $isExpense}';
  }

  static RecordEntity fromJson(Map<String, Object> json) {
    return RecordEntity(
      json['id'] as String,
      json['amount'] as double,
      json['description'] as String,
      // CategoryEntity.fromJson(json['category']),
      DateTime.fromMillisecondsSinceEpoch(json['date']),
      json['isExpense'] as bool,
    );
  }
}
