import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';
import '../data/global_expense.dart'; 

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> _expenses = globalExpenses;

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
    // Urutkan data dari tanggal terbaru ke terlama
    _expenses.sort((a, b) => b.date.compareTo(a.date));

    // Hitung total pengeluaran
    double total = _expenses.fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Pengeluaran',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white), 
      ),

      // 🔹 FloatingActionButton dihapus
      body: _expenses.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pengeluaran tercatat.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // Card total pengeluaran
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.teal,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pengeluaran:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(total),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Daftar pengeluaran
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) {
                      final e = _expenses[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: const Color(0xFFF3EDF7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade100,
                            child: const Icon(Icons.attach_money, color: Colors.teal),
                          ),
                          title: Text(
                            e.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${e.formattedAmount} • ${e.formattedDate}\n${e.category}',
                          ),
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
                ),
              ],
            ),
    );
  }
}
