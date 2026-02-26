import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/event_provider.dart';

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event['title'])),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("รายละเอียด: ${event['description'] ?? '-'}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("วันที่: ${event['event_date']}"), 
            Text("เวลา: ${event['start_time']} - ${event['end_time']}"), 
            const Divider(height: 40),
            const Text("เปลี่ยนสถานะกิจกรรม:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // ปุ่มเปลี่ยนสถานะตามโจทย์ Lab 11 (Pending, In Progress, Completed, Cancelled)
            Wrap(
              spacing: 10,
              children: ['pending', 'in_progress', 'completed', 'cancelled'].map((status) {
                return ElevatedButton(
                  onPressed: () async {
                    // เรียกใช้ฟังก์ชันอัปเดตใน Provider
                    await context.read<EventProvider>().updateStatus(event['id'], status);
                    Navigator.pop(context); // กลับหน้าหลัก
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: event['status'] == status ? Colors.blue.shade200 : null,
                  ),
                  child: Text(status.toUpperCase()),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}