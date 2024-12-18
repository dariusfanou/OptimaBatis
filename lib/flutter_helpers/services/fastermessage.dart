import 'dart:convert';

import 'package:dio/dio.dart';

class FasterMessage {

  final dio = Dio();

  final key = base64Encode(utf8.encode("assi9058:c7f2ca2d"));

  Future<Map<String, dynamic>> sendCode(Map<String, dynamic> data) async {

    if (key != "") {
      dio.options.headers['AUTHORIZATION'] = 'Basic $key';
    }

    final response = await dio.post('https://api.fastermessage.com/v1/sms/send', data: data);

    return response.data;
  }

}