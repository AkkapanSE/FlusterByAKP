import 'package:flutter/material.dart';

class MyNavigationPage extends StatelessWidget {
  const MyNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Navigation Demo")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// 1) Navigation แบบ push
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MySecondPage()),
                );
              },
              child: const Text("Go to Second Page (push)"),
            ),

            const SizedBox(height: 20),

            /// 2) Navigation แบบ pushNamed
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/textinput");
              },
              child: const Text("Go to TextInput Page (pushNamed)"),
            ),

            const SizedBox(height: 20),

            /// 3) ส่งข้อมูล + รับผลลัพธ์กลับ
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyResultPage(
                      message: "Hello from Navigation Page!",
                    ),
                  ),
                );

                if (result != null) {
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.hideCurrentSnackBar();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text("Returned: $result"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text("Send & Receive Data"),
            ),
          ],
        ),
      ),
    );
  }
}


/// ---------- หน้าที่ 2 ----------
class MySecondPage extends StatelessWidget {
  const MySecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // แก้ .shade100 → ใช้ค่าสีคงที่ เพื่อรองรับเวอร์ชันเก่า
      backgroundColor: const Color(0xFFBBDEFB),

      appBar: AppBar(title: const Text("Second Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Back to First Page"),
        ),
      ),
    );
  }
}


/// ---------- ส่งข้อมูล ----------
class MyResultPage extends StatelessWidget {
  final String message;
  const MyResultPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receive Data")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              message,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => Navigator.pop(context, "OK! Message received!"),
              child: const Text("Send Back Result"),
            ),
          ],
        ),
      ),
    );
  }
}