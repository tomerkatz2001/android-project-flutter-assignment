import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/ransom_words.dart';
import 'package:provider/provider.dart';


class Saved extends StatelessWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final saved = Provider.of<WordModel>(context, listen: false).saved;
    final tiles = saved.map<Widget>(
      (pair) {
        return Dismissible(
          child: ListTile(
            title: Text(
              pair.asPascalCase,
              style: Provider.of<WordModel>(context, listen: false).biggerFont,
            ),
          ),
          key: ValueKey<WordPair>(pair),
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.deepPurple,
            alignment: Alignment.centerLeft,
            child: Row(
              children: const [
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                Text(
                  "Delete suggestion",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          secondaryBackground: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.deepPurple,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  "Delete suggestion",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          confirmDismiss: (DismissDirection direction) async {
            return await _DeleteDialog(context, pair);
          },
        );
      },
    );
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
        : <Widget>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Suggestions'),
      ),
      body: ListView(children: divided),
    );
  }
}

Future<bool?> _DeleteDialog(BuildContext context, WordPair name) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Suggestion'),
        content: SingleChildScrollView(
          child: Text('Are you sure you wnat to delete $name from your saved suggestion?'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('yes'),
            onPressed: () {
              Provider.of<WordModel>(context, listen: false).removePair(name);
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: const Text('no'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}


