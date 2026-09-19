import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheLastWeather(WeatherModel weather);
  Future<WeatherModel> getLastCachedWeather();
  Future<void> saveLastCityName(String cityName);
  Future<String?> getLastCityName();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  static const String _cachedWeatherKey = 'CACHED_WEATHER_DATA';
  static const String _lastCityKey = 'LAST_SEARCHED_CITY';

  @override
  Future<void> cacheLastWeather(WeatherModel weather) async {
    final jsonString = jsonEncode(weather.toJson());
    await sharedPreferences.setString(_cachedWeatherKey, jsonString);
  }

  @override
  Future<WeatherModel> getLastCachedWeather() async {
    final jsonString = sharedPreferences.getString(_cachedWeatherKey);
    if (jsonString != null) {
      return WeatherModel.fromJson(jsonDecode(jsonString));
    } else {
      throw  ServerException('لا توجد بيانات محفوظة محلياً');
    }
  }

  @override
  Future<void> saveLastCityName(String cityName) async {
    await sharedPreferences.setString(_lastCityKey, cityName);
  }

  @override
  Future<String?> getLastCityName() async {
    return sharedPreferences.getString(_lastCityKey);
  }
}