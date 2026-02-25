import 'package:flutter/material.dart';

class MyTextInputPage extends StatefulWidget {
  const MyTextInputPage({super.key});

  @override
  State<MyTextInputPage> createState() => _MyTextInputPageState();
}

class _MyTextInputPageState extends State<MyTextInputPage> {
  final textCtrl = TextEditingController();
  String output = "";

  @override
  void dispose() {
    textCtrl.dispose(); // ป้องกัน memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Example")),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// -------- กล่องกรอกข้อความ ----------
          TextField(
            controller: textCtrl,
            decoration: InputDecoration(
              labelText: "Type something",
              filled: true,
              prefixIcon: const Icon(Icons.edit),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  textCtrl.clear();
                  setState(() => output = "");
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// -------- ปุ่มกด ----------
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              setState(() => output = textCtrl.text);
            },
            child: const Text("Show Output"),
          ),

          const SizedBox(height: 20),

          /// -------- แสดงผลลัพธ์ ----------
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                output.isEmpty ? "No Input" : "Your Input: $output",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}