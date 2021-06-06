import 'package:dio/dio.dart';

Dio dio({token}) {
  Dio dio = new Dio();
  // dio.options.baseUrl = 'http://10.0.2.2:8000/api/v1/';
  dio.options.baseUrl = 'http://10.0.2.2:8000/api/v1/';

  dio.options.headers['accept'] = 'application/json';
  if (token != '' && token != null) {
    dio.options.headers['Authorization'] = "Bearer " + token;
  }
  return dio;
}
