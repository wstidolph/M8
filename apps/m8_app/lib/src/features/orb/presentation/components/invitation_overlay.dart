import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../orb_controller.dart';
import '../../../responses/presentation/invitation_controller.dart';
import '../../../responses/infrastructure/answer_repository.dart';
import '../../infrastructure/sensor_service.dart';
import 'confirmation_visual.dart';

enum ConfirmationAction { accept, reject }

/// A modal overlay for accepting or rejecting a gifted Answer Set.
/// Now features a "swim up" Confirmation Visual (Vivid Revision 003).
class InvitationOverlay extends ConsumerStatefulWidget {
  const InvitationOverlay({super.key});

  @override
  ConsumerState<InvitationOverlay> createState() => _InvitationOverlayState();
}

class _InvitationOverlayState extends ConsumerState<InvitationOverlay> {
  StreamSubscription? _sensorSub;
  final _sensorService = SensorService();
  
  ConfirmationAction? _pendingAction;
  int _confirmationClock = 0;
  double _swimSeed = 0.0;

  @override
  void initState() {
    super.initState();
    _sensorService.init();
    _sensorSub = _sensorService.shakeIntensityStream.listen((intensity) {
      final progress = ref.read(invitationControllerProvider);
      if (progress.status == InvitationStatus.pending) {
        if (intensity == ShakeIntensity.light && _pendingAction != ConfirmationAction.accept) {
          _handleTrigger(ConfirmationAction.accept);
        } else if (intensity == ShakeIntensity.violent && _pendingAction != ConfirmationAction.reject) {
          _handleTrigger(ConfirmationAction.reject);
        }
      }
    });
  }

  void _handleTrigger(ConfirmationAction action) {
    HapticFeedback.mediumImpact();
    setState(() {
      _pendingAction = action;
      _confirmationClock++;
      _swimSeed = math.Random().nextDouble();
    });
    
    // Auto-dismiss confirmation after 5 seconds if no action taken
    final currentClock = _confirmationClock;
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _confirmationClock == currentClock) {
        setState(() { _pendingAction = null; });
      }
    });
  }

  void _handleConfirm() async {
    final action = _pendingAction;
    if (action == null) return;

    HapticFeedback.heavyImpact();
    setState(() { _pendingAction = null; });

    if (action == ConfirmationAction.accept) {
      final progress = ref.read(invitationControllerProvider);
      if (progress.answers != null && progress.label != null) {
        await ref.read(answerRepositoryProvider).setCustomAnswers(progress.answers!, progress.label!);
        await ref.read(orbControllerProvider.notifier).refreshAnswers();
        ref.read(invitationControllerProvider.notifier).clear();
      }
    } else {
      ref.read(invitationControllerProvider.notifier).clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(invitationControllerProvider);
    if (progress.status == InvitationStatus.none) return const SizedBox.shrink();

    final isGated = progress.status == InvitationStatus.gated;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // 1. Initial Gift Announcement (Simplified)
        if (_pendingAction == null)
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: isGated ? Colors.orange.withOpacity(0.3) : Colors.blue.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: isGated ? Colors.orange.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                      blurRadius: 40.0,
                      spreadRadius: 10.0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isGated ? Icons.security : Icons.celebration,
                      size: 40.0,
                      color: isGated ? Colors.orange : Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isGated ? "Waiting for Approval" : "GIFT FROM ${ (progress.label ?? 'A FRIEND').toUpperCase() }",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Outfit',
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!isGated) ...[
                      const _InstructionRow(
                        icon: Icons.vibration,
                        label: "Shake to Accept",
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
                          backgroundColor: const Color(0xFF1E293B), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("OK"),
                      ),
                  ],
                ),
              ),
            ),
          ),

        // 2. The Confirmation Visual Swim-up Layer
        if (_pendingAction != null)
          Center(
            child: TweenAnimationBuilder<double>(
              key: ValueKey(_confirmationClock),
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutQuart,
              builder: (context, value, child) {
                final inv = 1.0 - value; 
                
                // Physical Drift + Rise
                final driftX = inv * (_swimSeed - 0.5) * width * 0.3;
                final floatY = inv * 0.25;
                
                // 3D Matrix Physics
                final rotX = inv * 1.0 * (_swimSeed > 0.5 ? 1 : -1); 
                final rotY = inv * 0.8 * (_swimSeed * 10 % 3 - 1);
                
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0015)
                    ..translate(driftX, width * floatY)
                    ..rotateX(rotX)
                    ..rotateY(rotY),
                  alignment: Alignment.center,
                  child: ConfirmationVisual(
                    text: _pendingAction == ConfirmationAction.accept ? "ACCEPT?" : "REJECT?",
                    color: _pendingAction == ConfirmationAction.accept ? Colors.blue : Colors.red,
                    onConfirm: _handleConfirm,
                  ),
                );
              },
            ),
          ),
      ],
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
        Icon(icon, size: 16.0, color: color),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 10.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

