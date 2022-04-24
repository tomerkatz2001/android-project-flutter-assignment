import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class GrabbingWidget extends StatelessWidget {
  final Function() changeState;
  String email = "";
  GrabbingWidget(this.changeState);

  @override
  Widget build(BuildContext context) {
    email = Provider.of<AuthRepository>(context, listen: false).user!.email!;
    return GestureDetector(
      onTap: () => changeState(),
      child: Container(
        alignment: Alignment.centerLeft,
        color: Colors.grey[400],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                "Welcome back, $email", //auth.email
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.keyboard_arrow_up),
            ),
          ],
        ),
      ),
    );
  }
}

