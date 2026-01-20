import 'package:flutter/material.dart';
import '../ml/wildlife_model.dart';

class AnimalDashboard extends StatefulWidget {
  const AnimalDashboard({super.key});

  @override
  State<AnimalDashboard> createState() => _AnimalDashboardState();
}

class _AnimalDashboardState extends State<AnimalDashboard> {
  final WildlifeModel wildlifeModel = WildlifeModel();

  final Map<String, TextEditingController> controllers = {
    'body_temperature': TextEditingController(),
    'heart_rate': TextEditingController(),
    'activity_level': TextEditingController(),
    'feeding_frequency': TextEditingController(),
    'respiration_rate': TextEditingController(),
    'ambient_temperature': TextEditingController(),
    'humidity': TextEditingController(),
    'movement_speed': TextEditingController(),
    'hour': TextEditingController(),
    'temp_rolling_mean': TextEditingController(),
    'activity_rolling_mean': TextEditingController(),
  };

  Map<String, String>? prediction;

  @override
  void initState() {
    super.initState();
    wildlifeModel.load();
  }

  @override
  void dispose() {
    for (var c in controllers.values) c.dispose();
    super.dispose();
  }

  void runPrediction() {
    final input = controllers.values
        .map((c) => double.tryParse(c.text) ?? 0.0)
        .toList();
    final result = wildlifeModel.predict(input);
    setState(() => prediction = result);
  }

  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controllers[label],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label.replaceAll('_', ' ').toUpperCase(),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animal Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ...controllers.keys.map(buildTextField),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: runPrediction,
              child: const Text('Predict Health & Reproductive State'),
            ),
            const SizedBox(height: 20),
            if (prediction != null)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Health State: ${prediction!['health']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reproductive State: ${prediction!['reproductive']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
