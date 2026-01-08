import 'package:flutter/material.dart';
import 'ui/animal_dashboard.dart';

void main() {
  runApp(const WildlifeApp());
}

class WildlifeApp extends StatelessWidget {
  const WildlifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Wildlife Health',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const AnimalDashboard(),
    );
  }
}
