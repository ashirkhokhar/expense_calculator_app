import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_expense_calcultor_app/chartscreen.dart';
import 'package:weekly_expense_calcultor_app/listexpensescreen.dart';
import 'package:weekly_expense_calcultor_app/main.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ExpenseCalculatorScreen extends StatefulWidget {
  const ExpenseCalculatorScreen({Key? key}) : super(key: key);

  @override
  _ExpenseCalculatorScreenState createState() =>
      _ExpenseCalculatorScreenState();
}

class _ExpenseCalculatorScreenState extends State<ExpenseCalculatorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _itemCountController = TextEditingController();
  List<Expense> _weeklyExpenses = [];
  int _totalItems = 0;
  bool _nameFieldError = false;
  bool _expenseFieldError = false;
  bool _itemCountFieldError = false;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        final expenseList = prefs.getStringList('expenses') ?? [];
        _totalItems = prefs.getInt('totalItems') ?? 0;
        _weeklyExpenses = expenseList.map((expenseString) {
          final expenseData = expenseString.split(':');
          final name = expenseData[0];
          final amount = double.tryParse(expenseData[1]) ?? 0.0;
          final dateTime =
              DateTime.fromMillisecondsSinceEpoch(int.parse(expenseData[2]));
          return Expense(name, amount, dateTime: dateTime);
        }).toList();
      });
    } catch (e) {
      print('Error loading expenses: $e');
      // Handle the error gracefully, show an error message, or perform any other necessary actions.
    }
  }

  void _saveExpenses() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      final expenseList = _weeklyExpenses
          .map((expense) =>
              '${expense.name}:${expense.amount}:${expense.dateTime.millisecondsSinceEpoch}')
          .toList();
      await prefs.setStringList('expenses', expenseList);
      await prefs.setInt('totalItems', _totalItems);
    } catch (e) {
      print('Error saving expenses: $e');
    }
  }

  void _addExpense() async {
    setState(() {
      _isLoading = true;
    });
    final String name = _nameController.text;
    final String expenseText = _expenseController.text;
    final String itemCountText = _itemCountController.text;

    if (name.isEmpty || expenseText.isEmpty || itemCountText.isEmpty) {
      // Show an error message and highlight the text fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _nameController.text.isEmpty
            ? _nameFieldError = true
            : _nameFieldError = false;
        _expenseController.text.isEmpty
            ? _expenseFieldError = true
            : _expenseFieldError = false;
        _itemCountController.text.isEmpty
            ? _itemCountFieldError = true
            : _itemCountFieldError = false;
      });
      return;
    }

    final double expense = double.tryParse(expenseText) ?? 0.0;
    final int itemCount = int.tryParse(itemCountText) ?? 0;
    final DateTime now = DateTime.now();

    setState(() {
      // Multiply the expense amount by the item count
      final double totalExpense = expense * itemCount;
      _weeklyExpenses.add(Expense(name, totalExpense, dateTime: now));
      _nameController.clear();
      _expenseController.clear();
      _itemCountController.clear();
      _totalItems += itemCount; // Increment totalItems by the item count
    });

    try {
      _saveExpenses();
    } catch (e) {
      print('Error saving expenses: $e');
      // Handle the error gracefully, show an error message, or perform any other necessary actions.
    }

    // Show a success message using a Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense added successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to the ExpensesListScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensesListScreen(_weeklyExpenses),
      ),
    );
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensesListScreen(_weeklyExpenses),
      ),
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _showExpenseDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensesListScreen(_weeklyExpenses),
      ),
    );
  }

  double _calculateTotalExpenses() {
    double totalExpenses = 0.0;
    try {
      for (final expense in _weeklyExpenses) {
        totalExpenses += expense.amount;
      }
    } catch (e) {
      print('Error calculating total expenses: $e');
      // Handle the error gracefully, show an error message, or perform any other necessary actions.
    }
    return totalExpenses;
  }

  charts.Series<Expense, String> _createExpenseData() {
    return charts.Series<Expense, String>(
      id: 'Weekly Expenses',
      domainFn: (Expense expense, _) => expense.name,
      measureFn: (Expense expense, _) => expense.amount,
      colorFn: (Expense expense, _) =>
          charts.ColorUtil.fromDartColor(_getExpenseColor(expense)),
      data: _weeklyExpenses,
      // Assign custom renderer ID to enable color customization
      seriesColor: charts.ColorUtil.fromDartColor(Colors.blue),
      displayName: 'Expenses',
      insideLabelStyleAccessorFn: (Expense expense, _) {
        // Customize label style here if desired
        return charts.TextStyleSpec();
      },
      outsideLabelStyleAccessorFn: (Expense expense, _) {
        // Customize label style here if desired
        return charts.TextStyleSpec();
      },
    );
  }

  Color _getExpenseColor(Expense expense) {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    final index = _weeklyExpenses.indexOf(expense);
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: const Center(child: Text('Weekly Expens33000030e')),
        actions: [
          IconButton(
              icon: const Icon(Icons.show_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChartScreen(_createExpenseData()),
                  ),
                );
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          hintText: ' Expense Name', border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: _expenseController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: ' Expense Amount',
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: _itemCountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: ' Number of Items',
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60.0),
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _addExpense,
                  child: Text(
                    'Add Expense',
                    style: GoogleFonts.bebasNeue(
                        color: Colors.black, fontSize: 25, letterSpacing: 1),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow[600],
                    onPrimary: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _showExpenseDetails,
                  child: Text(
                    'Details List',
                    style: GoogleFonts.bebasNeue(
                        color: Colors.black, fontSize: 25, letterSpacing: 1),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[500],
                    onPrimary: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.red[500],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Weekly Expenses: \$${_calculateTotalExpenses().toStringAsFixed(2)}',
                          style: GoogleFonts.bebasNeue(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Total Items: $_totalItems',
                          style: GoogleFonts.bebasNeue(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
