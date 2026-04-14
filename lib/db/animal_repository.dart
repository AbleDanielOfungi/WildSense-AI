// import 'package:sqflite/sqflite.dart';
// import 'app_database.dart';

// class AnimalRepository {
//   final _db = AppDatabase.instance;

//   Future<void> registerAnimal({
//     required String id,
//     required String species,
//     required String tag,
//   }) async {
//     final db = await _db.database;

//     await db.insert('animals', {
//       'id': id,
//       'species': species,
//       'tag': tag,
//       'created_at': DateTime.now().toIso8601String(),
//     }, conflictAlgorithm: ConflictAlgorithm.abort);
//   }

//   Future<bool> animalExists(String id) async {
//     final db = await _db.database;

//     final result = await db.query(
//       'animals',
//       where: 'id = ?',
//       whereArgs: [id],
//       limit: 1,
//     );

//     return result.isNotEmpty;
//   }
// }

import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class AnimalRepository {
  final dbProvider = AppDatabase.instance;

  Future<void> registerAnimal({
    required String id,
    required String name,
    required String species,
    required String category,
    required String sex,
    required int age,
  }) async {
    final db = await dbProvider.database;

    await db.insert("animals", {
      "id": id,
      "name": name,
      "species": species,
      "category": category,
      "sex": sex,
      "age": age,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAnimals() async {
    final db = await dbProvider.database;
    return await db.query("animals", orderBy: "created_at DESC");
  }
}
