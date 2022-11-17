import 'dart:convert';
import 'package:bsoc_book/routes/app_routes.dart';
import 'package:bsoc_book/view/contact/contact_page.dart';
import 'package:bsoc_book/view/infor/infor_page.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/main_page.dart';
import 'package:bsoc_book/view/terms/terms_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bsoc_book/data/network/api_client.dart';
import 'package:http/http.dart' as http;

String? demo;
Map? mapDemo;
Map? demoReponse;
List? listReponse;

class MenuAside extends StatefulWidget {
  const MenuAside({Key? key}) : super(key: key);

  @override
  State<MenuAside> createState() => _MenuAsideState();
}

class _MenuAsideState extends State<MenuAside> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  String? token;

  Future<void> getUserDetail() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio().get('http://103.77.166.202/api/user/infor',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        mapDemo = response.data;
        // print(datauser);
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }

  // Future<void> getInforUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('accessToken');

  //   var url =
  //       Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.inforUser);
  //   http.Response response =
  //       await http.get(url, headers: {'Authorization': 'Bearer $token'});
  //   if (response.statusCode == 200) {
  //     mapDemo = jsonDecode(response.body);

  //     isLoading = false;
  //   } else {
  //     throw Exception('Lỗi tải hệ thống');
  //   }
  // }

  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Color.fromARGB(255, 138, 175, 52),
                Color.fromARGB(255, 138, 175, 52)
              ])),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        elevation: 8,
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Image.asset(
                              "assets/images/logo-b4usolution.png",
                              height: 80,
                              width: 80),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Xin chào,',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              final SharedPreferences? prefs = await _prefs;
                              await prefs?.setString(
                                  'accessToken', token.toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const InforPage()));
                            },
                            child: Text(
                              mapDemo == null
                                  ? 'Đang tải dữ liệu'
                                  : mapDemo!['username'],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            )),
                      ],
                    ),
                    // Text(
                    //   mapDemo == null ? 'Đang tải dữ liệu' : mapDemo!['email'],
                    //   style: TextStyle(color: Colors.white, fontSize: 16),
                    // )
                  ],
                ),
              )),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400))),
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {
                      Get.to(MainIndexPage());
                    },
                    child: ListTile(
                      leading: const Icon(Icons.my_library_books),
                      title: const Text(
                        'Thư viện sách',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // ListTile(
          //   leading: const Icon(Icons.assessment_outlined),
          //   title: const Text('Rao vặt'),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400))),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () async {
                  Get.to(ContactPage());
                },
                child: ListTile(
                  leading: const Icon(Icons.contact_page),
                  title: const Text(
                    'Liên hệ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400))),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () {
                  Get.to(TermsPage());
                },
                child: ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text(
                    'Điều khoản sử dụng',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400))),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () async {
                  // SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // await prefs.remove('accessToken');
                  // Get.offAll(LoginPage());
                  showDialog(
                    context: context,
                    builder: (context) => const DialogLogout(),
                  );
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.logout_outlined,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Đăng xuất',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),

          Container(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Text('Phiên bản: 1.0.0')),
            ),
          ),
        ],
      ),
    );
  }
}

class DialogLogout extends StatelessWidget {
  const DialogLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thông báo'),
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bạn có chắc chắn muốn thoát khỏi ứng dụng?'),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              primary: Colors.blueAccent,
              minimumSize: const Size.fromHeight(35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('accessToken');
              Get.offAll(LoginPage());
            },
            child: Text('Có'),
          ),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () => Navigator.pop(context, 'Không'),
              child: Text(
                'Không',
                style: TextStyle(color: Colors.black),
              )),
        ],
      )),
    );
  }
}
