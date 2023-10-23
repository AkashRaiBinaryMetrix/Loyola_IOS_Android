import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController feedbackController = TextEditingController();

  int? userID;
  List? feedbackList;
  double ratings = 0.0;
  List<String> tempArray = [];
  List improveList = [];
  String? commentData, feedback;

  String currentDateTime =
      DateFormat("yyyy-MM-dd H:mm:ss").format(DateTime.now());

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
      fetchFeedbackList();
    });
  }

  fetchFeedbackList() {
    CommonClass().showWait(context);
    ApiService().getSetting().then((value) => setState(() {
          feedbackList = value['data']['feedback_type'];
          fetchFeedbackData();
          print("Feedback List $feedbackList");
        }));
  }

  fetchFeedbackData() {
    final body = {"user_id": userID.toString()};
    ApiService().getFeedback(body).then((value) => setState(() {
          CommonClass().dismissDialog(context);
          print("get Feedback Data $value");
          commentData = value['data']['feedback']['message'];
          improveList = value['data']['type'];
          feedbackController.text = commentData ?? '';
          ratings = double.tryParse(value['data']['feedback']['rate']) ?? 0.0;
          feedback = value['data']['feedback'].toString();
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
              )),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Help & Feedback',
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
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 15, left: 20),
                          child: const Text(
                            'Rate Your Experience',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                            ),
                          )),
                      Container(
                          margin: const EdgeInsets.only(top: 10, left: 20),
                          child: const Text(
                            'Are you satisfied with the service?',
                            style: TextStyle(
                              color: CustomColor.subTitleTextColor,
                              fontSize: 14,
                            ),
                          )),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 20),
                        child: RatingBar.builder(
                          initialRating: ratings,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: feedback == null ? false : true,
                          itemSize: 40,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 3,
                          ),
                          onRatingUpdate: (rating) {
                            ratings = rating;
                            print(rating);
                          },
                        ),

                        // RatingBarIndicator(
                        //   rating: 4.0,
                        //   itemBuilder: (context, index) => const Icon(
                        //     Icons.star,
                        //     color: Colors.amber,
                        //   ),
                        //   itemCount: 5,
                        //   itemSize: 40.0,
                        //   direction: Axis.horizontal,
                        // ),
                      ),
                      Divider(
                        thickness: 1.2,
                        color: Colors.grey.shade300,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10, left: 20),
                          child: const Text(
                            'Tell us what can be improved?',
                            style: TextStyle(
                                color: CustomColor.titleTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Container(
                      //       margin: const EdgeInsets.only(top: 10, bottom: 10),
                      //       decoration: BoxDecoration(
                      //         color: CustomColor.buttonColor,
                      //         border:
                      //             Border.all(color: CustomColor.buttonColor),
                      //         borderRadius: const BorderRadius.only(
                      //             topLeft: Radius.circular(20.0),
                      //             topRight: Radius.circular(20.0),
                      //             bottomLeft: Radius.circular(20.0),
                      //             bottomRight: Radius.circular(20.0)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.grey.withOpacity(0.05),
                      //             spreadRadius: 1,
                      //             blurRadius: 1,
                      //             offset: const Offset(
                      //                 0, 1), // changes position of shadow
                      //           ),
                      //         ],
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.only(
                      //             left: 25.0,
                      //             right: 25.0,
                      //             top: 10.0,
                      //             bottom: 10.0),
                      //         child: Text(
                      //           'Overall Service',
                      //           style: TextStyle(
                      //               fontSize: 14, color: Colors.white),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       margin: const EdgeInsets.only(top: 10, bottom: 10),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         border: Border.all(color: Colors.grey.shade300),
                      //         borderRadius: const BorderRadius.only(
                      //             topLeft: Radius.circular(20.0),
                      //             topRight: Radius.circular(20.0),
                      //             bottomLeft: Radius.circular(20.0),
                      //             bottomRight: Radius.circular(20.0)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.grey.withOpacity(0.05),
                      //             spreadRadius: 1,
                      //             blurRadius: 1,
                      //             offset: const Offset(
                      //                 0, 1), // changes position of shadow
                      //           ),
                      //         ],
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.only(
                      //             left: 25.0,
                      //             right: 25.0,
                      //             top: 10.0,
                      //             bottom: 10.0),
                      //         child: Text(
                      //           'Customer Support',
                      //           style: TextStyle(
                      //               fontSize: 14, color: Colors.black),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Container(
                      //       margin: const EdgeInsets.only(top: 10, bottom: 10),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         border: Border.all(color: Colors.grey.shade300),
                      //         borderRadius: const BorderRadius.only(
                      //             topLeft: Radius.circular(20.0),
                      //             topRight: Radius.circular(20.0),
                      //             bottomLeft: Radius.circular(20.0),
                      //             bottomRight: Radius.circular(20.0)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.grey.withOpacity(0.05),
                      //             spreadRadius: 1,
                      //             blurRadius: 1,
                      //             offset: const Offset(
                      //                 0, 1), // changes position of shadow
                      //           ),
                      //         ],
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.only(
                      //             left: 25.0,
                      //             right: 25.0,
                      //             top: 10.0,
                      //             bottom: 10.0),
                      //         child: Text(
                      //           'Speed and Efficiency',
                      //           style: TextStyle(
                      //               fontSize: 14, color: Colors.black),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       margin: const EdgeInsets.only(top: 10, bottom: 10),
                      //       decoration: BoxDecoration(
                      //         color: CustomColor.buttonColor,
                      //         border:
                      //             Border.all(color: CustomColor.buttonColor),
                      //         borderRadius: const BorderRadius.only(
                      //             topLeft: Radius.circular(20.0),
                      //             topRight: Radius.circular(20.0),
                      //             bottomLeft: Radius.circular(20.0),
                      //             bottomRight: Radius.circular(20.0)),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.grey.withOpacity(0.05),
                      //             spreadRadius: 1,
                      //             blurRadius: 1,
                      //             offset: const Offset(
                      //                 0, 1), // changes position of shadow
                      //           ),
                      //         ],
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.only(
                      //             left: 25.0,
                      //             right: 25.0,
                      //             top: 10.0,
                      //             bottom: 10.0),
                      //         child: Text(
                      //           'Repair Quality',
                      //           style: TextStyle(
                      //               fontSize: 14, color: Colors.white),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 10, bottom: 10),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border.all(color: Colors.grey.shade300),
                      //     borderRadius: const BorderRadius.only(
                      //         topLeft: Radius.circular(20.0),
                      //         topRight: Radius.circular(20.0),
                      //         bottomLeft: Radius.circular(20.0),
                      //         bottomRight: Radius.circular(20.0)),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.grey.withOpacity(0.05),
                      //         spreadRadius: 1,
                      //         blurRadius: 1,
                      //         offset: const Offset(
                      //             0, 1), // changes position of shadow
                      //       ),
                      //     ],
                      //   ),
                      //   child: const Padding(
                      //     padding: EdgeInsets.only(
                      //         left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                      //     child: Text(
                      //       'Transperancy',
                      //       style: TextStyle(fontSize: 14, color: Colors.black),
                      //     ),
                      //   ),
                      // ),
                      feedbackList == null
                          ? Container()
                          : feedbackList!.isEmpty
                              ? Container()
                              : Container(
                                  margin: const EdgeInsets.only(
                                      top: 0, left: 10, right: 10),
                                  height: 240,
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 1,
                                            childAspectRatio: 2.8),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: feedbackList?.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String? name = feedbackList?[index];
                                      return feedback == null
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (tempArray.contains(
                                                      feedbackList?[index]
                                                          .toString())) {
                                                    tempArray.remove(
                                                        feedbackList?[index]
                                                            .toString());
                                                  } else {
                                                    tempArray.add(
                                                        feedbackList![index]
                                                            .toString());
                                                  }
                                                });
                                              },
                                              child: tempArray.contains(
                                                      feedbackList?[index]
                                                          .toString())
                                                  ? Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10,
                                                              left: 10,
                                                              right: 10),
                                                      decoration: BoxDecoration(
                                                        color: CustomColor
                                                            .buttonColor,
                                                        border: Border.all(
                                                            color: CustomColor
                                                                .buttonColor),
                                                        borderRadius: const BorderRadius
                                                                .only(
                                                            topLeft: Radius
                                                                .circular(20.0),
                                                            topRight: Radius
                                                                .circular(20.0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20.0)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.05),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          name.toString(),
                                                          //'Overall Service',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10,
                                                              left: 10,
                                                              right: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300),
                                                        borderRadius: const BorderRadius
                                                                .only(
                                                            topLeft: Radius
                                                                .circular(20.0),
                                                            topRight: Radius
                                                                .circular(20.0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20.0)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.05),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          name.toString(),
                                                          // 'Customer Support',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                            )
                                          : improveList.contains(
                                                  feedbackList?[index]
                                                      .toString())
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  margin: const EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        CustomColor.buttonColor,
                                                    border: Border.all(
                                                        color: CustomColor
                                                            .buttonColor),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20.0)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.05),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset: const Offset(0,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      name.toString(),
                                                      //'Overall Service',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  margin: const EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20.0)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.05),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset: const Offset(0,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      name.toString(),
                                                      // 'Customer Support',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                );
                                    },
                                  ),
                                ),

                      feedbackTextFormField(),

                      feedback == null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Center(child: saveButtonWidget()),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget feedbackTextFormField() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
      child: TextFormField(
        maxLines: 5,
        minLines: 5,
        readOnly: commentData == null ? false : true,
        keyboardType: TextInputType.text,
        controller: feedbackController,
        decoration: InputDecoration(
          hintText: "Tell us on how can we improve...",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.green,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Enter Phone';
          }
          return null;
        },
      ),
    );
  }

  Widget saveButtonWidget() {
    return InkWell(
        onTap: () {
          CommonClass().showWait(context);
          // if (feedbackController.text.isEmpty) {
          //   CommonClass().dismissDialog(context);
          //   CommonClass().toastWidget("Enter message");
          // } else {
          submitFeedback();
          //  }
        },
        child: CommonClass().customButtonWidget(
            context,
            50,
            MediaQuery.of(context).size.width,
            30.0,
            20.0,
            20.0,
            20.0,
            "Submit",
            18.0,
            Colors.white));
  }

  void submitFeedback() {
    final body = {
      "user_id": userID.toString(),
      "rate": ratings.toString(),
      "type": tempArray,
      "message": feedbackController.text.toString(),
      "dateTime": currentDateTime
    };

    if (ratings == 0.0 &&
        tempArray.isEmpty &&
        feedbackController.text.isEmpty) {
      CommonClass().toastWidget("All fields Should not be Empty");
      CommonClass().dismissDialog(context);
    } else {
      ApiService().submitFeedback(body).then((value) {
        CommonClass().dismissDialog(context);
        if (ratings == 0.0) {
          CommonClass().toastWidget(value['errors']['rate'][0]);
        } else {
          CommonClass().toastWidget(value['msg']);
          Future.delayed(const Duration(milliseconds: 2000), () {
            Navigator.of(context).pop();
          });
        }
      });
    }
  }
}
