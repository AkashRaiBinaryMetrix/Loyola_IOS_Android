import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loyola/Commons/common_class.dart';
import 'package:loyola/src/category_list_screen.dart';
import 'package:loyola/src/category_survey_screen.dart';
import 'package:loyola/src/radio_survey_screen.dart';
import 'package:loyola/src/upcoming_survey_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int? userID;
  String? userName;
  List? upcomingSurveyList, newSurveyList, categoryList;

  @override
  void initState() {
    super.initState();
    getLoginData();
  }

  getLoginData() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getInt("userId");
      fetchUpcomingSurveyList();
      fetchNewSurveyList();
      fetchCategoryList();
    });
  }

  fetchUpcomingSurveyList() {
    CommonClass().showWait(context);
    final body = {
      "user_id": userID.toString(),
      "category_id": "",
      "type": "upcoming"
    };
    ApiService().getSurveyList(body).then((value) => setState(() {
          CommonClass().dismissDialog(context);
          upcomingSurveyList = value['data'];
          print("upcoming survey List $upcomingSurveyList");
        }));
  }

  fetchNewSurveyList() {
    final body = {
      "user_id": userID.toString(),
      "category_id": "",
      "type": "new"
    };
    ApiService().getSurveyList(body).then((value) => setState(() {
          newSurveyList = value['data'];
          print("new survey List ${value['data']}");
        }));
  }

  fetchCategoryList() {
    ApiService().getCategory().then((value) => setState(() {
          categoryList = value['data'];
          //   print("Category List $categoryList");
        }));
  }

  DateTime? backbuttonpressedTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime!) >
            const Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    {
      SystemNavigator.pop();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55), // Set this height
          child: Container(
              padding: const EdgeInsets.only(
                  top: 40, bottom: 10, left: 20, right: 20),
              color: CustomColor.buttonColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Surveys",
                    // userName ?? "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )),
        ),
        body: ListView(
          children: [
            categoryList == null||categoryList!.isEmpty?Container():   Container(
                margin: const EdgeInsets.only(top: 10, left: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Category Surveys',
                      style: TextStyle(
                          color: CustomColor.titleTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const CategorySurveyScreen();
                        }));
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                            color: CustomColor.subTitleTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                )),
            categoryList == null
                ? Container()
                : categoryList!.isEmpty
                    ? Container()
                    : Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(top: 10),
                        //  height: 230,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 3,
                                    childAspectRatio: 3),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categoryList?.length.clamp(0, 6),
                            itemBuilder: (BuildContext context, int index) {
                              int? id = categoryList?[index]['id'];
                              String? image = categoryList?[index]['image'];
                              String? technology = categoryList?[index]['name'];
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return CategoryListScreen(technology!, id!);
                                  }));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.45,
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(7.0),
                                        topRight: Radius.circular(7.0),
                                        bottomLeft: Radius.circular(7.0),
                                        bottomRight: Radius.circular(7.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 1,
                                        offset: const Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        image == null
                                            ? Image.asset(
                                                'assets/images/science.png',height: 40,width: 40,
                                          fit: BoxFit.fill,)
                                            : Image.network(
                                                image,
                                                height: 40,
                                                width: 40,
                                      fit: BoxFit.fill,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Image.asset(
                                                      'assets/images/science.png',height: 40,width: 40,
                                                    fit: BoxFit.fill,);
                                                },
                                              ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        technology == null
                                            ? Container()
                                            : Container(
                                          width: MediaQuery.of(context).size.width*0.25,
                                              child: Text(
                                                  technology,
                                                  // 'Science',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                overflow: TextOverflow.ellipsis,
                                                ),
                                            )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            // primary: false,
                            // padding: const EdgeInsets.all(20),
                            // children: <Widget>[
                            //   Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.white),
                            //       borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(7.0),
                            //           topRight: Radius.circular(7.0),
                            //           bottomLeft: Radius.circular(7.0),
                            //           bottomRight: Radius.circular(7.0)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           spreadRadius: 2,
                            //           blurRadius: 1,
                            //           offset:
                            //               const Offset(0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Row(
                            //         children: [
                            //           Image.asset('assets/images/science.png'),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           const Text(
                            //             'Science',
                            //             style: TextStyle(
                            //                 color: Colors.black,
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w700),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            //   Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.white),
                            //       borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(7.0),
                            //           topRight: Radius.circular(7.0),
                            //           bottomLeft: Radius.circular(7.0),
                            //           bottomRight: Radius.circular(7.0)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           spreadRadius: 2,
                            //           blurRadius: 1,
                            //           offset:
                            //               const Offset(0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Row(
                            //         children: [
                            //           Image.asset('assets/images/social.png'),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           const Text(
                            //             'Sociali',
                            //             style: TextStyle(
                            //                 color: Colors.black,
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w700),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            //   Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.white),
                            //       borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(7.0),
                            //           topRight: Radius.circular(7.0),
                            //           bottomLeft: Radius.circular(7.0),
                            //           bottomRight: Radius.circular(7.0)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           spreadRadius: 2,
                            //           blurRadius: 1,
                            //           offset:
                            //               const Offset(0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Row(
                            //         children: [
                            //           Image.asset('assets/images/technology.png'),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           const Text(
                            //             'Technology',
                            //             style: TextStyle(
                            //                 color: Colors.black,
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w700),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            //   Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.white),
                            //       borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(7.0),
                            //           topRight: Radius.circular(7.0),
                            //           bottomLeft: Radius.circular(7.0),
                            //           bottomRight: Radius.circular(7.0)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           spreadRadius: 2,
                            //           blurRadius: 1,
                            //           offset:
                            //               const Offset(0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Row(
                            //         children: [
                            //           Image.asset('assets/images/gaming.png'),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           const Text(
                            //             'Gaming',
                            //             style: TextStyle(
                            //                 color: Colors.black,
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w700),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            //   Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.white),
                            //       borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(7.0),
                            //           topRight: Radius.circular(7.0),
                            //           bottomLeft: Radius.circular(7.0),
                            //           bottomRight: Radius.circular(7.0)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           spreadRadius: 2,
                            //           blurRadius: 1,
                            //           offset:
                            //               const Offset(0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Row(
                            //         children: [
                            //           Image.asset('assets/images/history.png'),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           const Text(
                            //             'History',
                            //             style: TextStyle(
                            //                 color: Colors.black,
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w700),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            //   Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.white),
                            //       borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(7.0),
                            //           topRight: Radius.circular(7.0),
                            //           bottomLeft: Radius.circular(7.0),
                            //           bottomRight: Radius.circular(7.0)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           spreadRadius: 2,
                            //           blurRadius: 1,
                            //           offset:
                            //               const Offset(0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Row(
                            //         children: [
                            //           Image.asset('assets/images/analytics.png'),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           const Text(
                            //             'Analytics',
                            //             style: TextStyle(
                            //                 color: Colors.black,
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w700),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ],
                          ),
                        ),
                    ),
            upcomingSurveyList == null||upcomingSurveyList!.isEmpty?Container():    Container(
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Upcoming Survey',
                      style: TextStyle(
                          color: CustomColor.titleTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const UpcomingSurveyScreen();
                        }));
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                            color: CustomColor.subTitleTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                )),
            upcomingSurveyList == null
                ? Container()
                : upcomingSurveyList!.isEmpty
                    ? Container()
                    : SizedBox(
                        height: 195,
                        child: ListView.builder(
                          itemCount: upcomingSurveyList?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            int? id = upcomingSurveyList?[index]['id'];
                            String? image =
                                upcomingSurveyList?[index]['image'];
                            String? heading =
                                upcomingSurveyList?[index]['heading'];
                            String? date =
                                upcomingSurveyList![index]['created_at'];
                            String? publishDate =
                                upcomingSurveyList![index]['published_date'];
                            DateTime dt2 = DateTime.parse(publishDate!);
                            String formattedDate =
                            DateFormat('MMM, dd, y').format(dt2);

                            print(formattedDate);
                            return Container(
                              width: 180,
                              margin: const EdgeInsets.only(
                                  top: 15, left: 20, right: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(7.0),
                                    topRight: Radius.circular(7.0),
                                    bottomLeft: Radius.circular(7.0),
                                    bottomRight: Radius.circular(7.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 1,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    image == null
                                        ? Image.asset(
                                            'assets/images/image_not_found.png',
                                            height: 100,
                                            width: 100,
                                      fit: BoxFit.fill,
                                          )
                                        : Image.network(
                                            image,
                                            height: 100,
                                            width: 100,
                                  fit: BoxFit.fill,
                                            errorBuilder:
                                                (BuildContext context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                              return Image.asset(
                                                'assets/images/image_not_found.png',
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.fill,
                                              );
                                            },
                                          ),
                                    heading == null
                                        ? Container()
                                        : Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                              heading,
                                              // 'Course Evaluation Survey',
                                              style: const TextStyle(
                                                  color:
                                                      CustomColor.buttonColor,
                                                  fontSize: 14,
                                                  height: 1.3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight:
                                                      FontWeight.w400),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                    publishDate == null
                                        ? Container()
                                        : Container(
                                            // color: Colors.yellow,
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/clock_icon.png',
                                                  height: 20,
                                                ),
                                                Text(
                                                  formattedDate,
                                                //  publishDate,
                                                  // 'May, 13, 2023',
                                                  style: const TextStyle(
                                                      color: CustomColor
                                                          .subTitleTextColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            );
                          },
                          // children: [
                          //   Container(
                          //     width:170,
                          //     margin: const EdgeInsets.only(top: 15, left: 20, right: 5),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(color: Colors.white),
                          //       borderRadius: const BorderRadius.only(
                          //           topLeft: Radius.circular(7.0),
                          //           topRight: Radius.circular(7.0),
                          //           bottomLeft: Radius.circular(7.0),
                          //           bottomRight: Radius.circular(7.0)),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.grey.withOpacity(0.1),
                          //           spreadRadius: 2,
                          //           blurRadius: 1,
                          //           offset:
                          //           const Offset(0, 1), // changes position of shadow
                          //         ),
                          //       ],
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(10.0),
                          //       child: Column(
                          //         children: [
                          //           Image.asset(
                          //             'assets/images/img7.png',
                          //             height: 80,),
                          //           Container(
                          //             margin:
                          //             const EdgeInsets.only(top: 5),
                          //             child: const Text(
                          //               'Course Evaluation Survey',
                          //               style: TextStyle(
                          //                   color: CustomColor.buttonColor,
                          //                   fontSize: 14,
                          //                   height: 1.3,
                          //                   fontWeight: FontWeight.w400),
                          //               textAlign: TextAlign.center,
                          //             ),
                          //           ),
                          //           Container(
                          //             // color: Colors.yellow,
                          //             margin:
                          //             const EdgeInsets.only(top: 5),
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: [
                          //                 Image.asset(
                          //                   'assets/images/clock_icon.png',
                          //                   height: 20,
                          //                 ),
                          //                 const Text(
                          //                   'May, 13, 2023',
                          //                   style: TextStyle(
                          //                       color: CustomColor.subTitleTextColor,
                          //                       fontSize: 12,
                          //                       fontWeight: FontWeight.normal),
                          //                 ),
                          //
                          //               ],
                          //             ),
                          //           )
                          //
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          //   Container(
                          //     width:170,
                          //     margin: const EdgeInsets.only(top: 15, left: 10, right: 5),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(color: Colors.white),
                          //       borderRadius: const BorderRadius.only(
                          //           topLeft: Radius.circular(7.0),
                          //           topRight: Radius.circular(7.0),
                          //           bottomLeft: Radius.circular(7.0),
                          //           bottomRight: Radius.circular(7.0)),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.grey.withOpacity(0.1),
                          //           spreadRadius: 2,
                          //           blurRadius: 1,
                          //           offset:
                          //           const Offset(0, 1), // changes position of shadow
                          //         ),
                          //       ],
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(10.0),
                          //       child: Column(
                          //         children: [
                          //           Image.asset(
                          //             'assets/images/img5.png',
                          //             height: 80,),
                          //           Container(
                          //             margin:
                          //             const EdgeInsets.only(top: 5),
                          //             child: const Text(
                          //               'Course Evaluation Survey',
                          //               style: TextStyle(
                          //                   color: CustomColor.buttonColor,
                          //                   fontSize: 14,
                          //                   height: 1.3,
                          //                   fontWeight: FontWeight.w400),
                          //               textAlign: TextAlign.center,
                          //             ),
                          //           ),
                          //           Container(
                          //             // color: Colors.yellow,
                          //             margin:
                          //             const EdgeInsets.only(top: 5),
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: [
                          //                 Image.asset(
                          //                   'assets/images/clock_icon.png',
                          //                   height: 20,
                          //                 ),
                          //                 const Text(
                          //                   'May, 13, 2023',
                          //                   style: TextStyle(
                          //                       color: CustomColor.subTitleTextColor,
                          //                       fontSize: 12,
                          //                       fontWeight: FontWeight.normal),
                          //                 ),
                          //
                          //               ],
                          //             ),
                          //           )
                          //
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          //   Container(
                          //     width:170,
                          //     margin: const EdgeInsets.only(top: 15, left: 10, right: 5),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(color: Colors.white),
                          //       borderRadius: const BorderRadius.only(
                          //           topLeft: Radius.circular(7.0),
                          //           topRight: Radius.circular(7.0),
                          //           bottomLeft: Radius.circular(7.0),
                          //           bottomRight: Radius.circular(7.0)),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.grey.withOpacity(0.1),
                          //           spreadRadius: 2,
                          //           blurRadius: 1,
                          //           offset:
                          //           const Offset(0, 1), // changes position of shadow
                          //         ),
                          //       ],
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(10.0),
                          //       child: Column(
                          //         children: [
                          //           Image.asset(
                          //             'assets/images/img6.png',
                          //             height: 80,),
                          //           Container(
                          //             margin:
                          //             const EdgeInsets.only(top: 5),
                          //             child: const Text(
                          //               'Course Evaluation Survey',
                          //               style: TextStyle(
                          //                   color: CustomColor.buttonColor,
                          //                   fontSize: 14,
                          //                   height: 1.3,
                          //                   fontWeight: FontWeight.w400),
                          //               textAlign: TextAlign.center,
                          //             ),
                          //           ),
                          //           Container(
                          //             // color: Colors.yellow,
                          //             margin:
                          //             const EdgeInsets.only(top: 5),
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: [
                          //                 Image.asset(
                          //                   'assets/images/clock_icon.png',
                          //                   height: 20,
                          //                 ),
                          //                 const Text(
                          //                   'May, 13, 2023',
                          //                   style: TextStyle(
                          //                       color: CustomColor.subTitleTextColor,
                          //                       fontSize: 12,
                          //                       fontWeight: FontWeight.normal),
                          //                 ),
                          //
                          //               ],
                          //             ),
                          //           )
                          //
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ],
                        ),
                      ),
            newSurveyList == null||newSurveyList!.isEmpty?Container():   Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'New Surveys',
                    style: TextStyle(
                        color: CustomColor.titleTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '',
                    style: TextStyle(
                        color: CustomColor.subTitleTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            newSurveyList == null
                ? Container()
                : newSurveyList!.isEmpty
                    ? Container()
                    : Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                         // height: 400,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: newSurveyList?.length,
                            itemBuilder: (BuildContext context, int index) {
                              int? id = newSurveyList?[index]['id'];
                              int? categoryId =
                                  newSurveyList?[index]['category_id'];
                              String? image = newSurveyList?[index]['image'];
                              String? heading =
                                  newSurveyList?[index]['heading'];
                              String? description =
                                  newSurveyList?[index]['description'];

                              return Material(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return RadioSurveyScreen(id!, heading!,"new");
                                    }));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 15, left: 20, right: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(7.0),
                                          topRight: Radius.circular(7.0),
                                          bottomLeft: Radius.circular(7.0),
                                          bottomRight: Radius.circular(7.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 1,
                                          offset: const Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            child: image == null
                                                ? Image.asset(
                                                    'assets/images/image_not_found.png',
                                                    height: 80,
                                                    width: 80,
                                              fit: BoxFit.fill,
                                                  )
                                                : Image.network(
                                                    image,
                                                    height: 80,
                                                    width: 80,
                                                fit: BoxFit.fill,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        'assets/images/image_not_found.png',
                                                        height: 80,
                                                        width: 80,
                                                        fit: BoxFit.fill,
                                                      );
                                                    },
                                                  ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                heading == null
                                                    ? Container()
                                                    : Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.58,
                                                        child: Text(
                                                          heading,
                                                          //'Role of Education Surveys',
                                                          style: const TextStyle(
                                                              color: CustomColor
                                                                  .titleTextColor,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                description == null
                                                    ? Container()
                                                    : Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.58,
                                                        margin: const EdgeInsets
                                                            .only(top: 7),
                                                        child: Text(
                                                          description,
                                                          // 'Technology Meter',
                                                          style: const TextStyle(
                                                              color: CustomColor
                                                                  .subTitleTextColor,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                Container(
                                                  // color: Colors.yellow,
                                                  margin: const EdgeInsets.only(
                                                      top: 7, bottom: 5),

                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.58,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xffFDBB18),
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xffFDBB18),
                                                          ),
                                                          borderRadius: const BorderRadius
                                                                  .only(
                                                              topLeft:
                                                                  Radius
                                                                      .circular(
                                                                          5.0),
                                                              topRight:
                                                                  Radius
                                                                      .circular(
                                                                          5.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      5.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5.0)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.2),
                                                              spreadRadius: 2,
                                                              blurRadius: 3,
                                                              offset: const Offset(
                                                                  0,
                                                                  1), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15.0,
                                                                  right: 15,
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: Text(
                                                            'Start Survey',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Image.asset(
                                                          'assets/images/share_icon.png',
                                                          height: 20,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            // children: [
                            //   Container(
                            //     margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.white),
                            //       borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(7.0),
                            //           topRight: Radius.circular(7.0),
                            //           bottomLeft: Radius.circular(7.0),
                            //           bottomRight: Radius.circular(7.0)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           spreadRadius: 2,
                            //           blurRadius: 1,
                            //           offset:
                            //               const Offset(0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(5.0),
                            //       child: Row(
                            //         children: [
                            //           Container(
                            //             child: Image.asset(
                            //               'assets/images/img4.png',
                            //               height: 80,
                            //             ),
                            //             margin: const EdgeInsets.only(left: 5),
                            //           ),
                            //           Container(
                            //             margin: const EdgeInsets.only(left: 10, top: 5),
                            //             child: Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Container(
                            //                   child: const Text(
                            //                     'Role of Education Surveys',
                            //                     style: TextStyle(
                            //                         color: CustomColor.titleTextColor,
                            //                         fontSize: 15,
                            //                         fontWeight: FontWeight.w500),
                            //                   ),
                            //                 ),
                            //                 Container(
                            //                   margin: const EdgeInsets.only(top: 7),
                            //                   child: const Text(
                            //                     'Technology Meter',
                            //                     style: TextStyle(
                            //                         color: CustomColor.subTitleTextColor,
                            //                         fontSize: 13,
                            //                         fontWeight: FontWeight.normal),
                            //                   ),
                            //                 ),
                            //                 Container(
                            //                   // color: Colors.yellow,
                            //                   margin:
                            //                       const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                       MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         decoration: BoxDecoration(
                            //                           color: Color(0xffFDBB18),
                            //                           border: Border.all(
                            //                             color: Color(0xffFDBB18),
                            //                           ),
                            //                           borderRadius: const BorderRadius.only(
                            //                               topLeft: Radius.circular(5.0),
                            //                               topRight: Radius.circular(5.0),
                            //                               bottomLeft: Radius.circular(5.0),
                            //                               bottomRight:
                            //                                   Radius.circular(5.0)),
                            //                           boxShadow: [
                            //                             BoxShadow(
                            //                               color:
                            //                                   Colors.grey.withOpacity(0.2),
                            //                               spreadRadius: 2,
                            //                               blurRadius: 3,
                            //                               offset: const Offset(0,
                            //                                   1), // changes position of shadow
                            //                             ),
                            //                           ],
                            //                         ),
                            //                         child: const Padding(
                            //                           padding: EdgeInsets.only(
                            //                               left: 15.0,
                            //                               right: 15,
                            //                               top: 5,
                            //                               bottom: 5),
                            //                           child: Text(
                            //                             'Start Survey',
                            //                             style: TextStyle(
                            //                                 color: Colors.white,
                            //                                 fontSize: 13,
                            //                                 fontWeight: FontWeight.normal),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/share_icon.png',
                            //                           height: 20,
                            //                         ),
                            //                       )
                            //                     ],
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            //   Container(
                            //     margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.white),
                            //       borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(7.0),
                            //           topRight: Radius.circular(7.0),
                            //           bottomLeft: Radius.circular(7.0),
                            //           bottomRight: Radius.circular(7.0)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           spreadRadius: 2,
                            //           blurRadius: 1,
                            //           offset:
                            //               const Offset(0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(5.0),
                            //       child: Row(
                            //         children: [
                            //           Container(
                            //             margin: const EdgeInsets.only(left: 5),
                            //             child: Image.asset(
                            //               'assets/images/img1.png',
                            //               height: 80,
                            //             ),
                            //           ),
                            //           Container(
                            //             margin: const EdgeInsets.only(left: 10, top: 5),
                            //             child: Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Container(
                            //                   child: const Text(
                            //                     'Role of Education Surveys',
                            //                     style: TextStyle(
                            //                         color: CustomColor.titleTextColor,
                            //                         fontSize: 15,
                            //                         fontWeight: FontWeight.w500),
                            //                   ),
                            //                 ),
                            //                 Container(
                            //                   margin: const EdgeInsets.only(top: 7),
                            //                   child: const Text(
                            //                     'Technology Meter',
                            //                     style: TextStyle(
                            //                         color: CustomColor.subTitleTextColor,
                            //                         fontSize: 13,
                            //                         fontWeight: FontWeight.normal),
                            //                   ),
                            //                 ),
                            //                 Container(
                            //                   // color: Colors.yellow,
                            //                   margin:
                            //                       const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                       MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         decoration: BoxDecoration(
                            //                           color: const Color(0xffFDBB18),
                            //                           border: Border.all(
                            //                             color: const Color(0xffFDBB18),
                            //                           ),
                            //                           borderRadius: const BorderRadius.only(
                            //                               topLeft: Radius.circular(5.0),
                            //                               topRight: Radius.circular(5.0),
                            //                               bottomLeft: Radius.circular(5.0),
                            //                               bottomRight:
                            //                                   Radius.circular(5.0)),
                            //                           boxShadow: [
                            //                             BoxShadow(
                            //                               color:
                            //                                   Colors.grey.withOpacity(0.2),
                            //                               spreadRadius: 2,
                            //                               blurRadius: 3,
                            //                               offset: const Offset(0,
                            //                                   1), // changes position of shadow
                            //                             ),
                            //                           ],
                            //                         ),
                            //                         child: Padding(
                            //                           padding: const EdgeInsets.only(
                            //                               left: 15.0,
                            //                               right: 15,
                            //                               top: 5,
                            //                               bottom: 5),
                            //                           child: Text(
                            //                             'Start Survey',
                            //                             style: TextStyle(
                            //                                 color: Colors.white,
                            //                                 fontSize: 13,
                            //                                 fontWeight: FontWeight.normal),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/share_icon.png',
                            //                           height: 20,
                            //                         ),
                            //                       )
                            //                     ],
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            //   Container(
                            //     margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.white),
                            //       borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(7.0),
                            //           topRight: Radius.circular(7.0),
                            //           bottomLeft: Radius.circular(7.0),
                            //           bottomRight: Radius.circular(7.0)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           spreadRadius: 2,
                            //           blurRadius: 1,
                            //           offset:
                            //               const Offset(0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(5.0),
                            //       child: Row(
                            //         children: [
                            //           Container(
                            //             child: Image.asset(
                            //               'assets/images/img2.png',
                            //               height: 80,
                            //             ),
                            //             margin: const EdgeInsets.only(left: 5),
                            //           ),
                            //           Container(
                            //             margin: const EdgeInsets.only(left: 10, top: 5),
                            //             child: Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Container(
                            //                   child: Text(
                            //                     'Role of Education Surveys',
                            //                     style: TextStyle(
                            //                         color: CustomColor.titleTextColor,
                            //                         fontSize: 15,
                            //                         fontWeight: FontWeight.w500),
                            //                   ),
                            //                 ),
                            //                 Container(
                            //                   margin: const EdgeInsets.only(top: 7),
                            //                   child: Text(
                            //                     'Technology Meter',
                            //                     style: TextStyle(
                            //                         color: CustomColor.subTitleTextColor,
                            //                         fontSize: 13,
                            //                         fontWeight: FontWeight.normal),
                            //                   ),
                            //                 ),
                            //                 Container(
                            //                   // color: Colors.yellow,
                            //                   margin:
                            //                       const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                       MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         decoration: BoxDecoration(
                            //                           color: Color(0xffFDBB18),
                            //                           border: Border.all(
                            //                             color: Color(0xffFDBB18),
                            //                           ),
                            //                           borderRadius: const BorderRadius.only(
                            //                               topLeft: Radius.circular(5.0),
                            //                               topRight: Radius.circular(5.0),
                            //                               bottomLeft: Radius.circular(5.0),
                            //                               bottomRight:
                            //                                   Radius.circular(5.0)),
                            //                           boxShadow: [
                            //                             BoxShadow(
                            //                               color:
                            //                                   Colors.grey.withOpacity(0.2),
                            //                               spreadRadius: 2,
                            //                               blurRadius: 3,
                            //                               offset: const Offset(0,
                            //                                   1), // changes position of shadow
                            //                             ),
                            //                           ],
                            //                         ),
                            //                         child: Padding(
                            //                           padding: const EdgeInsets.only(
                            //                               left: 15.0,
                            //                               right: 15,
                            //                               top: 5,
                            //                               bottom: 5),
                            //                           child: Text(
                            //                             'Start Survey',
                            //                             style: TextStyle(
                            //                                 color: Colors.white,
                            //                                 fontSize: 13,
                            //                                 fontWeight: FontWeight.normal),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/share_icon.png',
                            //                           height: 20,
                            //                         ),
                            //                       )
                            //                     ],
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            //   Container(
                            //     margin: const EdgeInsets.only(
                            //         top: 10, left: 20, right: 20, bottom: 20),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.white),
                            //       borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(7.0),
                            //           topRight: Radius.circular(7.0),
                            //           bottomLeft: Radius.circular(7.0),
                            //           bottomRight: Radius.circular(7.0)),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           spreadRadius: 2,
                            //           blurRadius: 1,
                            //           offset:
                            //               const Offset(0, 1), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(5.0),
                            //       child: Row(
                            //         children: [
                            //           Container(
                            //             child: Image.asset(
                            //               'assets/images/img3.png',
                            //               height: 80,
                            //             ),
                            //             margin: const EdgeInsets.only(left: 5),
                            //           ),
                            //           Container(
                            //             margin: const EdgeInsets.only(left: 10, top: 5),
                            //             child: Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Container(
                            //                   child: Text(
                            //                     'Role of Education Surveys',
                            //                     style: TextStyle(
                            //                         color: CustomColor.titleTextColor,
                            //                         fontSize: 15,
                            //                         fontWeight: FontWeight.w500),
                            //                   ),
                            //                 ),
                            //                 Container(
                            //                   margin: const EdgeInsets.only(top: 7),
                            //                   child: Text(
                            //                     'Technology Meter',
                            //                     style: TextStyle(
                            //                         color: CustomColor.subTitleTextColor,
                            //                         fontSize: 13,
                            //                         fontWeight: FontWeight.normal),
                            //                   ),
                            //                 ),
                            //                 Container(
                            //                   // color: Colors.yellow,
                            //                   margin:
                            //                       const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                       MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         decoration: BoxDecoration(
                            //                           color: Color(0xffFDBB18),
                            //                           border: Border.all(
                            //                             color: Color(0xffFDBB18),
                            //                           ),
                            //                           borderRadius: const BorderRadius.only(
                            //                               topLeft: Radius.circular(5.0),
                            //                               topRight: Radius.circular(5.0),
                            //                               bottomLeft: Radius.circular(5.0),
                            //                               bottomRight:
                            //                                   Radius.circular(5.0)),
                            //                           boxShadow: [
                            //                             BoxShadow(
                            //                               color:
                            //                                   Colors.grey.withOpacity(0.2),
                            //                               spreadRadius: 2,
                            //                               blurRadius: 3,
                            //                               offset: const Offset(0,
                            //                                   1), // changes position of shadow
                            //                             ),
                            //                           ],
                            //                         ),
                            //                         child: Padding(
                            //                           padding: const EdgeInsets.only(
                            //                               left: 15.0,
                            //                               right: 15,
                            //                               top: 5,
                            //                               bottom: 5),
                            //                           child: Text(
                            //                             'Start Survey',
                            //                             style: TextStyle(
                            //                                 color: Colors.white,
                            //                                 fontSize: 13,
                            //                                 fontWeight: FontWeight.normal),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/share_icon.png',
                            //                           height: 20,
                            //                         ),
                            //                       )
                            //                     ],
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ],
                          ),
                        ),
                    )
          ],
        ),
      ),
    );
  }
}
