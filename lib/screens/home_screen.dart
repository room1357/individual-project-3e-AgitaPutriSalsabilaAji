import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'setting_screen.dart';
import 'advanced_expense_list_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal', style: TextStyle(color: Colors.black),),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 3,
        iconTheme: const IconThemeData(color: Colors.white), // ✅ letakkan di sini
        title: const Text(
          'Beranda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
      ),

      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.tealAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.teal),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Selamat Datang!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Pengguna Aplikasi',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              _drawerItem(context, Icons.home, 'Beranda', () => Navigator.pop(context)),
              _drawerItem(context, Icons.person, 'Profil', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()));
              }),
              _drawerItem(context, Icons.settings, 'Pengaturan', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()));
              }),
              const Divider(),
              _drawerItem(context, Icons.logout, 'Keluar', () => _logout(context)),
            ],
          ),
        ),
      ),
      body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFB2FEFA), Color(0xFF0ED2F7)], // gradasi hijau muda ke tosca
      ),
    ),
    child: Stack(
      children: [
        // Elemen bulatan dekoratif seperti di login
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          right: -60,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
        ), 
      
      FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu Utama',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildMenuCard(context, 'Profil', Icons.person, Colors.teal),
                      _buildMenuCard(context, 'Manajer Pengeluaran',
                          Icons.account_balance_wallet, Colors.teal),
                      _buildMenuCard(context, 'Pesan', Icons.message, Colors.teal),
                      _buildMenuCard(context, 'Pengaturan', Icons.settings, Colors.teal),
                      _buildMenuCard(context, 'Bantuan', Icons.help_outline, Colors.teal),
                      ],
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ); 
  } 
    
  Widget _drawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
      onTap: onTap,
    );
  }

  Widget _buildMenuCard(
      BuildContext context, String title, IconData icon, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Card(
              elevation: 6,
              color: Colors.white,
              shadowColor: Colors.teal.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                splashColor: Colors.teal.withOpacity(0.2),
                onTap: () {
                  switch (title) {
                    case 'Profil':
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()));
                      break;
                    case 'Manajer Pengeluaran':
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const AdvancedExpenseListScreen()));
                      break;
                    case 'Pengaturan':
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()));
                      break;
                    default:
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Menu "$title" diklik')),
                      );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 48, color: color),
                      const SizedBox(height: 14),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
