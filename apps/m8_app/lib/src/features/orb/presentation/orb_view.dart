import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'orb_controller.dart';
import 'orb_painter.dart';
import 'components/answer_visual.dart';
import 'components/history_drawer.dart';
import 'components/invitation_overlay.dart';
import '../domain/orb_state.dart';

/// The primary Questioner view (Vivid Revision 002.5 - Ultra Vivid).
class OrbView extends ConsumerStatefulWidget {
  const OrbView({super.key});

  @override
  ConsumerState<OrbView> createState() => _OrbViewState();
}

class _OrbViewState extends ConsumerState<OrbView> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), 
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orbState = ref.watch(orbControllerProvider);
    final isVisible = (orbState.state == OrbState.revealing || orbState.state == OrbState.presenting);
    
    return Scaffold(
      backgroundColor: const Color(0xFF000814),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth ?? 360.0;
          final isWatchSize = width < 320;
          final basePadding = math.max(16.0, isWatchSize ? width * 0.15 : 24.0);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.mediumImpact();
              ref.read(orbControllerProvider.notifier).simulateManualShake();
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        colors: [Color(0xFF001233), Color(0xFF0F172A)],
                        center: Alignment(0.0, -0.4),
                        radius: 1.5,
                      ),
                    ),
                  ),
                ),
                
                Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Padding(
                      padding: EdgeInsets.all(basePadding),
                      child: ClipOval(
                        child: Stack(
                          children: [
                            // 1. The Orb Graphics Layer (Ultra-Vivid 18px NASA Ring)
                            RepaintBoundary(
                              child: AnimatedBuilder(
                                animation: _animController,
                                builder: (context, _) {
                                  return CustomPaint(
                                    size: Size.infinite,
                                    painter: OrbPainter(
                                      animationValue: _animController.value,
                                      state: orbState.state,
                                      turbulence: orbState.turbulence ?? 0.0,
                                      isAODMode: orbState.isAODMode ?? false,
                                      nebulaIntensity: orbState.nebulaIntensity ?? 0.25,
                                    ),
                                  );
                                },
                              ),
                            ),
                            
                            // 2. The Vivid Manifestation Layer
                            if (isVisible)
                              Center(
                                child: AnimatedScale(
                                  scale: isVisible ? 1.0 : 0.8,
                                  duration: const Duration(milliseconds: 1200),
                                  curve: Curves.elasticOut,
                                  child: AnimatedOpacity(
                                    opacity: isVisible ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 800),
                                    child: TweenAnimationBuilder<double>(
                                      key: ValueKey(orbState.manifestationClock),
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      duration: const Duration(milliseconds: 3500),
                                      curve: Curves.easeOutQuart,
                                      builder: (context, value, child) {
                                        final seed = orbState.revealSeed ?? 0.0;
                                        final inv = 1.0 - value; 
                                        
                                        // Physical Drift + Rise
                                        final driftX = inv * (seed - 0.5) * width * 0.4;
                                        final floatY = inv * 0.35;
                                        
                                        // 3D Matrix Physics
                                        final rotX = inv * 1.5 * (seed > 0.5 ? 1 : -1); 
                                        final rotY = inv * 1.2 * (seed * 10 % 3 - 1);
                                        final rotZ = inv * 0.6 * (seed - 0.5);
                                        
                                        return Transform(
                                          transform: Matrix4.identity()
                                            ..setEntry(3, 2, 0.0015)
                                            ..translate(driftX, width * floatY)
                                            ..rotateX(rotX)
                                            ..rotateY(rotY)
                                            ..rotateZ(rotZ),
                                          alignment: Alignment.center,
                                          child: orbState.revealedAnswer != null ? AnswerVisual(
                                            text: orbState.revealedAnswer!,
                                            shape: orbState.containerShape,
                                          ) : const SizedBox(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                if (orbState.showHistory)
                   HistoryDrawer(
                     history: orbState.history,
                     onClose: () => ref.read(orbControllerProvider.notifier).toggleHistory(),
                   ),
                
                const InvitationOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }
}
