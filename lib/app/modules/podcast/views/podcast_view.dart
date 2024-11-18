import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class PodcastView extends StatefulWidget {
  @override
  _PodcastViewState createState() => _PodcastViewState();
}

class _PodcastViewState extends State<PodcastView> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _searchQuery = '';
  bool _isListening = false;

  String _currentCategory = 'Suplemen';

  final List<Map<String, dynamic>> podcasts = [
    {
      'category': 'Suplemen',
      'title': 'Suplemen Protein: Pilih Whey, Casein, atau Plant-Based?',
      'duration': '25:00',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'category': 'Suplemen',
      'title': 'Membangun Otot Lebih Cepat: Peran Kreatin dalam Latihanmu',
      'duration': '10:00',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'category': 'Gym',
      'title':
          'Pump It Up! Cara Mendapatkan Biceps Lebih Berisi dengan Superset',
      'duration': '25:00',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'category': 'Gym',
      'title': 'Kesalahan Umum dalam Melatih Triceps dan Cara Memperbaikinya',
      'duration': '10:00',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'image': 'https://via.placeholder.com/150',
    },
  ];

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _searchQuery = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  void dispose() {
    _speech.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPodcasts = podcasts
        .where((podcast) =>
            podcast['category'] == _currentCategory &&
            podcast['title'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcast'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search and Voice Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
              ],
            ),
          ),
          // Category Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Suplemen'),
                selected: _currentCategory == 'Suplemen',
                onSelected: (selected) {
                  setState(() {
                    _currentCategory = 'Suplemen';
                  });
                },
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('Gym'),
                selected: _currentCategory == 'Gym',
                onSelected: (selected) {
                  setState(() {
                    _currentCategory = 'Gym';
                  });
                },
              ),
            ],
          ),
          // Podcast List
          Expanded(
            child: ListView.builder(
              itemCount: filteredPodcasts.length,
              itemBuilder: (context, index) {
                final podcast = filteredPodcasts[index];
                return ListTile(
                  leading: Image.network(
                    podcast['image'],
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(podcast['title']),
                  subtitle: Text(podcast['duration']),
                  onTap: () => _showPodcastPlayer(context, podcast),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPodcastPlayer(BuildContext context, Map<String, dynamic> podcast) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return PodcastPlayer(podcast: podcast, audioPlayer: _audioPlayer);
      },
    );
  }
}

class PodcastPlayer extends StatefulWidget {
  final Map<String, dynamic> podcast;
  final AudioPlayer audioPlayer;

  const PodcastPlayer({required this.podcast, required this.audioPlayer});

  @override
  _PodcastPlayerState createState() => _PodcastPlayerState();
}

class _PodcastPlayerState extends State<PodcastPlayer> {
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    widget.audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    widget.audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    widget.audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    widget.audioPlayer.play(UrlSource(widget.podcast['url']));
  }

  @override
  void dispose() {
    widget.audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.podcast['title'],
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Image.network(widget.podcast['image'], height: 150),
          const SizedBox(height: 20),
          Slider(
            value: _position.inSeconds.toDouble(),
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) {
              widget.audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: () => widget.audioPlayer
                    .seek(_position - const Duration(seconds: 10)),
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if (_isPlaying) {
                    widget.audioPlayer.pause();
                  } else {
                    widget.audioPlayer.play(UrlSource(widget.podcast['url']));
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10),
                onPressed: () => widget.audioPlayer
                    .seek(_position + const Duration(seconds: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
