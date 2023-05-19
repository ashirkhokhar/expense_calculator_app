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

    // Add any initialization tasks or delay here if needed

    // Example: Navigate to the home screen after a delay
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
              'assets/unnamed.png', // Replace with your splash screen image path
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Expense Tracker',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 180),
            const CircularProgressIndicator(
              color: Colors.black,
            ), // Loading indicator
            const SizedBox(height: 20),
            const Text(
              'Loading',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
