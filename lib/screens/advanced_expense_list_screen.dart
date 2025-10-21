import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
import 'expense_list_screen.dart';
import 'statistics_screen.dart';
import 'category_screen.dart';

class AdvancedExpenseListScreen extends StatelessWidget {
  const AdvancedExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajer Pengeluaran'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildMenuItem(
            context,
            label: 'Daftar Pengeluaran',
            icon: Icons.list,
            route: const ExpenseListScreen(),
          ),
          _buildMenuItem(
            context,
            label: 'Tambah Pengeluaran',
            icon: Icons.add_circle,
            route: const AddExpenseScreen(),
          ),
          _buildMenuItem(
            context,
            label: 'Statistik Pengeluaran',
            icon: Icons.bar_chart,
            route: const StatisticsScreen(),
          ),
          _buildMenuItem(
            context,
            label: 'Kelola Kategori',
            icon: Icons.category,
            route: const CategoryScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String label, required IconData icon, required Widget route}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => route),
          );
        },
      ),
    );
  }
}
