import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/weather_local_data_source.dart';
import '../../domain/usecases/get_current_weather_usecase.dart';
import '../../domain/usecases/get_weekly_forecast_usecase.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  final GetWeeklyForecastUseCase getWeeklyForecastUseCase;
  final WeatherLocalDataSource localDataSource;

  WeatherCubit({
    required this.getCurrentWeatherUseCase,
    required this.getWeeklyForecastUseCase,
    required this.localDataSource,
  }) : super(WeatherInitialState());

  Future<void> loadInitialWeather() async {
    final lastCity = await localDataSource.getLastCityName();
    fetchWeather(lastCity ?? 'Istanbul');
  }

  Future<void> fetchWeather(String cityName) async {
    if (cityName.trim().isEmpty) {
      emit(WeatherEmptyState());
      return;
    }

    emit(WeatherLoadingState());

    final weatherResult = await getCurrentWeatherUseCase(cityName);

    await weatherResult.fold(
      (failure) async => emit(WeatherErrorState(failure.message)),
      (weather) async {
        final forecastResult = await getWeeklyForecastUseCase(cityName);
        forecastResult.fold(
          (_) => emit(WeatherLoadedState(weather: weather, forecast: const [])),
          (forecast) => emit(WeatherLoadedState(weather: weather, forecast: forecast)),
        );
      },
    );
  }
}