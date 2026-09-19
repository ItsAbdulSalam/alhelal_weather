import '../../../../core/networks/api_endpoints.dart';
import '../../../../core/networks/api_service.dart';
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeatherByCity(String cityName);
  Future<WeatherModel> getCurrentWeatherByLocation(double lat, double lon);
  Future<List<ForecastModel>> getWeeklyForecast(String cityName);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiService apiService;

  WeatherRemoteDataSourceImpl({required this.apiService});

  @override
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final response = await apiService.get(
      endpoint: ApiEndpoints.currentWeather,
      queryParameters: {'q': cityName},
    );
    return WeatherModel.fromJson(response);
  }

  @override
  Future<WeatherModel> getCurrentWeatherByLocation(double lat, double lon) async {
    final response = await apiService.get(
      endpoint: ApiEndpoints.currentWeather,
      queryParameters: {'lat': lat, 'lon': lon},
    );
    return WeatherModel.fromJson(response);
  }

  @override
  Future<List<ForecastModel>> getWeeklyForecast(String cityName) async {
    final response = await apiService.get(
      endpoint: ApiEndpoints.forecast,
      queryParameters: {'q': cityName},
    );

    final List list = response['list'] ?? [];
    // أخذ قراءة واحدة لكل يوم عند الساعة 12:00 ظهراً
    final dailyForecasts = list
        .where((item) => item['dt_txt'].toString().contains('12:00:00'))
        .map((item) => ForecastModel.fromJson(item))
        .toList();

    return dailyForecasts;
  }
}