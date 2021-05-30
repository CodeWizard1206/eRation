import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? pass;
  String? contact;
  String? profile;
  String? gender;
  DateTime? dob;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.pass,
    this.contact,
    this.profile,
    this.gender,
    this.dob,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? pass,
    String? contact,
    String? profile,
    String? gender,
    DateTime? dob,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      pass: pass ?? this.pass,
      contact: contact ?? this.contact,
      profile: profile ?? this.profile,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'pass': pass,
      'contact': contact,
      'profile': profile,
      'gender': gender,
      'dob': dob,
    };
  }

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      pass: map['pass'],
      contact: map['contact'],
      profile: map['profile'],
      gender: map['gender'],
      dob: map['dob'].toDate(),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      pass: map['pass'],
      contact: map['contact'],
      profile: map['profile'],
      gender: map['gender'],
      dob: map['dob'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, pass: $pass, contact: $contact, profile: $profile, gender: $gender, dob: $dob)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.pass == pass &&
        other.contact == contact &&
        other.profile == profile &&
        other.gender == gender &&
        other.dob == dob;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        pass.hashCode ^
        contact.hashCode ^
        profile.hashCode ^
        gender.hashCode ^
        dob.hashCode;
  }
}
