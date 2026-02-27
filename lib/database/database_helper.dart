import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('job_portal.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, filePath);

    return await openDatabase(
      dbPath,
      version: 1,   // 🔥 Increase when schema changes
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE staff(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT,
        username TEXT UNIQUE,
        password_hash TEXT,
        role TEXT,
        is_active INTEGER,
        created_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE jobseekers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT,
        phone_number TEXT UNIQUE,
        skills TEXT,
        education TEXT,
        gender TEXT,
        experience_years INTEGER,
        is_synced INTEGER DEFAULT 0,
        created_at INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          "ALTER TABLE jobseekers ADD COLUMN is_synced INTEGER DEFAULT 0");
    }
  }

Future<void> insertApplicant(
  String fullText,
  String phone,
  String email,
  String imagePath,
) async {
  final db = await database;

  await db.insert('applicants', {
    'full_text': fullText,
    'phone': phone,
    'email': email,
    'image_path': imagePath,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  });
}  
}

