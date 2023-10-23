import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loyola/src/radio_survey_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';

class CategoryListScreen extends StatefulWidget {
  String technologyName;
  int id;
  CategoryListScreen(this.technologyName,this.id,{Key? key}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  int? userID;
  List? categoryList;

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
      fetchCategoryList();
    });
  }

  fetchCategoryList() {
    CommonClass().showWait(context);
    final body={
      "user_id":userID.toString(),
      "category_id":widget.id.toString(),
      "type":"new"
    };
    ApiService().getSurveyList(body).then((value) => setState(() {
      print("Survey response $value");
      CommonClass().dismissDialog(context);
      categoryList = value['data'];
      print("Category List $categoryList");
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
          Container(
            margin: const EdgeInsets.only(
              left: 0,
              top: 40,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                 Container(
                   width: MediaQuery.of(context).size.width*0.7,
                   margin: const EdgeInsets.only(top: 5,left: 10),
                   child: Text(widget.technologyName,
                   // 'Survey History',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: CustomColor.titleTextColor),
                     overflow: TextOverflow.clip,
                ),
                 ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          categoryList == null
              ? SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text('Loading.....'),
            ),
          )
              : categoryList!.isEmpty
              ? SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text('No Survey Found'),
            ),
          )
              : Container(
            height: MediaQuery.of(context).size.height * 0.95,
            margin:
            const EdgeInsets.only(left: 00, top: 60, right: 00),
            child: Expanded(
              child: GridView.builder(
                itemCount: categoryList?.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1.1),
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                // primary: false,
                // padding: const EdgeInsets.all(20),
                itemBuilder: (BuildContext context, int index) {
                  int? id = categoryList?[index]['id'];
                  String? image = categoryList?[index]['image'];
                  String? heading = categoryList?[index]['heading'];
                  String? date = categoryList?[index]['created_at'];
                  DateTime dt2 = DateTime.parse(date!);
                  String formattedDate =
                  DateFormat('MMM, dd, y')
                      .format(dt2);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return RadioSurveyScreen(id!,heading!,"category");
                      }));
                    },
                    child: Container(
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
                            date == null
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
                                        color: CustomColor
                                            .subTitleTextColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
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
            ),
          ),
        ],
      ),
    );
  }
}
