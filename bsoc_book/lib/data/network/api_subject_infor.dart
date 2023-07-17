import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://103.77.166.202/api/quiz/subject-info";
String? token;

Map<String, dynamic>? headquestions;

Future<void> getSubject2(int? total) async {
  final box = GetStorage();
  token = box.read('accessToken');
  print('Token Infor Question: $token');
  String url = "$baseUrl/$total";
  final response = await Dio().get(
    url,
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  print('Get Infor Question: $response');
  headquestions = response.data;
}
