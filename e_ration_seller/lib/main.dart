import 'package:e_ration_seller/PAGES/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences _cache = await SharedPreferences.getInstance();
  bool? _isLoggedIn =
      _cache.getBool('loggedIn') == null ? false : _cache.getBool('loggedIn');

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
        scaffoldBackgroundColor: Color(0xFFFFA000),
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
        primarySwatch: Colors.grey,
      ),
      routes: {
        '/': (context) => HomeRoute(),
      },
    );
  }
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
