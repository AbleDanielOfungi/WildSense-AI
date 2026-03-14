import 'package:flutter/material.dart';
import '../db/user_repository.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final userRepo = UserRepository();

  final username = TextEditingController();
  final password = TextEditingController();
  final fullname = TextEditingController();

  String role = "user";

  void createUser() async {
    await userRepo.createUser(
      username: username.text,
      password: password.text,
      role: role,
      fullName: fullname.text,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("User Created")));

    username.clear();
    password.clear();
    fullname.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create User")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: fullname,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),

            TextField(
              controller: username,
              decoration: const InputDecoration(labelText: "Username"),
            ),

            TextField(
              controller: password,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 10),

            DropdownButton<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: "admin", child: Text("Admin")),
                DropdownMenuItem(value: "user", child: Text("User")),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: createUser,
              child: const Text("Create User"),
            ),
          ],
        ),
      ),
    );
  }
}
