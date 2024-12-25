import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pure Tone Generator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      home: const PureToneGenerator(),
    );
  }
}

class PureToneGenerator extends StatefulWidget {
  const PureToneGenerator({super.key});

  @override
  _PureToneGeneratorState createState() => _PureToneGeneratorState();
}

class _PureToneGeneratorState extends State<PureToneGenerator> {
  final AudioPlayer _player = AudioPlayer();
  int _selectedFrequency = 2000; // 初期周波数を2000Hzに設定
  bool _isPlaying = false;

  // 周波数リストを定義
  final List<int> _frequencies = [2000, 4000, 8000, 16000];
  final Map<int, String> _frequencyFiles = {
    2000: '2000Hz.wav',
    4000: '4000Hz.wav',
    8000: '8000Hz.wav',
    16000: '16000Hz.wav',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pure Tone Generator'),
        // elevation: 4,
        // shadowColor: Colors.black.withOpacity(0.2),
        // backgroundColor: Colors.white,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: theme.colorScheme.primary, width: 1),
                ),
                child: DropdownButton<int>(
                  value: _selectedFrequency,
                  icon: Icon(Icons.arrow_drop_down,
                      color: theme.colorScheme.primary),
                  isExpanded: true,
                  underline: SizedBox(), // デフォルトの下線を削除
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: theme.colorScheme.primary,
                  ),
                  items: _frequencies
                      .map((freq) => DropdownMenuItem<int>(
                            value: freq,
                            child: Text('$freq Hz'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFrequency = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.stop_circle : Icons.play_circle,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                onPressed: _isPlaying ? _stopTone : _playTone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _playTone() async {
    final filePath = _frequencyFiles[_selectedFrequency];
    if (filePath != null) {
      await _player.play(AssetSource(filePath));
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _stopTone() async {
    await _player.stop();
    setState(() {
      _isPlaying = false;
    });
  }
}
