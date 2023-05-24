import 'package:flutter/material.dart';
import 'package:flutter_wake/Example_nfc.dart';
import 'package:flutter_wake/background.dart';

import 'alarm.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const NFC()
      );
    } 
  }