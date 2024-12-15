import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dio_instance.dart';

class FasterMessage {

  Dio api = configureDio();

  Future<Map<String, dynamic>> login (Map<String, dynamic> data) async{

    final response =  await api.post('tokenObtain/', data: data);

    print(response.data["access"]);

    return response.data;
  }

  Future<Map<String, dynamic>> create (Map<String, dynamic> data) async{

    final response = await api.post('immobilierpannehelper/usercreate', data: data);

    return response.data;
  }

  Future<Map<String, dynamic>> getUser () async{

    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('immobilierpannehelper/usermodif/1/');

    return response.data;
  }

}