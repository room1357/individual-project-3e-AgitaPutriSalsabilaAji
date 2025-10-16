import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/expense_list_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/category_screen.dart';

void main() {
  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // halaman pertama tetap LoginScreen
      debugShowCheckedModeBanner: false,
    );
  }
}

// Contoh HomeScreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(
              context,
              label: 'Daftar Pengeluaran',
              icon: Icons.list,
              route: const ExpenseListScreen(),
            ),
            _buildMenuButton(
              context,
              label: 'Tambah Pengeluaran',
              icon: Icons.add,
              route: const AddExpenseScreen(),
            ),
            _buildMenuButton(
              context,
              label: 'Statistik',
              icon: Icons.bar_chart,
              route: const StatisticsScreen(),
            ),
            _buildMenuButton(
              context,
              label: 'Kelola Kategori',
              icon: Icons.category,
              route: const CategoryScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String label, required IconData icon, required Widget route}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => route),
          );
        },
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
