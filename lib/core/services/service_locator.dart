import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../networks/api_service.dart';
import '../../features/weather/data/datasources/weather_local_data_source.dart';
import '../../features/weather/data/datasources/weather_remote_data_source.dart';
import '../../features/weather/data/repositories/weather_repository_impl.dart';
import '../../features/weather/domain/repositories/weather_repository.dart';
import '../../features/weather/domain/usecases/get_current_weather_usecase.dart';
import '../../features/weather/domain/usecases/get_weekly_forecast_usecase.dart';
import '../../features/weather/presentation/cubit/weather_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // 1. External Services
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<Dio>()));

  // 2. Data Sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );
  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // 3. Repositories
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl<WeatherRemoteDataSource>(),
      localDataSource: sl<WeatherLocalDataSource>(),
    ),
  );

  // 4. Use Cases
  sl.registerLazySingleton(() => GetCurrentWeatherUseCase(sl<WeatherRepository>()));
  sl.registerLazySingleton(() => GetWeeklyForecastUseCase(sl<WeatherRepository>()));

  // 5. Cubit
  sl.registerFactory(
    () => WeatherCubit(
      getCurrentWeatherUseCase: sl<GetCurrentWeatherUseCase>(),
      getWeeklyForecastUseCase: sl<GetWeeklyForecastUseCase>(),
      localDataSource: sl<WeatherLocalDataSource>(),
    ),
  );
}