import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loyola/src/radio_survey_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';


class NotificationsScreen extends StatefulWidget {
  const
  NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  int? userID;
  List? notificationList;

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
      fetchNotificationList();
    });
  }

  fetchNotificationList() {
    CommonClass().showWait(context);
    ApiService().getNotificationList(userID!).then((value) => setState(() {
      CommonClass().dismissDialog(context);
      notificationList = value['data'];
      print("Notification List $notificationList");
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.fill,
                // color: Colors.white,
              )),

          Column(
            children: [

              Container(
                margin: const EdgeInsets.only(
                  left: 0,
                  top: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        'assets/images/back_yellow_btn.png',
                        height: 40,
                      ),
                    ),

                    const Text(
                      'Notifications',
                      style: TextStyle(
                          fontSize:26,
                          fontWeight: FontWeight.w700,
                          color: CustomColor.titleTextColor),
                    ),

                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              notificationList == null
                  ? SizedBox(
                height: MediaQuery.of(context).size.height*0.85,
                child: const Center(
                  child: Text('Loading.....'),
                ),
              )
                  : notificationList!.isEmpty
                  ? SizedBox(
                height: MediaQuery.of(context).size.height*0.85,
                child: const Center(
                  child: Text('Data Not Found'),
                ),
              )
                  : Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 5),
                  itemCount: notificationList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    String? message =
                    notificationList?[index]['message'];
                    String? createDate =
                    notificationList?[index]['created_at'];
                    int? surveyId =
                    notificationList?[index]['survey_id'];
                    String? type = notificationList?[index]['type'];
                    DateTime dt2 = DateTime.parse(createDate!);
                    String formattedDate =
                    DateFormat('MMM, dd, y').format(dt2);
                    String formattedTime =
                    DateFormat('hh:mm a').format(dt2);
                    return InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) {
                        //           return RadioSurveyScreen(
                        //               surveyId!, message!,"notification");
                        //         }));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 15, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)),
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
                          child: Row(
                            children: [
                              Container(
                                margin:
                                const EdgeInsets.only(left: 5),
                                child: Image.asset(
                                  'assets/images/notifications.png',
                                  height: 50,
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
                                    message == null
                                        ? Container()
                                        : Container(
                                      width: MediaQuery.of(context).size.width*0.58,
                                      child: Text(
                                        message,
                                        // 'New Survey',
                                        style: const TextStyle(
                                            color: CustomColor
                                                .titleTextColor,
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight
                                                .w500),
                                        overflow: TextOverflow.ellipsis,
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
                                          Text(
                                            formattedDate ?? '',
                                            // 'May, 8, 2023',
                                            style: const TextStyle(
                                                color: CustomColor
                                                    .subTitleTextColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight
                                                    .normal),
                                          ),
                                          Text(formattedTime,
                                            // '12:45 PM',
                                            style: TextStyle(
                                                color: CustomColor
                                                    .subTitleTextColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight
                                                    .normal),
                                          ),
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
                  //           topLeft: Radius.circular(10.0),
                  //           topRight: Radius.circular(10.0),
                  //           bottomLeft: Radius.circular(10.0),
                  //           bottomRight: Radius.circular(10.0)),
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
                  //       child: Row(
                  //         children: [
                  //           Container(
                  //             margin: const EdgeInsets.only(left: 5),
                  //             child: Image.asset(
                  //               'assets/images/notifications.png',
                  //               height: 50,
                  //             ),
                  //           ),
                  //           Container(
                  //             margin: const EdgeInsets.only(left: 10, top: 5),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.end,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   child: Row(
                  //                     children: const [
                  //                       Text(
                  //                         'New Survey',
                  //                         style: TextStyle(
                  //                             color: CustomColor.titleTextColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.w500),
                  //                       ),
                  //                       SizedBox(width: 3,),
                  //                       Text(
                  //                         'has been added',
                  //                         style: TextStyle(
                  //                             color: CustomColor.subTitleTextColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.normal),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //
                  //                 Container(
                  //                   // color: Colors.yellow,
                  //                   margin:
                  //                   const EdgeInsets.only(top: 7, bottom: 5),
                  //
                  //                   width:
                  //                   MediaQuery.of(context).size.width * 0.65,
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                     children: const [
                  //                       Text(
                  //                         'May, 8, 2023',
                  //                         style: TextStyle(
                  //                             color: CustomColor.subTitleTextColor,
                  //                             fontSize: 12,
                  //                             fontWeight: FontWeight.normal),
                  //                       ),
                  //                       Text(
                  //                         '12:45 PM',
                  //                         style: TextStyle(
                  //                             color: CustomColor.subTitleTextColor,
                  //                             fontSize: 12,
                  //                             fontWeight: FontWeight.normal),
                  //                       ),
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
                  //           topLeft: Radius.circular(10.0),
                  //           topRight: Radius.circular(10.0),
                  //           bottomLeft: Radius.circular(10.0),
                  //           bottomRight: Radius.circular(10.0)),
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
                  //       child: Row(
                  //         children: [
                  //           Container(
                  //             margin: const EdgeInsets.only(left: 5),
                  //             child: Image.asset(
                  //               'assets/images/notifications.png',
                  //               height: 50,
                  //             ),
                  //           ),
                  //           Container(
                  //             margin: const EdgeInsets.only(left: 10, top: 5),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.end,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   child: Row(
                  //                     children: const [
                  //                       Text(
                  //                         'New Survey',
                  //                         style: TextStyle(
                  //                             color: CustomColor.titleTextColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.w500),
                  //                       ),
                  //                       SizedBox(width: 3,),
                  //                       Text(
                  //                         'has been added',
                  //                         style: TextStyle(
                  //                             color: CustomColor.subTitleTextColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.normal),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //
                  //                 Container(
                  //                   // color: Colors.yellow,
                  //                   margin:
                  //                   const EdgeInsets.only(top: 7, bottom: 5),
                  //
                  //                   width:
                  //                   MediaQuery.of(context).size.width * 0.65,
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                     children: const [
                  //                       Text(
                  //                         'May, 8, 2023',
                  //                         style: TextStyle(
                  //                             color: CustomColor.subTitleTextColor,
                  //                             fontSize: 12,
                  //                             fontWeight: FontWeight.normal),
                  //                       ),
                  //                       Text(
                  //                         '12:45 PM',
                  //                         style: TextStyle(
                  //                             color: CustomColor.subTitleTextColor,
                  //                             fontSize: 12,
                  //                             fontWeight: FontWeight.normal),
                  //                       ),
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
          )

        ],
      ),
    );
  }

}

