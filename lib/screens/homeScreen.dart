import 'package:daily_expense_tracker/screens/summaryScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expenseProvider.dart';
import '../provider/userprovider.dart';
import 'AddExpenseScreen.dart';
import 'expenseListScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: Text(
          userProvider.username,
          style: TextStyle(color: Colors.white70),
        ),
        leading: Icon(Icons.person,color: Colors.white70,),
        actions: [
          Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(color: Colors.white70), // Change the icon color to white70
      ),
            child: PopupMenuButton<String>(

              onSelected: (value) {
                if (value == 'logout') {
                  userProvider.logout(context); // Call logout method from UserProvider
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(

                    value: choice.toLowerCase(),
                    child: Text(choice,style: TextStyle(),),
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
              SizedBox(height: 40,),
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
                      Text(
                        'Total Expenses',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '₹${expenseProvider.totalExpenses}',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExpenseListScreen()), // Navigate to ExpenseListScreen
                  );
                },
                child: Text('View Expenses'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  backgroundColor: Colors.orange,
                  elevation: 5,
                  minimumSize: Size(240,40)
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SummaryScreen()), // Navigate to SummaryScreen
                  );
                },
                child: Text('View Chart'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  backgroundColor: Colors.orange,
                  elevation: 5,
                    minimumSize: Size(240,40)
                ),
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
        child: Icon(Icons.add),
      ),
    );
  }
}
