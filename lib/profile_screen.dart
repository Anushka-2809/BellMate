import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'auth_service.dart';
import 'theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    (user?.email.isNotEmpty == true ? user!.email[0].toUpperCase() : 'U'),
                    style: TextStyle(fontSize: 36, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  user?.email ?? 'No email found',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Theme'),
                    const SizedBox(width: 12),
                    SegmentedButton<ThemeMode>(
                      segments: const <ButtonSegment<ThemeMode>>[
                        ButtonSegment<ThemeMode>(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                        ButtonSegment<ThemeMode>(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
                      ],
                      selected: <ThemeMode>{themeProvider.themeMode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light},
                      onSelectionChanged: (sel) {
                        if (sel.isNotEmpty) {
                          themeProvider.setThemeMode(sel.first);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await authService.signOut();
                      if (context.mounted) {
                        context.go('/auth');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
