import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loyola/Commons/common_class.dart';
import 'package:loyola/src/radio_survey_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Commons/constant_class.dart';
import '../Services/api_service.dart';

class UpcomingSurveyScreen extends StatefulWidget {
  const UpcomingSurveyScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingSurveyScreen> createState() => _UpcomingSurveyScreenState();
}

class _UpcomingSurveyScreenState extends State<UpcomingSurveyScreen> {
  int? userID;
  List? upcomingSurveyList;

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
          ;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55), // Set this height
        child: Container(
            padding:
                const EdgeInsets.only(top: 40, bottom: 10, left: 20, right: 20),
            color: CustomColor.buttonColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                const Text(
                  "Upcoming Survey",
                  // userName ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            )),
      ),
      body: upcomingSurveyList == null
          ? const Center(
              child: Text('Loading.......'),
            )
          : upcomingSurveyList!.isEmpty
              ? const Center(
                  child: Text('Data Not Found'),
                )
              : GridView.builder(
                  itemCount: upcomingSurveyList?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 1.1),
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  // primary: false,
                  // padding: const EdgeInsets.all(20),
                  itemBuilder: (BuildContext context, int index) {
                    int? id = upcomingSurveyList?[index]['id'];
                    String? image = upcomingSurveyList?[index]['image'];
                    String? heading = upcomingSurveyList?[index]['heading'];
                    String? date = upcomingSurveyList![index]['created_at'];
                    String? publishDate =
                        upcomingSurveyList![index]['published_date'];
                    DateTime dt2 = DateTime.parse(publishDate!);
                    String formattedDate = DateFormat('MMM, dd, y').format(dt2);
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    image,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.fill,
                                    errorBuilder: (BuildContext context,
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
                            heading == null
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      heading,
                                      //  'Course Evaluation Survey',
                                      style: const TextStyle(
                                          color: CustomColor.buttonColor,
                                          fontSize: 14,
                                          height: 1.3,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                            formattedDate == null
                                ? Container()
                                : Container(
                                    // color: Colors.yellow,
                                    margin: const EdgeInsets.only(top: 5),
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
                                          // 'May, 13, 2023',
                                          style: const TextStyle(
                                              color:
                                                  CustomColor.subTitleTextColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    );
                  },
                  // children: <Widget>[
                  //   InkWell(
                  //     onTap: (){
                  //       Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  //         return const RadioSurveyScreen();
                  //       }));
                  //     },
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width,
                  //       margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         border: Border.all(color: Colors.white),
                  //         borderRadius: const BorderRadius.only(
                  //             topLeft: Radius.circular(7.0),
                  //             topRight: Radius.circular(7.0),
                  //             bottomLeft: Radius.circular(7.0),
                  //             bottomRight: Radius.circular(7.0)),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.grey.withOpacity(0.1),
                  //             spreadRadius: 2,
                  //             blurRadius: 1,
                  //             offset:
                  //             const Offset(0, 1), // changes position of shadow
                  //           ),
                  //         ],
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(10.0),
                  //         child: Column(
                  //           children: [
                  //             Image.asset(
                  //               'assets/images/img7.png',
                  //               height: 80,),
                  //             Container(
                  //               margin:
                  //               const EdgeInsets.only(top: 5),
                  //               child: const Text(
                  //                 'Course Evaluation Survey',
                  //                 style: TextStyle(
                  //                     color: CustomColor.buttonColor,
                  //                     fontSize: 14,
                  //                     height: 1.3,
                  //                     fontWeight: FontWeight.w400),
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ),
                  //             Container(
                  //               // color: Colors.yellow,
                  //               margin:
                  //               const EdgeInsets.only(top: 5),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Image.asset(
                  //                     'assets/images/clock_icon.png',
                  //                     height: 20,
                  //                   ),
                  //                   const Text(
                  //                     'May, 13, 2023',
                  //                     style: TextStyle(
                  //                         color: CustomColor.subTitleTextColor,
                  //                         fontSize: 12,
                  //                         fontWeight: FontWeight.normal),
                  //                   ),
                  //
                  //                 ],
                  //               ),
                  //             )
                  //
                  //           ],
                  //         ),
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
                  // ],
                ),
    );
  }
}
