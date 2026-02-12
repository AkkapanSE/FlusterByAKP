import 'package:flutter/material.dart';

class MySelectionPage extends StatefulWidget {
  const MySelectionPage({super.key});

  @override
  State<MySelectionPage> createState() => _MySelectionPageState();
}

class _MySelectionPageState extends State<MySelectionPage> {
  bool agree = false;
  bool notify = true;
  String choice = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selection Widgets")),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// Section: Checkbox
          Row(
            children: [
              Checkbox(
                value: agree,
                onChanged: (v) => setState(() => agree = v ?? false),
              ),
              const Text("Agree Terms"),
            ],
          ),

          const Divider(height: 30),

          /// Section: Switch
          SwitchListTile(
            title: const Text("Notifications"),
            value: notify,
            onChanged: (v) => setState(() => notify = v),
          ),

          const Divider(height: 30),

          /// Section: Radio buttons
          const Text(
            "Select Gender:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          RadioListTile(
            title: const Text("Male"),
            value: "Male",
            groupValue: choice,
            onChanged: (v) => setState(() => choice = v ?? "Male"),
          ),

          RadioListTile(
            title: const Text("Female"),
            value: "Female",
            groupValue: choice,
            onChanged: (v) => setState(() => choice = v ?? "Female"),
          ),
        ],
      ),
    );
  }
}