import 'package:intl/intl.dart';
import '../../domain/entities/forecast_entity.dart';

class ForecastModel extends ForecastEntity {
  const ForecastModel({
    required super.dayName,
    required super.date,
    required super.condition,
    required super.iconCode,
    required super.minTemp,
    required super.maxTemp,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final dateTime = DateTime.parse(json['dt_txt']);
    return ForecastModel(
      dayName: DateFormat('EEEE', 'ar').format(dateTime),
      date: dateTime,
      condition: json['weather'] != null && json['weather'].isNotEmpty
          ? json['weather'][0]['description'] ?? ''
          : '',
      iconCode: json['weather'] != null && json['weather'].isNotEmpty
          ? json['weather'][0]['icon'] ?? ''
          : '',
      minTemp: (json['main']['temp_min'] as num).toDouble(),
      maxTemp: (json['main']['temp_max'] as num).toDouble(),
    );
  }
}