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
            'Pengeluaran "${pengeluaran.title}" berhasil ditambahkan!',
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
      builder: (context, child) {
        // Warna tema kalender seperti di EditExpenseScreen
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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
        title: const Text('Tambah Pengeluaran', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white, // ✅ sama seperti EditExpenseScreen
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Judul
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  labelText: 'Judul Pengeluaran',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan judul pengeluaran' : null,
              ),
              const SizedBox(height: 16),

              // Jumlah
              TextFormField(
                controller: _jumlahController,
                decoration: InputDecoration(
                  labelText: 'Jumlah (Rp)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan jumlah pengeluaran' : null,
              ),
              const SizedBox(height: 16),

              // Kategori
              DropdownButtonFormField<String>(
                value: _kategoriDipilih,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: kategori
                    .map((cat) => DropdownMenuItem<String>(
                          value: cat.name,
                          child: Text(cat.name),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _kategoriDipilih = val),
                validator: (val) =>
                    val == null ? 'Pilih kategori pengeluaran' : null,
              ),
              const SizedBox(height: 16),

              // Deskripsi
              TextFormField(
                controller: _catatanController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi / Catatan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Tanggal
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tanggal: ${_tanggalDipilih.day}/${_tanggalDipilih.month}/${_tanggalDipilih.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: _pilihTanggal,
                    icon: const Icon(Icons.calendar_today, color: Colors.teal),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              ElevatedButton.icon(
                onPressed: _simpanPengeluaran,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Simpan Pengeluaran',
                  style: TextStyle(color: Colors.white), // teks putih
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.teal, // warna tombol
                  foregroundColor: Colors.white, // warna ikon & teks
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
