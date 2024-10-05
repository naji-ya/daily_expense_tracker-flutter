import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expenseProvider.dart';


class AddExpenseScreen extends StatelessWidget {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  //default
  String _selectedCategory = 'Food';

  final List<String> _categories = ['Food', 'Transport', 'Entertainment', 'Shopping','Other'];

  AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Add Expense',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 35,),
              TextField(
                style: const TextStyle(color: Colors.white70),
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11)
                )),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField(dropdownColor: Colors.black,
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category,style: const TextStyle(color: Colors.white70),),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _selectedCategory = newValue!;
                },
                decoration: InputDecoration(labelText: 'Category',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)
                    )
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                style: const TextStyle(color: Colors.white70),
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description (optional)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)
                    )),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date: ${_selectedDate.toLocal()}".split(' ')[0],style: const TextStyle(color: Colors.white24),),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        _selectedDate = pickedDate;
                      }
                    },
                    child: const Text("Select date"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(_amountController.text);
                  if (amount != null) {
                    Provider.of<ExpenseProvider>(context, listen: false).addExpense(
                      amount,
                      _selectedDate,
                      _selectedCategory,
                      _descriptionController.text,
                    );
                    Navigator.pop(context); // Go back to the previous screen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter a valid amount'),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange,
                minimumSize: const Size(280, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Add Expense',style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
