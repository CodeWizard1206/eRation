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
  String? address;
  String? area;
  String? city;
  String? state;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.pass,
    this.contact,
    this.profile,
    this.gender,
    this.dob,
    this.address,
    this.area,
    this.city,
    this.state,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? shopName,
    String? email,
    String? pass,
    String? contact,
    String? profile,
    String? gender,
    DateTime? dob,
    String? address,
    String? area,
    String? city,
    String? state,
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
      address: address ?? this.address,
      area: area ?? this.area,
      city: city ?? this.city,
      state: state ?? this.state,
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
      'address': address,
      'area': area,
      'city': city,
      'state': state,
    };
  }

  Map<String, dynamic> toCred() {
    return {
      'email': email,
      'pass': pass,
    };
  }

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      uid: doc.id,
      name: doc.get('name'),
      email: doc.get('email'),
      pass: doc.get('pass'),
      contact: doc.get('contact'),
      profile: doc.get('profile'),
      gender: doc.get('gender'),
      dob: doc.get('dob').toDate(),
      address: doc.get('address'),
      area: doc.get('area'),
      city: doc.get('city'),
      state: doc.get('state'),
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
      address: map['address'],
      area: map['area'],
      city: map['city'],
      state: map['state'],
    );
  }

  String toJson() => json.encode(toCred());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, pass: $pass, contact: $contact, profile: $profile, gender: $gender, dob: $dob, address: $address, area: $area, city: $city, state: $state)';
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
        other.dob == dob &&
        other.address == address &&
        other.area == area &&
        other.city == city &&
        other.state == state;
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
        dob.hashCode ^
        address.hashCode ^
        area.hashCode ^
        city.hashCode ^
        state.hashCode;
  }
}
