import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();

  dio.options.baseUrl = 'http://10.0.2.2:8000/api/v1/';
  dio.options.headers['accept'] = 'application/json';

  return dio;
}
