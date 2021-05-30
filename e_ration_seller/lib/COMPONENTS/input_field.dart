import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  bool obscureText;
  final String? title;
  final bool visibilityToggle;
  InputField({
    Key? key,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.visibilityToggle = false,
    this.title,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.widget.controller,
      focusNode: this.widget.focusNode,
      obscureText: this.widget.obscureText,
      maxLines: 1,
      cursorColor: Theme.of(context).primaryColorLight,
      decoration: InputDecoration(
        hintText: this.widget.title,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColorLight,
        ),
        labelText: this.widget.title,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColorDark,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColorLight,
            width: 0.7,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColorLight,
            width: 1.5,
          ),
        ),

        // suffix: this.widget.visibilityToggle
        //     ? GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             this.widget.obscureText = !this.widget.obscureText;
        //           });
        //         },
        //         child: Icon(this.widget.obscureText
        //             ? Icons.visibility_outlined
        //             : Icons.visibility_off_outlined),
        //       )
        //     : null,
      ),
    );
  }
}
