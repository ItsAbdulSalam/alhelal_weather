import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository repository;

  GetCurrentWeatherUseCase(this.repository);

  Future<Either<Failure, WeatherEntity>> call(String cityName) async {
    return await repository.getCurrentWeatherByCity(cityName);
  }
}