import 'package:flutter/material.dart';

class IconButtonMaterial extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final void Function()? onPressed;
  const IconButtonMaterial({
    Key? key,
    this.title,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(10.0),
      child: Center(
        child: RawMaterialButton(
          onPressed: this.onPressed,
          fillColor: Theme.of(context).primaryColorDark,
          splashColor: Theme.of(context).primaryColorLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 18.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon != null
                    ? Icon(
                        this.icon,
                        color: Colors.white,
                      )
                    : SizedBox(),
                SizedBox(width: icon != null ? 4.0 : 0.0),
                Text(
                  this.title.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
