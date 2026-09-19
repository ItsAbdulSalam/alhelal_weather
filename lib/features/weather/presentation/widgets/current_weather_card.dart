import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/weather_entity.dart';
import 'weather_detail_item.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherEntity weather;

  const CurrentWeatherCard({super.key, required this.weather});

  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return Icons.wb_sunny_rounded;
      case '01n':
        return Icons.nightlight_round;
      case '02d':
        return Icons.wb_cloudy_rounded;
      case '02n':
        return Icons.nights_stay_rounded;
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return Icons.cloud_rounded;
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return Icons.water_drop_rounded;
      case '11d':
      case '11n':
        return Icons.flash_on_rounded;
      case '13d':
      case '13n':
        return Icons.ac_unit_rounded;
      case '50d':
      case '50n':
        return Icons.waves_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }

  Color _getIconColor(String iconCode) {
    if (iconCode == '01d' || iconCode == '02d') {
      return const Color(0xFFFFD54F); // شمس ذهبية
    } else if (iconCode == '01n' || iconCode == '02n') {
      return const Color(0xFFFFF59D); // هلال ليلي مضيء
    } else if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
      return const Color(0xFF81D4FA); // مطر أزرق فاتح
    } else if (iconCode.startsWith('11')) {
      return const Color(0xFFFFE082); // برق
    } else if (iconCode.startsWith('13')) {
      return const Color(0xFFE0F7FA); // ثلج
    }
    return Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    final iconData = _getWeatherIcon(weather.iconCode);
    final iconColor = _getIconColor(weather.iconCode);

    return Column(
      children: [
        const SizedBox(height: 10),
        // اسم المدينة والدولة
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_rounded, color: Colors.white70, size: 20),
            const SizedBox(width: 6),
            Text(
              '${weather.cityName}، ${weather.country}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // التاريخ واليوم
        Text(
          DateFormat('EEEE, d MMMM', 'ar').format(weather.dateTime),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
        ),
        const SizedBox(height: 24),

        // الأيقونة والحرارة الرئيسية
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.25),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(iconData, color: iconColor, size: 48),
            ),
            const SizedBox(width: 14),
            Text(
              '${weather.temperature.round()}°',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 82,
                fontWeight: FontWeight.w200,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // حالة الطقس المكتوبة
        Text(
          weather.condition,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // درجات الحرارة العظمى والصغرى
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'الصغرى: ${weather.minTemp.round()}°  |  العظمى: ${weather.maxTemp.round()}°',
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 24),

        // شبكة التفاصيل
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: [
            WeatherDetailItem(
              icon: Icons.water_drop_rounded,
              title: 'الرطوبة',  
              value: '${weather.humidity}%',
            ),
            WeatherDetailItem( 
              icon: Icons.air_rounded,
              title: 'سرعة الرياح',
              value: '${weather.windSpeed} كم/س',
            ),
            WeatherDetailItem(
              icon: Icons.speed_rounded,
              title: 'الضغط الجوي', 
              value: '${weather.pressure} hPa',
            ),
            WeatherDetailItem(
              icon: Icons.visibility_rounded,
              title: 'نسبة الرؤية',
              value: '${weather.visibility.toStringAsFixed(1)} كم',
            ),
          ],
        ),
      ],
    );
  }
}