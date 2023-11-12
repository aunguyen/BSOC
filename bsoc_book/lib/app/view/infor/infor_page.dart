import 'dart:convert';
import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/view/home/home_view.dart';
import 'package:bsoc_book/app/view/infor/infor_page_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/user_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/controller/authen/authen_controller.dart';
import 'package:bsoc_book/controller/changepass/changepass_controller.dart';
import 'package:bsoc_book/app/view/about/about_page.dart';
import 'package:bsoc_book/app/view/contact/contact_page.dart';
import 'package:bsoc_book/app/view/login/login_page.dart';
import 'package:bsoc_book/app/view/rewards/rewards.dart';
import 'package:bsoc_book/app/view/terms/terms_page.dart';
import 'package:bsoc_book/app/view/update/update_infor.dart';
import 'package:bsoc_book/app/view/update/uploadavt_page.dart';
import 'package:bsoc_book/app/view/home/home_page.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/utils/resource_values.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
// import 'package:flutter_offline/flutter_offline.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({
    super.key,
    required this.homeViewModel,
    required this.parentViewState,
    required this.userViewModel,
  });

  final HomeViewModel homeViewModel;
  final InfoPageViewState parentViewState;
  final UserViewModel userViewModel;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  HomeViewModel? _homeViewModel;
  UserViewModel? _userViewModel;
  bool _isLoading = false;
  UserModel? _userItem;
  void goHome() {
    Application.router.navigateTo(context, Routes.app, clearStack: true);
  }

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    _userViewModel = widget.userViewModel;

    setState(() {
      _isLoading = true;
    });

    _userViewModel?.getInfoPage().then((value) {
      if (value != null) {
        _userItem = value;
        print("User Info 2222: $_userItem");
      }
    });

    super.initState();
  }

  File? _image;

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      var formData = FormData.fromMap(
        {
          "image": await MultipartFile.fromFile(pickedImage.path),
          "userId": _userItem!.id!,
          "username": _userItem!.username!,
          "email": _userItem!.email!,
          "phone": _userItem!.phone!,
          "fullname": _userItem!.fullname!
        },
      );
      var response = await Dio().post('http://103.77.166.202/api/user/update',
          data: formData,
          options: Options(headers: {
            'Authorization': 'Bearer ${AppDataGlobal().accessToken}',
          }));
      if (response.statusCode == 200) {
        WidgetHelper.showMessageSuccess(
            context: context, content: 'Cập nhật avatar thành công');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_COLOR,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        title: const Text(
          'Thông tin tài khoản',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            goHome();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
              child: Column(
            children: [
              (AppDataGlobal().accessToken != '')
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        StreamBuilder(
                            stream: _userViewModel!.userInfoModelSubjectStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                UserModel item = snapshot.data!;
                                return Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: 60.0,
                                          backgroundImage: (_image != null)
                                              ? FileImage(_image!)
                                                  as ImageProvider<Object>?
                                              : NetworkImage(AppDataGlobal()
                                                      .domain +
                                                  (_userItem?.avatar ?? '')),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        GestureDetector(
                                          onTap: _pickImageFromGallery,
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _userItem!.username ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: ResourceValues
                                                    .FONT_SIZE_MEDIUM),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ],
                    )
                  : Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                            'Bạn cần đăng nhập hoặc đăng ký để xem thông tin tài khoản.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: Container(
                            width: 190,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: const Text(
                              'Đăng nhập hoặc Đăng ký',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          )),
        ),
      ),
    );
  }
}

// Map<String, dynamic>? datauser;

// class InforPage extends StatefulWidget {
//   const InforPage({super.key});

//   @override
//   State<InforPage> createState() => _InforPageState();
// }

// class _InforPageState extends State<InforPage> {
//   final AuthController authController = Get.find();
//   final box = GetStorage();
//   ConnectivityResult connectivity = ConnectivityResult.none;
//   bool isLoading = true;
//   String? token;

//   Future<void> getUserDetail() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       token = box.read('accessToken');
//       print(token);

