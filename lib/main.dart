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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(

        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.orange,

      ),
      home: const LoginRegisterScreen(), // Start with login/register screen
    );
  }
}
