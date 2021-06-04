import 'package:flutter/material.dart';

class CirclePicture extends StatelessWidget {
  final ImageProvider<Object> backgroundImage;
  const CirclePicture({
    Key? key,
    required this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).primaryColorLight,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: this.backgroundImage,
      ),
    );
  }
}
