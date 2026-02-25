import 'package:dio/dio.dart';

class ApiService {
  ApiService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<Response<dynamic>> getJson(String url) => _dio.get(url);
}

