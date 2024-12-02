import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://todo-app-backend-dusky.vercel.app',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Response> get(String endpoint, {Map<String, dynamic>? headers}) async {
    return await dio.get(endpoint, options: Options(headers: headers));
  }

  Future<Response> post(String endpoint, dynamic data, {Map<String, dynamic>? headers}) async {
    return await dio.post(endpoint, data: data, options: Options(headers: headers));
  }

  Future<Response> put(String endpoint, dynamic data, {Map<String, dynamic>? headers}) async {
    return await dio.put(endpoint, data: data, options: Options(headers: headers));
  }

  Future<Response> delete(String endpoint, {Map<String, dynamic>? headers}) async {
    return await dio.delete(endpoint, options: Options(headers: headers));
  }
}
