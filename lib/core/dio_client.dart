import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://35.216.60.56:8080/api/',
    ),
  );

  factory DioClient() => _instance;

  DioClient._();

  Dio get dio => _dio;

  Future<Response<dynamic>> get(String path) async => _dio.get(path);

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
  }) async =>
      _dio.post(path, data: data);
}
