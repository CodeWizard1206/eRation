import 'package:flutter/material.dart';

// class InputField extends StatelessWidget {
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//   final bool obscureText;
//   final String? title;
//   final bool visibilityToggle;
//   final int? maxLines;
//   final TextInputType? keyboardType;
//   const InputField({
//     Key? key,
//     this.controller,
//     this.focusNode,
//     this.obscureText = false,
//     this.visibilityToggle = false,
//     this.title,
//     this.maxLines = 1,
//     this.keyboardType = TextInputType.text,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: this.controller,
//       focusNode: this.focusNode,
//       obscureText: this.obscureText,
//       minLines: 1,
//       maxLines: this.maxLines,
//       keyboardType: this.keyboardType,
//       cursorColor: Theme.of(context).primaryColorLight,
//       decoration: InputDecoration(
//         hintText: this.title,
//         hintStyle: TextStyle(
//           color: Theme.of(context).primaryColorLight,
//         ),
//         labelText: this.title,
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
//       ),
//     );
//   }
// }

class InputField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final String? title;
  final bool visibilityToggle;
  final bool dateToggle;
  final bool enabled;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool iconPlaceholder;
  final IconData? icon;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChange;

  InputField({
    Key? key,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.visibilityToggle = false,
    this.dateToggle = false,
    this.enabled = true,
    this.iconPlaceholder = false,
    this.icon,
    this.title,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.onFieldSubmitted,
    this.onChange,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool obscureText;

  @override
  void initState() {
    this.obscureText = this.widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: this.widget.controller,
        focusNode: this.widget.focusNode,
        obscureText: this.obscureText,
        minLines: 1,
        maxLines: this.widget.maxLines,
        keyboardType: this.widget.keyboardType,
        cursorColor: Theme.of(context).primaryColorLight,
        textCapitalization: this.widget.textCapitalization,
        enabled: this.widget.dateToggle ? false : this.widget.enabled,
        onFieldSubmitted: this.widget.onFieldSubmitted,
        onChanged: this.widget.onChange,
        decoration: InputDecoration(
          hintText: this.widget.title,
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
          disabledBorder: OutlineInputBorder(
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
          suffix: this.widget.visibilityToggle
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      this.obscureText = !this.obscureText;
                    });
                  },
                  child: Icon(this.obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                )
              : this.widget.dateToggle
                  ? Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.black87,
                    )
                  : this.widget.iconPlaceholder
                      ? Icon(
                          this.widget.icon,
                          color: Colors.black87,
                        )
                      : null,
        ),
      ),
    );
  }
}