//       if (token == null) {
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Phiên đã hết hạn"),
//               content: Text("Vui lòng đăng nhập lại."),
//               actions: [
//                 TextButton(
//                   child: Text("Đồng ý"),
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginPage()),
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }

//       var response = await Dio().get('http://103.77.166.202/api/user/profile',
//           options: Options(headers: {'Authorization': 'Bearer $token'}));
//       if (response.statusCode == 200) {
//         datauser = response.data;
//         await prefs.setString('username', datauser!['username']);
//         await prefs.setString('avatar', datauser!['avatar']);
//         setState(() {
//           isLoading = false;
//         });
//       } else {
//         Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
//       }
//       print("res: ${response.data}");
//     } catch (e) {
//       // Get.snackbar("error", e.toString());
//       print(e);
//     }
//   }

//   @override
//   void initState() {
//     // InternetPopup().initialize(context: context);
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (authController.isLoggedIn.value) {
//         await getUserDetail();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 138, 175, 52),
//         centerTitle: true,
//         title: Text('Cài đặt tài khoản'),
//         leading: GestureDetector(
//             child: Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//             ),
//             onTap: () {
//               // Navigator.push(
//               //     context, MaterialPageRoute(builder: (context) => HomePage()));
//             }),
//       ),
//       body: getUserDetail == ConnectivityResult.none
//           ? Center(
//               child: LoadingAnimationWidget.discreteCircle(
//               color: Color.fromARGB(255, 138, 175, 52),
//               secondRingColor: Colors.black,
//               thirdRingColor: Colors.purple,
//               size: 30,
//             ))
//           : Obx(() => authController.isLoggedIn.value
//               ? RefreshIndicator(
//                   onRefresh: () async {
//                     getUserDetail();
//                   },
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: size.height * 0.02),
//                           Center(
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             const UploadAvatar()));
//                               },
//                               child: datauser == null
//                                   ? const CircleAvatar(
//                                       radius: 50.0,
//                                       backgroundImage: AssetImage(
//                                           'assets/images/avatar.png'),
//                                       backgroundColor: Colors.transparent,
//                                     )
                                  // : CircleAvatar(
                                  //     radius: 60.0,
                                  //     backgroundImage: NetworkImage(
                                  //         datauser!['avatar'] == null
                                  //             ? 'assets/images/avatar.png'
                                  //             : 'http://103.77.166.202' +
                                  //                 datauser!['avatar']
                                  //                     .toString()),
                                  //     backgroundColor: Colors.transparent,
                                  //   ),
