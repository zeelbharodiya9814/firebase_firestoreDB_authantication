import 'package:firebase_app/views/screens/homepage.dart';
import 'package:firebase_app/views/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();


  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: 'Login_page',
      routes: {
        '/' : (context) => Home_page(),
        'Login_page' : (context) => Login_page(),
      },
    ),
  );
}