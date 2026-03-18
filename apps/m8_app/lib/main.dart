import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/features/orb/presentation/orb_view.dart';
import 'src/features/onboarding/presentation/age_verification_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Replace with your credentials from Supabase Project Settings > API
  await Supabase.initialize(
    url: 'https://wmryrzbkcjqwmhbqaeus.supabase.co',
    anonKey: 'sb_publishable_ba6YYsXyaBfpP4QTz-5GDw_kwZQ2TLP',
  );

  runApp(
    const ProviderScope(
      child: AgeVerificationPage(
        child: M8App(),
      ),
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
