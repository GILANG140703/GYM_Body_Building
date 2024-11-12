import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  File? _profileImage; // Variabel untuk menyimpan gambar profil
  final ImagePicker _picker = ImagePicker();

  // Variabel untuk menyimpan info dasar
  String _jenisKelamin = 'Laki - Laki';
  double _beratSaatIni = 74.0;
  double _targetBerat = 70.0;
  double _tinggi = 171.0;

  // Fungsi untuk mengambil gambar dari galeri atau kamera
  Future<void> _openImagePicker() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? pickedImage =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      _profileImage = File(pickedImage.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? pickedImage =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _profileImage = File(pickedImage.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi untuk menampilkan dialog pilihan jenis kelamin
  void _showGenderSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih Jenis Kelamin'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  _jenisKelamin = 'Laki - Laki';
                });
                Navigator.pop(context);
              },
              child: const Text('Laki - Laki'),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  _jenisKelamin = 'Perempuan';
                });
                Navigator.pop(context);
              },
              child: const Text('Perempuan'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog input
  void _showInputDialog(
      String title, String currentValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            keyboardType: title.contains('Berat') || title == 'Tinggi'
                ? TextInputType.number
                : TextInputType.text,
            decoration: InputDecoration(hintText: 'Masukkan $title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan'),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3E5FC),
              Color(0xFF1565C0),
            ],
          ),
        ),
        child: _selectedIndex == 0
            ? Column(
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Latihan Dada',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '2 Latihan',
                            style: TextStyle(fontSize: 18),
                          ),
                          const Text(
                            'Incline Bench Press - Dumbbell',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Text(
                            'Incline Bench Press - Barbell',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _openImagePicker,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!) as ImageProvider
                                  : const AssetImage(
                                      'assets/default_profile.png'),
                              child: _profileImage == null
                                  ? const Icon(Icons.camera_alt,
                                      size: 50, color: Colors.white)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Selamat Datang, Gym',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: _openImagePicker,
                            child: const Text('Ubah Foto Profil'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Info Dasar',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Card(
                      color: Colors.blue[50],
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Jenis Kelamin'),
                            trailing: Text(_jenisKelamin),
                            onTap: _showGenderSelectionDialog,
                          ),
                          ListTile(
                            title: const Text('Berat Saat Ini (kg)'),
                            trailing: Text('$_beratSaatIni kg'),
                            onTap: () {
                              _showInputDialog(
                                  'Berat Saat Ini', _beratSaatIni.toString(),
                                  (newValue) {
                                setState(() {
                                  _beratSaatIni = double.parse(newValue);
                                });
                              });
                            },
                          ),
                          ListTile(
                            title: const Text('Target Berat (kg)'),
                            trailing: Text('$_targetBerat kg'),
                            onTap: () {
                              _showInputDialog(
                                  'Target Berat', _targetBerat.toString(),
                                  (newValue) {
                                setState(() {
                                  _targetBerat = double.parse(newValue);
                                });
                              });
                            },
                          ),
                          ListTile(
                            title: const Text('Tinggi (cm)'),
                            trailing: Text('$_tinggi cm'),
                            onTap: () {
                              _showInputDialog('Tinggi', _tinggi.toString(),
                                  (newValue) {
                                setState(() {
                                  _tinggi = double.parse(newValue);
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Latihan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
        backgroundColor: Colors.blue[100],
      ),
    );
  }
}
