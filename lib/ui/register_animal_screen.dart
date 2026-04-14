import 'package:flutter/material.dart';
import '../db/animal_repository.dart';

class RegisterAnimalScreen extends StatefulWidget {
  const RegisterAnimalScreen({super.key});

  @override
  State<RegisterAnimalScreen> createState() => _RegisterAnimalScreenState();
}

class _RegisterAnimalScreenState extends State<RegisterAnimalScreen> {
  final repo = AnimalRepository();

  final name = TextEditingController();
  final species = TextEditingController();
  final category = TextEditingController();
  final age = TextEditingController();

  String sex = "Male";

  String generateId(String species) {
    final prefix = species.substring(0, 3).toUpperCase();
    final number = DateTime.now().millisecondsSinceEpoch.toString().substring(
      8,
    );
    return "$prefix-$number";
  }

  void saveAnimal() async {
    final id = generateId(species.text);

    await repo.registerAnimal(
      id: id,
      name: name.text,
      species: species.text,
      category: category.text,
      sex: sex,
      age: int.tryParse(age.text) ?? 0,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Animal")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Animal Name"),
            ),

            TextField(
              controller: species,
              decoration: const InputDecoration(labelText: "Species"),
            ),

            TextField(
              controller: category,
              decoration: const InputDecoration(labelText: "Category"),
            ),

            TextField(
              controller: age,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Age"),
            ),

            const SizedBox(height: 10),

            DropdownButton<String>(
              value: sex,
              items: const [
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(value: "Female", child: Text("Female")),
              ],
              onChanged: (value) {
                setState(() {
                  sex = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveAnimal,
              child: const Text("Register Animal"),
            ),
          ],
        ),
      ),
    );
  }
}
