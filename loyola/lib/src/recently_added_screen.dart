import 'package:flutter/material.dart';
import 'package:loyola/Commons/common_class.dart';
import 'package:loyola/src/radio_survey_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Commons/constant_class.dart';
import '../Services/api_service.dart';

class RecentlyAddedScreen extends StatefulWidget {
  const RecentlyAddedScreen({Key? key}) : super(key: key);

  @override
  State<RecentlyAddedScreen> createState() => _RecentlyAddedScreenState();
}

class _RecentlyAddedScreenState extends State<RecentlyAddedScreen> {
  int? userID;
  List? totalStatusList;
  List? recentlyAddedList;

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
      fetchTotalStatusList();
    });
  }

  fetchTotalStatusList() {
    final body = {"user_id": userID.toString()};
    CommonClass().showWait(context);
    ApiService().getDashboard(body).then((value) => setState(() {
      CommonClass().dismissDialog(context);
      totalStatusList = value['data'];
          recentlyAddedList = totalStatusList?[0]['recently_added'];
          print("total Status List $recentlyAddedList");
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
                     'Recently Added',
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
             recentlyAddedList == null
                 ? Container(
               height: MediaQuery.of(context).size.height * 0.85,
               child: const Center(
                 child: Text(''),
               ),
             )
                 : recentlyAddedList!.isEmpty
                 ? Container(
               height: MediaQuery.of(context).size.height * 0.85,
               child: const Center(
                 child: Text('Data Not Found'),
               ),
             )
                 : Expanded(
                   child: ListView.builder(
                     padding: const EdgeInsets.only(top: 5),
                     // physics: const NeverScrollableScrollPhysics(),
                     // shrinkWrap: true,
                     itemCount: recentlyAddedList?.length,
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
                       String? image = recentlyAddedList?[index]['image'];
                       return InkWell(
                         onTap: () {
                           Navigator.of(context)
                               .push(MaterialPageRoute(builder: (context) {
                             return RadioSurveyScreen(id!, heading!,"recently");
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
                                     width: 80
                                     ,fit: BoxFit.fill,)
                                       : Image.network(
                                     image,
                                     height: 80,
                                     width: 80,
                                     fit: BoxFit.fill,
                                     errorBuilder: (BuildContext context, Object exception,
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
                                         width: MediaQuery.of(context).size.width * 0.58,
                                         child: Text(
                                           heading,
                                           // 'Role of Education Surveys',
                                           style: const TextStyle(
                                               color: CustomColor
                                                   .titleTextColor,
                                               fontSize: 15,
                                               fontWeight:
                                               FontWeight.w500),
                                           overflow: TextOverflow.ellipsis,
                                         ),
                                       ),
                                       description == null
                                           ? Container()
                                           : Container(
                                         margin:
                                         const EdgeInsets.only(
                                             top: 7),
                                         width: MediaQuery.of(context).size.width * 0.58,
                                         child: Text(
                                           description,
                                           // 'Technology Meter',
                                           style: TextStyle(
                                               color: CustomColor
                                                   .subTitleTextColor,
                                               fontSize: 13,
                                               fontWeight: FontWeight
                                                   .normal),
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
                                             Container(
                                               decoration: BoxDecoration(
                                                 color: const Color(
                                                     0xffFDBB18),
                                                 border: Border.all(
                                                   color: const Color(
                                                       0xffFDBB18),
                                                 ),
                                                 borderRadius:
                                                 const BorderRadius
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
                                                         .withOpacity(0.2),
                                                     spreadRadius: 2,
                                                     blurRadius: 3,
                                                     offset: const Offset(
                                                         0,
                                                         1), // changes position of shadow
                                                   ),
                                                 ],
                                               ),
                                               child: const Padding(
                                                 padding: EdgeInsets.only(
                                                     left: 15.0,
                                                     right: 15,
                                                     top: 5,
                                                     bottom: 5),
                                                 child: Text(
                                                   'Start Survey',
                                                   style: TextStyle(
                                                       color: Colors.white,
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

           ],
         )
        ],
      ),
    );
  }
}
