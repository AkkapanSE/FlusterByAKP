import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  bool isLoading = false;
  String? error; // เพิ่มตัวแปร error เพื่อรองรับการแสดงผลในหน้า UI

  Future<void> loadProducts() async {
    isLoading = true;
    error = null; // รีเซ็ต error ก่อนเริ่มโหลดใหม่
    notifyListeners();
    
    try {
      final res = await http.get(Uri.parse('https://fakestoreapi.com/products')); 
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        products = data.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        error = "ไม่สามารถโหลดข้อมูลได้ (Status: ${res.statusCode})";
      }
    } catch (e) {
      error = "เกิดข้อผิดพลาด: ${e.toString()}";
      debugPrint(e.toString());
    }
    
    isLoading = false;
    notifyListeners();
  }
}