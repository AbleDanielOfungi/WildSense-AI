import 'package:flutter/material.dart';
import 'package:wildlife_dashboard/ui/animal_list_screen.dart';
import '../db/user_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userRepo = UserRepository();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String error = "";

  void login() async {
    final user = await userRepo.login(
      usernameController.text,
      passwordController.text,
    );

    if (user == null) {
      setState(() {
        error = "Invalid login credentials";
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AnimalListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wildlife Login")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: login, child: const Text("Login")),

            const SizedBox(height: 10),

            Text(error, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
