import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loyola/src/radio_survey_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';

class SurveyHistoryScreen extends StatefulWidget {
  const SurveyHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SurveyHistoryScreen> createState() => _SurveyHistoryScreenState();
}

class _SurveyHistoryScreenState extends State<SurveyHistoryScreen> {
  int? userID;
  late int initialData;
  List? surveyHistoryList;

  @override
  void initState() {
    initialData = 0;
    super.initState();
    getLoginData();
  }

  getLoginData() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getInt("userId");
      fetchSurveyHistorySList();
    });
  }

  fetchSurveyHistorySList() {
    CommonClass().showWait(context);
    final body = {
      "user_id": userID.toString(),
      "status": initialData == 0 ? "completed" : "incompleted"
    };
    ApiService().getSurveyHistoryList(body).then((value) => setState(() {
          CommonClass().dismissDialog(context);
          surveyHistoryList = value['data'];
          print("Survey History List $surveyHistoryList");
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
                    "Surveys History ",
                    // userName ?? "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: ToggleSwitch(
                    minWidth: MediaQuery.of(context).size.width * 0.4,
                    minHeight: 45,
                    initialLabelIndex: initialData,
                    activeBgColor: const [CustomColor.buttonColor],
                    activeBorders: [Border.all(color: CustomColor.buttonColor)],
                    inactiveBgColor: Colors.white,
                    borderColor: [Colors.black12],
                    fontSize: 16,
                    borderWidth: 1,
                    totalSwitches: 2,
                    labels: const ['Completed', 'InCompleted'],
                    onToggle: (index) {
                      initialData = index!;
                      print('switched to: $initialData');
                      fetchSurveyHistorySList();
                    },
                  ),
                ),
              ),
              surveyHistoryList == null
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: const Center(
                        child: Text(''),
                      ),
                    )
                  : surveyHistoryList!.isEmpty
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const Center(
                            child: Text('Data Not Found'),
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView.builder(
                            itemCount: surveyHistoryList?.length,
                            itemBuilder: (BuildContext context, int index) {
                              int? id = surveyHistoryList?[index]['survey_id'];
                              int? categoryId =
                                  surveyHistoryList?[index]['category_id'];
                              String? heading =
                                  surveyHistoryList?[index]['survey']['heading'];
                              String? description = surveyHistoryList?[index]
                                  ['survey']['description'];
                              String? status =
                                  surveyHistoryList?[index]['survey']['status'];
                              String? image =
                                  surveyHistoryList?[index]['survey']['image'];
                              String? createdAt =
                                  surveyHistoryList?[index]['created_at'];
                              DateTime dt2 = DateTime.parse(createdAt!);
                              String formattedDate =
                              DateFormat('MMM, dd, y').format(dt2);
                                 // DateFormat('d-MM-y HH:mm').format(dt2);
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return RadioSurveyScreen(id!, heading!,initialData == 0 ? "completed" : "incomplete");
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
                                        offset: const Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(left: 5),
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
                                                          StackTrace? stackTrace) {
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
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.58,
                                                      child: Text(
                                                        heading,
                                                        // 'School climate survey',
                                                        style: const TextStyle(
                                                            color: CustomColor
                                                                .titleTextColor,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                              description == null
                                                  ? Container()
                                                  : Container(
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.58,
                                                      margin: const EdgeInsets.only(
                                                          top: 7),
                                                      child: Text(
                                                        description,
                                                        // 'Technology Meter',
                                                        style: const TextStyle(
                                                            color: CustomColor
                                                                .subTitleTextColor,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.normal),
                                                        overflow:
                                                            TextOverflow.ellipsis,
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
                                                    createdAt == null
                                                        ? Container()
                                                        : Container(
                                                            // color: Colors.yellow,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  'assets/images/clock_icon.png',
                                                                  height: 20,
                                                                ),
                                                                const SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                  formattedDate,
                                                                  // 'May, 13, 2023',
                                                                  style: const TextStyle(
                                                                      color: CustomColor
                                                                          .subTitleTextColor,
                                                                      fontSize: 12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                    Container(
                                                      child: Image.asset(
                                                        'assets/images/next_icon.png',
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
                              );
                            },
                            // shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics()
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
                            //           const Offset(0, 1), // changes position of shadow
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
                            //                     'School climate survey',
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
                            //                   const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                   MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         // color: Colors.yellow,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Image.asset(
                            //                               'assets/images/clock_icon.png',
                            //                               height: 20,
                            //                             ),
                            //                             SizedBox(width: 3,),
                            //                             const Text(
                            //                               'May, 13, 2023',
                            //                               style: TextStyle(
                            //                                   color: CustomColor.subTitleTextColor,
                            //                                   fontSize: 12,
                            //                                   fontWeight: FontWeight.normal),
                            //                             ),
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/next_icon.png',
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
                            //           const Offset(0, 1), // changes position of shadow
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
                            //               'assets/images/img4.png',
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
                            //                     'School climate survey',
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
                            //                   const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                   MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         // color: Colors.yellow,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Image.asset(
                            //                               'assets/images/clock_icon.png',
                            //                               height: 20,
                            //                             ),
                            //                             SizedBox(width: 3,),
                            //                             const Text(
                            //                               'May, 13, 2023',
                            //                               style: TextStyle(
                            //                                   color: CustomColor.subTitleTextColor,
                            //                                   fontSize: 12,
                            //                                   fontWeight: FontWeight.normal),
                            //                             ),
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/next_icon.png',
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
                            //
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
                            //           const Offset(0, 1), // changes position of shadow
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
                            //                     'School climate survey',
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
                            //                   const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                   MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         // color: Colors.yellow,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Image.asset(
                            //                               'assets/images/clock_icon.png',
                            //                               height: 20,
                            //                             ),
                            //                             SizedBox(width: 3,),
                            //                             const Text(
                            //                               'May, 13, 2023',
                            //                               style: TextStyle(
                            //                                   color: CustomColor.subTitleTextColor,
                            //                                   fontSize: 12,
                            //                                   fontWeight: FontWeight.normal),
                            //                             ),
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/next_icon.png',
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
                            //           const Offset(0, 1), // changes position of shadow
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
                            //               'assets/images/img4.png',
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
                            //                     'School climate survey',
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
                            //                   const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                   MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         // color: Colors.yellow,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Image.asset(
                            //                               'assets/images/clock_icon.png',
                            //                               height: 20,
                            //                             ),
                            //                             SizedBox(width: 3,),
                            //                             const Text(
                            //                               'May, 13, 2023',
                            //                               style: TextStyle(
                            //                                   color: CustomColor.subTitleTextColor,
                            //                                   fontSize: 12,
                            //                                   fontWeight: FontWeight.normal),
                            //                             ),
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/next_icon.png',
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
                            //
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
                            //           const Offset(0, 1), // changes position of shadow
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
                            //                     'School climate survey',
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
                            //                   const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                   MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         // color: Colors.yellow,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Image.asset(
                            //                               'assets/images/clock_icon.png',
                            //                               height: 20,
                            //                             ),
                            //                             SizedBox(width: 3,),
                            //                             const Text(
                            //                               'May, 13, 2023',
                            //                               style: TextStyle(
                            //                                   color: CustomColor.subTitleTextColor,
                            //                                   fontSize: 12,
                            //                                   fontWeight: FontWeight.normal),
                            //                             ),
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/next_icon.png',
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
                            //           const Offset(0, 1), // changes position of shadow
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
                            //               'assets/images/img4.png',
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
                            //                     'School climate survey',
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
                            //                   const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                   MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         // color: Colors.yellow,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Image.asset(
                            //                               'assets/images/clock_icon.png',
                            //                               height: 20,
                            //                             ),
                            //                             SizedBox(width: 3,),
                            //                             const Text(
                            //                               'May, 13, 2023',
                            //                               style: TextStyle(
                            //                                   color: CustomColor.subTitleTextColor,
                            //                                   fontSize: 12,
                            //                                   fontWeight: FontWeight.normal),
                            //                             ),
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/next_icon.png',
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
                            //
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
                            //           const Offset(0, 1), // changes position of shadow
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
                            //                     'School climate survey',
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
                            //                   const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                   MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         // color: Colors.yellow,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Image.asset(
                            //                               'assets/images/clock_icon.png',
                            //                               height: 20,
                            //                             ),
                            //                             SizedBox(width: 3,),
                            //                             const Text(
                            //                               'May, 13, 2023',
                            //                               style: TextStyle(
                            //                                   color: CustomColor.subTitleTextColor,
                            //                                   fontSize: 12,
                            //                                   fontWeight: FontWeight.normal),
                            //                             ),
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/next_icon.png',
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
                            //           const Offset(0, 1), // changes position of shadow
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
                            //               'assets/images/img4.png',
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
                            //                     'School climate survey',
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
                            //                   const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                   MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         // color: Colors.yellow,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Image.asset(
                            //                               'assets/images/clock_icon.png',
                            //                               height: 20,
                            //                             ),
                            //                             SizedBox(width: 3,),
                            //                             const Text(
                            //                               'May, 13, 2023',
                            //                               style: TextStyle(
                            //                                   color: CustomColor.subTitleTextColor,
                            //                                   fontSize: 12,
                            //                                   fontWeight: FontWeight.normal),
                            //                             ),
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/next_icon.png',
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
                            //
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
                            //           const Offset(0, 1), // changes position of shadow
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
                            //                     'School climate survey',
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
                            //                   const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                   MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         // color: Colors.yellow,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Image.asset(
                            //                               'assets/images/clock_icon.png',
                            //                               height: 20,
                            //                             ),
                            //                             SizedBox(width: 3,),
                            //                             const Text(
                            //                               'May, 13, 2023',
                            //                               style: TextStyle(
                            //                                   color: CustomColor.subTitleTextColor,
                            //                                   fontSize: 12,
                            //                                   fontWeight: FontWeight.normal),
                            //                             ),
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/next_icon.png',
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
                            //           const Offset(0, 1), // changes position of shadow
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
                            //               'assets/images/img4.png',
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
                            //                     'School climate survey',
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
                            //                   const EdgeInsets.only(top: 7, bottom: 5),
                            //
                            //                   width:
                            //                   MediaQuery.of(context).size.width * 0.6,
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                     children: [
                            //                       Container(
                            //                         // color: Colors.yellow,
                            //                         child: Row(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Image.asset(
                            //                               'assets/images/clock_icon.png',
                            //                               height: 20,
                            //                             ),
                            //                             SizedBox(width: 3,),
                            //                             const Text(
                            //                               'May, 13, 2023',
                            //                               style: TextStyle(
                            //                                   color: CustomColor.subTitleTextColor,
                            //                                   fontSize: 12,
                            //                                   fontWeight: FontWeight.normal),
                            //                             ),
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         child: Image.asset(
                            //                           'assets/images/next_icon.png',
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
            ],
          ),
        ),
      ),
    );
  }
}
