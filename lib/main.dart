import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/auth_screen.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/splash_screen.dart';
import 'package:myapp/welcome_screen.dart';
import 'auth_service.dart';
import 'bell_service.dart';
import 'notification_service.dart';
import 'notes_provider.dart';
import 'timetable_provider.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService(prefs)),
        ChangeNotifierProvider(create: (context) => TimetableProvider()),
        ChangeNotifierProvider(create: (context) => NotesProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider(prefs)),
        Provider(
          create: (context) => BellService(),
        ),
        ProxyProvider2<TimetableProvider, BellService, NotificationService>(
          update: (context, timetableProvider, bellService, previous) =>
              NotificationService(timetableProvider, bellService),
          dispose: (context, service) => service.dispose(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primarySeedColor = Colors.teal;

    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: primarySeedColor, brightness: Brightness.light),
      scaffoldBackgroundColor: Colors.teal.shade50,
      cardColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.teal.shade100,
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
        iconTheme: IconThemeData(color: Colors.teal.shade900),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.teal),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
      scaffoldBackgroundColor: Colors.grey.shade900,
      cardColor: Colors.grey.shade800,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade900,
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.deepPurple),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      ),
    );

  final authService = Provider.of<AuthService>(context);
  final themeProvider = Provider.of<ThemeProvider>(context);

  final router = GoRouter(
      initialLocation: '/',
      refreshListenable: authService,
      redirect: (context, state) {
        final bool loggedIn = authService.isLoggedIn();
        final String location = state.matchedLocation;

        final bool goingToAuth = location == '/auth' || location == '/welcome';
        final bool atRoot = location == '/';
        final bool goingHome = location == '/home';

        if (!loggedIn && (goingHome)) {
          return '/auth';
        }

        if (loggedIn && (goingToAuth || atRoot)) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'BellMate',
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
