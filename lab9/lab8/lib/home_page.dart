import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Material Lab"),
        elevation: 2,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          buildMenu(context, Icons.chat, "Communication", "/communication"),
          buildMenu(context, Icons.dashboard, "Containment", "/containment"),
          buildMenu(context, Icons.route, "Navigation", "/navigation"),
          buildMenu(context, Icons.check_circle, "Selection", "/selection"),
          buildMenu(context, Icons.text_fields, "Text Input", "/textinput"),
        ],
      ),
    );
  }

  Widget buildMenu(
    BuildContext ctx,
    IconData icon,
    String title,
    String route,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 3,                          // Flutter เวอร์ชันเก่ารองรับ
        child: ListTile(
          leading: Icon(icon, color: Colors.indigo),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => Navigator.pushNamed(ctx, route),
        ),
      ),
    );
  }
}