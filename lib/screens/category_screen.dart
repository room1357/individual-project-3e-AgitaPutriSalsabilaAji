import 'package:flutter/material.dart';
import '../models/category.dart';
import '../data/category_data.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  void _addCategory() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tambah Kategori',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Masukkan nama kategori...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () => Navigator.pop(context, controller.text),
            icon: const Icon(Icons.check),
            label: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        CategoryData.addCategory(result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kategori "$result" berhasil ditambahkan!'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  void _editCategory(Category category) async {
    final controller = TextEditingController(text: category.name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Kategori',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Ubah nama kategori...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.edit),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () => Navigator.pop(context, controller.text),
            icon: const Icon(Icons.save),
            label: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        CategoryData.updateCategory(category.id, result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kategori berhasil diperbarui menjadi "$result"!'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  void _deleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content:
            Text('Apakah kamu yakin ingin menghapus kategori "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                CategoryData.deleteCategory(category.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Kategori "${category.name}" dihapus.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = CategoryData.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: categories.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category_outlined,
                        size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    const Text(
                      'Belum ada kategori 😢',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _addCategory,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Sekarang'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: Colors.white.withOpacity(0.9),
                    shadowColor: Colors.teal.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade50,
                        child: const Icon(Icons.label, color: Colors.teal),
                      ),
                      title: Text(
                        category.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editCategory(category),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(category),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: _addCategory,
        icon: const Icon(Icons.add),
        label: const Text('Tambah', style: TextStyle(color: Colors.white), ),
      ),
    );
  }
}
