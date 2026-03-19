import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/orb_controller.dart';
import '../../../responses/presentation/invitation_controller.dart';
import '../../../responses/infrastructure/answer_repository.dart';
import '../../infrastructure/sensor_service.dart';

/// A modal overlay for accepting or rejecting a gifted Answer Set.
class InvitationOverlay extends ConsumerStatefulWidget {
  const InvitationOverlay({super.key});

  @override
  ConsumerState<InvitationOverlay> createState() => _InvitationOverlayState();
}

class _InvitationOverlayState extends ConsumerState<InvitationOverlay> {
  StreamSubscription? _sensorSub;
  final _sensorService = SensorService();

  @override
  void initState() {
    super.initState();
    _sensorService.init();
    _sensorSub = _sensorService.shakeIntensityStream.listen((intensity) {
      final progress = ref.read(invitationControllerProvider);
      if (progress.status == InvitationStatus.pending) {
        if (intensity == ShakeIntensity.light) {
          _handleAccept();
        } else if (intensity == ShakeIntensity.violent) {
          _handleReject();
        }
      }
    });
  }

  void _handleAccept() async {
    final progress = ref.read(invitationControllerProvider);
    if (progress.answers != null && progress.label != null) {
      HapticFeedback.mediumImpact();
      await ref.read(answerRepositoryProvider).setCustomAnswers(progress.answers!, progress.label!);
      // Refresh the pool in the Orb UI
      await ref.read(orbControllerProvider.notifier).refreshAnswers();
      ref.read(invitationControllerProvider.notifier).clear();
    }
  }

  void _handleReject() {
    HapticFeedback.heavyImpact();
    ref.read(invitationControllerProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(invitationControllerProvider);
    if (progress.status == InvitationStatus.none) return const SizedBox.shrink();

    final isGated = progress.status == InvitationStatus.gated;

    return Material(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: isGated ? Colors.orange.withOpacity(0.3) : Colors.blue.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: isGated ? Colors.orange.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                blurRadius: 40,
                spreadRadius: 10,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isGated ? Icons.security : Icons.celebration,
                size: 48,
                color: isGated ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                isGated ? "Waiting for Approval" : "New from ${progress.label ?? 'a Friend'}!",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isGated 
                  ? "This content is pending parental review. We'll let you know when it's ready!"
                  : "A custom set of mystical responses has been gifted to you.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8), // slate-400
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              if (!isGated) ...[
                _InstructionRow(
                  icon: Icons.vibration,
                  label: "Light Shake to Accept",
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                _InstructionRow(
                  icon: Icons.error_outline,
                  label: "Violent Shake to Reject",
                  color: Colors.red.shade400,
                ),
              ] else 
                ElevatedButton(
                  onPressed: () => ref.read(invitationControllerProvider.notifier).clear(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B), // slate-800
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("OK"),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sensorSub?.cancel();
    super.dispose();
  }
}

class _InstructionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InstructionRow({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
