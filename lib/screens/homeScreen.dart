import 'package:daily_expense_tracker/screens/summaryScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expenseProvider.dart';
import '../provider/userprovider.dart';
import 'AddExpenseScreen.dart';
import 'expenseListScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: Text(
          userProvider.username,
          style: const TextStyle(color: Colors.white70),
        ),
        leading: const Icon(Icons.person,color: Colors.white70,),
        actions: [
          Theme(
      data: Theme.of(context).copyWith(
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
            child: PopupMenuButton<String>(

              onSelected: (value) {
                if (value == 'logout') {
                  userProvider.logout(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(

                    value: choice.toLowerCase(),
                    child: Text(choice,style: const TextStyle(),),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40,),
              Container(
                height: 200,
                width: 270,
                decoration:BoxDecoration(
                  color: Colors.white10,

                  borderRadius:
                  BorderRadius.circular(11),

                ),
                child: Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total Expenses',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '₹${expenseProvider.totalExpenses}',
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExpenseListScreen()), // Navigate to ExpenseListScreen
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  backgroundColor: Colors.orange,
                  elevation: 5,
                  minimumSize: const Size(240,40)
                ),
                child: const Text('View Expenses'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SummaryScreen()), // Navigate to SummaryScreen
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  backgroundColor: Colors.orange,
                  elevation: 5,
                    minimumSize: const Size(240,40)
                ),
                child: const Text('View Chart'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()), // Navigate to AddExpenseScreen
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
