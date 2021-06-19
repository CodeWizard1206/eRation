import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? uid;
  String? imageUri;
  String? category;
  DateTime? timestamp;

  CategoryModel({
    this.uid,
    this.imageUri,
    this.category,
    this.timestamp,
  });

  CategoryModel copyWith({
    String? uid,
    String? imageUri,
    String? category,
    DateTime? timestamp,
  }) {
    return CategoryModel(
      uid: uid ?? this.uid,
      imageUri: imageUri ?? this.imageUri,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUri': imageUri,
      'category': category,
      'timestamp': timestamp,
    };
  }

  factory CategoryModel.fromDoc(DocumentSnapshot doc) {
    return CategoryModel(
      uid: doc.id,
      imageUri: doc.get('imageUri'),
      category: doc.get('category'),
      timestamp: doc.get('timestamp').toDate(),
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      uid: map['uid'],
      imageUri: map['imageUri'],
      category: map['category'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(uid: $uid, imageUri: $imageUri, category: $category, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.uid == uid &&
        other.imageUri == imageUri &&
        other.category == category &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        imageUri.hashCode ^
        category.hashCode ^
        timestamp.hashCode;
  }
}
