import 'package:flutter/material.dart';
import '../../data/db/db_helper.dart';

class EventProvider with ChangeNotifier {
  final dbHelper = DBHelper();
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _categories = [];

  List<Map<String, dynamic>> get events => _events;
  List<Map<String, dynamic>> get categories => _categories;

  // ดึงข้อมูลทั้งหมดจาก SQLite [cite: 73]
  Future<void> fetchAllData() async {
    _categories = await dbHelper.getCategories();
    _events = await dbHelper.getEvents();
    notifyListeners(); // แจ้งเตือน UI ให้วาดใหม่ [cite: 76]
  }

  // เพิ่มกิจกรรมใหม่และรีเฟรชหน้าจอ [cite: 78, 80]
  Future<void> addEvent(Map<String, dynamic> eventData) async {
    await dbHelper.insertEvent(eventData);
    await fetchAllData();
  }

  Future<void> updateStatus(int id, String newStatus) async {
  await dbHelper.updateEventStatus(id, newStatus); // เรียกใช้ฟังก์ชันที่เราแก้ใน DBHelper ไว้ก่อนหน้านี้
  await fetchAllData(); // โหลดข้อมูลใหม่เพื่อให้หน้า Home อัปเดตสถานะทันที
}

}