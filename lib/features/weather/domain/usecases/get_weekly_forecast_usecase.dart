import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/forecast_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeeklyForecastUseCase {
  final WeatherRepository repository;

  GetWeeklyForecastUseCase(this.repository);

  Future<Either<Failure, List<ForecastEntity>>> call(String cityName) async {
    return await repository.getWeeklyForecast(cityName);
  }
}