import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'app_database.dart';

class UserRepository {
  final dbProvider = AppDatabase.instance;

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> createUser({
    required String username,
    required String password,
    required String role,
    required String fullName,
  }) async {
    final db = await dbProvider.database;

    await db.insert("users", {
      "username": username,
      "password": hashPassword(password),
      "role": role,
      "full_name": fullName,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final db = await dbProvider.database;

    final result = await db.query(
      "users",
      where: "username=?",
      whereArgs: [username],
    );

    if (result.isEmpty) return null;

    final user = result.first;

    if (user["password"] == hashPassword(password)) {
      return user;
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await dbProvider.database;
    return await db.query("users");
  }
}
