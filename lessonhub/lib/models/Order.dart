import 'package:lesson_flutter/models/Category.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';

class Order {
  final int id;
  final String orderDate;
  final String status;
  final int amount;
  final String processor;
  final String currency;
  final SchoolClass schoolClass;
  final Category category;
  Order({
    this.id,
    this.amount,
    this.currency,
    this.orderDate,
    this.processor,
    this.status,
    this.category,
    this.schoolClass,
  });

  factory Order.fromJson(Map json) {
    return Order(
      id: json["id"],
      orderDate: json["order_date"],
      status: json["status"],
      amount: json["amount"],
      processor: json["processor"],
      currency: json["currency"],
      schoolClass: json["school_class"] != null
          ? SchoolClass.fromJson(json["school_class"])
          : null,
      category:
          json["category"] != null ? Category.fromJson(json["category"]) : null,
    );
  }
}
