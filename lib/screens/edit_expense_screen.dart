import 'package:flutter/material.dart';

class EditExpenseScreen extends StatelessWidget {
  const EditExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pengeluaran')),
      body: Center(
        child: Text('Form edit pengeluaran akan ada di sini'),
      ),
    );
  }
}
