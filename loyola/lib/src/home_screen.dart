import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loyola/src/complete_survey_screen.dart';
import 'package:loyola/src/incompleted_survey_screen.dart';
import 'package:loyola/src/pending_survey_screen.dart';
import 'package:loyola/src/profile_screen.dart';
import 'package:loyola/src/radio_survey_screen.dart';
import 'package:loyola/src/recently_added_screen.dart';
import 'package:loyola/src/surveys_history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? userID;
  String? userName;
  List? totalStatusList;
  List? profileList;
  List? recentlyAddedList;
  String? name;
  int completed = 00;
  int pending = 00;
  int incompleted = 00;

  void getProfileData() {
    CommonClass().showWait(context);
    ApiService().getProfile(userID!).then((value) => setState(() {
          CommonClass().dismissDialog(context);
          profileList = value['data'];

          name = profileList![0]['name'];

          /// image = profileList![0]['image'];
        }));
  }

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
      print("user id $userID");

      fetchTotalStatusList();
      getProfileData();
    });
  }

  fetchTotalStatusList() {
    final body = {"user_id": userID.toString()};
    ApiService().getDashboard(body).then((value) => setState(() {
          totalStatusList = value['data'];
          completed = totalStatusList?[0]['totalComplate'];
          pending = totalStatusList?[0]['totalPending'];
          incompleted = totalStatusList?[0]['totalIncomplate'];
          recentlyAddedList = totalStatusList?[0]['recently_added'];
          print("total Status List $recentlyAddedList");
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
        // backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80), // Set this height
          child: Container(
              padding: const EdgeInsets.only(
                  top: 40, bottom: 10, left: 20, right: 20),
              color: CustomColor.buttonColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back,",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    name ?? '',
                    //"Carolina Terner",
                    // userName ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )),
        ),
        body: ListView(
          children: [
            Stack(
              children: [
                Container(
                  color: CustomColor.buttonColor,
                  height: 60,
                ),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    //   .builder(
                    // itemCount: totalStatusList?.length,
                    // scrollDirection: Axis.horizontal,
                    // itemBuilder: (BuildContext context, int index) {
                    //   String? statusName = totalStatusList?[index]['status'];
                    //   String? statusCount = totalStatusList?[index]['count'];
                    //   return Container(
                    //     width: MediaQuery.of(context).size.width * 0.3,
                    //     margin: const EdgeInsets.only(
                    //         left: 20, right: 10, bottom: 5),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border.all(color: Colors.white),
                    //       borderRadius: const BorderRadius.only(
                    //           topLeft: Radius.circular(15.0),
                    //           topRight: Radius.circular(15.0),
                    //           bottomLeft: Radius.circular(15.0),
                    //           bottomRight: Radius.circular(15.0)),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.grey.withOpacity(0.5),
                    //           spreadRadius: 3,
                    //           blurRadius: 7,
                    //           offset: const Offset(
                    //               0, 1), // changes position of shadow
                    //         ),
                    //       ],
                    //     ),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         statusCount == null
                    //             ? const Text(
                    //                 '000',
                    //                 style: TextStyle(
                    //                     color: Color(0xff03BD03),
                    //                     fontWeight: FontWeight.w700,
                    //                     fontSize: 35),
                    //               )
                    //             : Text(
                    //                 statusCount.toString(),
                    //                 style: const TextStyle(
                    //                     color: Color(0xff03BD03),
                    //                     fontWeight: FontWeight.w700,
                    //                     fontSize: 35),
                    //               ),
                    //         const SizedBox(
                    //           height: 5,
                    //         ),
                    //         statusName == null
                    //             ? Container()
                    //             : Text(
                    //                 statusName,
                    //                 style: const TextStyle(
                    //                     color: CustomColor.subTitleTextColor,
                    //                     fontWeight: FontWeight.normal,
                    //                     fontSize: 16),
                    //               ),
                    //       ],
                    //     ),
                    //   );
                    // },
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const CompleteSurveyScreen();
                          })).then((value) {
                            setState(() {
                              fetchTotalStatusList();
                            });
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          margin: const EdgeInsets.only(
                              left: 20, right: 10, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                completed.toString(),
                                style: const TextStyle(
                                    color: Color(0xff03BD03),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 35),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Completed',
                                style: TextStyle(
                                    color: CustomColor.subTitleTextColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const PendingSurveyScreen();
                          })).then((value) {
                            setState(() {
                              fetchTotalStatusList();
                            });
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pending.toString(),
                                style: const TextStyle(
                                    color: Color(0xffFDBB18),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 35),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Pending',
                                style: TextStyle(
                                    color: CustomColor.subTitleTextColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const IncompletedSurveyScreen();
                          })).then((value) {
                            setState(() {
                              fetchTotalStatusList();
                            });
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          margin: const EdgeInsets.only(
                              left: 10, right: 20, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                incompleted.toString(),
                                style: const TextStyle(
                                    color: Color(0xffFA0707),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 35),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'InCompleted',
                                style: TextStyle(
                                    color: CustomColor.subTitleTextColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recently Added',
                    style: TextStyle(
                        color: CustomColor.titleTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const RecentlyAddedScreen();
                        })).then((value) {
                          setState(() {
                            fetchTotalStatusList();
                          });
                        });
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                            color: CustomColor.subTitleTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  )
                ],
              ),
            ),
            recentlyAddedList == null
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const Center(
                      child: Text(''),
                    ),
                  )
                : recentlyAddedList!.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const Center(
                          child: Text('Data Not Found'),
                        ),
                      )
                    : Expanded(
                      child: Container(
                        margin:const EdgeInsets.only(bottom: 10),
                          //height: MediaQuery.of(context).size.height * 0.6,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: recentlyAddedList?.length.clamp(0, 4),
                            itemBuilder: (BuildContext context, int index) {
                              int? id = recentlyAddedList?[index]['id'];
                              int? categoryId =
                                  recentlyAddedList?[index]['category_id'];
                              String? heading =
                                  recentlyAddedList?[index]['heading'];
                              String? description =
                                  recentlyAddedList?[index]['description'];
                              String? status =
                                  recentlyAddedList?[index]['status'];
                              String? image =
                                  recentlyAddedList?[index]['image'];
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return RadioSurveyScreen(id!, heading!,"recently");
                                  })).then((value){
                                    setState(() {
                                      fetchTotalStatusList();
                                    });
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,

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
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: image == null
                                              ? Image.asset(
                                                  'assets/images/image_not_found.png',
                                                  height: 80,
                                                  width: 80,fit: BoxFit.fill,)
                                              : Image.network(
                                                  image,
                                                  height: 80,
                                                  width: 80
                                              ,fit: BoxFit.fill,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/image_not_found.png',
                                                      height: 80,
                                                      width: 80
                                  ,fit: BoxFit.fill,
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.58,
                                                      child: Text(
                                                        heading,
                                                        // 'Role of Education Surveys',
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
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 7),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.58,
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
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffFDBB18),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xffFDBB18),
                                                        ),
                                                        borderRadius: const BorderRadius
                                                                .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    5.0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5.0),
                                                            bottomRight:
                                                                Radius.circular(
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
                                                              color:
                                                                  Colors.white,
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
                            //             child: Image.asset(
                            //               'assets/images/img1.png',
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
                            //         top: 10, left: 20, right: 20, bottom: 0),
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
                            //             child: Image.asset(
                            //               'assets/images/img1.png',
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
                            //         top: 10, left: 20, right: 20, bottom: 0),
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
