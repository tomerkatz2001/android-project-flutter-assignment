import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class SignUpModal extends StatelessWidget {
  var enteredPassword;
  var mail;

  SignUpModal({Key? key, required this.enteredPassword, required this.mail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SignUpBottomSheet(
                enteredPassword: enteredPassword,
                mail: mail,
              );
            });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        primary: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: const Text("New user? Click here to sign up"),
    );
  }
}

class SignUpBottomSheet extends StatefulWidget {
  var enteredPassword;
  var mail;
  SignUpBottomSheet(
      {Key? key, required this.enteredPassword, required this.mail})
      : super(key: key);

  @override
  _SignUpBottomSheetState createState() =>
      _SignUpBottomSheetState(enteredPassword, mail);
}

class _SignUpBottomSheetState extends State<SignUpBottomSheet> {
  var enteredPassword;
  var mail;
  final passwordController = TextEditingController();
  var _valid = true;

  _SignUpBottomSheetState(this.enteredPassword, this.mail);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(builder: (context, auth, child) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 222,
          child: Column(
            children: [
              const ListTile(
                title: Center(
                  child: Text('Please confirm your password below:'),
                ),
              ),
              const Divider(),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _valid ? null : "Passwords must match"),
                controller: passwordController,
                obscureText: true,
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  if (auth.status == Status.Authenticating) {}
                  else {
                    if (passwordController.text == enteredPassword.text) {
                      auth.signUp(mail.text, enteredPassword.text).then(
                            (value) {
                          if (value != null) {
                            FirebaseFirestore.instance
                                .collection('v1.0.0')
                                .doc("data")
                                .collection("users")
                                .doc(auth.user!.email)
                                .update({
                              "avatar_path": "users/default/avatar.jpg"
                            }).then((value) {});
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              _valid = true;
                            });
                          }
                        },
                      );
                    } else {
                      setState(() {
                        _valid = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: auth.status == Status.Authenticating
                      ? Colors.black12
                      : Colors.lightBlue,
                ),
                child: const Text("Confirm"),
              ),
            ],
          ),
        ),
      );
    });
  }
}
