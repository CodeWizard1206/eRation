import 'package:e_ration/COMPONENTS/async_loader.dart';
import 'package:e_ration/COMPONENTS/input_field.dart';
import 'package:e_ration/MODELS/database_model.dart';
import 'package:e_ration/PAGES/sign_up_screen.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _userFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  bool? _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: this._isLoading,
        opacity: 0.8,
        progressIndicator: AsyncLoader(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: (MediaQuery.of(context).size.height - 25),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    width: MediaQuery.of(context).size.width * 0.80,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputField(
                        controller: _userController,
                        focusNode: _userFocus,
                        title: "Email",
                      ),
                      InputField(
                        controller: _passController,
                        focusNode: _passFocus,
                        title: "Password",
                        obscureText: true,
                        visibilityToggle: true,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                // Navigator.pushNamed(context, '/signUp');
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: SignUpScreen(),
                                  ),
                                );
                              },
                              splashColor: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 20.0,
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(
                                  color: Theme.of(context).primaryColorLight,
                                  width: 2,
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) =>
                                  FloatingActionButton.extended(
                                label: Text(
                                  'Login',
                                  style: TextStyle(
                                    // color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_userFocus.hasPrimaryFocus)
                                    _userFocus.unfocus();
                                  if (_passFocus.hasPrimaryFocus)
                                    _passFocus.unfocus();

                                  if (_userController.text.isNotEmpty &&
                                      _passController.text.isNotEmpty) {
                                    setState(() {
                                      this._isLoading = true;
                                    });
                                    DatabaseManager _db =
                                        DatabaseManager.getInstance;

                                    bool _result = await _db.getLoginCred(
                                        _userController.text,
                                        _passController.text);
                                    setState(() {
                                      this._isLoading = false;
                                    });

                                    if (_result) {
                                      // ignore: deprecated_member_use
                                      Navigator.popAndPushNamed(context, '/');
                                      // Scaffold.of(context).showSnackBar(
                                      //     SnackBar(content: Text("Logged IN")));
                                    } else {
                                      // ignore: deprecated_member_use
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Invalid Credentials Provided!!!"),
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_right_sharp,
                                  size: 38,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
