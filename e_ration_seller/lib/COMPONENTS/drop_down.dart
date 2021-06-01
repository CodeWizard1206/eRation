import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final String? label;
  final String? initialValue;
  final List<DropdownMenuItem<dynamic>>? items;
  final void Function(dynamic)? onChange;
  DropDown({Key? key, this.label, this.initialValue, this.items, this.onChange})
      : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        hintText: this.widget.label,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColorLight,
        ),
        labelText: this.widget.label,
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
      ),
      value: widget.initialValue,
      items: widget.items,
      onChanged: widget.onChange,
    );
  }
}
