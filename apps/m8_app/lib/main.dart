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
      home: const OrbView(),
    );
  }
}
