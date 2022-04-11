import 'package:flutter/material.dart';
import 'package:hello_me/models/ransom_words.dart';
import 'package:hello_me/screens/saved_page.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../snapping_sheet.dart';
import 'login_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthRepository,WordModel>(
      builder: (context,auth,words, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Startup Name Generator'),
            actions: [
              IconButton(
                icon: const Icon(Icons.star),
                onPressed: () {
                  _pushSaved(context);
                },
                tooltip: 'Saved Suggestions',
              ),
              IconButton(
                icon: auth.isAuthenticated
                    ? const Icon(Icons.exit_to_app)
                    : const Icon(Icons.login),
                onPressed: () {
                  auth.isAuthenticated
                      ? _pushLogout(context, auth)
                      : _pushLogin(context);
                },
                tooltip: auth.isAuthenticated ? 'Logout' : 'Login',
              ),
            ],
          ),
          body: auth.isAuthenticated? SimpleSnappingSheet() :words.buildSuggestions(),
        );
      },
    );
  }

  void _pushSaved(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return const Saved();
        },
      ),
    );
  }

  void _pushLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return LogInPage();
        },
      ),
    );
  }

  void _pushLogout(BuildContext context, AuthRepository auth) async {
    await auth.signOut();
  }
}
