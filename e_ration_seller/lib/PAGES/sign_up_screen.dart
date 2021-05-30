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
            Container(
              width: MediaQuery.of(context).size.width,
              child: CircleAvatar(
                radius: (MediaQuery.of(context).size.width * 0.3),
                backgroundImage: AssetImage('assets/images/user.png'),
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
          ],
        ),
      ),
    );
  }
}
