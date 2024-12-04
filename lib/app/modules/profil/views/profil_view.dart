import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      }, SetOptions(merge: true));
    }
  }

  void _deleteProfileImage() {
    setState(() {
      _profileImage = null;
    });
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
    await firestore
        .collection('To-Do List')
        .doc(_toDoList[index]['id'])
        .update({'completed': value});
    setState(() {
      _toDoList[index]['completed'] = value;
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
                  DocumentReference newDoc =
                      await firestore.collection('To-Do List').add({
                    'text': toDoController.text,
                    'completed': false,
                  });
                  setState(() {
                    _toDoList.add({
                      'id': newDoc.id,
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
                  await firestore
                      .collection('To-Do List')
                      .doc(_toDoList[index]['id'])
                      .update({'text': newText});

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
        backgroundColor: Colors.blue[800], // Warna biru gelap
        actions: [
          IconButton(
            icon: Icon(Icons.location_on), // Ikon lokasi
            onPressed: () async {
              ProfilController().goToLocationView();
              Navigator.pushNamed(context, '/location');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await ProfilController().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: user == null
          ? Center(child: Text("User not authenticated"))
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade200, Colors.blue.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
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
                            if (_profileImage != null)
                              TextButton(
                                onPressed: _deleteProfileImage,
                                child: const Text(
                                  'Hapus Foto Profil',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.white, // Warna putih pada card info dasar
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('Jenis Kelamin'),
                              subtitle: Text(_gender),
                              trailing: const Icon(Icons.edit),
                              onTap: _showGenderSelectionDialog,
                            ),
                            ListTile(
                              title: const Text('Berat Badan Saat Ini'),
                              subtitle: Text('$_currentWeight kg'),
                              trailing: const Icon(Icons.edit),
                              onTap: () => _showInputDialog(
                                  'Berat Badan Saat Ini',
                                  _currentWeight.toString(), (newValue) {
                                setState(() {
                                  _currentWeight =
                                      double.tryParse(newValue) ?? 0.0;
                                });
                              }),
                            ),
                            ListTile(
                              title: const Text('Berat Badan Target'),
                              subtitle: Text('$_targetWeight kg'),
                              trailing: const Icon(Icons.edit),
                              onTap: () => _showInputDialog(
                                  'Berat Badan Target',
                                  _targetWeight.toString(), (newValue) {
                                setState(() {
                                  _targetWeight =
                                      double.tryParse(newValue) ?? 0.0;
                                });
                              }),
                            ),
                            ListTile(
                              title: const Text('Tinggi Badan'),
                              subtitle: Text('$_height cm'),
                              trailing: const Icon(Icons.edit),
                              onTap: () => _showInputDialog(
                                  'Tinggi Badan', _height.toString(),
                                  (newValue) {
                                setState(() {
                                  _height = double.tryParse(newValue) ?? 0.0;
                                });
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'To-Do List',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _toDoList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_toDoList[index]['text']),
                            leading: Checkbox(
                              value: _toDoList[index]['completed'],
                              onChanged: (value) {
                                _toggleToDoCompletion(index, value);
                              },
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _editToDoAt(index);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteToDoAt(index);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: _addToDo,
                          child: const Text('Tambah To-Do'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
