import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Commons/constant_class.dart';
import '../Services/api_service.dart';
import 'category_list_screen.dart';

class CategorySurveyScreen extends StatefulWidget {
  const CategorySurveyScreen({Key? key}) : super(key: key);

  @override
  State<CategorySurveyScreen> createState() => _CategorySurveyScreenState();
}

class _CategorySurveyScreenState extends State<CategorySurveyScreen> {
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
    ApiService().getCategory().then((value) => setState(() {
          categoryList = value['data'];
          //   print("Category List $categoryList");
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
                  "Category Survey",
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
      body: categoryList == null
          ? Container()
          : categoryList!.isEmpty
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 3,
                            childAspectRatio: 3),
                    shrinkWrap: true,

                    ///  physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoryList?.length,
                    itemBuilder: (BuildContext context, int index) {
                      int? id = categoryList?[index]['id'];
                      String? image = categoryList?[index]['image'];
                      String? technology = categoryList?[index]['name'];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return CategoryListScreen(technology!, id!);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
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
                                        'assets/images/science.png',
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        image,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.fill,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Image.asset(
                                            'assets/images/science.png',
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.fill,
                                          );
                                        },
                                      ),
                                const SizedBox(
                                  width: 5,
                                ),
                                technology == null
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Text(
                                          technology,
                                          // 'Science',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
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
    );
  }
}
