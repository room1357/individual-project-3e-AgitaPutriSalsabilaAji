import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../data/category_data.dart';
import '../data/global_expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _catatanController = TextEditingController();

  String? _kategoriDipilih;
  DateTime _tanggalDipilih = DateTime.now();

  void _simpanPengeluaran() {
    if (_formKey.currentState!.validate()) {
      final pengeluaran = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _judulController.text,
        amount: double.parse(_jumlahController.text),
        category: _kategoriDipilih ?? 'Lainnya',
        date: _tanggalDipilih,
        description: _catatanController.text,
      );

      globalExpenses.add(pengeluaran);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pengeluaran "${pengeluaran.title}" berhasil ditambahkan di Daftar Pengeluaran!',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
        ),
      );

      Navigator.pop(context, pengeluaran);
    }
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalDipilih,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal Pengeluaran',
    );
    if (picked != null) {
      setState(() => _tanggalDipilih = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Category> kategori = CategoryData.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengeluaran'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadowColor: Colors.teal.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _judulController,
                    label: 'Judul Pengeluaran',
                    icon: Icons.title,
                    validatorMsg: 'Masukkan judul pengeluaran',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _jumlahController,
                    label: 'Jumlah (Rp)',
                    icon: Icons.attach_money,
                    keyboard: TextInputType.number,
                    validatorMsg: 'Masukkan jumlah pengeluaran',
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _kategoriDipilih,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: kategori
                        .map((cat) => DropdownMenuItem(
                              value: cat.name,
                              child: Text(cat.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _kategoriDipilih = value);
                    },
                    validator: (value) =>
                        value == null ? 'Pilih kategori pengeluaran' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _catatanController,
                    label: 'Deskripsi / Catatan',
                    icon: Icons.notes,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today, color: Colors.teal),
                    title: Text(
                      'Tanggal: ${_tanggalDipilih.day}/${_tanggalDipilih.month}/${_tanggalDipilih.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_calendar, color: Colors.teal),
                      onPressed: _pilihTanggal,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _simpanPengeluaran,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Pengeluaran'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? validatorMsg,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.teal.withOpacity(0.05),
      ),
      validator: (value) {
        if (validatorMsg != null &&
            (value == null || value.trim().isEmpty)) {
          return validatorMsg;
        }
        return null;
      },
    );
  }
}
