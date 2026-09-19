class ApiEndpoints {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey =
      'f959553ecca04254fe4d7eb625792eca'; // استبدله بمفتاح OpenWeatherMap الخاص بك

  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';

  static String weatherIcon(String iconCode) =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
