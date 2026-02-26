class EventModel {
  final int? id;
  final String title;
  final String? description;
  final int categoryId;
  final String eventDate; // รูปแบบ YYYY-MM-DD [cite: 218]
  final String startTime; // รูปแบบ HH:mm [cite: 219]
  final String endTime;   // รูปแบบ HH:mm [cite: 221]
  final String status;    // pending, in_progress, completed, cancelled [cite: 222]
  final int priority;     // ระดับ 1-3 [cite: 224]

  EventModel({
    this.id,
    required this.title,
    this.description,
    required this.categoryId,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    this.status = 'pending',
    this.priority = 2,
  });

  // แปลง Object เป็น Map เพื่อเก็บใน SQLite [cite: 24, 25]
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category_id': categoryId,
      'event_date': eventDate,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'priority': priority,
    };
  }

  // แปลง Map จาก SQLite กลับมาเป็น Object [cite: 28, 29]
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      categoryId: map['category_id'],
      eventDate: map['event_date'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      status: map['status'],
      priority: map['priority'],
    );
  }
}