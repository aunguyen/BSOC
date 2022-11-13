import 'package:bsoc_book/controller/register/register_controller.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  RegisterationController registerController =
      Get.put(RegisterationController());

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
                          "ĐĂNG KÝ TÀI KHOẢN",
                          style: TextStyle(
                            fontSize: 19,
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
                            'Tên đăng nhập (*)',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: registerController.usernameController,
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Vui lòng nhập Username'
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
                            'Email (*)',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: registerController.emailController,
                        validator: (value) => EmailValidator.validate(value!)
                            ? null
                            : "Vui lòng nhập email",
                        decoration: InputDecoration(
                            hintText: "Email",
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
                            'Số điện thoại (*)',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: registerController.phoneController,
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Vui lòng nhập Số điện thoại'
                              : null;
                        },
                        maxLength: 2,
                        decoration: InputDecoration(
                            hintText: "Phone",
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
                            'Mật khẩu (*)',
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
                        controller: registerController.passwordController,
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Please Enter Password'
                              : null;
                        },
                        decoration: InputDecoration(
                            hintText: "Password",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => {
                                if (_formKey.currentState!.validate())
                                  {
                                    registerController.registerWithUser(),
                                  },
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15)),
                              child: const Text(
                                "Đăng ký",
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
                              Get.toNamed(Routes.login);
                            },
                            child: const Text("Đăng nhập"),
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
