import 'package:e_ration_seller/MODELS/user_model.dart';
import 'package:flutter/material.dart';

class Constant {
  static UserModel _user = UserModel();
  static bool? isLoggedIn = false;
  static List<DropdownMenuItem> categoryList = [
    DropdownMenuItem(
      value: "NONE",
      child: Text('SELECT A CATEGORY'),
    ),
  ];

  static UserModel get getUser => _user;
  static set setUser(UserModel user) => _user = user;
}
