import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/expenseModel.dart'; // Ensure to import your Expense model

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = []; // List to hold expenses
  double _totalExpenses = 0.0; // Total expenses variable
  bool _isLoading = true; // Track loading state

  // Getter for expenses
  List<Expense> get expenses => _expenses;

  // Getter for total expenses
  double get totalExpenses => _totalExpenses;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Initialize database
  Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'expense_tracker.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL, date TEXT, category TEXT, description TEXT)',
        );
      },
      version: 1,
    );
  }

  // Fetch expenses from the database
  Future<void> fetchExpenses() async {
    _isLoading = true; // Set loading to true
    notifyListeners(); // Notify listeners about loading state

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');

    _expenses = List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        amount: maps[i]['amount'],
        date: DateTime.parse(maps[i]['date']),
        category: maps[i]['category'],
        description: maps[i]['description'],
      );
    });

    _totalExpenses = _expenses.fold(0, (sum, item) => sum + item.amount); // Calculate total
    _isLoading = false; // Set loading to false
    notifyListeners(); // Notify listeners after loading
  }

  // Add a new expense
  Future<void> addExpense(double amount, DateTime date, String category, String description) async {
    final db = await database;

    final id = await db.insert(
      'expenses',
      {
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category,
        'description': description,
      },
    );

    // Add to local list
    _expenses.add(Expense(
      id: id,
      amount: amount,
      date: date,
      category: category,
      description: description,
    ));

    _totalExpenses += amount; // Update total
    notifyListeners(); // Notify listeners
  }

  // Update an existing expense
  Future<void> updateExpense(int id, double amount, DateTime date, String category, String description) async {
    final db = await database;

    // Update expense in database
    await db.update(
      'expenses',
      {
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category,
        'description': description,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    // Update local list
    int index = _expenses.indexWhere((expense) => expense.id == id);
    if (index != -1) {
      double oldAmount = _expenses[index].amount; // Store old amount to update total
      _expenses[index] = Expense(id: id, amount: amount, date: date, category: category, description: description);
      _totalExpenses = _totalExpenses - oldAmount + amount; // Update total
      notifyListeners(); // Notify listeners
    }
  }

  // Delete an expense
  Future<void> deleteExpense(int id) async {
    final db = await database;

    // Delete expense from database
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Remove expense from local list
    int index = _expenses.indexWhere((expense) => expense.id == id);
    if (index != -1) {
      _totalExpenses -= _expenses[index].amount; // Update total
      _expenses.removeAt(index); // Remove from list
      notifyListeners(); // Notify listeners
    }
  }

  // Constructor to initialize and fetch expenses
  ExpenseProvider() {
    fetchExpenses(); // Fetch expenses when provider is initialized
  }
}
