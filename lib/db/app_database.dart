import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wildlife_health.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    /// USERS TABLE
    await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE,
      password TEXT,
      role TEXT,
      full_name TEXT,
      created_at TEXT
    )
    ''');

    /// ANIMALS TABLE
    await db.execute('''
    CREATE TABLE animals(
      id TEXT PRIMARY KEY,
      name TEXT,
      species TEXT,
      category TEXT,
      sex TEXT,
      age INTEGER,
      created_at TEXT
    )
    ''');

    /// DIAGNOSIS TABLE
    await db.execute('''
    CREATE TABLE diagnosis(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      animal_id TEXT,
      health_state TEXT,
      reproductive_state TEXT,
      created_at TEXT
    )
    ''');
  }
}
