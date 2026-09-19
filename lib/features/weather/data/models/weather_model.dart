import '../../domain/entities/weather_entity.dart';


class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.cityName,
    required super.country,
    required super.temperature,
    required super.minTemp,
    required super.maxTemp,
    required super.condition,
    required super.iconCode,
    required super.humidity,
    required super.pressure,
    required super.windSpeed,
    required super.visibility,
    required super.dateTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      country: json['sys']?['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      minTemp: (json['main']['temp_min'] as num).toDouble(),
      maxTemp: (json['main']['temp_max'] as num).toDouble(),
      condition: json['weather'] != null && json['weather'].isNotEmpty
          ? json['weather'][0]['description'] ?? ''
          : '',
      iconCode: json['weather'] != null && json['weather'].isNotEmpty
          ? json['weather'][0]['icon'] ?? ''
          : '',
      humidity: json['main']['humidity'] ?? 0,
      pressure: json['main']['pressure'] ?? 0,
      windSpeed: (json['wind']?['speed'] as num?)?.toDouble() ?? 0.0,
      visibility: ((json['visibility'] as num?)?.toDouble() ?? 0.0) / 1000.0, // تحويل إلى كم
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {'country': country},
      'main': {
        'temp': temperature,
        'temp_min': minTemp,
        'temp_max': maxTemp,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': [
        {'description': condition, 'icon': iconCode}
      ],
      'wind': {'speed': windSpeed},
      'visibility': visibility * 1000,
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
    };
  }
}