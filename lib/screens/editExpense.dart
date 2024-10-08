import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/expenseProvider.dart';
import '../model/expenseModel.dart';
import 'package:intl/intl.dart'; //for datetime

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late double _amount;
  late DateTime _date;
  String? _category;
  String? _description;

  @override
  void initState() {
    super.initState();
    _amount = widget.expense.amount;
    _date = widget.expense.date;
    _category = widget.expense.category;
    _description = widget.expense.description;
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30,),
                TextFormField(
                  style: const TextStyle(color: Colors.white70),
                  initialValue: _amount.toString(),
                  decoration: InputDecoration(labelText: 'Amount',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(11))),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _amount = double.parse(value!);
                  },
                ),
                const SizedBox(height: 15,),
                TextFormField( style: const TextStyle(color: Colors.white70),
                  initialValue: DateFormat('yyyy-MM-dd').format(_date),
                  decoration: InputDecoration(labelText: 'Date', border: OutlineInputBorder(borderRadius: BorderRadius.circular(11))),
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _date = selectedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 15,),
                DropdownButtonFormField<String>( style: const TextStyle(color: Colors.white70),
                  value: _category,
                  decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder(borderRadius: BorderRadius.circular(11))),
                  items: <String>['Food', 'Transport', 'Entertainment','Shopping', 'Other']
                      .map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _category = newValue;
                    });
                  },
                ),
                const SizedBox(height: 15,),
                TextFormField( style: const TextStyle(color: Colors.white70),
                  initialValue: _description,
                  decoration: InputDecoration(labelText: 'Description (optional)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(11))),
                  onSaved: (value) {
                    _description = value;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11),),
                  minimumSize: const Size(270, 50)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      expenseProvider.updateExpense(
                        widget.expense.id!,
                        _amount,
                        _date,
                        _category!,
                        _description!,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Update Expense',style: TextStyle(color: Colors.black),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
