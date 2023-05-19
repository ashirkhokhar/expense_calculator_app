// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:weekly_expense_calcultor_app/expensecalculatorscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExpenseCalculatorScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/unnamed (1).png', // Replace with your splash screen image path
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Expense Tracker',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 180),
            const CircularProgressIndicator(
              color: Colors.black,
            ), // Loading indicator
            const SizedBox(height: 20),
            const Text(
              'Loading...',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
