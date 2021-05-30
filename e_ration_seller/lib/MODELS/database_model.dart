import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ration_seller/MODELS/contants.dart';
import 'package:e_ration_seller/MODELS/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseManager {
  static DatabaseManager _db = DatabaseManager();
  static DatabaseManager get getInstance => _db;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> getLoginCred(String email, String pass) async {
    try {
      UserCredential _userCred =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      if (_userCred.user != null) {
        User? _user = _userCred.user;

        DocumentSnapshot doc =
            await _firestore.collection("sellerDatabase").doc(_user!.uid).get();

        Constant.setUser = UserModel.fromDoc(doc);
        _storeCache();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void _storeCache() async {
    SharedPreferences _cache = await SharedPreferences.getInstance();
    _cache.setBool('loggedIn', true);
    _cache.setString('userData', Constant.getUser.toJson());
  }
}
