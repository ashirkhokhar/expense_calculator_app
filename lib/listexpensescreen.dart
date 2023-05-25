// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class ExpensesListScreen extends StatefulWidget {
  final List<Expense> expenses;

  const ExpensesListScreen(this.expenses, {Key? key}) : super(key: key);

  @override
  _ExpensesListScreenState createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  void _removeExpense(int index) {
    setState(() {
      widget.expenses.removeAt(index);
    });
  }

  TextEditingController _searchController = TextEditingController();
  List<Expense> _filteredExpenses = [];
  @override
  void initState() {
    super.initState();
    _filteredExpenses = widget.expenses;
  }

  void _filterExpenses(String searchText) {
    setState(() {
      _filteredExpenses = widget.expenses.where((expense) {
        final name = expense.name.toLowerCase();
        final date = DateFormat('EEE, MMM d, yyyy')
            .format(expense.dateTime)
            .toLowerCase();
        final time =
            DateFormat('h:mm a').format(expense.dateTime).toLowerCase();
        final searchLower = searchText.toLowerCase();
        return name.contains(searchLower) ||
            date.contains(searchLower) ||
            time.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: const Text('Expense List'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.white,
            child: TextField(
              cursorColor: Colors.white,
              controller: _searchController,
              onChanged: _filterExpenses,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Custom color for focused border
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredExpenses.length,
            itemBuilder: (BuildContext context, int index) {
              final expense = _filteredExpenses[index];

              return Builder(
                builder: (BuildContext context) {
                  return Dismissible(
                    key: Key(expense.name),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _removeExpense(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Expense deleted'),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ListTile(
                        tileColor: Colors.deepPurple[300],
                        title: Padding(
                          padding: const EdgeInsets.only(
                              right: 15.0, top: 15.0, bottom: 15.0),
                          child: Text(
                            'Expense: ${expense.name}',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 18,
                              // Highlighted font weight
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Amount: \$${expense.amount.toStringAsFixed(2)}\n\n'
                          'Date: ${DateFormat('EEE, MMM d, yyyy').format(expense.dateTime)}\n\n'
                          'Time: ${DateFormat('h:mm a').format(expense.dateTime)}\n',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 18,
                            // Highlighted font style
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
