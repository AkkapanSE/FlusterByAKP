import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_api_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherApiService _apiService = WeatherApiService();
  
  WeatherModel? _weather;
  bool _isLoading = false;
  String _error = '';

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Default to Bangkok Coordinates
  final double defaultLat = 13.7563;
  final double defaultLng = 100.5018;

  WeatherProvider() {
    _fetchWeather();
  }

  Future<void> fetchWeatherForLocation(double lat, double lng) async {
    _isLoading = true;
    _error = '';
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

  Future<void> refreshWeather() async {
    return fetchWeatherForLocation(defaultLat, defaultLng);
  }

  Future<void> _fetchWeather() async {
    await fetchWeatherForLocation(defaultLat, defaultLng);
  }
}
