import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Kategori')),
      body: Center(
        child: Text('Daftar kategori dan manajemen kategori ada di sini'),
      ),
    );
  }
}
