import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/sign_up_modal.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class LogInPage extends StatelessWidget {
  LogInPage({Key? key}) : super(key: key);

  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    EmailController.dispose();
    PasswordController.dispose();
    //super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Welcome to Startup Names Generator, please log in below",
                style: TextStyle(fontSize: 14),
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Email'),
                controller: EmailController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Password'),
                controller: PasswordController,
                obscureText: true,
              ),
              Consumer<AuthRepository>(
                builder: (context, auth, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (auth.status == Status.Authenticating) {
                      } else {
                         await auth.signIn(
                            EmailController.text, PasswordController.text).then((value) {
                          if (value == true) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'There was an error logging into the app')),
                            );
                          }
                        });

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: auth.status == Status.Authenticating
                          ? Colors.black12
                          : Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text("Log in"),
                  );
                },
              ),
              SignUpModal(enteredPassword:PasswordController, mail: EmailController,).build(context),
            ],
          )),
    );
  }
}
