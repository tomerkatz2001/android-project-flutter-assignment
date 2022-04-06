import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';



import 'auth.dart';
import 'ransom_words.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());

}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
            body: Center(
                child: Text(snapshot.error.toString(),
                    textDirection: TextDirection.ltr)));
      }
      if (snapshot.connectionState == ConnectionState.done) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthRepository.instance()),
            ChangeNotifierProxyProvider<AuthRepository, WordModel>(
              create: (context) => WordModel(),
              update: (context, auth, wordModel) => wordModel!.update(auth),
            ),
          ],
            child: MyApp(),
        );

      }
      return Center(child: CircularProgressIndicator());
        },
    );
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(          // Add the 5 lines from here...
        // appBarTheme: const AppBarTheme(
        //   backgroundColor: Colors.white,
        //   foregroundColor: Colors.black,
        // ),
        primarySwatch: Colors.deepPurple,
      ),
      home:  RandomWords(),
    );
  }
}










