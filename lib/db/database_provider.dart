import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/note_model.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'bio.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE bio(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            nim TEXT,
            fakultas TEXT,
            prodi TEXT,
            alamat TEXT,
            nomer_hp INTEGER,
            photo TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> addNewNote(NoteModel note) async {
    final db = await database;
    await db.insert("bio", note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NoteModel>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("bio");
    return List.generate(maps.length, (i) => NoteModel.fromMap(maps[i]));
  }
}
