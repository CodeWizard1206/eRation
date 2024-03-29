import 'package:e_ration/MODELS/constants.dart';
import 'package:e_ration/MODELS/database_model.dart';
import 'package:e_ration/PAGES/dashboard.dart';
import 'package:e_ration/PAGES/login_screen.dart';
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
    Constant.setUser = await DatabaseManager.getInstance.getUser(_cache);
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eRation',
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
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF5D3917),
          unselectedItemColor: Colors.blueGrey[700],
          showUnselectedLabels: false,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
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
    return Constant.isLoggedIn! ? Dashboard() : LoginScreen();
  }
}
