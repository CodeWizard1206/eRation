import 'package:e_ration_seller/MODELS/contants.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/PAGES/dashboard.dart';
import 'package:e_ration_seller/PAGES/login_screen.dart';
import 'package:e_ration_seller/PAGES/manage_product.dart';
import 'package:e_ration_seller/PAGES/orders.dart';
import 'package:e_ration_seller/PAGES/queries.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences _cache = await SharedPreferences.getInstance();
  Constant.isLoggedIn =
      _cache.getBool('loggedIn') == null ? false : _cache.getBool('loggedIn');

  if (Constant.isLoggedIn!) {
    Constant.setUser = await DatabaseManager.getInstance.getUser(_cache);
    await DatabaseManager.getInstance.getCategories();
  }

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eRation Seller',
      theme: ThemeData(
        primaryColorLight: Color(0xFF81664B),
        primaryColorDark: Color(0xFF5D3917),
        // scaffoldBackgroundColor: Color(0xFF5D3917),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF5D3917),
          foregroundColor: Colors.white,
          splashColor: Color(0xFF81664B),
        ),
        fontFamily: 'Product Sans',
        primarySwatch: Colors.grey,
        shadowColor: Color(0xFF81664B),
      ),
      routes: {
        '/': (context) => HomeRoute(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => Dashboard(),
        '/manage': (context) => ManageProduct(),
        '/orders': (context) => Orders(),
        '/queries': (context) => Queries(),
      },
      // initialRoute: '/',
    );
  }
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.isLoggedIn! ? Dashboard() : LoginScreen();
    // return AddCategory();
  }
}
