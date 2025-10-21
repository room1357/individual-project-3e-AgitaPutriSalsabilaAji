import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';
import '../data/global_expense.dart'; // tambahkan ini

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> _expenses =  globalExpenses;

  void _addExpense() async {
    final newExpense = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
    );

    if (newExpense != null && newExpense is Expense) {
      setState(() => _expenses.add(newExpense));
    }
  }

  void _editExpense(Expense expense) async {
    final updatedExpense = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditExpenseScreen(expense: expense)),
    );

    if (updatedExpense != null && updatedExpense is Expense) {
      setState(() {
        final index = _expenses.indexWhere((e) => e.id == expense.id);
        if (index != -1) _expenses[index] = updatedExpense;
      });
    }
  }

  void _deleteExpense(Expense expense) {
    setState(() => _expenses.removeWhere((e) => e.id == expense.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengeluaran'),
        backgroundColor: Colors.teal,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _addExpense,
      //   backgroundColor: Colors.teal,
      //   child: const Icon(Icons.add),
      // ),
      body: _expenses.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pengeluaran tercatat.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final e = _expenses[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: const Icon(Icons.attach_money, color: Colors.teal),
                    ),
                    title: Text(e.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${e.formattedAmount} • ${e.formattedDate}\n${e.category}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editExpense(e),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteExpense(e),
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
