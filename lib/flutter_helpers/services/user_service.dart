import 'package:dio/dio.dart';

import '../dio_instance.dart';

class UserService {

  Dio api = configureDio();

  Future<Map<String, dynamic>> login (Map<String, dynamic> data) async{

    final response =  await api.post('tokenObtain/', data: data);

    return response.data;
  }

  Future<Map<String, dynamic>> create (Map<String, dynamic> data) async{

    final response = await api.post('immobilierpannehelper/usercreate/', data: data);

    return response.data;
  }

}