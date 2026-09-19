import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // أضف هذا الاستيراد
import 'app/app.dart';
import 'core/services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null); // تهيئة التاريخ باللغة العربية
  await initServiceLocator();
  runApp(const WeatherApp());
}
