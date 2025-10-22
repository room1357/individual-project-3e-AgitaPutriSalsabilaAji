import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // background putih
      appBar: AppBar(
        title: const Text(
          'Daftar Akun',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Logo bulat
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_add, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 32),

              // TextField Nama Lengkap
              _buildTextField(
                label: 'Nama Lengkap',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),

              // Email
              _buildTextField(
                label: 'Alamat Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 16),

              // Username
              _buildTextField(
                label: 'Nama Pengguna',
                icon: Icons.account_circle,
              ),
              const SizedBox(height: 16),

              // Password
              _buildTextField(
                label: 'Kata Sandi',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Konfirmasi Password
              _buildTextField(
                label: 'Konfirmasi Kata Sandi',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pendaftaran berhasil!')),
                    );

                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'DAFTAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Link ke login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Masuk di sini',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Widget helper agar semua TextField konsisten
  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon, color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
