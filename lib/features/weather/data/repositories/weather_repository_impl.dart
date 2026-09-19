import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/forecast_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_data_source.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeatherByCity(String cityName) async {
    try {
      final remoteWeather = await remoteDataSource.getCurrentWeatherByCity(cityName);
      // حفظ المدينة والبيانات في الكاش
      await localDataSource.cacheLastWeather(remoteWeather);
      await localDataSource.saveLastCityName(cityName);
      return Right(remoteWeather);
    } on ServerException catch (e) {
      // في حال فشل الاتصال، نحاول جلب آخر كاش محفوظ
      try {
        final localWeather = await localDataSource.getLastCachedWeather();
        return Right(localWeather);
      } catch (_) {
        return Left(ServerFailure(e.message ?? 'فشل الاتصال بالخادم'));
      }
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeatherByLocation(double lat, double lon) async {
    try {
      final remoteWeather = await remoteDataSource.getCurrentWeatherByLocation(lat, lon);
      await localDataSource.cacheLastWeather(remoteWeather);
      await localDataSource.saveLastCityName(remoteWeather.cityName);
      return Right(remoteWeather);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'فشل الاتصال بالخادم'));
    } catch (e) {
      return Left(LocationFailure('حدث خطأ أثناء جلب الطقس حسب الموقع'));
    }
  }

  @override
  Future<Either<Failure, List<ForecastEntity>>> getWeeklyForecast(String cityName) async {
    try {
      final remoteForecast = await remoteDataSource.getWeeklyForecast(cityName);
      return Right(remoteForecast);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'فشل جلب التوقعات الأسبوعية'));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ أثناء جلب التوقعات: $e'));
    }
  }
}