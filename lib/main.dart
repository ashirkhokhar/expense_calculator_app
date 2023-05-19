// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

import 'SplashScreen.dart';

void main() {
  runApp(const ExpenseCalculatorApp());
}

class Expense {
  final String name;
  final double amount;
  final DateTime dateTime;

  Expense(
    this.name,
    this.amount, {
    required this.dateTime,
  });
}

class ExpenseCalculatorApp extends StatelessWidget {
  const ExpenseCalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.pink,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyText2: TextStyle(fontSize: 16.0, color: Colors.black),
          headline6: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