//                             ),
//                           ),
//                           Text(
//                             'Thông tin',
//                             style: TextStyle(color: Colors.blue, fontSize: 16),
//                           ),
//                           SizedBox(height: size.height * 0.01),
//                           Card(
//                             color: Colors.white,
//                             child: Column(
//                               children: [
//                                 ListTile(
//                                   title: Text(
//                                     'Mã tài khoản:',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.w500),
//                                   ),
//                                   trailing: Text(datauser == null
//                                       ? ""
//                                       : datauser!['id'].toString()),
//                                 ),
//                                 Divider(
//                                   height: 1,
//                                   endIndent: 0,
//                                   color: Color.fromARGB(255, 87, 87, 87),
//                                 ),
//                                 ListTile(
//                                   title: Text(
//                                     'Họ Tên:',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.w500),
//                                   ),
//                                   trailing: Text(datauser == null
//                                       ? ""
//                                       : datauser!['fullname'].toString()),
//                                 ),
//                                 Divider(
//                                   height: 2,
//                                   endIndent: 0,
//                                   color: Color.fromARGB(255, 87, 87, 87),
//                                 ),
//                                 ListTile(
//                                   title: Text(
//                                     'Tên đăng nhập:',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.w500),
//                                   ),
//                                   trailing: Text(datauser == null
//                                       ? ""
//                                       : datauser!['username'].toString()),
//                                 ),
//                                 Divider(
//                                   height: 2,
//                                   endIndent: 0,
//                                   color: Color.fromARGB(255, 87, 87, 87),
//                                 ),
//                                 ListTile(
//                                   title: Text(
//                                     'Email:',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.w500),
//                                   ),
//                                   trailing: Text(datauser == null
//                                       ? ""
//                                       : datauser!['email'].toString()),
//                                 ),
//                                 // Divider(
//                                 //   height: 2,
//                                 //   endIndent: 0,
//                                 //   color: Color.fromARGB(255, 87, 87, 87),
//                                 // ),
//                                 // ListTile(
//                                 //   title: Text(
//                                 //     'Số điện thoại:',
//                                 //     style:
//                                 //         TextStyle(fontWeight: FontWeight.w500),
//                                 //   ),
//                                 //   trailing: Text(datauser != null
//                                 //       ? " "
//                                 //       : datauser!['phone'].toString()),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: size.height * 0.04),
//                           GestureDetector(
//                             onTap: () {
//                               if (datauser?['pointForClaimBook'] == 0) {
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       title: Text('Thông báo'),
//                                       content: Text(
//                                           'Bạn vui lòng làm bài thi để được thu thập điểm thưởng'),
//                                       actions: <Widget>[
//                                         TextButton(
//                                           child: Text('OK'),
//                                           onPressed: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               } else {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const RewardsPage()),
//                                 );
//                               }
//                             },
//                             child: Card(
//                               color: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: 500,
//                                     height: 80,
//                                     decoration: BoxDecoration(
//                                         color:
//                                             Color.fromARGB(255, 138, 175, 52),
//                                         borderRadius: BorderRadius.vertical(
//                                             top: Radius.circular(8.0))),
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 15.0, right: 8.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             'Điểm thưởng',
//                                             style: TextStyle(
//                                                 fontSize: 22,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: Colors.white),
//                                           ),
//                                           Container(
//                                               height: 70,
//                                               child: Image.asset(
//                                                   'assets/images/gift.png'))
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: 500,
//                                     height: 100,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.vertical(
//                                             bottom: Radius.circular(8.0))),
//                                     child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: 16.0, top: 20.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             datauser?['pointForClaimBook'] ==
//                                                     null
//                                                 ? Text(
//                                                     '0 Điểm',
//                                                     style: TextStyle(
//                                                         fontSize: 20,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: Colors.black),
//                                                   )
//                                                 : Text(
//                                                     datauser!['pointForClaimBook']
//                                                             .toString() +
//                                                         ' Điểm',
//                                                     style: TextStyle(
//                                                         fontSize: 20,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: Colors.black),
//                                                   ),
//                                             SizedBox(
//                                                 height: size.height * 0.02),
//                                             Text(
//                                               'Mỗi bài thi đạt 100% sẽ được tặng 01 điểm',
//                                             )
//                                           ],
//                                         )),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: size.height * 0.04),
//                           Text(
//                             'Cài đặt chung',
//                             style: TextStyle(color: Colors.blue, fontSize: 16),
//                           ),
//                           SizedBox(height: size.height * 0.01),
//                           Card(
//                             color: Colors.white,
//                             child: Column(
//                               children: [
//                                 // ListTile(
//                                 //   leading: Icon(Icons.info),
//                                 //   title: Text(
//                                 //     'Cập nhật thông tin',
//                                 //     style:
//                                 //         TextStyle(fontWeight: FontWeight.w500),
//                                 //   ),
//                                 //   trailing: Icon(Icons.keyboard_arrow_right),
//                                 //   onTap: () async {
//                                 //     Navigator.push(
//                                 //         context,
//                                 //         MaterialPageRoute(
//                                 //             builder: (context) =>
//                                 //                 UpdateUser()));
//                                 //   },
//                                 // ),
//                                 // Divider(
//                                 //   height: 2,
//                                 //   endIndent: 0,
//                                 //   color: Color.fromARGB(255, 87, 87, 87),
//                                 // ),
//                                 ListTile(
//                                   leading: Icon(Icons.shield),
//                                   title: Text(
//                                     'Đổi mật khẩu',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.w500),
//                                   ),
//                                   trailing: Icon(Icons.keyboard_arrow_right),
//                                   onTap: () async {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const ChangePassword()));
//                                   },
//                                 ),
//                                 Divider(
//                                   height: 2,
//                                   endIndent: 0,
//                                   color: Color.fromARGB(255, 87, 87, 87),
//                                 ),
//                                 ListTile(
//                                   leading: Icon(Icons.delete),
//                                   title: Text(
//                                     'Xóa tài khoản',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.w500),
//                                   ),
//                                   trailing: Icon(Icons.keyboard_arrow_right),
//                                   onTap: () async {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) => DialogDelete(),
//                                     );
//                                   },
//                                 ),
//                                 Divider(
//                                   height: 2,
//                                   endIndent: 0,
//                                   color: Color.fromARGB(255, 87, 87, 87),
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       border: Border(
//                                           bottom: BorderSide(
//                                               color: Colors.grey.shade400))),
//                                   child: ListTile(
//                                     title: Text('Giới thiệu'),
//                                     trailing: Icon(Icons.arrow_right),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => AboutPage()),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       border: Border(
//                                           bottom: BorderSide(
//                                               color: Colors.grey.shade400))),
//                                   child: ListTile(
//                                     title: Text('Liên hệ'),
//                                     trailing: Icon(Icons.arrow_right),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 ContactPage()),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                   ),
//                                   child: ListTile(
//                                     title: Text('Điều khoản sử dụng'),
//                                     trailing: Icon(Icons.arrow_right),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => TermsPage()),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: size.height * 0.02),
//                           Center(
//                             child: Text(
//                               '1.1.3',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                           ),
//                           SizedBox(height: size.height * 0.02),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.only(left: 20.0, right: 20.0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => DialogLogout(),
//                                 );
//                               },
//                               child: Text(
//                                 'Đăng xuất',
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 primary: Colors.red[100],
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                                 minimumSize: Size(double.infinity, 50),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
// : Column(
//     children: [
//       Padding(
//         padding: const EdgeInsets.only(
//             top: 50, bottom: 50, left: 16, right: 16),
//         child: Column(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.only(left: 20.0, right: 20.0),
//               child: Text(
//                 'Bạn cần đăng nhập hoặc đăng ký để xem thông tin tài khoản.',
//                 style: TextStyle(fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: size.height * 0.02),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => LoginPage()),
//                 );
//               },
//               child: Container(
//                 width: 190,
//                 height: 50,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50.0),
//                 ),
//                 child: Text(
//                   'Đăng nhập hoặc Đăng ký',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border(
//                               bottom: BorderSide(color: Colors.grey.shade400))),
//                       child: ListTile(
//                         title: Text('Giới thiệu'),
//                         trailing: Icon(Icons.arrow_right),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => AboutPage()),
//                           );
//                         },
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border(
//                               bottom: BorderSide(color: Colors.grey.shade400))),
//                       child: ListTile(
//                         title: Text('Liên hệ'),
//                         trailing: Icon(Icons.arrow_right),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ContactPage()),
//                           );
//                         },
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                       ),
//                       child: ListTile(
//                         title: Text('Điều khoản sử dụng'),
//                         trailing: Icon(Icons.arrow_right),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => TermsPage()),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: size.height * 0.02),
//                     Center(
//                       child: Text(
//                         '1.1.3',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ],
//                 )),
//       // )
//     );
//   }
// }

// class ChangePassword extends StatefulWidget {
//   const ChangePassword({super.key});

//   @override
//   State<ChangePassword> createState() => _ChangePasswordState();
// }

// class _ChangePasswordState extends State<ChangePassword> {
//   final _formKey = GlobalKey<FormState>();
//   ChangepassConntroller changepass = Get.put(ChangepassConntroller());

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 138, 175, 52),
//         centerTitle: true,
//         title: Text('Đổi mật khẩu'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context, false),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Form(
//                 key: _formKey,
//                 child: SizedBox(
//                   width: size.width,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Container(
//                       width: size.width * 0.85,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: <Widget>[
//                             SizedBox(height: size.height * 0.04),
//                             const Align(
//                               alignment: Alignment.centerLeft,
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 0, bottom: 4),
//                                 child: Text(
//                                   'Mật khẩu hiện tại',
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             TextFormField(
//                               controller: changepass.currentpasswordController,
//                               obscureText: true,
//                               validator: (value) {
//                                 return (value == null || value.isEmpty)
//                                     ? 'Vui lòng nhập mật khẩu hiện tại'
//                                     : null;
//                               },
//                               decoration: InputDecoration(
//                                   hintText: "Mật khẩu hiện tại",
//                                   isDense: true,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   )),
//                             ),
//                             SizedBox(height: size.height * 0.02),
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 0, bottom: 4),
//                                 child: Text(
//                                   'Mật khẩu mới',
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             TextFormField(
//                               controller: changepass.newpasswordController,
//                               obscureText: true,
//                               validator: (value) {
//                                 return (value == null || value.isEmpty)
//                                     ? 'Vui lòng nhập mật khẩu mới'
//                                     : null;
//                               },
//                               decoration: InputDecoration(
//                                   hintText: "Mật khẩu mới",
//                                   isDense: true,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   )),
//                             ),
//                             SizedBox(height: size.height * 0.04),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   child: ElevatedButton(
//                                     onPressed: () => {
//                                       if (_formKey.currentState!.validate())
//                                         {
//                                           changepass.changepassUser(),
//                                           Navigator.of(context).pop(),
//                                         }
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                         primary:
//                                             Color.fromARGB(255, 153, 195, 59),
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 40, vertical: 15)),
//                                     child: const Text(
//                                       "Cập nhật",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DialogLogout extends StatelessWidget {
//   DialogLogout({super.key});
//   final AuthController authController = Get.put(AuthController());
//   final box = GetStorage();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Thông báo'),
//       content: Container(
//           child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text('Bạn có chắc chắn muốn thoát khỏi ứng dụng?'),
//           SizedBox(
//             height: 10,
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               elevation: 2,
//               primary: Colors.blueAccent,
//               minimumSize: const Size.fromHeight(35),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//             ),
//             onPressed: () async {
//               // SharedPreferences prefs = await SharedPreferences.getInstance();
//               // await prefs.remove('accessToken');
//               // await prefs.clear();
//               // box.write('isLoggedIn', false);
//               authController.logout();
//               // Navigator.push(
//               //     context, MaterialPageRoute(builder: (context) => HomePage()));
//             },
//             child: Text('Có'),
//           ),
//           OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(35),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//               onPressed: () => Navigator.pop(context, 'Không'),
//               child: Text(
//                 'Không',
//                 style: TextStyle(color: Colors.black),
//               )),
//         ],
//       )),
//     );
//   }
// }

