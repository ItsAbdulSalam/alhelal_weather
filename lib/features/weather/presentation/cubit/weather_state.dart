import 'package:equatable/equatable.dart';
import '../../domain/entities/forecast_entity.dart';
import '../../domain/entities/weather_entity.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

// 1. الحالة الابتدائية
class WeatherInitialState extends WeatherState {}

// 2. حالة التحميل
class WeatherLoadingState extends WeatherState {}

// 3. حالة النجاح مع توفر البيانات
class WeatherLoadedState extends WeatherState {
  final WeatherEntity weather;
  final List<ForecastEntity> forecast;

  const WeatherLoadedState({
    required this.weather,
    required this.forecast,
  });

  @override
  List<Object?> get props => [weather, forecast];
}

// 4. حالة لا توجد بيانات (Empty)
class WeatherEmptyState extends WeatherState {}

// 5. حالة الخطأ
class WeatherErrorState extends WeatherState {
  final String message;

  const WeatherErrorState(this.message);

  @override
  List<Object?> get props => [message];
}