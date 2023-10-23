import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loyola/src/radio_survey_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';

class IncompletedSurveyScreen extends StatefulWidget {
  const IncompletedSurveyScreen({Key? key}) : super(key: key);

  @override
  State<IncompletedSurveyScreen> createState() =>
      _IncompletedSurveyScreenState();
}

class _IncompletedSurveyScreenState extends State<IncompletedSurveyScreen> {
  int? userID;
  List? surveyHistoryList;

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
      fetchSurveyHistorySList();
    });
  }

  fetchSurveyHistorySList() {
    CommonClass().showWait(context);
    final body = {"user_id": userID.toString(), "status": "incompleted"};
    ApiService().getSurveyHistoryList(body).then((value) => setState(() {
          CommonClass().dismissDialog(context);
          surveyHistoryList = value['data'];
          print("InCompleted List $surveyHistoryList");
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
                     onTap: () {
                       Navigator.of(context).pop();
                     },
                     child: Image.asset(
                       'assets/images/back_yellow_btn.png',
                       height: 40,
                     ),
                   ),
                   const Text(
                     'InCompleted Survey',
                     style: TextStyle(
                         fontSize: 26,
                         fontWeight: FontWeight.w700,
                         color: CustomColor.titleTextColor),
                   ),
                   const SizedBox(
                     width: 20,
                   ),
                 ],
               ),
             ),
             surveyHistoryList == null
                 ? SizedBox(
               height: MediaQuery.of(context).size.height*0.85,
               child: const Center(
                 child: Text('Loading.....'),
               ),
             )
                 : surveyHistoryList!.isEmpty
                 ? SizedBox(
               height: MediaQuery.of(context).size.height*0.85,
               child: const Center(
                 child: Text('Data Not Found'),
               ),
             )
                 : Expanded(
                   child: ListView.builder(
                     padding: const EdgeInsets.only(top: 5),
                     itemCount: surveyHistoryList?.length,
                     itemBuilder: (BuildContext context, int index) {
                       int? id = surveyHistoryList?[index]['survey']['id'];
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
                       DateFormat('MMM, dd, y  hh:mm a').format(dt2);
                       return InkWell(
                         onTap: () {
                           Navigator.of(context)
                               .push(MaterialPageRoute(builder: (context) {
                             return RadioSurveyScreen(id!, heading!,"incomplete");
                           }));
                         },
                         child: Container(
                           margin: const EdgeInsets.only(
                               top: 10, left: 20, right: 20),
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
                                     errorBuilder: (BuildContext
                                     context,
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
                                         width:
                                         MediaQuery.of(context)
                                             .size
                                             .width *
                                             0.58,
                                         child: Text(
                                           heading,
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
                                         width:
                                         MediaQuery.of(context)
                                             .size
                                             .width *
                                             0.58,
                                         margin:
                                         const EdgeInsets.only(
                                             top: 7),
                                         child: Text(
                                           description,
                                           style: const TextStyle(
                                               color: CustomColor
                                                   .subTitleTextColor,
                                               fontSize: 13,
                                               fontWeight: FontWeight
                                                   .normal),
                                           overflow:
                                           TextOverflow.ellipsis,
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
                                             createdAt == null
                                                 ? Container()
                                                 : Row(
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
                     // physics: NeverScrollableScrollPhysics(),
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
         )
        ],
      ),
    );
  }
}
