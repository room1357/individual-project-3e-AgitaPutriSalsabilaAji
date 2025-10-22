import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Nama Pengguna';
  String email = 'user@email.com';
  String phone = '+62 812 3456 7890';
  String address = 'Malang, Jawa Timur';
  String job = 'Mahasiswa';

  File? _image; 
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profile_image.png');
    if (await file.exists()) {
      setState(() {
        _image = file;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        var status = await Permission.camera.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin kamera ditolak')),
          );
          return;
        }
      } else {
        var status = await Permission.photos.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin galeri ditolak')),
          );
          return;
        }
      }

      final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        final dir = await getApplicationDocumentsDirectory();
        final savedImage = await File(pickedFile.path).copy('${dir.path}/profile_image.png');

        setState(() {
          _image = savedImage;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editField(String title, String currentValue, Function(String) onSave) {
    final TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Masukkan $title baru...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  onSave(controller.text);
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                // 🔹 Bagian atas gradient teal
                Container(
                  height: screenWidth < 400 ? 200 : 240,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.tealAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: _showImageSourceDialog,
                            child: CircleAvatar(
                              radius: screenWidth < 380 ? 40 : 50,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  _image != null ? FileImage(_image!) : null,
                              child: _image == null
                                  ? const Icon(Icons.person,
                                      size: 60, color: Colors.teal)
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _showImageSourceDialog,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit,
                                    color: Colors.teal, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth < 380 ? 20 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth < 380 ? 13 : 15,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 380 ? 12 : 20),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      child: Column(
                        children: [
                        _buildProfileItem('Nama', Icons.person, Colors.teal, name, 
                            (val) => setState(() => name = val)),
                        const Divider(),
                        _buildProfileItem('Email', Icons.email, Colors.orange, email, 
                            (val) => setState(() => email = val)),
                        const Divider(),
                        _buildProfileItem('Nomor Telepon', Icons.phone, Colors.teal, phone, 
                            (val) => setState(() => phone = val)),
                        const Divider(),
                        _buildProfileItem('Alamat', Icons.location_on, Colors.redAccent, address, 
                            (val) => setState(() => address = val)),
                        const Divider(),
                        _buildProfileItem('Pekerjaan', Icons.work, Colors.green, job, 
                            (val) => setState(() => job = val)),
                      ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                  label: const Text(
                    'Kembali',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, 
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 380 ? 22 : 28,
                      vertical: screenWidth < 380 ? 12 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    String title,
    IconData icon,
    Color color,
    String value,
    Function(String) onSave,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(value),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.grey),
        onPressed: () => _editField(title, value, onSave),
      ),
    );
  }
}
