import 'package:e_ration_seller/COMPONENTS/input_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController? _name;
  TextEditingController? _email;
  TextEditingController? _contact;
  TextEditingController? _pass;
  TextEditingController? _passConfirm;
  TextEditingController? _address;
  TextEditingController? _area;
  TextEditingController? _city;
  TextEditingController? _state;

  String? _gender;
  DateTime? _dob;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _contact = TextEditingController();
    _pass = TextEditingController();
    _passConfirm = TextEditingController();
    _address = TextEditingController();
    _area = TextEditingController();
    _city = TextEditingController();
    _state = TextEditingController();

    _gender = "FEMALE";
    _dob = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    width: double.maxFinite,
                    child: Text(
                      'SignUp',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Product Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 36.0,
                      ),
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    fillColor: Theme.of(context).primaryColorDark,
                    splashColor: Theme.of(context).primaryColorLight,
                    shape: CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(20),
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        border: Border.all(
                            color: Theme.of(context).primaryColorLight,
                            width: 2),
                      ),
                      padding: const EdgeInsets.all(3.0),
                      child: CircleAvatar(
                        radius: (MediaQuery.of(context).size.width * 0.3),
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            null, //AssetImage('assets/images/user.png'),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(120),
                          child: Image.asset(
                            'assets/images/user.png',
                            scale: 1.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.camera_alt,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputField(
                    controller: _name,
                    title: "Name",
                  ),
                  InputField(
                    controller: _email,
                    title: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  InputField(
                    controller: _contact,
                    title: "Contact",
                    keyboardType: TextInputType.phone,
                  ),
                  InputField(
                    controller: _contact,
                    title: "Contact",
                    keyboardType: TextInputType.phone,
                  ),
                  InputField(
                    controller: _address,
                    title: "Address",
                    maxLines: 5,
                  ),
                  InputField(
                    controller: _area,
                    title: "Area",
                  ),
                  InputField(
                    controller: _city,
                    title: "City",
                  ),
                  InputField(
                    controller: _state,
                    title: "State",
                  ),
                  InputField(
                    controller: _pass,
                    title: "Password",
                    obscureText: true,
                    visibilityToggle: true,
                  ),
                  InputField(
                    controller: _passConfirm,
                    title: "Confirm Password",
                    obscureText: true,
                    visibilityToggle: true,
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.all(12.0),
              child: Center(
                child: RawMaterialButton(
                  onPressed: () {},
                  fillColor: Theme.of(context).primaryColorDark,
                  splashColor: Theme.of(context).primaryColorLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 22.0,
                    ),
                    child: Text(
                      'Sign Me Up!',
                      style: TextStyle(
                        fontFamily: 'Product Sans',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
