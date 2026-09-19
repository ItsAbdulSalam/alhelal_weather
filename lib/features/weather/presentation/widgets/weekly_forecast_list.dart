import 'package:flutter/material.dart';
import '../../domain/entities/forecast_entity.dart';

class WeeklyForecastList extends StatelessWidget {
  final List<ForecastEntity> forecastList;

  const WeeklyForecastList({super.key, required this.forecastList});

  IconData _getForecastIcon(String iconCode) {
    if (iconCode.contains('01')) return Icons.wb_sunny_rounded;
    if (iconCode.contains('02') ||
        iconCode.contains('03') ||
        iconCode.contains('04')) {
      return Icons.cloud_rounded;
    }
    if (iconCode.contains('09') || iconCode.contains('10'))
      return Icons.water_drop_rounded;
    if (iconCode.contains('11')) return Icons.flash_on_rounded;
    if (iconCode.contains('13')) return Icons.ac_unit_rounded;
    return Icons.wb_cloudy_rounded;
  }

  Color _getForecastIconColor(String iconCode) {
    if (iconCode.contains('01')) return const Color(0xFFFFD54F);
    if (iconCode.contains('09') || iconCode.contains('10'))
      return const Color(0xFF81D4FA);
    if (iconCode.contains('11')) return const Color(0xFFFFE082);
    return Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    if (forecastList.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: Colors.white70,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'توقعات الأيام القادمة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white12, height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forecastList.length,
            separatorBuilder: (_, _) =>
                const Divider(color: Colors.white10, height: 1),
            itemBuilder: (context, index) {
              final item = forecastList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.dayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Icon(
                            _getForecastIcon(item.iconCode),
                            color: _getForecastIconColor(item.iconCode),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.condition,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${item.minTemp.round()}° / ${item.maxTemp.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
