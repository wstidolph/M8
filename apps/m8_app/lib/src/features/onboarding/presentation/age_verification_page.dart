import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../infrastructure/user_repository.dart';

/// A minimalist, Zero-UI inspired age verification entry point.
class AgeVerificationPage extends ConsumerStatefulWidget {
  final Widget child;

  const AgeVerificationPage({super.key, required this.child});

  @override
  ConsumerState<AgeVerificationPage> createState() => _AgeVerificationPageState();
}

class _AgeVerificationPageState extends ConsumerState<AgeVerificationPage> {
  bool _isVerifying = true;
  bool _isAccepted = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    if (kIsWeb) {
      if (mounted) setState(() => _isVerifying = false);
      return;
    }
    final status = await ref.read(ageVerificationStatusProvider.future);
    if (mounted) {
      setState(() {
        _isAccepted = status;
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isVerifying) {
      return const Scaffold(
        backgroundColor: Color(0xFF000814),
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 1,
            color: Colors.blue,
          ),
        ),
      );
    }
    if (_isAccepted) return widget.child;

    return Scaffold(
      backgroundColor: const Color(0xFF000814),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CONSENT GATEWAY',
                style: GoogleFonts.outfit(
                  color: Colors.white24,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4.0,
                ),
              ),
              const SizedBox(height: 64),
              Text(
                'The M8 platform is for seekers of legal age only.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: () async {
                  await ref.read(userRepositoryProvider).setAgeVerified(true);
                  if (mounted) {
                    setState(() => _isAccepted = true);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white12, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'I AM 18+',
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'By entering, you confirm compliance with M8 Constitution v1.0.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.white24, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
