import 'dart:convert';
import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/view/home/components/item_book.dart';
import 'package:bsoc_book/app/view/home/components/item_top_book.dart';
import 'package:bsoc_book/app/view/home/home_view.dart';
import 'package:bsoc_book/app/view/quiz/quiz_page_view.dart';
import 'package:bsoc_book/app/view/wheel_spin/wheel_view.dart';
import 'package:bsoc_book/app/view/widgets/updatedialog.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view/banner/company_page.dart';
import 'package:bsoc_book/app/view/banner/job_page.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_version/new_version.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.homeViewModel,
    required this.parentViewState,
  });
  final HomeViewModel homeViewModel;
  final HomeViewState parentViewState;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel _homeViewModel;
  bool _loadingIsWaiting = false;
  // final AuthController authController = Get.find();

  // final getAllBooksController = Get.put(AllBooksController());

  // final getTopBookController = Get.put(TopBookController());

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    AppDataGlobal().setHomeViewModel(homeViewModel: _homeViewModel);
    _homeViewModel.getListBook();
    _homeViewModel.getListTopBook();
    _homeViewModel.listTopBookStream.listen((value) {
      if (mounted) {
        setState(() {
          _loadingIsWaiting = value;
        });
      }
    });
    _homeViewModel.bookModelSubjectStream.listen((value) {
      if (mounted) {
        setState(() {
          _loadingIsWaiting = value;
        });
      }
    });

    final newVersion = NewVersion(
      iOSId: 'com.b4usolution.app.bsoc',
      androidId: 'com.b4usolution.b4u_bsoc',
    );
    checkNewVersion(newVersion);
    super.initState();
  }

  _onTapNextPage(BookModel bookModel) async {
    print('object $bookModel');
    setState(() {
      _loadingIsWaiting = true;
    });
    widget.homeViewModel.bookId = bookModel.id!;
    widget.homeViewModel.getBookDetailPage().then((value) {
      if (value != null) {
        BookModel bookModel = value;
        setState(() {
          _loadingIsWaiting = false;
        });
        if (bookModel.chapters.isNotEmpty) {
          widget.parentViewState.jumpPageBookDetailPage();
        }
      }
    });
  }

  void checkNewVersion(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (status.canUpdate) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return UpdateDialog(
              allowDismissal: true,
              description: status.releaseNotes!,
              version: status.storeVersion,
              appLink: status.appStoreLink,
            );
          },
        );
      }
      print(status.appStoreLink);
      print(status.storeVersion);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        _homeViewModel.getListBook();
        _homeViewModel.getListTopBook();
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.02),
                    _renderSearchBook(),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CompanyPage()));
                            },
                            child: Container(
                                width: 170,
                                child: Image.asset('assets/images/banner1.png',
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const JobPage()));
                            },
                            child: Container(
                                width: 170,
                                child: Image.asset('assets/images/banner3.jpg',
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.03),
                    const Padding(
                      padding: EdgeInsets.only(left: 13.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Luyện thi "IELTS - TOEIC - IT - PSM1"',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.redAccent),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (AppDataGlobal().accessToken != '') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuizPageView()));
                          } else {
                            WidgetHelper.showPopupMessage(
                                context: context,
                                content: const Text(
                                    'Bạn cần đăng nhập để sử dụng chức năng này'));
                          }
                        },
                        child: Image.asset('assets/images/practice2.png'),
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    const Padding(
                      padding: EdgeInsets.only(left: 13.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vòng quay may mắn',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (AppDataGlobal().accessToken != '') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WheelPageView(
                                          homeViewModel: widget.homeViewModel,
                                        )));
                          } else {
                            WidgetHelper.showPopupMessage(
                                context: context,
                                content: const Text(
                                    'Bạn cần đăng nhập để sử dụng chức năng này'));
                          }
                        },
                        child: Image.asset('assets/images/banner-wheel.jpg'),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    const Padding(
                      padding: EdgeInsets.only(left: 13.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'TOP 5 SÁCH HAY',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    StreamBuilder<bool>(
                        stream: _homeViewModel.listTopBookStream,
                        builder: (context, snapshot) {
                          final data = _homeViewModel.checkListTopBook;
                          print('DU LIEU TRANG HOME 1 $data');
                          if (data != null && data['list'] != null) {
                            return ItemTopBook(
                              topBookModel: data['list'],
                              onTapNextPage: (BookModel bookModel) {
                                _onTapNextPage(bookModel);
                              },
                            );
                          }
                          return Container();
                        }),
                    SizedBox(height: size.height * 0.04),
                    const Padding(
                      padding: EdgeInsets.only(left: 13.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'THƯ VIỆN SÁCH',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    StreamBuilder<bool>(
                        stream: _homeViewModel.bookModelSubjectStream,
                        builder: (context, snapshot) {
                          final dataBook = _homeViewModel.checkListBook;
                          print('DU LIEU TRANG HOME 2 $dataBook');
                          if (dataBook != null && dataBook['list'] != null) {
                            return ItemBook(
                              bookModel: dataBook['list'],
                              onTapNextPage: (BookModel bookModel) {
                                _onTapNextPage(bookModel);
                              },
                            );
                          }
                          return Container();
                        }),
                  ],
                ),
              ),
              (true == _loadingIsWaiting)
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                      color: Color.fromARGB(255, 138, 175, 52),
                      secondRingColor: Colors.black,
                      thirdRingColor: Colors.purple,
                      size: 30,
                    ))
                  : Container(),
            ],
          ),
        )),
      ),
    );
  }

  _renderSearchBook() {
    return Column(children: [
      Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: TypeAheadField(
              hideSuggestionsOnKeyboardHide: false,
              textFieldConfiguration: const TextFieldConfiguration(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Tìm kiếm sách',
                ),
              ),
              suggestionsCallback: (dynamic value) async {
                var url = Uri.parse('http://103.77.166.202/api/book/all-book');
                http.Response response = await http.get(url);
                if (response.statusCode == 200) {
                  Map<String, dynamic> bookModel = jsonDecode(
                      const Utf8Decoder().convert(response.bodyBytes));
                  List<BookModel> books = (bookModel["content"] as List)
                      .map((item) => BookModel.fromJson(item))
                      .toList();

                  return books
                      .where((book) =>
                          '${removeDiacritics(book.bookName!)} ${removeDiacritics(book.author!)}'
                              .toLowerCase()
                              .contains(removeDiacritics(value).toLowerCase()))
                      .toList();
                } else {
                  throw Exception('Lỗi tải hệ thống');
                }
              },
              itemBuilder: (context, BookModel suggestion) {
                final book = suggestion;

                return ListTile(
                  leading: Image.network(
                    AppDataGlobal().domain + book.image!,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(book.bookName!),
                  subtitle: Text(book.author!),
                );
              },
              noItemsFoundBuilder: (context) => Container(
                height: 100,
                child: const Center(
                  child: Text(
                    'Không tìm thấy sách',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              onSuggestionSelected: (BookModel suggestion) async {
                final book = suggestion;
                widget.homeViewModel.bookId = book.id!;
                widget.homeViewModel.getBookDetailPage().then((value) {
                  if (value != null) {
                    widget.parentViewState.jumpPageBookDetailPage();
                  }
                });
              },
            ),
          ))
    ]);
  }
}
