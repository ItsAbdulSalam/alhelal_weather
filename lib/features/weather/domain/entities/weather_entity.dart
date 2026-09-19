import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String cityName;
  final String country;
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final String condition;
  final String iconCode;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final double visibility;
  final DateTime dateTime;

  const WeatherEntity({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
    required this.iconCode,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.visibility,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
        cityName,
        country,
        temperature,
        minTemp,
        maxTemp,
        condition,
        iconCode,
        humidity,
        pressure,
        windSpeed,
        visibility,
        dateTime,
      ];
}