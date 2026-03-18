import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'orb_controller.dart';
import 'orb_painter.dart';
import 'components/answer_visual.dart';
import '../domain/orb_state.dart';

/// The primary Questioner view for the M8 orb experience.
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
      duration: const Duration(seconds: 4), // Loop duration
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
    final isPresenting = orbState.state == OrbState.presenting;
    
    // Dynamic Circular Safety Insets (Workflow Phase 1)
    final screenSize = MediaQuery.of(context).size;
    final isWatchSize = screenSize.width < 320;
    // On small/watch screens, apply approx 15-20% padding to prevent clipping at corners
    final basePadding = isWatchSize ? screenSize.width * 0.15 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFF000814),
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: EdgeInsets.all(basePadding),
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: OrbPainter(
                          animationValue: _animController.value,
                          state: orbState.state,
                          turbulence: orbState.turbulence,
                          isAODMode: false, // TODO: Detect system AOD state
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          
          // 4. Floating Answer Overlay (US3)
          if (isPresenting && orbState.revealedAnswer != null)
             Center(
               child: AnimatedScale(
                 scale: isPresenting ? 1.0 : 0.8,
                 duration: const Duration(milliseconds: 1200),
                 curve: Curves.elasticOut,
                 child: AnimatedOpacity(
                   opacity: isPresenting ? 1.0 : 0.0,
                   duration: const Duration(milliseconds: 800),
                   child: AnswerVisual(text: orbState.revealedAnswer!),
                 ),
               ),
             ),
        ],
      ),
    );
  }
}
