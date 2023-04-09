import 'dart:convert';
import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://103.77.166.202:9999/api/quiz/list-question";

Future<List<Question>> getQuestions(int? total) async {
  String url = "$baseUrl/$total";
  // http.Response res = await http.get(Uri.parse(url));
  // List<Map<String, dynamic>> questions =
  //     List<Map<String, dynamic>>.from(json.decode(res.body)["listQuestion"]);
  // return Question.fromData(questions);
  final response = await Dio().get(url);
  final questions =
      List<Map<String, dynamic>>.from(response.data["listQuestion"]);
  return Question.fromData(questions);
}



  // Future<Question> getQuestions(int? total) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('accessToken');
      // var response = await Dio().get(
      //     'http://103.77.166.202:9999/api/quiz/list-question/$total',
      //     options: Options(headers: {
      //       'Authorization': 'Bearer $token',
      //     }));
      // if (response.statusCode == 200) {
      //   return Question.fromJson(json.decode(response.data));
      // }
      // print("res: ${response.data}");
  //   } on DioError catch (e) {
  //     if (e.isNoConnectionError) {
  //       // Get.dialog(DialogError());
  //     } else {
  //       Get.snackbar("error", e.toString());
  //       print(e);
  //       rethrow;
  //     }
  //   }
  // }