// class DialogDelete extends StatefulWidget {
//   const DialogDelete({super.key});

//   @override
//   State<DialogDelete> createState() => _DialogDeleteState();
// }

// class _DialogDeleteState extends State<DialogDelete> {
//   String? token;
//   Future<void> deleteUser() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       token = prefs.getString('accessToken');

//       var response = await Dio().post('http://103.77.166.202/api/user/delete',
//           options: Options(
//               headers: {'accept': '*/*', 'Authorization': 'Bearer $token'}));
//       if (response.statusCode == 200) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.remove('accessToken');
//         Get.offAll(LoginPage());
//       } else {
//         Get.snackbar("lỗi", "Xóa tải khoản lỗi. Thử lại.");
//       }
//       print("res: ${response.data}");
//     } catch (e) {
//       Get.snackbar("error", e.toString());
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Thông báo'),
//       content: Container(
//           child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text('Bạn có chắc chắn muốn xóa tài khoản này?'),
//           SizedBox(
//             height: 10,
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               elevation: 2,
//               primary: Colors.blueAccent,
//               minimumSize: const Size.fromHeight(35),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//             ),
//             onPressed: () async {
//               deleteUser();
//             },
//             child: Text('Có'),
//           ),
//           OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(35),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//               onPressed: () => Navigator.pop(context, 'Không'),
//               child: Text(
//                 'Không',
//                 style: TextStyle(color: Colors.black),
//               )),
//         ],
//       )),
//     );
//   }
// }
