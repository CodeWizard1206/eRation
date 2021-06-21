import 'package:e_ration/MODELS/cart_model.dart';
import 'package:e_ration/MODELS/user_model.dart';

class Constant {
  static UserModel _user = UserModel();
  static bool? isLoggedIn = false;
  static List<CartModel> cartItems = [];
  // static List<DropdownMenuItem> categoryList = [
  //   DropdownMenuItem(
  //     value: "NONE",
  //     child: Text('SELECT A CATEGORY'),
  //   ),
  //   DropdownMenuItem(
  //     value: "RICE",
  //     child: Text('RICE'),
  //   ),
  //   DropdownMenuItem(
  //     value: "FLOOR",
  //     child: Text('FLOOR'),
  //   ),
  // ];

  static UserModel get getUser => _user;
  static set setUser(UserModel user) => _user = user;
}
