import 'package:flutter/material.dart';
import '../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _category;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _descriptionController =
        TextEditingController(text: widget.expense.description);
    _category = widget.expense.category;
    _date = widget.expense.date;
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updated = Expense(
        id: widget.expense.id,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _category,
        date: _date,
        description: _descriptionController.text,
      );
      Navigator.pop(context, updated);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
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
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Pengeluaran',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
         iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            shadowColor: Colors.teal.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Judul Pengeluaran',
                        prefixIcon:
                            const Icon(Icons.title, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.teal.withOpacity(0.05),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Masukkan judul' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Jumlah (Rp)',
                        prefixIcon:
                            const Icon(Icons.attach_money, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.teal.withOpacity(0.05),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Masukkan jumlah' : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        prefixIcon:
                            const Icon(Icons.category, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: <String>[
                        'Makanan',
                        'Transport',
                        'Hiburan',
                        'Lainnya'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _category = val!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi / Catatan',
                        prefixIcon:
                            const Icon(Icons.notes, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.teal.withOpacity(0.05),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.teal),
                      title: Text(
                        'Tanggal: ${_date.day}/${_date.month}/${_date.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.edit_calendar,
                            color: Colors.teal),
                      ),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan Perubahan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
