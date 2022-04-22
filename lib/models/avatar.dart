import 'package:flutter/material.dart';

class AvatarPhoto extends StatelessWidget {
  String photoURL;
  AvatarPhoto({Key? key, required String this.photoURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image:
        DecorationImage(image: NetworkImage(photoURL), fit: BoxFit.fill),
      ),
    );
  }
}
