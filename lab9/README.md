# นาย เอกพันธ์ ทศทิศรังสรรค์ 67543210050-0 sec2
# Lab 9: Weather App Integration with Web API

แอปพลิเคชันพยากรณ์อากาศที่พัฒนาผ่าน Flutter โดยทำงานร่วมกับ Open-Meteo API เพื่อแสดงผลสภาพอากาศปัจจุบัน (อุณหภูมิ, ความชื้น, ลม, และสภาพอากาศ) 
แอปพลิเคชันถูกออกแบบด้วย Dynamic UI และองค์ประกอบสไตล์ Glassmorphism ให้ความรู้สึกพรีเมียมและตอบสนองการทำงานของผู้ใช้ได้ครบถ้วน

---

## 📷 Screenshots (ภาพหน้าจอ)

---

## 🛠 คำอธิบายส่วนสำคัญของโค้ดที่ทำงานกับ Web API
ในโปรเจ็กต์นี้ เราใช้เทคนิคการแยกโครงสร้าง Data Layer, Service Layer, และ State Management ออกจากกันดังนี้:

### 1. Model (`lib/models/weather_model.dart`)
ทำหน้าที่แปลงข้อมูล JSON ที่ได้รับจาก Open-Meteo API ให้เป็น Dart Object 

```dart
factory WeatherModel.fromJson(Map<String, dynamic> json) {
  final current = json['current'] ?? json['current_weather'] ?? {};
  return WeatherModel(
    temperature: _parseDouble(current['temperature_2m']),
    humidity: _parseDouble(current['relative_humidity_2m']),
    windSpeed: _parseDouble(current['wind_speed_10m']),
    weatherCode: _parseInt(current['weather_code']),
  );
}
```

### 2. Service (`lib/services/weather_api_service.dart`)
คลาสที่ทำหน้าที่ยิง Request HTTP ไปหา Web API 

```dart
Future<WeatherModel> fetchCurrentWeather(double latitude, double longitude) async {
  final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return WeatherModel.fromJson(data);
  } else {
    throw Exception('Failed to load weather data');
  }
}
```

### 3. State Management (`lib/providers/weather_provider.dart`)
ทำหน้าที่จัดการ state ของการโหลดข้อมูลว่า กำลังโหลด (Loading), สำเร็จ (Success), หรือ ล้มเหลว (Error) และส่งข้อมูลไปยัง UI ตามหลัก Provider
```dart
Future<void> fetchWeatherForLocation(double lat, double lng) async {
  _isLoading = true;
  notifyListeners();
  try {
    _weather = await _apiService.fetchCurrentWeather(lat, lng);
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

---

## 🚀 วิธีการรันโปรเจ็กต์

1. Clone Repository นี้ลงเครื่องของคุณ
2. รันคำสั่งเพิ่ม dependencies เบื้องต้นใน Terminal:
   ```bash
   flutter pub get
   ```
3. รันแอปพลิเคชัน
   ```bash
   flutter run
   ```

*(เมื่อนำไปนำเสนอ อย่าลืมเตรียมโปรเจ็กต์ Lab 8 Navigation and routing ไว้ด้วยนะครับ)*
