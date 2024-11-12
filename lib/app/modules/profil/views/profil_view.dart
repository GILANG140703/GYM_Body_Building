import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_prak/app/modules/profil/controllers/profil_controller.dart';
import 'package:image_picker/image_picker.dart';

class ProfilView extends StatefulWidget {
  final String documentId;

  ProfilView({
    this.documentId = '',
  });

  @override
  State<ProfilView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfilView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  String _gender = 'Laki - Laki';
  double _currentWeight = 80.0;
  double _targetWeight = 70.0;
  double _height = 168.0;

  List<Map<String, dynamic>> _toDoList = [];

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    if (user != null) {
      _fetchUserProfile();
      _fetchToDoList();
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      // Mendapatkan data pengguna berdasarkan email
      DocumentSnapshot snapshot =
          await firestore.collection('users').doc(user!.email).get();

      if (snapshot.exists) {
        setState(() {
          _gender = snapshot['gender'] ?? 'Laki - Laki';
          _currentWeight = snapshot['currentWeight']?.toDouble() ?? 0.0;
          _targetWeight = snapshot['targetWeight']?.toDouble() ?? 0.0;
          _height = snapshot['height']?.toDouble() ?? 0.0;
        });
      }
    } catch (error) {
      print('Error fetching user profile: $error');
    }
  }

  Future<void> _fetchToDoList() async {
    try {
      // Mendapatkan daftar To-Do sesuai email pengguna yang sedang login
      QuerySnapshot snapshot = await firestore
          .collection('To-Do List')
          .where('userEmail', isEqualTo: user!.email)
          .get();

      setState(() {
        _toDoList = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'text': doc['text'],
            'completed': doc['completed'],
          };
        }).toList();
      });
    } catch (error) {
      print('Error fetching To-Do list: $error');
    }
  }

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

  Future<void> _saveUserProfileToFirestore() async {
    if (user != null) {
      await firestore.collection('info dasar').doc(user!.email).set({
        'gender': _gender,
        'currentWeight': _currentWeight,
        'targetWeight': _targetWeight,
        'height': _height,
      }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
    }
  }

  void _showGenderSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih Jenis Kelamin'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                setState(() {
                  _gender = 'Laki - Laki';
                });
                await _saveUserProfileToFirestore();
                Navigator.pop(context);
              },
              child: const Text('Laki - Laki'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                setState(() {
                  _gender = 'Perempuan';
                });
                await _saveUserProfileToFirestore();
                Navigator.pop(context);
              },
              child: const Text('Perempuan'),
            ),
          ],
        );
      },
    );
  }

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
              onPressed: () async {
                onSave(controller.text);
                await _saveUserProfileToFirestore();
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _toggleToDoCompletion(int index, bool? value) async {
    // Update Firestore document to toggle completion status
    await firestore
        .collection('To-Do List')
        .doc(_toDoList[index]['id'])
        .update({'completed': value});
    setState(() {
      _toDoList[index]['completed'] = value; // Update local state
    });
  }

  void _addToDo() {
    TextEditingController toDoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah To-Do'),
          content: TextField(
            controller: toDoController,
            decoration: const InputDecoration(hintText: 'Masukkan tugas'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (toDoController.text.isNotEmpty) {
                  // Menambahkan tugas baru ke dalam Firestore
                  DocumentReference newDoc =
                      await firestore.collection('To-Do List').add({
                    'text': toDoController.text,
                    'completed': false,
                  });
                  setState(() {
                    _toDoList.add({
                      'id': newDoc.id, // Save the document ID
                      'text': toDoController.text,
                      'completed': false,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _deleteToDoAt(int index) async {
    // Delete Firestore document
    await firestore
        .collection('To-Do List')
        .doc(_toDoList[index]['id'])
        .delete();
    setState(() {
      _toDoList.removeAt(index);
    });
  }

  void _editToDoAt(int index) {
    TextEditingController editController = TextEditingController(
      text: _toDoList[index]['text'],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit To-Do'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Masukkan teks baru'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                String newText = editController.text;
                if (newText.isNotEmpty) {
                  // Update Firebase dengan teks yang diedit
                  await firestore
                      .collection('To-Do List')
                      .doc(_toDoList[index]['id'])
                      .update({'text': newText});

                  // Perbarui state lokal
                  setState(() {
                    _toDoList[index]['text'] = newText;
                  });
                }
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
        title: const Text('Profil'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await ProfilController().logout(); // Call the logout function
              Navigator.pushReplacementNamed(
                  context, '/login'); // Navigate to login view
            },
          ),
        ],
      ),
      body: user == null
          ? Center(child: Text("User not authenticated"))
          : SingleChildScrollView(
              // Tambahkan SingleChildScrollView di sini
              child: Padding(
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
                                  ? FileImage(_profileImage!)
                                  : const AssetImage(
                                          'assets/default_profile.png')
                                      as ImageProvider,
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
                          if (user?.email != null)
                            Text(
                              user!.email!,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
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
                            trailing: Text(_gender),
                            onTap: _showGenderSelectionDialog,
                          ),
                          ListTile(
                            title: const Text('Berat Badan Sekarang (kg)'),
                            trailing: Text(_currentWeight.toString()),
                            onTap: () {
                              _showInputDialog('Berat Badan Sekarang',
                                  _currentWeight.toString(), (value) {
                                setState(() {
                                  _currentWeight =
                                      double.tryParse(value) ?? 0.0;
                                });
                              });
                            },
                          ),
                          ListTile(
                            title: const Text('Target Berat Badan (kg)'),
                            trailing: Text(_targetWeight.toString()),
                            onTap: () {
                              _showInputDialog('Target Berat Badan',
                                  _targetWeight.toString(), (value) {
                                setState(() {
                                  _targetWeight = double.tryParse(value) ?? 0.0;
                                });
                              });
                            },
                          ),
                          ListTile(
                            title: const Text('Tinggi Badan (cm)'),
                            trailing: Text(_height.toString()),
                            onTap: () {
                              _showInputDialog(
                                  'Tinggi Badan', _height.toString(), (value) {
                                setState(() {
                                  _height = double.tryParse(value) ?? 0.0;
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'To-Do List',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    ListView.builder(
                      shrinkWrap: true, // Aktifkan shrinkWrap di sini
                      physics:
                          const NeverScrollableScrollPhysics(), // Nonaktifkan scroll di sini
                      itemCount: _toDoList.length,
                      itemBuilder: (context, index) {
                        final toDoItem = _toDoList[index];
                        return ListTile(
                          leading: Checkbox(
                            value: toDoItem['completed'],
                            onChanged: (bool? value) {
                              _toggleToDoCompletion(index, value);
                            },
                          ),
                          title: Text(
                            toDoItem['text'],
                            style: TextStyle(
                              decoration: toDoItem['completed']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editToDoAt(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteToDoAt(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: _addToDo,
                      child: const Text('Tambah To-Do'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
