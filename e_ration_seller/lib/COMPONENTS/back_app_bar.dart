import 'package:flutter/material.dart';

class BackAppBar extends StatelessWidget {
  final String? title;
  const BackAppBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 0.0,
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: double.maxFinite,
            child: Text(
              this.title.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
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
    );
  }
}
