import 'package:dio/dio.dart';

Dio configureDio() {

  final options = BaseOptions(
    baseUrl: 'https://kerrykimwayne.pythonanywhere.com/',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  );
  final dio = Dio(options);

  return dio;
}
