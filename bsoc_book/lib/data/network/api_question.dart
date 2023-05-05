import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://103.77.166.202/api/quiz/list-question";

Map<String, dynamic>? data2;

Future<List<Question>> getQuestions(int? total) async {
  String? token;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final box = GetStorage();
  bool isLoggedIn = box.read('isLoggedIn');
  if (isLoggedIn) {
    token = prefs.getString('accessToken');
  }

  String url = "$baseUrl/$total";
  final response = await Dio().get(
    url,
    options: isLoggedIn
        ? Options(headers: {'Authorization': 'Bearer $token'})
        : null,
  );
  data2 = response.data;
  final questions =
      List<Map<String, dynamic>>.from(response.data["listQuestion"]);
  debugPrint(questions.toString(), wrapWidth: 1024);
  return Question.fromData(questions);
}
