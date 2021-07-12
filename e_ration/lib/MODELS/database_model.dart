import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ration/MODELS/cart_model.dart';
import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/MODELS/order_model.dart';
import 'package:e_ration/MODELS/product_model.dart';
import 'package:e_ration/MODELS/query_model.dart';
import 'package:e_ration/MODELS/seller_order_model.dart';
import 'package:e_ration/MODELS/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseManager {
  static DatabaseManager _db = DatabaseManager();
  static DatabaseManager get getInstance => _db;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  final String _userDB = 'userDatabase';
  final String _sellerDB = 'sellerDatabase';
  // final String _reviewColl = 'userReviews';
  final String _productDB = 'productDatabase';
  // final String _queriesColl = 'userQueries';

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
            await _firestore.collection(_userDB).doc(_user!.uid).get();

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

      await _firestore.collection(_userDB).doc(uid).set(user.toMap());
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
        await _firestore.collection(_userDB).doc(_userCred.user!.uid).get();

    return UserModel.fromDoc(_doc);
  }

  //get review data stream of user.
  // Stream<List<int>> getReviewDataStream() {
  //   Stream<List<int>> _return = _firestore
  //       .collection(_userDB)
  //       .doc(Constant.getUser.uid)
  //       .collection(_reviewColl)
  //       .orderBy('timestamp')
  //       .snapshots()
  //       .map((event) => event.docs.map((e) => e['rating'] as int).toList());

  //   return _return;
  // }

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
        .orderBy('productName')
        .snapshots()
        .map(
          (event) => event.docs.map((e) => ProductModel.fromDoc(e)).toList(),
        );

    return _return;
  }

  Stream<List<ProductModel>> getProductsWhereCategory(String category) {
    Stream<List<ProductModel>> _return = _firestore
        .collection(_productDB)
        .where('category', isEqualTo: category)
        .orderBy('productName')
        .snapshots()
        .map(
          (event) => event.docs.map((e) => ProductModel.fromDoc(e)).toList(),
        );

    return _return;
  }

  // Stream<int> getQueries() {
  //   Stream<int> _return = _firestore
  //       .collection(_userDB)
  //       .doc(Constant.getUser.uid)
  //       .collection(_queriesColl)
  //       .where('answered', isEqualTo: true)
  //       .snapshots()
  //       .map((event) => event.docs.length);

  //   return _return;
  // }

  Future<void> deleteProfileImage() async {
    try {
      await _storage.ref('profileImages/${Constant.getUser.uid}.jpeg').delete();
      await _firestore
          .collection(_userDB)
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
          .collection(_userDB)
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
    await _auth.signInWithEmailAndPassword(
        email: Constant.getUser.email!, password: Constant.getUser.pass!);
    try {
      if (updateEmail) {
        await _auth.currentUser!.updateEmail(user.email.toString());
      }
      if (updatePassword) {
        await _auth.currentUser!.updatePassword(user.pass.toString());
      }

      await _firestore.collection(_userDB).doc(user.uid).update(user.toMap());

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

  Future<bool> placeOrder() async {
    int sum = 0;
    for (CartModel i in Constant.cartItems) {
      sum += (i.product.price! * i.qty);
    }

    DateTime _now = DateTime.now();
    try {
      var _user = await _firestore
          .collection(_userDB)
          .where('contact', isEqualTo: Constant.getUser.contact)
          .get();

      String _uid = _user.docs.first.id;

      OrderModel _order = OrderModel(
        timestamp: _now,
        totalAmount: sum.toString(),
        date: Constant.cartItems.first.date,
        time: Constant.cartItems.first.time,
        products: Constant.cartItems.map((cart) => cart.product).toList(),
      );

      var _doc = await _firestore
          .collection(_userDB)
          .doc(_uid)
          .collection('myOrders')
          .add(_order.toMap());

      for (CartModel i in Constant.cartItems) {
        SellerOrderModel _sellerorder = SellerOrderModel(
          orderId: _doc.id,
          name: Constant.getUser.name,
          email: Constant.getUser.email,
          contact: Constant.getUser.contact,
          profile: Constant.getUser.profile,
          timestamp: _now,
          date: i.date,
          time: i.time,
          product: i.product,
        );

        await _firestore
            .collection(_sellerDB)
            .doc(i.product.sellerId)
            .collection('orders')
            .add(_sellerorder.toMap());

        var _data = await _firestore
            .collection('productDatabase')
            .doc(i.product.uid)
            .get();
        await _firestore
            .collection('productDatabase')
            .doc(i.product.uid)
            .update({
          'stocks': (_data.get('stocks') - 1),
        });
      }

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
    // ignore: dead_code
    return false;
  }

  Stream<List<OrderModel>> getMyOrders() {
    var _data = _firestore
        .collection(_userDB)
        .doc(Constant.getUser.uid!)
        .collection('myOrders')
        .snapshots()
        .map((query) =>
            query.docs.map((doc) => OrderModel.fromDoc(doc)).toList());

    return _data;
  }

  Future<List<QueryModel>> getQueries(String uid) async {
    try {
      var _data = await _firestore
          .collection(_productDB)
          .doc(uid)
          .collection('query')
          .orderBy('timestamp', descending: true)
          .get();

      return _data.docs.map((snap) => QueryModel.fromDoc(snap)).toList();
    } catch (ex) {
      print(ex.toString());
      return [];
    }
  }

  Future<bool> askQuery(String uid, QueryModel query) async {
    try {
      await _firestore
          .collection(_productDB)
          .doc(uid)
          .collection('query')
          .add(query.toMap());

      await _firestore
          .collection(_productDB)
          .doc(uid)
          .update({'lastQuery': DateTime.now()});
      return true;
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }

  Stream<List<String>> getNearbySellers() {
    var _data = _firestore
        .collection(_sellerDB)
        .where('area', isEqualTo: Constant.getUser.area)
        .orderBy('shopName')
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => doc.get('shopName').toString()).toList());

    return _data;
  }

  Stream<List<ProductModel>> getSellerProducts(String shopName) {
    var _data = _firestore
        .collection(_productDB)
        .where('sellerName', isEqualTo: shopName)
        .where('stocks', isGreaterThan: 0)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => ProductModel.fromDoc(doc)).toList(),
        );

    return _data;
  }
}
