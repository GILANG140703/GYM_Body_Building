import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

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
<<<<<<< HEAD
                Get.to(() => VideoPage()); // Pastikan ini tidak dikomentari
=======
                Get.to(() => VideoPage());
>>>>>>> 56bc44680b542242b7a6144e394afbf06d48ccc4
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
  const PhotoPage({super.key});

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
      body: photos.isEmpty
          ? Center(child: Text("Tidak ada foto"))
          : Column(
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
                              PopupMenuItem(
                                  value: 'Rename', child: Text('Rename')),
                              PopupMenuItem(
                                  value: 'Delete', child: Text('Delete')),
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
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera, color: Colors.blue),
                title: Text('Ambil Foto dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _addPhoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo, color: Colors.blue),
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
class VideoPage extends StatefulWidget {
<<<<<<< HEAD
  const VideoPage({super.key});

=======
>>>>>>> 56bc44680b542242b7a6144e394afbf06d48ccc4
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
<<<<<<< HEAD
  VideoPlayerController? _controller;
  String? _videoPath;
  bool _isPlaying = false;
  bool _isLandscape = true;
=======
  List<Map<String, String>> videos = [];
>>>>>>> 56bc44680b542242b7a6144e394afbf06d48ccc4

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _checkPermissions();
    _loadVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final storageStatus = await Permission.storage.request();

    if (cameraStatus.isGranted && storageStatus.isGranted) {
      print('Permissions granted');
    } else {
      print('Permissions denied');
    }
  }

  Future<void> _loadVideo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPath = prefs.getString('savedVideoPath');
    if (savedPath != null) {
      setState(() {
        _videoPath = savedPath;
      });
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    if (_videoPath != null) {
      _controller = VideoPlayerController.file(File(_videoPath!))
        ..initialize().then((_) {
          setState(() {});
          _controller?.play();
          _isPlaying = true;
        });
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
=======
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? videoPaths = prefs.getStringList('videos');
    if (videoPaths != null) {
      setState(() {
        videos = videoPaths.map((path) {
          List<String> split = path.split('|');
          return {"path": split[0], "name": split[1]};
        }).toList();
      });
    }
  }

  Future<void> _saveVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> videoPaths =
        videos.map((video) => '${video["path"]}|${video["name"]}').toList();
    await prefs.setStringList('videos', videoPaths);
  }

  Future<void> _addVideo(ImageSource source) async {
>>>>>>> 56bc44680b542242b7a6144e394afbf06d48ccc4
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: source);

    if (pickedFile != null) {
      setState(() {
<<<<<<< HEAD
        _videoPath = pickedFile.path;
      });
      _saveVideoPath(pickedFile.path);
      _initializeVideo();
    }
  }

  Future<void> _saveVideoPath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedVideoPath', path);
  }

  void _showAddVideoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Rekam Video dengan Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _controller?.pause();
    } else {
      _controller?.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _stopVideo() {
    _controller?.pause();
    setState(() {
      _controller?.seekTo(Duration.zero);
      _isPlaying = false;
    });
  }

  Future<void> _deleteVideo() async {
    if (_videoPath == null) return;

    final videoFile = File(_videoPath!);
    await videoFile.delete();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedVideoPath');

    setState(() {
      _videoPath = null;
      _controller?.dispose();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Video deleted')),
    );
  }

  void _toggleOrientation(bool value) {
    setState(() {
      _isLandscape = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
=======
        videos.add(
            {"path": pickedFile.path, "name": "Video ${videos.length + 1}"});
      });
      _saveVideos();
    }
  }

  void _renameVideo(int index) async {
    TextEditingController controller =
        TextEditingController(text: videos[index]["name"]);
    String? newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rename Video"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "Video Name"),
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
        videos[index]["name"] = newName;
      });
      _saveVideos();
    }
  }

  void _deleteVideo(int index) {
    setState(() {
      videos.removeAt(index);
    });
    _saveVideos();
  }

  void _viewVideo(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoPath: path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
>>>>>>> 56bc44680b542242b7a6144e394afbf06d48ccc4
      appBar: AppBar(
        title: Text('Video'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
<<<<<<< HEAD
      body: Center(
        child: _videoPath == null
            ? Text('Pilih atau rekam video')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: _isLandscape ? 300 : 500,
                    width: double.infinity,
                    child:
                        _controller != null && _controller!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              )
                            : Center(child: CircularProgressIndicator()),
=======
      body: videos.isEmpty
          ? Center(child: Text("Tidak ada video"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () => _viewVideo(videos[index]["path"]!),
                            child: Icon(Icons.videocam, size: 50),
                          ),
                          title: Text(videos[index]["name"]!),
                          trailing: PopupMenuButton<String>(
                            onSelected: (String choice) {
                              if (choice == 'Rename') {
                                _renameVideo(index);
                              } else if (choice == 'Delete') {
                                _deleteVideo(index);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 'Rename', child: Text('Rename')),
                              PopupMenuItem(
                                  value: 'Delete', child: Text('Delete')),
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
        onPressed: _showAddVideoOptions,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddVideoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.videocam, color: Colors.blue),
                title: Text('Ambil Video dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _addVideo(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library, color: Colors.blue),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _addVideo(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// VideoPlayerScreen: Displays the video player
class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  VideoPlayerScreen({required this.videoPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(
            () {}); // Ensure the first frame is shown after the video is initialized.
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio < 1.0
                        ? _controller.value.aspectRatio *
                            0.7 // For vertical videos
                        : _controller.value
                            .aspectRatio, // Original aspect ratio for horizontal
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          if (_controller.value.isInitialized)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Colors.blue,
                      backgroundColor: Colors.grey,
                      bufferedColor: Colors.lightBlue,
                    ),
>>>>>>> 56bc44680b542242b7a6144e394afbf06d48ccc4
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
<<<<<<< HEAD
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: _togglePlayPause,
                      ),
                      IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: _stopVideo,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: _deleteVideo,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Aspect Ratio: '),
                      DropdownButton<bool>(
                        value: _isLandscape,
                        items: [
                          DropdownMenuItem<bool>(
                            value: true,
                            child: Text('Landscape'),
                          ),
                          DropdownMenuItem<bool>(
                            value: false,
                            child: Text('Portrait'),
                          ),
                        ],
                        onChanged: (bool? value) {
                          if (value != null) {
                            _toggleOrientation(value);
                          }
=======
                        icon: Icon(Icons.replay_10, color: Colors.blue),
                        onPressed: () {
                          _controller.seekTo(
                            _controller.value.position - Duration(seconds: 10),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.forward_10, color: Colors.blue),
                        onPressed: () {
                          _controller.seekTo(
                            _controller.value.position + Duration(seconds: 10),
                          );
>>>>>>> 56bc44680b542242b7a6144e394afbf06d48ccc4
                        },
                      ),
                    ],
                  ),
                ],
              ),
<<<<<<< HEAD
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVideoOptions,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
=======
            ),
        ],
      ),
>>>>>>> 56bc44680b542242b7a6144e394afbf06d48ccc4
    );
  }
}
