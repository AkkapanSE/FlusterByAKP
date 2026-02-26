import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/state/event_provider.dart';
import 'ui/screens/home_screen.dart'; // อย่าลืมสร้างไฟล์นี้ในขั้นตอนถัดไป

void main() {
  runApp(
    MultiProvider(
      providers: [
        // ลงทะเบียน EventProvider ให้คนทั้งแอปใช้ร่วมกัน [cite: 88, 89]
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Reminder Lab11',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // กำหนดหน้าแรกของแอป
      home: const HomeScreen(), 
    );
  }
}