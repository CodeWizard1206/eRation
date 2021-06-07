import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final IconData? icon;
  final String? message;
  const NoData({
    Key? key,
    this.icon,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          this.icon,
          size: 210.0,
        ),
        SizedBox(
          width: double.maxFinite,
          height: 4.0,
        ),
        Text(
          this.message.toString(),
          style: TextStyle(fontSize: 22.0),
        ),
        SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}
