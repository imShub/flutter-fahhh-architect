import 'package:dio/dio.dart';

import '../constants/api_endpoints.dart';

/// A tiny API abstraction. Keep it small and injectable.
class ApiService {
  ApiService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  final Dio _dio;

  Future<bool> healthCheck() async {
    final res = await _dio.get(ApiEndpoints.health);
    return res.statusCode == 200;
  }
}

