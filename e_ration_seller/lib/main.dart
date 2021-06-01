import 'package:e_ration_seller/MODELS/contants.dart';
import 'package:e_ration_seller/MODELS/database_model.dart';
import 'package:e_ration_seller/PAGES/dashboard.dart';
import 'package:e_ration_seller/PAGES/login_screen.dart';
import 'package:e_ration_seller/PAGES/sign_up_screen.dart';
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
  }

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E Ration Seller',
      theme: ThemeData(
          primaryColorLight: Color(0xFFFFCA28),
          primaryColorDark: Color(0xFFFFA000),
          // scaffoldBackgroundColor: Color(0xFFFFA000),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFFFA000),
            foregroundColor: Colors.white,
            splashColor: Color(0xFFFFCA28),
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              fontFamily: 'Product Sans',
            ),
          ),
          fontFamily: 'Product Sans',
          primarySwatch: Colors.grey,
          shadowColor: Color(0xFFFFCA28)),
      routes: {
        '/': (context) => HomeRoute(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignUpScreen(),
      },
    );
  }
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.isLoggedIn! ? Dashboard() : LoginScreen();
  }
}
