import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A premium glassmorphic drawer for viewing mystical history.
class HistoryDrawer extends StatelessWidget {
  final List<String> history;
  final VoidCallback onClose;

  const HistoryDrawer({
    super.key, 
    required this.history,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWatch = size.width < 320;
    
    // Workflow [/cross-platform-wearable]: Increase horizontal padding for circular bezels
    final horizontalPadding = isWatch ? 48.0 : 24.0;
    final drawerHeight = isWatch ? size.height * 0.9 : size.height * 0.6;

    return Stack(
      children: [
        // 1. Full-screen tap-to-close area
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.black26,
          ),
        ),
        
        // 2. Glassmorphic Surface
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: double.infinity,
                height: drawerHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05), // Frosted glass effect
                  border: Border(
                    top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1.5),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Drag Handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'MYSTIC HISTORY',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: isWatch ? 10 : 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: history.isEmpty 
                        ? Center(
                            child: Text(
                              'The void remains silent...',
                              style: GoogleFonts.inter(color: Colors.white38, fontStyle: FontStyle.italic, fontSize: isWatch ? 12 : 14),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                            itemCount: history.length,
                            separatorBuilder: (context, _) => Divider(color: Colors.white12, height: isWatch ? 24 : 32),
                            itemBuilder: (context, index) {
                              return Text(
                                history[index].toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: isWatch ? 14 : 18,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2,
                                ),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
