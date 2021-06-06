import 'package:e_ration/MODELS/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences _cache = await SharedPreferences.getInstance();
  Constant.isLoggedIn =
      _cache.getBool('loggedIn') == null ? false : _cache.getBool('loggedIn')!;

  if (Constant.isLoggedIn!) {
    // Constant.setUser = await DatabaseManager.getInstance.getUser(_cache);
  }

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eRation',
      theme: ThemeData(
        primaryColorLight: Color(0xFFFFCA28),
        primaryColorDark: Color(0xFFFFA000),
        // scaffoldBackgroundColor: Color(0xFFFFA000),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFA000),
          foregroundColor: Colors.white,
          splashColor: Color(0xFFFFCA28),
        ),
        fontFamily: 'Product Sans',
        primarySwatch: Colors.grey,
        shadowColor: Color(0xFFFFCA28),
      ),
      routes: {
        '/': (context) => Home(),
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
