import 'package:flutter/material.dart';
import 'package:wildlife_dashboard/ui/register_animal_screen.dart';
import '../db/animal_repository.dart';
// import 'register_animal_screen.dart';
import 'animal_dashboard.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final repo = AnimalRepository();

  List<Map<String, dynamic>> animals = [];

  @override
  void initState() {
    super.initState();
    loadAnimals();
  }

  Future<void> loadAnimals() async {
    final data = await repo.getAnimals();
    setState(() {
      animals = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registered Animals")),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterAnimalScreen()),
          );

          loadAnimals();
        },
      ),

      body: animals.isEmpty
          ? const Center(child: Text("No animals registered"))
          : ListView.builder(
              itemCount: animals.length,
              itemBuilder: (context, index) {
                final animal = animals[index];

                return Card(
                  child: ListTile(
                    title: Text("${animal["name"]} (${animal["id"]})"),
                    subtitle: Text(
                      "${animal["species"]} • ${animal["category"]}",
                    ),

                    trailing: const Icon(Icons.arrow_forward),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AnimalDashboard(animalId: animal["id"]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
