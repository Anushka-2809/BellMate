import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/gradient_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final begin = Alignment.lerp(Alignment.topLeft, Alignment.bottomLeft, t)!;
          final end = Alignment.lerp(Alignment.bottomRight, Alignment.topRight, t)!;
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: begin,
                end: end,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 100 - (t * 10),
                  left: -50 + (t * 30),
                  child: _buildBlob(colorScheme.primary.withOpacity(0.15), 200),
                ),
                Positioned(
                  bottom: 120 - (t * 20),
                  right: -40 + (t * 40),
                  child: _buildBlob(colorScheme.secondary.withOpacity(0.12), 240),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(
                          Icons.notifications_active_outlined,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Welcome to BellMate",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Your personal timetable and notes companion!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 60),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            context.go('/auth');
                          },
                          child: const Text('Get Started'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 60, spreadRadius: 10),
        ],
      ),
    );
  }
}
