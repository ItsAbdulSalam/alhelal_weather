import 'package:equatable/equatable.dart';

class ForecastEntity extends Equatable {
  final String dayName;
  final DateTime date;
  final String condition;
  final String iconCode;
  final double minTemp;
  final double maxTemp;

  const ForecastEntity({
    required this.dayName,
    required this.date,
    required this.condition,
    required this.iconCode,
    required this.minTemp,
    required this.maxTemp,
  });

  @override
  List<Object?> get props => [
        dayName,
        date,
        condition,
        iconCode,
        minTemp,
        maxTemp,
      ];
}