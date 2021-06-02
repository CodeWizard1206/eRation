import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ration_seller/MODELS/contants.dart';
import 'package:e_ration_seller/MODELS/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseManager {
  static DatabaseManager _db = DatabaseManager();
  static DatabaseManager get getInstance => _db;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  final String _sellerDB = 'sellerDatabase';
  final String _reviewColl = 'userReviews';

  //Store login data in cache for auto relogin.
  void _storeCache() async {
    SharedPreferences _cache = await SharedPreferences.getInstance();
    _cache.setBool('loggedIn', true);
    _cache.setString('cred', Constant.getUser.toJson());
  }

  //logging out user and clear cache data from cache memory.
  void logoutUser() async {
    SharedPreferences _cache = await SharedPreferences.getInstance();
    _cache.clear();
    _cache.setBool('loggedIn', false);
    Constant.setUser = UserModel();
    Constant.isLoggedIn = false;
    _auth.signOut();
  }

  //get and validate login credentials for first/initial login.
  Future<bool> getLoginCred(String email, String pass) async {
    try {
      UserCredential _userCred =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      if (_userCred.user != null) {
        User? _user = _userCred.user;

        DocumentSnapshot doc =
            await _firestore.collection("sellerDatabase").doc(_user!.uid).get();

        Constant.setUser = UserModel.fromDoc(doc);
        Constant.isLoggedIn = true;
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

  //Sign up or enroll new users to app.
  Future<bool> signUp(UserModel user, File? image) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: user.email.toString(), password: user.pass.toString());

      String uid = _auth.currentUser!.uid;

      if (image != null) {
        UploadTask _task =
            _storage.ref('profileImages/$uid.jpeg').putFile(image);
        await _task.whenComplete(() async {
          String _uri =
              await _storage.ref('profileImages/$uid.jpeg').getDownloadURL();

          user.profile = _uri;
        });
      }

      await _firestore.collection(_sellerDB).doc(uid).set(user.toMap());
      user.uid = uid;
      Constant.setUser = user;
      _storeCache();

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //get user data via credentials saved in cached memory.
  Future<UserModel> getUser(SharedPreferences _cache) async {
    Map<String, dynamic> _map =
        json.decode(_cache.getString('cred').toString());

    UserCredential _userCred = await _auth.signInWithEmailAndPassword(
        email: _map['email'], password: _map['pass']);

    DocumentSnapshot _doc =
        await _firestore.collection(_sellerDB).doc(_userCred.user!.uid).get();

    return UserModel.fromDoc(_doc);
  }

  //get review data stream of user.
  Stream<List<int>> getReviewDataStream() {
    Stream<List<int>> _return = _firestore
        .collection(_sellerDB)
        .doc(Constant.getUser.uid)
        .collection(_reviewColl)
        .orderBy('timestamp')
        .snapshots()
        .map((event) => event.docs.map((e) => e['rating'] as int).toList());

    return _return;
  }
}
