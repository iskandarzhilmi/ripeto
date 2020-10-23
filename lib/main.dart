import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripeto/screens/home_screen.dart';
import 'package:ripeto/screens/login_screen.dart';
import 'package:ripeto/services/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class Data extends ChangeNotifier {
  String uid;

  Data(this.uid);
}
