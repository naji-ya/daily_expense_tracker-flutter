import 'package:daily_expense_tracker/provider/expenseProvider.dart';
import 'package:daily_expense_tracker/provider/userprovider.dart';
import 'package:daily_expense_tracker/screens/auth/loginRegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(

        appBarTheme: AppBarTheme(backgroundColor: Colors.black),
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.orange,

      ),
      home: LoginRegisterScreen(), // Start with login/register screen
    );
  }
}
