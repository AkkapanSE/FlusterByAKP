import 'package:flutter/material.dart';

class MyContainmentPage extends StatelessWidget {
  const MyContainmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Containment Example")),

      body: Center(
        child: Card(
          elevation: 4, // รองรับ Flutter ทุกเวอร์ชัน
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          child: InkWell(
            onTap: () {
              final messenger = ScaffoldMessenger.of(context);
              messenger.hideCurrentSnackBar();
              messenger.showSnackBar(
                const SnackBar(
                  content: Text("Card clicked!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },

            // InkWell ต้องครอบ Material หรือ Container (ได้)
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(20),

              // Decoration รองรับแน่นอนในเวอร์ชันเก่า
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD), // แทน Colors.blue.shade50 เพื่อรองรับเวอร์ชันเก่า
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.widgets, size: 40, color: Colors.blue),
                  SizedBox(height: 10),
                  Text(
                    "Container with Decoration",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}