import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/weather_entity.dart';
import '../entities/forecast_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getCurrentWeatherByCity(String cityName);
  Future<Either<Failure, WeatherEntity>> getCurrentWeatherByLocation(double lat, double lon);
  Future<Either<Failure, List<ForecastEntity>>> getWeeklyForecast(String cityName);
}