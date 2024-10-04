import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/expenseProvider.dart';
import 'editExpense.dart';

class ExpenseListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense List',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
      ),
      // Check loading state
      body: expenseProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(shrinkWrap: true,
        itemCount: expenseProvider.expenses.length,
        itemBuilder: (context, index) {
          final expense = expenseProvider.expenses[index];
          return Card(color:Colors.white10,
            margin: EdgeInsets.all(7),
            child: ListTile(iconColor: Colors.orange,

              textColor: Colors.white70,
              title: Text(expense.description ?? 'No Description'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount: ₹${expense.amount}'),
                  Text('Date: ${DateFormat('yMMMd').format(expense.date)}'),
                  Text('Category: ${expense.category}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditExpenseScreen(expense: expense),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      expenseProvider.deleteExpense(expense.id!);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
