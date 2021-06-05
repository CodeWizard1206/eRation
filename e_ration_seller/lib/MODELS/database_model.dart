import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ration_seller/MODELS/contants.dart';
import 'package:e_ration_seller/MODELS/product_model.dart';
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
  final String _productDB = 'productDatabase';
  final String _queriesColl = 'userQueries';

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

  Stream<int> getProductsCount() {
    Stream<int> _return = _firestore
        .collection(_productDB)
        .where('sellerId', isEqualTo: Constant.getUser.uid)
        .where('stocks', isGreaterThan: 0)
        .snapshots()
        .map((event) => event.docs.length);

    return _return;
  }

  Stream<List<ProductModel>> getProducts() {
    Stream<List<ProductModel>> _return = _firestore
        .collection(_productDB)
        .where('sellerId', isEqualTo: Constant.getUser.uid)
        .orderBy('productName')
        .snapshots()
        .map(
          (event) => event.docs.map((e) => ProductModel.fromDoc(e)).toList(),
        );

    return _return;
  }

  Stream<int> getQueries() {
    Stream<int> _return = _firestore
        .collection(_sellerDB)
        .doc(Constant.getUser.uid)
        .collection(_queriesColl)
        .where('answered', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs.length);

    return _return;
  }

  Future<void> deleteProfileImage() async {
    try {
      await _storage.ref('profileImages/${Constant.getUser.uid}.jpeg').delete();
      await _firestore
          .collection(_sellerDB)
          .doc(Constant.getUser.uid)
          .update({'profile': null});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> updateProfileImage(File image) async {
    try {
      UploadTask _task = _storage
          .ref('profileImages/${Constant.getUser.uid}.jpeg')
          .putFile(image);
      await _task.whenComplete(() async {});
      String _uri = await _storage
          .ref('profileImages/${Constant.getUser.uid}.jpeg')
          .getDownloadURL();

      await _firestore
          .collection(_sellerDB)
          .doc(Constant.getUser.uid)
          .update({'profile': _uri});

      return _uri;
    } catch (e) {
      print(e.toString());
      return 'none';
    }
  }

  Future<bool> updateProfile(
      UserModel user, bool updateEmail, bool updatePassword) async {
    try {
      if (updateEmail) {
        await _auth.currentUser!.updateEmail(user.email.toString());
      }
      if (updatePassword) {
        await _auth.currentUser!.updatePassword(user.pass.toString());
      }

      await _firestore.collection(_sellerDB).doc(user.uid).update(user.toMap());

      Constant.setUser = user;
      _storeCache();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addProductToDB(ProductModel product, List<File> images) async {
    try {
      List<String>? uriS = [];
      String? thumb;
      var _docRef =
          await _firestore.collection(_productDB).add(product.toMap());

      for (int i = 0; i < images.length; ++i) {
        UploadTask _task = _storage
            .ref('product/${_docRef.id}')
            .child('${_docRef.id}_$i.jpg')
            .putFile(images.elementAt(i));
        await _task.whenComplete(() {});
        String uri = await _storage
            .ref('product/${_docRef.id}')
            .child('${_docRef.id}_$i.jpg')
            .getDownloadURL();
        uriS.add(uri);
        if (i == 0) thumb = uri;
        await Future.delayed(Duration(seconds: 1));
      }

      product.thumbUri = thumb;
      product.images = uriS;
      await _firestore
          .collection(_productDB)
          .doc(_docRef.id)
          .update(product.toMap());

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateProductData(
      {required String uid,
      required var value,
      required String fieldName}) async {
    try {
      await _firestore
          .collection(_productDB)
          .doc(uid)
          .update({fieldName: value});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteProduct(String uid) async {
    try {
      await _firestore.collection(_productDB).doc(uid).delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
