import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../provider/expenseProvider.dart';


class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    Map<String, double> categoryTotals = {};

    // Calculate totals per category
    for (var expense in expenseProvider.expenses) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Summary',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10.0),
        child: PieChart(
          PieChartData(
            sections: categoryTotals.entries.map((entry) {
              return PieChartSectionData(
                titleStyle: const TextStyle(fontSize: 10),
                color: Colors.primaries[categoryTotals.keys.toList().indexOf(entry.key) % Colors.primaries.length],
                value: entry.value,
                title: entry.key,
                radius: 100,
              );
            }).toList(),
            borderData: FlBorderData(show: false),
            centerSpaceRadius: 50,
            sectionsSpace:1,
          ),
        ),
      ),
    );
  }
}
