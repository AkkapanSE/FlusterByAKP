import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/event_provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  int? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("เพิ่มกิจกรรมใหม่")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ชื่อกิจกรรม (จำเป็น) [cite: 143]
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "ชื่อกิจกรรม *"),
              validator: (value) => value!.isEmpty ? "กรุณากรอกชื่อกิจกรรม" : null,
            ),
            
            // เลือกประเภทกิจกรรม (เชื่อมกับ Category) [cite: 145]
            DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(labelText: "ประเภทกิจกรรม"),
              items: provider.categories.map((cat) {
                return DropdownMenuItem<int>(
                  value: cat['id'],
                  child: Text(cat['name']),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategoryId = val),
              validator: (val) => val == null ? "กรุณาเลือกประเภท" : null,
            ),

            const SizedBox(height: 20),
            
            // ส่วนเลือกเวลา (Start - End) [cite: 147, 149, 150]
            ListTile(
              title: Text("วันที่: ${_selectedDate.toLocal()}".split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),

            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text("เริ่ม: ${_startTime.format(context)}"),
                    onTap: () async {
                      final picked = await showTimePicker(context: context, initialTime: _startTime);
                      if (picked != null) setState(() => _startTime = picked);
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text("สิ้นสุด: ${_endTime.format(context)}"),
                    onTap: () async {
                      final picked = await showTimePicker(context: context, initialTime: _endTime);
                      if (picked != null) setState(() => _endTime = picked);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text("บันทึกกิจกรรม"),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // 1. ตรวจสอบว่ากรอกข้อมูลครบไหม [cite: 191]
    if (!_formKey.currentState!.validate()) return;

    // 2. Validation: ตรวจสอบว่า End Time > Start Time [cite: 151, 248]
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เวลาสิ้นสุดต้องมากกว่าเวลาเริ่ม!")),
      );
      return;
    }

    // 3. บันทึกลง SQLite ผ่าน Provider [cite: 63, 120]
    final newEvent = {
      'title': _titleController.text,
      'description': _descController.text,
      'category_id': _selectedCategoryId,
      'event_date': _selectedDate.toIso8601String().split('T')[0],
      'start_time': _startTime.format(context),
      'end_time': _endTime.format(context),
      'status': 'pending',
      'priority': 2,
    };

    context.read<EventProvider>().addEvent(newEvent);
    Navigator.pop(context); // กลับไปหน้า Home
  }
}