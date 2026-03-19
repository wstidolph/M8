import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/features/orb/presentation/orb_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: M8App(),
    ),
  );

  _initSupabase();
}

Future<void> _initSupabase() async {
  try {
    await Supabase.initialize(
      url: 'https://wmryrzbkcjqwmhbqaeus.supabase.co',
      anonKey: 'sb_publishable_ba6YYsXyaBfpP4QTz-5GDw_kwZQ2TLP',
    ).timeout(const Duration(seconds: 3));
  } catch (e) {
    // Silence during local dev
  }
}

class M8App extends StatelessWidget {
  const M8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M8 Magic Orb',
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
