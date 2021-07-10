import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ration/MODELS/product_model.dart';

class SellerOrderModel {
  String? uid;
  String? orderId;
  String? name;
  String? email;
  String? contact;
  String? profile;
  String? status;
  DateTime? timestamp;
  DateTime? date;
  String? time;
  ProductModel? product;

  SellerOrderModel({
    this.uid,
    this.orderId,
    this.name,
    this.email,
    this.status = 'Not Picked',
    this.contact,
    this.profile,
    this.timestamp,
    this.date,
    this.time,
    this.product,
  });

  SellerOrderModel copyWith({
    String? uid,
    String? orderId,
    String? name,
    String? status,
    String? email,
    String? contact,
    String? profile,
    DateTime? timestamp,
    DateTime? date,
    String? time,
    ProductModel? product,
  }) {
    return SellerOrderModel(
      uid: uid ?? this.uid,
      orderId: orderId ?? this.orderId,
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      contact: contact ?? this.contact,
      profile: profile ?? this.profile,
      timestamp: timestamp ?? this.timestamp,
      date: date ?? this.date,
      time: time ?? this.time,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'orderId': orderId,
      'name': name,
      'email': email,
      'contact': contact,
      'status': status,
      'profile': profile,
      'timestamp': timestamp,
      'date': date,
      'time': time,
      'product': product?.toMap(),
    };
  }

  factory SellerOrderModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return SellerOrderModel(
      uid: doc.id,
      orderId: map['orderId'],
      name: map['name'],
      email: map['email'],
      status: map['status'] ?? 'Not Picked',
      contact: map['contact'],
      profile: map['profile'],
      timestamp: map['timestamp'].toDate(),
      date: map['date'].toDate(),
      time: map['time'],
      product: ProductModel.fromMap(map['product']),
    );
  }

  factory SellerOrderModel.fromMap(Map<String, dynamic> map) {
    return SellerOrderModel(
      uid: map['uid'],
      orderId: map['orderId'],
      name: map['name'],
      email: map['email'],
      status: map['status'],
      contact: map['contact'],
      profile: map['profile'],
      timestamp: map['timestamp'].toDate(),
      date: map['date'].toDate(),
      time: map['time'],
      product: ProductModel.fromMap(map['product']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SellerOrderModel.fromJson(String source) =>
      SellerOrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SellerOrderModel(uid: $uid, orderId: $orderId, name: $name, email: $email, status: $status, contact: $contact, profile: $profile, timestamp: $timestamp, date: $date, time: $time, product: $product)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SellerOrderModel &&
        other.uid == uid &&
        other.orderId == orderId &&
        other.name == name &&
        other.email == email &&
        other.status == status &&
        other.contact == contact &&
        other.profile == profile &&
        other.timestamp == timestamp &&
        other.date == date &&
        other.time == time &&
        other.product == product;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        orderId.hashCode ^
        name.hashCode ^
        email.hashCode ^
        status.hashCode ^
        contact.hashCode ^
        profile.hashCode ^
        timestamp.hashCode ^
        date.hashCode ^
        time.hashCode ^
        product.hashCode;
  }
}
