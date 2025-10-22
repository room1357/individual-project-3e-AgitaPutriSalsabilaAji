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
      // AppBar dengan tema warna teal
      appBar: AppBar(
        title: const Text(
          'Manajer Pengeluaran',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Background menggunakan gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              _buildMenuCard(
                context,
                label: 'Daftar Pengeluaran',
                icon: Icons.list,
                route: const ExpenseListScreen(),
              ),
              _buildMenuCard(
                context,
                label: 'Tambah Pengeluaran',
                icon: Icons.add_circle,
                route: const AddExpenseScreen(),
              ),
              _buildMenuCard(
                context,
                label: 'Statistik Pengeluaran',
                icon: Icons.bar_chart,
                route: const StatisticsScreen(),
              ),
              _buildMenuCard(
                context,
                label: 'Kelola Kategori',
                icon: Icons.category,
                route: const CategoryScreen(),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Kelola keuanganmu dengan lebih mudah 💰',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk membuat menu card navigasi
  Widget _buildMenuCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Widget route,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shadowColor: Colors.teal.withOpacity(0.4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.teal.withOpacity(0.2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => route),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, color: Colors.teal.shade800, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
