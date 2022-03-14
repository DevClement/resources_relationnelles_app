import 'package:cube/screen/account_screen.dart';
import 'package:cube/screen/home_screen.dart';
import 'package:cube/screen/login_screen.dart';
import 'package:cube/screen/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ressources Relationnels',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        HomeScreen.route: (context) => HomeScreen(),
        LoginScreen.route: (context) => LoginScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
        AccountScreen.route: (context) => AccountScreen(),
      },
      initialRoute: HomeScreen.route,
    );
  }
}
