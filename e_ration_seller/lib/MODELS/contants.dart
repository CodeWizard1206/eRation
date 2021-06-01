import 'package:e_ration_seller/MODELS/user_model.dart';

class Constant {
  static UserModel _user = UserModel();
  static bool? isLoggedIn = false;

  static UserModel get getUser => _user;
  static set setUser(UserModel user) => _user = user;
}
