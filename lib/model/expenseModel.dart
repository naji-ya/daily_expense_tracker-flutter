class Expense {
  final int? id;
  final double amount;
  final DateTime date;
  final String category;
  final String? description;

  Expense({
    this.id,
    required this.amount,
    required this.date,
    required this.category,
    this.description,
  });

  // Method to convert an Expense object to a Map (used for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(), // Store date as string
      'category': category,
      'description': description,
    };
  }

  // Factory method to create an Expense object from a Map (used for SQLite)
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      description: map['description'],
    );
  }
}
