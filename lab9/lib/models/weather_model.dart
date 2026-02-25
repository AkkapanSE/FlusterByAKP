class WeatherModel {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final int weatherCode;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // Open-Meteo current weather format might be inside 'current' or 'current_weather'
    final current = json['current'] ?? json['current_weather'] ?? {};
    
    return WeatherModel(
      temperature: _parseDouble(current['temperature_2m'] ?? current['temperature']),
      humidity: _parseDouble(current['relative_humidity_2m'] ?? current['relative_humidity'] ?? 0),
      windSpeed: _parseDouble(current['wind_speed_10m'] ?? current['windspeed']),
      weatherCode: _parseInt(current['weather_code'] ?? current['weathercode']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
