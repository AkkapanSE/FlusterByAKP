import 'package:flutter/material.dart';

import 'home_page.dart';
import 'pages/communication_page.dart';
import 'pages/containment_page.dart';
import 'pages/navigation_page.dart';
import 'pages/selection_page.dart';
import 'pages/textinput_page.dart';

void main() {
  runApp(const AppStarter());
}

class AppStarter extends StatelessWidget {
  const AppStarter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Material Widgets Lab",
      debugShowCheckedModeBanner: false,

      /// ใช้ Material2 เพื่อความเสถียรของ Snackbar
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 3,
        ),
      ),

      initialRoute: "/",

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(builder: (_) => const MyHomePage());
          case "/communication":
            return MaterialPageRoute(builder: (_) => const MyCommunicationPage());
          case "/containment":
            return MaterialPageRoute(builder: (_) => const MyContainmentPage());
          case "/navigation":
            return MaterialPageRoute(builder: (_) => const MyNavigationPage());
          case "/selection":
            return MaterialPageRoute(builder: (_) => const MySelectionPage());
          case "/textinput":
            return MaterialPageRoute(builder: (_) => const MyTextInputPage());

          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text("Not Found")),
                body: const Center(child: Text("Page not found")),
              ),
            );
        }
      },
    );
  }
}