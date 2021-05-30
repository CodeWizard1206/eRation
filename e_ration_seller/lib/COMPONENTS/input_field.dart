import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final String? title;
  final bool visibilityToggle;
  final int? maxLines;
  const InputField({
    Key? key,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.visibilityToggle = false,
    this.title,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      focusNode: this.focusNode,
      obscureText: this.obscureText,
      minLines: 1,
      maxLines: this.maxLines,
      cursorColor: Theme.of(context).primaryColorLight,
      decoration: InputDecoration(
        hintText: this.title,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColorLight,
        ),
        labelText: this.title,
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
      ),
    );
  }
}

// class InputField extends StatefulWidget {
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//   final bool obscureText;
//   final String? title;
//   final bool visibilityToggle;
//   InputField({
//     Key? key,
//     this.controller,
//     this.focusNode,
//     this.obscureText = false,
//     this.visibilityToggle = false,
//     this.title,
//   }) : super(key: key);

//   @override
//   _InputFieldState createState() => _InputFieldState();
// }

// class _InputFieldState extends State<InputField> {
//   late bool obscureText;
//   @override
//   void initState() {
//     super.initState();
//     obscureText = this.widget.obscureText;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: this.widget.controller,
//       focusNode: this.widget.focusNode,
//       obscureText: this.obscureText,
//       maxLines: 1,
//       cursorColor: Theme.of(context).primaryColorLight,
//       decoration: InputDecoration(
//         hintText: this.widget.title,
//         hintStyle: TextStyle(
//           color: Theme.of(context).primaryColorLight,
//         ),
//         labelText: this.widget.title,
//         labelStyle: TextStyle(
//           color: Theme.of(context).primaryColorDark,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20.0),
//           borderSide: BorderSide(
//             color: Theme.of(context).primaryColorLight,
//             width: 0.7,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20.0),
//           borderSide: BorderSide(
//             color: Theme.of(context).primaryColorLight,
//             width: 1.5,
//           ),
//         ),

//         suffix: this.widget.visibilityToggle
//             ? GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     this.widget.obscureText = !this.widget.obscureText;
//                   });
//                 },
//                 child: Icon(this.widget.obscureText
//                     ? Icons.visibility_outlined
//                     : Icons.visibility_off_outlined),
//               )
//             : null,
//       ),
//     );
//   }
// }
