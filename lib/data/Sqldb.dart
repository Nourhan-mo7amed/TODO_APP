import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class Sqldb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
    }
    return _db;
  }

  Future<Database> intialDb() async {
    String path = p.join(await getDatabasesPath(), 'TODO.db');
    return openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE main_tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      dueDate TEXT,
      color TEXT,
      is_favorite INTEGER DEFAULT 0
    )
  ''');

    await db.execute('''
    CREATE TABLE sub_tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id INTEGER,
      content TEXT NOT NULL,
      is_done INTEGER DEFAULT 0,
      FOREIGN KEY (task_id) REFERENCES main_tasks(id) ON DELETE CASCADE
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // if (oldVersion < 4) {
    //   await db.execute(
    //     "ALTER TABLE main_tasks ADD COLUMN is_favorite INTEGER DEFAULT 0",
    //   );
    // }
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'TODO.db');
    await deleteDatabase(path);
    print("✅ Database deleted.");
    _db = null;
  }

  Future<List<Map<String, dynamic>>> getMainTasks() async {
    Database? mydb = await db;
    return await mydb!.query("main_tasks", orderBy: "id DESC");
  }

  Future<int> insertMainTask(
    String title,
    String? dueDate,
    String color,
  ) async {
    Database? mydb = await db;
    return await mydb!.insert("main_tasks", {
      "title": title,
      "dueDate": dueDate,
      "color": color,
      "is_favorite": 0,
    });
  }

  Future<int> deleteMainTask(int id) async {
    Database? mydb = await db;
    await mydb!.delete("sub_tasks", where: "task_id = ?", whereArgs: [id]);
    return await mydb.delete("main_tasks", where: "id = ?", whereArgs: [id]);
  }

  Future<int> toggleFavorite(int taskId, bool isFav) async {
    Database? mydb = await db;
    return await mydb!.update(
      "main_tasks",
      {"is_favorite": isFav ? 1 : 0},
      where: "id = ?",
      whereArgs: [taskId],
    );
  }

  Future<int> updateData(String sql, List<dynamic> arguments) async {
    Database? mydb = await db;
    return await mydb!.rawUpdate(sql, arguments);
  }

  Future<List<Map<String, dynamic>>> getSubTasks(int taskId) async {
    Database? mydb = await db;
    return await mydb!.query(
      "sub_tasks",
      where: "task_id = ?",
      whereArgs: [taskId],
    );
  }

  Future<void> insertSubTask(int taskId, String content) async {
    final dbClient = await db;
    await dbClient?.insert('sub_tasks', {
      'task_id': taskId,
      'content': content,
      'is_done': 0,
    });
  }

  Future<int> updateSubTaskDone(int id, bool isDone) async {
    Database? mydb = await db;
    return await mydb!.update(
      "sub_tasks",
      {"is_done": isDone ? 1 : 0},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteSubTask(int id) async {
    Database? mydb = await db;
    return await mydb!.delete("sub_tasks", where: "id = ?", whereArgs: [id]);
  }
}
