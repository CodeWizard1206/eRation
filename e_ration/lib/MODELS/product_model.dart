import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProductModel {
  String? uid;
  String? sellerId;
  String? sellerName;
  String? sellerCity;
  String? sellerArea;
  String? productName;
  int? rating;
  String? category;
  String? description;
  String? thumbUri;
  DateTime? timestamp;
  DateTime? lastQuery;
  int qty;
  int? stocks;
  int? price;
  List<String>? images;

  ProductModel({
    this.uid,
    this.sellerId,
    this.sellerName,
    this.sellerCity,
    this.rating = 0,
    this.qty = 0,
    this.sellerArea,
    this.productName,
    this.category,
    this.description,
    this.thumbUri,
    this.timestamp,
    this.lastQuery,
    this.stocks,
    this.price,
    this.images,
  });

  ProductModel copyWith({
    String? uid,
    String? sellerId,
    String? sellerName,
    String? sellerCity,
    String? sellerArea,
    int? rating,
    String? productName,
    String? category,
    String? description,
    String? thumbUri,
    DateTime? timestamp,
    DateTime? lastQuery,
    int? stocks,
    int? price,
    List<String>? images,
  }) {
    return ProductModel(
      uid: uid ?? this.uid,
      sellerId: sellerId ?? this.sellerId,
      rating: rating ?? this.rating,
      sellerName: sellerName ?? this.sellerName,
      sellerCity: sellerCity ?? this.sellerCity,
      sellerArea: sellerArea ?? this.sellerArea,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      description: description ?? this.description,
      thumbUri: thumbUri ?? this.thumbUri,
      timestamp: timestamp ?? this.timestamp,
      lastQuery: lastQuery ?? this.lastQuery,
      stocks: stocks ?? this.stocks,
      price: price ?? this.price,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'rating': rating,
      'sellerName': sellerName,
      'sellerCity': sellerCity,
      'sellerArea': sellerArea,
      'productName': productName,
      'category': category,
      'qty': qty,
      'description': description,
      'thumbUri': thumbUri,
      'timestamp': timestamp,
      'lastQuery': lastQuery,
      'stocks': stocks,
      'price': price,
      'images': images,
    };
  }

  factory ProductModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return ProductModel(
      uid: doc.id,
      sellerId: doc.get('sellerId'),
      rating: doc.get('rating'),
      sellerName: doc.get('sellerName'),
      sellerCity: doc.get('sellerCity'),
      sellerArea: doc.get('sellerArea'),
      productName: doc.get('productName'),
      category: doc.get('category'),
      description: doc.get('description'),
      thumbUri: doc.get('thumbUri'),
      timestamp: doc.get('timestamp').toDate(),
      lastQuery: map['lastQuery'] != null
          ? doc.get('lastQuery').toDate()
          : DateTime.now(),
      stocks: doc.get('stocks'),
      price: doc.get('price'),
      images: List<String>.from(doc.get('images')),
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      // uid: map['uid'],
      sellerId: map['sellerId'],
      rating: map['rating'],
      sellerName: map['sellerName'],
      sellerCity: map['sellerCity'],
      sellerArea: map['sellerArea'],
      productName: map['productName'],
      category: map['category'],
      description: map['description'],
      thumbUri: map['thumbUri'],
      timestamp: map['timestamp'].toDate(),
      qty: map['qty'] != null ? map['qty'] : 0,
      lastQuery:
          map['lastQuery'] != null ? map['lastQuery'].toDate() : DateTime.now(),
      stocks: map['stocks'],
      price: map['price'],
      images: List<String>.from(map['images']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(uid: $uid, sellerId: $sellerId, rating: $rating, sellerName: $sellerName, sellerCity: $sellerCity, sellerArea: $sellerArea, productName: $productName, category: $category, description: $description, thumbUri: $thumbUri, timestamp: $timestamp, stocks: $stocks, price: $price, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.uid == uid &&
        other.rating == rating &&
        other.sellerId == sellerId &&
        other.sellerName == sellerName &&
        other.sellerCity == sellerCity &&
        other.sellerArea == sellerArea &&
        other.productName == productName &&
        other.category == category &&
        other.description == description &&
        other.thumbUri == thumbUri &&
        other.timestamp == timestamp &&
        other.lastQuery == lastQuery &&
        other.stocks == stocks &&
        other.price == price &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        rating.hashCode ^
        sellerId.hashCode ^
        sellerName.hashCode ^
        sellerCity.hashCode ^
        sellerArea.hashCode ^
        productName.hashCode ^
        category.hashCode ^
        description.hashCode ^
        thumbUri.hashCode ^
        timestamp.hashCode ^
        lastQuery.hashCode ^
        stocks.hashCode ^
        price.hashCode ^
        images.hashCode;
  }
}
