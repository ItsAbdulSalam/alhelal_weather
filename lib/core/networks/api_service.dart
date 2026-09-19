import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import 'api_endpoints.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio) {
    dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  Future<dynamic> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final queryParams = {
        'appid': ApiEndpoints.apiKey,
        'units': 'metric', // لجلب درجات الحرارة بالمئوية
        'lang': 'ar',      // لدعم اللغة العربية في وصف الطقس
        ...?queryParameters,
      };

      final response = await dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException('حدث خطأ غير متوقع: $e');
    }
  }

  void _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ServerException('انتهت مهلة الاتصال بالخادم');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'فشل الطلب';
        if (statusCode == 404) {
          throw ServerException('المدينة المطلوبة غير موجودة');
        }
        throw ServerException('خطأ من الخادم ($statusCode): $message');
      case DioExceptionType.connectionError:
        throw ServerException('لا يوجد اتصال بالإنترنت');
      default:
        throw ServerException('حدث خطأ أثناء جلب البيانات');
    }
  }
}