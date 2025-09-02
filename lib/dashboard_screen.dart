import 'package:flutter/material.dart';
import 'package:myapp/notes_screen.dart';
import 'package:myapp/timetable_screen.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // 0 for Timetable, 1 for Notes

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;
  final backgroundColor = theme.scaffoldBackgroundColor;
  final textColor = theme.colorScheme.onBackground;
  final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text('Dashboard', style: theme.appBarTheme.titleTextStyle),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: theme.appBarTheme.iconTheme?.color),
            tooltip: 'Toggle Theme',
            onPressed: () => themeProvider.toggle(),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: theme.appBarTheme.iconTheme?.color),
            onPressed: () async {
              final auth = Provider.of<AuthService>(context, listen: false);
              await auth.signOut();
              if (mounted) context.go('/auth');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            _buildToggleButtons(isDarkMode, theme),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: const [
                      TimetableScreen(),
                      NotesScreen(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons(bool isDarkMode, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.teal.shade700 : Colors.teal.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: _selectedIndex == 0 ? (isDarkMode ? Colors.teal.shade900 : Colors.white) : Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => setState(() => _selectedIndex = 0),
              child: Text('Timetable', style: TextStyle(color: _selectedIndex == 0 ? theme.colorScheme.primary : theme.colorScheme.onSurface)),
            ),
          ),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: _selectedIndex == 1 ? (isDarkMode ? Colors.teal.shade900 : Colors.white) : Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => setState(() => _selectedIndex = 1),
              child: Text('Notes', style: TextStyle(color: _selectedIndex == 1 ? theme.colorScheme.primary : theme.colorScheme.onSurface)),
            ),
          ),
        ],
      ),
    );
  }
}
