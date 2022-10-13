import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/firebase_options.dart';
import 'package:twitterclone/modules/welcome/welcome_view.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint(Firebase.apps.length.toString());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeView(),
    );
  }
}
