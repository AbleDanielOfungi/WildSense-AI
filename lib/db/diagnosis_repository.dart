import 'app_database.dart';

class DiagnosisRepository {
  final _db = AppDatabase.instance;

  Future<void> saveDiagnosis({
    required String animalId,
    required String healthState,
    required String reproductiveState,
    double? confidence,
  }) async {
    final db = await _db.database;

    await db.insert('diagnoses', {
      'animal_id': animalId,
      'health_state': healthState,
      'reproductive_state': reproductiveState,
      'confidence': confidence,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAnimalHistory(String animalId) async {
    final db = await _db.database;

    return await db.query(
      'diagnoses',
      where: 'animal_id = ?',
      whereArgs: [animalId],
      orderBy: 'created_at DESC',
    );
  }
}
