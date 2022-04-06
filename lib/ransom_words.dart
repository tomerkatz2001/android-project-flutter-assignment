import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/saved_page.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'auth.dart';
import 'login_screen.dart';

class WordModel extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthRepository? _auth;
  final _suggestions = <WordPair>[];

  final _saved = <WordPair>{};
  get saved => _saved;

  final _biggerFont = const TextStyle(fontSize: 18);
  get biggerFont => _biggerFont;

  void removePair(WordPair name)
  {
    _saved.remove(name);
    _updateCloud(name);
    notifyListeners();
  }

  void _getFromCloud(AuthRepository auth)  {
    if(auth.isAuthenticated){
      var x =  _firestore.collection('v1.0.0').doc("data").collection("users").doc(auth.user!.email).get().then((value) {
        var data = value.data();
        var cloud_saved = data==null?{}:data["favorites"];
        var set = {...List<String>.from(cloud_saved)};
        var reg = RegExp(r"(?<=[a-z])(?=[A-Z])");
        var add = set.map((e) => WordPair(e.split(reg)[0].toLowerCase(),e.split(reg)[1].toLowerCase()));
        _saved.addAll(add);
      }).then((value) {notifyListeners();});

    }
  }

  void _updateCloud(WordPair? remove){
      if(_auth == null) return;
      if(_auth!.isAuthenticated){
        if (remove==null){
          var new_list = _saved.map((e) => e.asPascalCase).toList();
          var x =  _firestore.collection('v1.0.0').doc("data").collection("users").doc(_auth!.user!.email).update({"favorites":FieldValue.arrayUnion(new_list)}).then((value) { });
        }
        else{
          var x =  _firestore.collection('v1.0.0').doc("data").collection("users").doc(_auth!.user!.email).update({"favorites":FieldValue.arrayRemove([remove.asPascalCase])}).then((value) { });
        }
      }
  }

  WordModel update(AuthRepository auth){
    _getFromCloud(auth);
    _auth = auth;
    _updateCloud(null);
    return this;
  }

  Widget buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      // The itemBuilder callback is called once per suggested
      // word pairing, and places each suggestion into a ListTile
      // row. For even rows, the function adds a ListTile row for
      // the word pairing. For odd rows, the function adds a
      // Divider widget to visually separate the entries. Note that
      // the divider may be difficult to see on smaller devices.
      itemBuilder: (context, i) {
        // Add a one-pixel-high divider widget before each row
        // in the ListView.
        if (i.isOdd) {
          return const Divider();
        }

        // The syntax "i ~/ 2" divides i by 2 and returns an
        // integer result.
        // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
        // This calculates the actual number of word pairings
        // in the ListView,minus the divider widgets.
        final index = i ~/ 2;
        // If you've reached the end of the available word
        // pairings...
        if (index >= _suggestions.length) {
          // ...then generate 10 more and add them to the
          // suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index], Provider.of<AuthRepository>(context, listen: false));
      },
    );
  }

  Widget _buildRow(WordPair pair, AuthRepository auth) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.deepPurple : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () {
        if (alreadySaved) {
          _saved.remove(pair);
          _updateCloud(pair);

        } else {
          _saved.add(pair);
          _updateCloud(null);
        }
        notifyListeners();
      },
    );
  }
}

class RandomWords extends StatelessWidget {
  const RandomWords({Key? key}) : super(key: key);

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
          body: words.buildSuggestions(),
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
