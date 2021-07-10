import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class QueryModel {
  String? uid;
  String? question;
  String? answer;
  String? askedBy;
  DateTime? timestamp;

  QueryModel({
    this.uid,
    this.question,
    this.answer,
    this.askedBy,
    this.timestamp,
  });

  QueryModel copyWith({
    String? uid,
    String? question,
    String? answer,
    String? askedBy,
    DateTime? timestamp,
  }) {
    return QueryModel(
      uid: uid ?? this.uid,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      askedBy: askedBy ?? this.askedBy,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'askedBy': askedBy,
      'timestamp': timestamp,
    };
  }

  factory QueryModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return QueryModel(
      uid: doc.id,
      question: map['question'],
      answer: map['answer'],
      askedBy: map['askedBy'],
      timestamp: map['timestamp'].toDate(),
    );
  }

  factory QueryModel.fromMap(Map<String, dynamic> map) {
    return QueryModel(
      uid: map['uid'],
      question: map['question'],
      answer: map['answer'],
      askedBy: map['askedBy'],
      timestamp: map['timestamp'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory QueryModel.fromJson(String source) =>
      QueryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QueryModel(uid: $uid, question: $question, answer: $answer, askedBy: $askedBy, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QueryModel &&
        other.uid == uid &&
        other.question == question &&
        other.answer == answer &&
        other.askedBy == askedBy &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        question.hashCode ^
        answer.hashCode ^
        askedBy.hashCode ^
        timestamp.hashCode;
  }
}
