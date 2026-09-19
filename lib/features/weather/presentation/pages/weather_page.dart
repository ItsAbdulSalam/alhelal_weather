import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/weather_cubit.dart';
import '../cubit/weather_state.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/weekly_forecast_list.dart';
import '../widgets/weather_shimmer_loading.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherCubit>().loadInitialWeather();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      FocusScope.of(context).unfocus();
      context.read<WeatherCubit>().fetchWeather(query);
    }
  }

  List<Color> _getWeatherGradient(String? condition) {
    final cond = condition?.toLowerCase() ?? '';
    if (cond.contains('rain') ||
        cond.contains('مطر') ||
        cond.contains('drizzle')) {
      return [
        const Color(0xFF2C3E50),
        const Color(0xFF3498DB),
        const Color(0xFF2980B9),
      ];
    } else if (cond.contains('cloud') ||
        cond.contains('غائم') ||
        cond.contains('غيوم')) {
      return [
        const Color(0xFF37474F),
        const Color(0xFF546E7A),
        const Color(0xFF78909C),
      ];
    } else if (cond.contains('night') || cond.contains('ليل')) {
      return [
        const Color(0xFF0F2027),
        const Color(0xFF203A43),
        const Color(0xFF2C5364),
      ];
    }
    return [
      const Color(0xFF1E3C72),
      const Color(0xFF2A5298),
      const Color(0xFF4A90E2),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        String? currentCondition;
        if (state is WeatherLoadedState) {
          currentCondition = state.weather.condition;
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _getWeatherGradient(currentCondition),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      color: Color(0xFFFFD54F),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 19),
                      children: [
                        TextSpan(
                          text: 'Alhelal ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        TextSpan(
                          text: 'Weather',
                          style: TextStyle(
                            color: Color(0xFF90CAF9),
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // شريط البحث بتصميم زجاجي
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'ابحث عن اسم المدينة...',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Colors.white70,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                            onPressed: _onSearch,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (_) => _onSearch(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // محتوى الشاشة التفاعلي
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (state is WeatherLoadingState) {
                            return const WeatherShimmerLoading();
                          } else if (state is WeatherLoadedState) {
                            return RefreshIndicator(
                              color: Colors.blueAccent,
                              backgroundColor: Colors.white,
                              onRefresh: () async {
                                context.read<WeatherCubit>().fetchWeather(
                                  state.weather.cityName,
                                );
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    CurrentWeatherCard(weather: state.weather),
                                    const SizedBox(height: 20),
                                    WeeklyForecastList(
                                      forecastList: state.forecast,
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            );
                          } else if (state is WeatherErrorState) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.cloud_off_rounded,
                                      color: Colors.white70,
                                      size: 54,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      state.message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.blue.shade900,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        context
                                            .read<WeatherCubit>()
                                            .fetchWeather('Istanbul');
                                      },
                                      icon: const Icon(Icons.refresh_rounded),
                                      label: const Text('إعادة المحاولة'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const Center(
                            child: Text(
                              'ابحث عن مدينة لعرض حالة الطقس',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
