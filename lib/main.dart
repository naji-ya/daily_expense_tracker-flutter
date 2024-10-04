import 'package:daily_expense_tracker/provider/userprovider.dart';
import 'package:daily_expense_tracker/screens/auth/loginRegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      home: LoginRegisterScreen(),
    );
  }
}
