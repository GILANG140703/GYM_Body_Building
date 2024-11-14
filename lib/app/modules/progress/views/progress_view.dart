import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.photo),
              label: Text('Foto'),
              onPressed: () {
                Get.to(() => PhotoPage());
              },
            ),
            SizedBox(width: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.videocam),
              label: Text('Video'),
              onPressed: () {
                //Get.to(() => //VideoPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

// PhotoPage: Displays and manages photos
class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  List<Map<String, String>> photos = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? photoPaths = prefs.getStringList('photos');
    if (photoPaths != null) {
      setState(() {
        photos = photoPaths.map((path) {
          List<String> split = path.split('|');
          return {"path": split[0], "name": split[1]};
        }).toList();
      });
    }
  }

  Future<void> _savePhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> photoPaths =
        photos.map((photo) => '${photo["path"]}|${photo["name"]}').toList();
    await prefs.setStringList('photos', photoPaths);
  }

  Future<void> _addPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        photos.add(
            {"path": pickedFile.path, "name": "Photo ${photos.length + 1}"});
      });
      _savePhotos();
    }
  }

  void _renamePhoto(int index) async {
    TextEditingController controller =
        TextEditingController(text: photos[index]["name"]);
    String? newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rename Photo"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "Photo Name"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () => Navigator.pop(context, controller.text),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        photos[index]["name"] = newName;
      });
      _savePhotos();
    }
  }

  void _deletePhoto(int index) {
    setState(() {
      photos.removeAt(index);
    });
    _savePhotos();
  }

  void _viewPhoto(String path) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.file(File(path)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () => _viewPhoto(photos[index]["path"]!),
                      child: Image.file(File(photos[index]["path"]!),
                          width: 50, height: 50),
                    ),
                    title: Text(photos[index]["name"]!),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String choice) {
                        if (choice == 'Rename') {
                          _renamePhoto(index);
                        } else if (choice == 'Delete') {
                          _deletePhoto(index);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'Rename', child: Text('Rename')),
                        PopupMenuItem(value: 'Delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPhotoOptions,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Ambil Foto dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _addPhoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _addPhoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// VideoPage: Displays and manages videos
