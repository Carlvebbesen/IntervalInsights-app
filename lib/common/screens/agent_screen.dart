import 'package:flutter/material.dart';

import 'package:interval_insights_app/common/utils/app_theme.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen>
    with SingleTickerProviderStateMixin {
  bool isListening = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
      // Speed up animation when listening
      if (isListening) {
        _controller.duration = const Duration(milliseconds: 800);
      } else {
        _controller.duration = const Duration(seconds: 2);
      }
      _controller.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Header
            const Positioned(
              top: 24,
              left: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Agent',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Voice-powered training assistant',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Center Animation
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // The Orb / Wave
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ripples
                        _buildRipple(0.0),
                        _buildRipple(0.3),
                        _buildRipple(0.6),

                        // Core Orb (Gradient Circle)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isListening
                                  ? [
                                      AppColors.petalFrost,
                                      const Color(0xFF0891B2),
                                    ]
                                  : [
                                      AppColors.vanillaCustard,
                                      const Color(0xFF7C3AED),
                                    ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (isListening
                                            ? AppColors.petalFrost
                                            : AppColors.vanillaCustard)
                                        .withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Text
                  Text(
                    isListening ? 'Listening...' : 'Tap mic to add context',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isListening
                        ? 'Speak naturally about your training'
                        : 'or analyze recent training',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 40),

                  // Mic Button
                  GestureDetector(
                    onTap: _toggleListening,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isListening
                              ? [AppColors.petalFrost, AppColors.vanillaCustard]
                              : [Colors.purple, Colors.deepPurple],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isListening
                                        ? AppColors.petalFrost
                                        : Colors.purple)
                                    .withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        isListening ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Actions
            const Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Row(
                children: [
                  Expanded(child: _QuickAction('Recent workout', '🏃')),
                  SizedBox(width: 16),
                  Expanded(child: _QuickAction('Weekly summary', '📊')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRipple(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final val = (_controller.value + delay) % 1.0;
        final scale = 1.0 + (val * 0.5); // Grow from 100% to 150%
        final opacity = 1.0 - val; // Fade out

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity * 0.5,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isListening
                      ? AppColors.petalFrost
                      : AppColors.petalFrost,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final String emoji;
  const _QuickAction(this.label, this.emoji);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}
