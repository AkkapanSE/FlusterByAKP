import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ต้อง import provider
import '../providers/user_provider.dart';
import 'product_list_screen.dart'; // เปลี่ยนไปหน้าสินค้าตาม flow ปกติ

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ใส่ค่าเริ่มต้นไว้ให้ทดสอบง่ายๆ เหมือนเดิมครับ
  final _userCtrl = TextEditingController(text: 'mor_2314');
  final _passCtrl = TextEditingController(text: '83r5^_');

  void _handleLogin() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // 1. ใช้ .trim() เพื่อตัดช่องว่างที่อาจหลุดมา
    final username = _userCtrl.text.trim();
    final password = _passCtrl.text.trim();

    // 2. เรียกใช้ Login ผ่าน Provider (ไม่ต้องจัดการ _isLoading เองที่นี่)
    final success = await userProvider.login(username, password);

    if (success && mounted) {
      // 3. ถ้าสำเร็จ ย้ายหน้าไป Product List
      Navigator.pushReplacementNamed(context, '/product_list');
    } else if (mounted) {
      // 4. ถ้าพลาด แสดง SnackBar แจ้งเตือน
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.error ?? 'เข้าสู่ระบบไม่สำเร็จ!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ใช้ Consumer เพื่อฟังสถานะ isLoading จาก Provider
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_person, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  "FakeStore System", 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 30),
                
                TextField(
                  controller: _userCtrl, 
                  enabled: !userProvider.isLoading, // ปิดการพิมพ์ขณะโหลด
                  decoration: const InputDecoration(
                    labelText: 'Username', 
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),
                
                TextField(
                  controller: _passCtrl, 
                  obscureText: true, 
                  enabled: !userProvider.isLoading, // ปิดการพิมพ์ขณะโหลด
                  decoration: const InputDecoration(
                    labelText: 'Password', 
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key),
                  ),
                ),
                const SizedBox(height: 25),

                // ส่วนของปุ่มที่เช็คสถานะ Loading
                SizedBox(
                  width: double.infinity, 
                  height: 50,
                  child: ElevatedButton(
                    onPressed: userProvider.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: userProvider.isLoading 
                      ? const SizedBox(
                          width: 24, 
                          height: 24, 
                          child: CircularProgressIndicator(
                            color: Colors.white, 
                            strokeWidth: 2
                          ),
                        ) 
                      : const Text("LOGIN", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}