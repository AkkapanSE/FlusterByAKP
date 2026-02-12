import 'package:flutter/material.dart';

class MyCommunicationPage extends StatelessWidget {
  const MyCommunicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Communication Widgets")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// 🔥 Snackbar แบบแก้บัค — ปิดทับ M3, เปิด M2 เต็มรูปแบบ
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications),
              label: const Text("Show Snackbar"),
              onPressed: () {
                final messenger = ScaffoldMessenger.of(context);

                /// เคลียร์ของเก่าก่อน
                messenger.hideCurrentSnackBar();

                messenger.showSnackBar(
                  SnackBar(
                    content: const Text("This is a custom Snackbar!"),
                    duration: const Duration(seconds: 3),

                    /// ⭐ ทำให้ Snackbar เป็นแบบ M2 (ไม่ใช่ M3)
                    behavior: SnackBarBehavior.floating,

                    /// ⭐ ทำให้เลื่อนซ้าย-ขวาเพื่อปิดได้ (M2 style)
                    dismissDirection: DismissDirection.horizontal,

                    /// ⭐ Action แบบไม่บัค
                    action: SnackBarAction(
                      label: "Close",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// Dialog
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Information"),
                    content: const Text("This is a custom dialog window."),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                );
              },
              child: const Text("Open Dialog"),
            ),
          ],
        ),
      ),
    );
  }
}