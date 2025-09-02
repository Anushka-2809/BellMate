import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/notes_screen.dart';
import 'package:myapp/profile_screen.dart';
import 'package:myapp/timetable_screen.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.gradient,
  });

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Icon(
        icon,
        size: size,
        color: Colors.white, // Color must be white for ShaderMask to work
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TimetableScreen(),
    NotesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    const LinearGradient buttonGradient = LinearGradient(
      colors: [Colors.green, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('BellMate'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const GradientIcon(
              icon: Icons.logout,
              size: 24,
              gradient: buttonGradient,
            ),
            onPressed: () async {
              await authService.signOut();
              context.go('/');
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: GradientIcon(
              icon: Icons.schedule, // Changed from Icons.notifications
              size: 24,
              gradient: buttonGradient,
            ),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: GradientIcon(
              icon: Icons.notes, // Changed from Icons.note
              size: 24,
              gradient: buttonGradient,
            ),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: GradientIcon(
              icon: Icons.person, // Remains the same
              size: 24,
              gradient: buttonGradient,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
