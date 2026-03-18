import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/features/orb/presentation/orb_view.dart';

void main() {
  runApp(
    const ProviderScope(
      child: M8App(),
    ),
  );
}

class M8App extends StatelessWidget {
  const M8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M8 (Magic Eightball)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000814),
        useMaterial3: true,
      ),
      home: const M8HomePage(),
    );
  }
}

class M8HomePage extends StatefulWidget {
  const M8HomePage({super.key});

  @override
  State<M8HomePage> createState() => _M8HomePageState();
}

class _M8HomePageState extends State<M8HomePage> {
  String _currentAnswer = "Ask a Question";
  bool _isShaking = false;

  final List<String> _answers = [
    "Yes, absolutely",
    "It is certain",
    "Without a doubt",
    "Yes - definitely",
    "Signs point to yes",
    "Reply hazy, try again",
    "Ask again later",
    "Better not tell you now",
    "Concentrate and ask again",
    "Don't count on it",
    "My reply is no",
    "My sources say no",
    "Outlook not so good",
    "Very doubtful",
  ];

  void _simulateShake() async {
    if (_isShaking) return;

    setState(() {
      _isShaking = true;
      _currentAnswer = "...";
    });

    // Simulate "shaking" duration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isShaking = false;
      _currentAnswer = _answers[DateTime.now().millisecond % _answers.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. The Mystic Orb
          const Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: OrbView(),
              ),
            ),
          ),

          // 2. The Answer Overlay
          Center(
            child: AnimatedOpacity(
              opacity: _isShaking ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  _currentAnswer,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),

          // 3. Shake Button (Mock for testing)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _simulateShake,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900.withValues(alpha: 0.5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Shake Device"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
