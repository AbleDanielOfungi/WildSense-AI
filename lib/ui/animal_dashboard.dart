import 'package:flutter/material.dart';
import '../ml/wildlife_model.dart';

class AnimalDashboard extends StatefulWidget {
  const AnimalDashboard({super.key});

  @override
  State<AnimalDashboard> createState() => _AnimalDashboardState();
}

class _AnimalDashboardState extends State<AnimalDashboard> {
  final WildlifeModel model = WildlifeModel();

  bool isLoaded = false;
  String health = '--';
  String reproductive = '--';

  // Controllers for simulated IoT inputs
  final controllers = List.generate(11, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    model.load().then((_) {
      setState(() => isLoaded = true);
    });
  }

  void predict() {
    final input = controllers
        .map((c) => double.tryParse(c.text) ?? 0.0)
        .toList();

    final result = model.predict(input);

    setState(() {
      health = result['health']!;
      reproductive = result['reproductive']!;
    });
  }

  Widget inputField(String label, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controllers[index],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Color healthColor() {
    switch (health) {
      case 'Healthy':
        return Colors.green;
      case 'Sick':
        return Colors.orange;
      case 'Critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Animal Health Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            inputField('Body Temperature', 0),
            inputField('Heart Rate', 1),
            inputField('Activity Level', 2),
            inputField('Feeding Frequency', 3),
            inputField('Respiration Rate', 4),
            inputField('Ambient Temperature', 5),
            inputField('Humidity', 6),
            inputField('Movement Speed', 7),
            inputField('Hour of Day', 8),
            inputField('Temp Rolling Mean', 9),
            inputField('Activity Rolling Mean', 10),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: predict,
              child: const Text('Run AI Analysis'),
            ),

            const SizedBox(height: 24),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Health Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      health,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: healthColor(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Reproductive State',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reproductive,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
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
