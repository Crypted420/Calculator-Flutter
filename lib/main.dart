// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  ThemeData lightThemeData() {
    return ThemeData(
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  ThemeData darkThemeData() {
    return ThemeData(scaffoldBackgroundColor: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.grey));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(),
        home: const Calculator());
  }
}
