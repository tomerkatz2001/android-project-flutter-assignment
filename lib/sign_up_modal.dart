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
                  print(passwordController.text);
                  print(enteredPassword);
                  if (passwordController.text == enteredPassword.text) {
                    print("here!!!!!!!!!!!!!!!!!!!");
                    var res = auth.signUp(mail.text, enteredPassword.text);
                    if (res == true) {
                      Navigator.of(context).pop();
                    }
                    else{
                      print("faild!!!!");
                      setState(() {
                        _valid = true;
                      });
                    }
                  }else {
                    print("invaliddd!!!!!!!!!!!");
                    setState(() {
                      _valid = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
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
