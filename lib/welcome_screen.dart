import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/gradient_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to BellMate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your personal timetable and notes companion!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            GradientButton(
              text: 'Get Started',
              onPressed: () {
                context.go('/auth');
              },
            ),
          ],
        ),
      ),
    );
  }
}
