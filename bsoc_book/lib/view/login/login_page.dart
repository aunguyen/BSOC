import 'package:bsoc_book/controller/login/login_controller.dart';
import 'package:bsoc_book/routes/app_routes.dart';
import 'package:bsoc_book/view/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Form(
          key: _formKey,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: size.width * 0.85,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                              'assets/images/logo-b4usolution.png')),
                      SizedBox(height: size.height * 0.02),
                      const Center(
                        child: Text(
                          "ĐĂNG NHẬP",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0, bottom: 4),
                          child: Text(
                            'Tên đăng nhập',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: loginController.usernameController,
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Vui lòng nhập tên đăng nhập'
                              : null;
                        },
                        decoration: InputDecoration(
                            hintText: "Tên đăng nhập",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      SizedBox(height: size.height * 0.02),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0, bottom: 4),
                          child: Text(
                            'Mật khẩu',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: loginController.passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập mật khẩu";
                          } else if (value.length < 6) {
                            return "Mật khẩu phải chứa tối thiểu 6 ký tự";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Mật khẩu",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      SizedBox(height: size.height * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => {
                                if (_formKey.currentState!.validate())
                                  {
                                    loginController.loginWithUsername(),
                                  }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15)),
                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.offAllNamed(Routes.register);
                            },
                            child: const Text("Tạo tài khoản mới"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
