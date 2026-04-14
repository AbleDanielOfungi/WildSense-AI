import 'package:flutter/material.dart';
import 'db/app_database.dart';
import 'ui/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite
  await AppDatabase.instance.database;

  runApp(const WildlifeHealthApp());
}

class WildlifeHealthApp extends StatelessWidget {
  const WildlifeHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wildlife Health Monitor',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),

      // Start from login
      home: const LoginScreen(),
    );
  }
}
