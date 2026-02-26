import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/event_provider.dart';
import 'add_event_screen.dart';
import 'event_detail_screen.dart'; // เพิ่มการ Import หน้าจอรายละเอียด [cite: 192, 243]

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลกิจกรรมทั้งหมดจาก SQLite ทันทีที่เปิดหน้าจอ [cite: 73, 101]
    Future.microtask(() => context.read<EventProvider>().fetchAllData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AKP Notes(SQLite)"), 
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<EventProvider>().fetchAllData(), 
          )
        ],
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          if (provider.events.isEmpty) {
            return const Center(
              child: Text("ยังไม่มีกิจกรรมในระบบ\nกดปุ่ม + เพื่อเพิ่มรายการใหม่", textAlign: TextAlign.center)
            );
          }

          return ListView.builder(
            itemCount: provider.events.length, 
            itemBuilder: (context, index) {
              final event = provider.events[index];
              // ดึงค่าสี Hex จากฐานข้อมูลมาแปลงเป็นวัตถุ Color [cite: 138, 209]
              final categoryColor = Color(int.parse(event['color_hex'].replaceFirst('#', '0xff')));

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: categoryColor, // แสดงสีตามประเภทกิจกรรม [cite: 179]
                    child: const Icon(Icons.event, color: Colors.white),
                  ),
                  title: Text(event['title'], style: const TextStyle(fontWeight: FontWeight.bold)), 
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ประเภท: ${event['category_name']}"), 
                      Text("เวลา: ${event['start_time']} - ${event['end_time']}"), 
                    ],
                  ),
                  trailing: Chip(
                    label: Text(event['status'].toString().toUpperCase()), 
                    backgroundColor: _getStatusColor(event['status']), 
                  ),
                  // เพิ่มความสามารถในการกดเพื่อไปดูหนารายละเอียดและเปลี่ยนสถานะ 
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(event: event), 
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()), 
          );
        },
        child: const Icon(Icons.add), 
      ),
    );
  }

  // กำหนดสีของ Chip ตามสถานะกิจกรรม [cite: 155, 186]
  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return Colors.green.shade200; 
      case 'pending': return Colors.orange.shade200; 
      case 'cancelled': return Colors.red.shade200; 
      case 'in_progress': return Colors.blue.shade200; 
      default: return Colors.grey.shade300;
    }
  }
}