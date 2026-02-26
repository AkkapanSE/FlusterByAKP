import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  initDB() async {
    // กำหนดพาธของฐานข้อมูลในเครื่อง [cite: 45]
    String path = join(await getDatabasesPath(), 'event_reminder.db');
    
    return await openDatabase(
      path, 
      version: 1, 
      onCreate: (db, version) async {
        // สร้างตารางประเภทกิจกรรม (Categories) [cite: 133, 205]
        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            color_hex TEXT,
            icon_key TEXT
          )
        ''');

        // สร้างตารางกิจกรรม (Events) [cite: 141, 212]
        await db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            category_id INTEGER,
            event_date TEXT,
            start_time TEXT,
            end_time TEXT,
            status TEXT,
            priority INTEGER,
            FOREIGN KEY (category_id) REFERENCES categories (id)
          )
        ''');

        // เพิ่มข้อมูลประเภทกิจกรรมเริ่มต้น 3 ประเภท ตาม Checklist 
        await _seedCategories(db);
      }
    );
  }

  // ฟังก์ชันเพิ่มข้อมูลเริ่มต้น (Seed Data) 
  Future<void> _seedCategories(Database db) async {
    final List<Map<String, dynamic>> initialCategories = [
      {'name': 'ประชุม', 'color_hex': '#FF5733', 'icon_key': 'groups'},
      {'name': 'อบรม', 'color_hex': '#33FF57', 'icon_key': 'school'},
      {'name': 'งานเอกสาร', 'color_hex': '#3357FF', 'icon_key': 'description'},
    ];

    for (var cat in initialCategories) {
      await db.insert('categories', cat);
    }
  }

  // --- ฟังก์ชันจัดการข้อมูล (CRUD) ---

  // 1. ดึงประเภทกิจกรรมทั้งหมด [cite: 53]
  Future<List<Map<String, dynamic>>> getCategories() async {
    final dbClient = await db;
    return await dbClient.query('categories');
  }

  // 2. ดึงกิจกรรมทั้งหมด พร้อมข้อมูลชื่อและสีของประเภทกิจกรรม (Join Table) [cite: 53, 178]
  Future<List<Map<String, dynamic>>> getEvents() async {
    final dbClient = await db;
    return await dbClient.rawQuery('''
      SELECT events.*, categories.name as category_name, categories.color_hex
      FROM events
      LEFT JOIN categories ON events.category_id = categories.id
      ORDER BY event_date ASC, start_time ASC
    ''');
  }

  // 3. เพิ่มกิจกรรมใหม่ [cite: 59, 61]
  Future<int> insertEvent(Map<String, dynamic> row) async {
    final dbClient = await db;
    return await dbClient.insert('events', row);
  }

  // 4. แก้ไขสถานะกิจกรรม [cite: 161, 195]
  Future<int> updateEventStatus(int id, String status) async {
    final dbClient = await db;
    return await dbClient.update(
      'events', 
      {'status': status}, 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  // 5. ลบกิจกรรม [cite: 141]
  Future<int> deleteEvent(int id) async {
    final dbClient = await db;
    return await dbClient.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}