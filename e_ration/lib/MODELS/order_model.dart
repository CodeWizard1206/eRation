import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:e_ration/MODELS/product_model.dart';

class OrderModel {
  String? uid;
  String? time;
  DateTime? timestamp;
  DateTime? date;
  List<dynamic>? products;
  String? totalAmount;

  OrderModel({
    this.uid,
    this.time,
    this.timestamp,
    this.date,
    this.products,
    this.totalAmount,
  });

  OrderModel copyWith({
    String? uid,
    String? time,
    DateTime? timestamp,
    DateTime? date,
    List<ProductModel>? products,
    String? totalAmount,
  }) {
    return OrderModel(
      uid: uid ?? this.uid,
      time: time ?? this.time,
      timestamp: timestamp ?? this.timestamp,
      date: date ?? this.date,
      products: products ?? this.products,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'timestamp': timestamp,
      'date': date,
      'products': products!.map((product) => product.toMap()).toList(),
      'totalAmount': totalAmount,
    };
  }

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    List<dynamic> _list = doc
        .get('products')
        .map((product) => ProductModel.fromMap(product as Map<String, dynamic>))
        .toList();

    OrderModel _data = OrderModel(
      uid: doc.id,
      time: doc.get('time').toString(),
      timestamp: doc.get('timestamp').toDate(),
      date: doc.get('date').toDate(),
      products: _list,
      totalAmount: doc.get('totalAmount').toString(),
    );
    return _data;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      uid: map['uid'],
      time: map['time'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      products: List<ProductModel>.from(
          map['products']?.map((x) => ProductModel.fromMap(x))),
      totalAmount: map['totalAmount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(uid: $uid, time: $time, timestamp: $timestamp, date: $date, products: $products, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.uid == uid &&
        other.time == time &&
        other.timestamp == timestamp &&
        other.date == date &&
        listEquals(other.products, products) &&
        other.totalAmount == totalAmount;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        time.hashCode ^
        timestamp.hashCode ^
        date.hashCode ^
        products.hashCode ^
        totalAmount.hashCode;
  }
}
