import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_api_service.dart';

class UserProvider extends ChangeNotifier {
  final UserApiService _api = UserApiService();
  
  List<UserModel> users = [];
  bool isLoading = false;
  String? error;

  // เพิ่มตัวแปรสำหรับสถานะการ Login
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // ==========================================
  // 1. ฟังก์ชัน Login (หัวใจหลักที่ขาดไป)
  // ==========================================
  Future<bool> login(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // จำลองการเรียก API (ถ้าใช้ FakeStore API จริงต้องยิง POST ไปที่ /auth/login)
      await Future.delayed(const Duration(seconds: 2)); 

      // เงื่อนไขทดสอบ: ถ้ากรอก username และ password (อะไรก็ได้ที่ไม่ว่าง) ให้ผ่าน
      if (username.isNotEmpty && password.isNotEmpty) {
        _isAuthenticated = true;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = "กรุณากรอก Username และ Password";
        _isAuthenticated = false;
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = "เกิดข้อผิดพลาด: ${e.toString()}";
      _isAuthenticated = false;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ฟังก์ชัน Logout
  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  // ==========================================
  // 2. ฟังก์ชันจัดการข้อมูล Users (CRUD)
  // ==========================================

  // ดึงข้อมูล Users ทั้งหมด
  Future<void> loadUsers() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      users = await _api.fetchUsers();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // เพิ่ม User ใหม่
  Future<void> addUser(UserModel newUser) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      final newId = users.isEmpty 
          ? 1 
          : (users.map((u) => u.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);

      final created = UserModel(
        id: newId,
        email: newUser.email,
        username: newUser.username,
        password: newUser.password,
        name: newUser.name,
        address: newUser.address,
        phone: newUser.phone,
      );

      users.insert(0, created);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // แก้ไขข้อมูล User
  Future<void> editUser(int id, UserModel updatedUser) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      final index = users.indexWhere((u) => u.id == id);
      
      if (index != -1) {
        users[index] = UserModel(
          id: id,
          email: updatedUser.email,
          username: updatedUser.username,
          password: updatedUser.password,
          name: updatedUser.name,
          address: updatedUser.address,
          phone: updatedUser.phone,
        );
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // ลบข้อมูล User
  Future<void> removeUser(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _api.deleteUser(id);
      users.removeWhere((u) => u.id == id);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}