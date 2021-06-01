import 'package:flutter/material.dart';

class AsyncLoader extends StatelessWidget {
  const AsyncLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation(Theme.of(context).primaryColorLight),
        ),
        SizedBox(height: 12.0),
        Text(
          'Please Wait...',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
