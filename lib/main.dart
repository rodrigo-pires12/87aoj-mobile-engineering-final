import 'package:flutter/material.dart';
import 'package:trabalho_final/screens/add.dart';
import 'package:trabalho_final/screens/home.dart';
import 'package:trabalho_final/screens/list.dart';
import 'package:trabalho_final/screens/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weight Tracker',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const Home(),
          "/list": (context) => const WeightListWidget(),
          "/add": (context) => const AddWeight(),
          "/settings": (context) => const Settings()
        });
  }
}
