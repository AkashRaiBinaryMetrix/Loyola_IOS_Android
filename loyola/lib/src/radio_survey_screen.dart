import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loyola/Commons/constant_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Commons/common_class.dart';
import '../Services/api_service.dart';
import '../login_src/landing_screen.dart';
import '../model/sureyList.dart';

class RadioSurveyScreen extends StatefulWidget {
  int serveyId;
  String heading;
  String status;

  RadioSurveyScreen(this.serveyId, this.heading, this.status, {Key? key})
      : super(key: key);

  @override
  State<RadioSurveyScreen> createState() => _RadioSurveyScreenState();
}

class _RadioSurveyScreenState extends State<RadioSurveyScreen> {
  int? userID;
  List? surveyQuestionList;

  //final TextEditingController commentsController = TextEditingController();
  List<TextEditingController> _controllers = [];

  TextEditingController? controllertxt;
  late int questionNumber;
  late PageController _pageController;
  String? selectedRadioValue, checkBoxvalue, radioButtonValue;
  List<String> userChecked = [];
  List<String> userCheckedRadio = [];
  List<dynamic> selectedSurvey = [];
  late int questionIndex;
  List<SurveyList> surveyList = <SurveyList>[];
  List<Map<String, dynamic>> selectedOption = [];
  List<Map<String, dynamic>> selectedCheckBoxOptionList = [];
  List<Map<String, dynamic>> selectedRadioButtonOptionList = [];
  bool buttonStatus = false;
  late int mNumber;
  String? type, selecedvalue;
  int? questionIds;
  String currentDateTime =
      DateFormat("yyyy-MM-dd H:mm:ss").format(DateTime.now());
  int? currentIndex;
  String? radioButtonAnswer;
  List? checkBoxAnswerList;
  String? answerInput;

  void _onSelectedCheckbox(bool selected, String dataName, optionId, questionId) {
    if (selected == true) {
      setState(() {
        userChecked.add(dataName);
        checkBoxvalue = dataName;
        selectedCheckBoxOptionList.add({"id": optionId});

        print("check box value add $selectedCheckBoxOptionList");
        // selectedOption.add({
        //   "id": questionId.toString(),
        //   "type": "checkbox",
        //   "option": selectedCheckBoxOptionList,
        //   "input": ""
        // });
      });
    } else {
      setState(() {
        userChecked.remove(dataName);
        checkBoxvalue = "";
        selectedCheckBoxOptionList.remove({"": []});


        print("check box value Remove $selectedCheckBoxOptionList");
        // selectedOption
        //     .remove({"id": "", "type": "", "option": [], "input": ""});
      });
    }
    print("check box value $selectedCheckBoxOptionList");
  }

  void _onSelectedRadioButton(optionId, questionId, dataName) {
    // if (selected == true) {
    setState(() {
      userCheckedRadio.add(dataName);
      radioButtonValue = dataName;
      selectedRadioButtonOptionList.add({"id": optionId});
      // selectedOption.add({
      //   "id": questionId.toString(),
      //   "type": "radio",
      //   "option": selectedRadioButtonOptionList,
      //   "input": ""
      // });
    });
    //  } else {
    //     setState(() {
    //       userCheckedRadio.remove(dataName);
    //       radioButtonValue = "";
    //       selectedRadioButtonOptionList.remove({"": []});
    // selectedOption
    //     .remove({"id": "", "type": "", "option": [], "input": ""});
    //   });
    ///  }
    print("Radio Button value $selectedRadioButtonOptionList");
    print("selected radio button option $selectedRadioValue");
  }

  // _onSelectedSurvey(bool value, String id, type, option, input) {
  //   if (value == true) {
  //     a.add({"id": id, "type": type, "option": selectedOptionList, "input": input});
  //   } else {
  //     a.remove({"id": id, "type": type, "option": option, "input": input});
  //   }
  //   // if (selected == true) {
  //   //   setState(() {
  //   //     selectedSurvey.add(id,type,option,input);
  //   //   //  checkBoxvalue = dataName;
  //   //   });
  //   // } else {
  //   //   setState(() {
  //   //     selectedSurvey.remove(id,type,option,input);
  //   //    // checkBoxvalue = "";
  //   //   });
  //   //
  //   print("Survey value $surveyList");
  // }

  _onChanged(String mobileNumber, questionId) {
    setState(() {
      selecedvalue = mobileNumber;
      // mNumber = mobileNumber.length;
      // if (mNumber < 1) {
      //   print('Hello $mNumber');
      // } else {
      // //  _onSelectedSurvey(true, questionId.toString(), "input", "", mobileNumber);
      //   print('Hello Text $mobileNumber');
      // }
    });
  }

  @override
  void initState() {
    questionNumber = 0;
    questionIndex = 2;
    currentIndex=0;
    _pageController = PageController(initialPage: 0);
    super.initState();
    getLoginData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  getLoginData() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getInt("userId");
      fetchSurveyQuestionList();
    });
  }

  fetchSurveyQuestionList() {
    CommonClass().showWait(context);
    ApiService()
        .getSurveyQuestionsList(widget.serveyId, userID.toString())
        .then((value) => setState(() {
              CommonClass().dismissDialog(context);
              surveyQuestionList = value['data'];
              print("survey Question List ${surveyQuestionList}");
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // Set this height
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
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
                  child: const Icon(
                    Icons.arrow_back,
                    color: CustomColor.subTitleTextColor,
                  )),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  widget.heading,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: CustomColor.subTitleTextColor),
                  overflow: TextOverflow.clip,
                ),
              ),
              const SizedBox(
                width: 5,
              )
            ],
          ),
        ),
      ),

      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   centerTitle: true,
      //   leading: InkWell(
      //       onTap: () {
      //         Navigator.of(context).pop();
      //       },
      //       child: const Icon(
      //         Icons.arrow_back,
      //         color: CustomColor.subTitleTextColor,
      //       )),
      //   title: Text(
      //     widget.heading,
      //     style: const TextStyle(
      //         fontWeight: FontWeight.w700,
      //         fontSize: 20,
      //         color: CustomColor.subTitleTextColor),
      //     overflow: TextOverflow.clip,
      //   ),
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: surveyQuestionList == null
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: const Center(
                  child: Text('you are already submitted this Survey'),
                ),
              )
            : surveyQuestionList!.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: const Center(
                      child: Text('Data Not Found'),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: surveyQuestionList?.length,
                      itemBuilder: (BuildContext context, int index) {
                        String name = surveyQuestionList?[index]['name'];
                        type = surveyQuestionList?[index]['type'];
                        List? optionsList = surveyQuestionList?[index]['option'];
                        questionIds = surveyQuestionList?[index]['id'];
                        radioButtonAnswer = surveyQuestionList?[index]['user_answer']['question_option_ids'];
                        String? answerType = surveyQuestionList?[index]['user_answer']['type'];
                        answerInput = surveyQuestionList?[index]['user_answer']['input'];
                       String? answerInputs = surveyQuestionList?[index]['user_answer']['input'];
                        checkBoxAnswerList = surveyQuestionList?[index]['user_answer']['question_option_array_ids'];
                        // int surveyId = surveyQuestionList?[index]['survey_id'];
                        String? date = surveyQuestionList?[index]['created_at'];
                        DateTime dt2 = DateTime.parse(date!);
                        String formattedDate =
                            DateFormat('MMM, dd, y hh:mm a').format(dt2);
                        // DateFormat('d-MM-y HH:mm').format(dt2);
                        _controllers.add(TextEditingController());
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 20,
                                  left: 20,
                                ),
                                child: Text(
                                  'Question ${index + 1}/${surveyQuestionList?.length}',
                                  style: const TextStyle(
                                      color: CustomColor.buttonColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    left: 20,
                                  ),
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                        color: CustomColor.titleTextColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )),
                              // Container(
                              //   margin:
                              //       const EdgeInsets.only(top: 20, left: 20),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       Image.asset(
                              //         'assets/images/clock_icon.png',
                              //         height: 20,
                              //       ),
                              //       const SizedBox(
                              //         width: 5,
                              //       ),
                              //       Text(
                              //         formattedDate,
                              //         //   'May, 10, 2023',
                              //         style: const TextStyle(
                              //             color: CustomColor.subTitleTextColor,
                              //             fontSize: 12,
                              //             fontWeight: FontWeight.normal),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              type == "radio"
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: optionsList?.length,
                                      itemBuilder: (BuildContext context,
                                          int innerIndex) {
                                        String name =
                                            optionsList?[innerIndex]['name'];
                                        int? questionId =
                                            optionsList?[innerIndex]
                                                ['question_id'];
                                        int? optionId =
                                            optionsList?[innerIndex]['id'];

                                        return answerType == "radio"
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    top: 20,
                                                    left: 20,
                                                    right: 20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  7.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  7.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  7.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  7.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                      spreadRadius: 2,
                                                      blurRadius: 1,
                                                      offset: const Offset(0,
                                                          1), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child:

                                                              // questionAnswer==optionId.toString()? Radio(
                                                              //   groupValue:questionAnswer.toString(),
                                                              //   value: optionId.toString(),
                                                              //   toggleable: true,
                                                              //   activeColor: CustomColor
                                                              //       .buttonColor,
                                                              //   onChanged: (value) {
                                                              //     setState(() {
                                                              //       // selectedRadioValue =
                                                              //       //     value.toString();
                                                              //       // if (selectedRadioValue !=
                                                              //       //     null) {//   _onSelectedRadioButton(
                                                              //       //       true,
                                                              //       //       optionId
                                                              //       //           .toString(),
                                                              //       //       questionId
                                                              //       //           .toString());
                                                              //       // }
                                                              //
                                                              //     });
                                                              //   },
                                                              // ):
                                                              Radio(
                                                            groupValue:
                                                            radioButtonAnswer
                                                                    .toString(),
                                                            value: optionId
                                                                .toString(),
                                                            toggleable: true,
                                                            activeColor:
                                                                CustomColor
                                                                    .buttonColor,
                                                            onChanged:
                                                                (value) {},
                                                          )),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        margin: const EdgeInsets
                                                            .only(top: 5),
                                                        child: Text(
                                                          name,
                                                          style: const TextStyle(
                                                              color: CustomColor
                                                                  .titleTextColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    top: 20,
                                                    left: 20,
                                                    right: 20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  7.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  7.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  7.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  7.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                      spreadRadius: 2,
                                                      blurRadius: 1,
                                                      offset: const Offset(0,
                                                          1), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: Radio(
                                                            groupValue:
                                                                selectedRadioValue,
                                                            value: name,
                                                            toggleable: true,
                                                            activeColor:
                                                                CustomColor
                                                                    .buttonColor,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedRadioButtonOptionList =
                                                                    [];
                                                                // userCheckedRadio.remove(name);
                                                                // radioButtonValue = "";
                                                                // selectedRadioButtonOptionList.remove({"": []});

                                                                selectedRadioValue =
                                                                    value
                                                                        .toString();
                                                                _onSelectedRadioButton(
                                                                    optionId
                                                                        .toString(),
                                                                    questionId
                                                                        .toString(),
                                                                    name);
                                                              });
                                                            },
                                                          )),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        margin: const EdgeInsets
                                                            .only(top: 5),
                                                        child: Text(
                                                          name,
                                                          style: const TextStyle(
                                                              color: CustomColor
                                                                  .titleTextColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                      },
                                    )
                                  : type == "checkbox"
                                      ? ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: optionsList?.length,
                                          itemBuilder: (BuildContext context,
                                              int innerIndex) {
                                            String name =
                                                optionsList?[innerIndex]
                                                    ['name'];
                                            int? questionId =
                                                optionsList?[innerIndex]
                                                    ['question_id'];
                                            int? optionId =
                                                optionsList?[innerIndex]['id'];
                                            return answerType == "checkbox"
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20,
                                                            left: 20,
                                                            right: 20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topLeft:
                                                                  Radius
                                                                      .circular(
                                                                          7.0),
                                                              topRight:
                                                                  Radius
                                                                      .circular(
                                                                          7.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      7.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          7.0)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          spreadRadius: 2,
                                                          blurRadius: 1,
                                                          offset: const Offset(
                                                              0,
                                                              1), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets.only(
                                                                      left: 5),
                                                              child: Checkbox(
                                                                  checkColor:
                                                                      CustomColor
                                                                          .buttonColor,
                                                                  value: checkBoxAnswerList
                                                                      ?.contains(
                                                                          optionId
                                                                              .toString()),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: CustomColor
                                                                        .buttonColor,
                                                                    //your desire colour here
                                                                    width: 1.5,
                                                                  ),
                                                                  activeColor:
                                                                      Colors
                                                                          .white,
                                                                  onChanged: (bool?
                                                                      value) {})),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.7,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
                                                            child: Text(
                                                              name,
                                                              style: const TextStyle(
                                                                  color: CustomColor
                                                                      .titleTextColor,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20,
                                                            left: 20,
                                                            right: 20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topLeft:
                                                                  Radius
                                                                      .circular(
                                                                          7.0),
                                                              topRight:
                                                                  Radius
                                                                      .circular(
                                                                          7.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      7.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          7.0)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          spreadRadius: 2,
                                                          blurRadius: 1,
                                                          offset: const Offset(
                                                              0,
                                                              1), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5),
                                                              child: Checkbox(
                                                                  checkColor:
                                                                      CustomColor
                                                                          .buttonColor,
                                                                  value: userChecked
                                                                      .contains(
                                                                          name),
                                                                  hoverColor: Colors
                                                                      .green,
                                                                  focusColor: Colors
                                                                      .orangeAccent,
                                                                  side:
                                                                      const BorderSide(
                                                                    color: CustomColor
                                                                        .buttonColor,
                                                                    //your desire colour here
                                                                    width: 1.5,
                                                                  ),
                                                                  activeColor:
                                                                      Colors
                                                                          .white,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    _onSelectedCheckbox(
                                                                        value!,
                                                                        name,
                                                                        optionId
                                                                            .toString(),
                                                                        questionId
                                                                            .toString());
                                                                  })),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.7,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
                                                            child: Text(
                                                              name,
                                                              style: const TextStyle(
                                                                  color: CustomColor
                                                                      .titleTextColor,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                          },
                                        )
                                      : type == "input"
                                          ? answerInputs != null
                                              ? commentsTextFormField(
                                                  questionIds!,
                                                  _controllers[index],
                                                  answerInputs)
                                              : commentsTextFormFields(
                                                  questionIds!,
                                                  _controllers[index])
                                          : Container()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ),
      bottomNavigationBar:
          surveyQuestionList == null ? Container() : nextButtonWidget(),
    );
  }

  Widget commentsTextFormField(
      int id, TextEditingController controllertxt, String answerInput) {
    controllertxt.text = answerInput;
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      child: TextFormField(
        maxLines: 8,
        minLines: 8,
        keyboardType: TextInputType.text,
        controller: controllertxt,
        onChanged: (value) {
          _onChanged(controllertxt.text, id.toString());
        },
        decoration: InputDecoration(
          hintText: "Write your message here...",
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
          } else {
            selecedvalue = text;
          }
          return null;
        },
      ),
    );
  }

  Widget commentsTextFormFields(int id, TextEditingController controllertxt) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      child: TextFormField(
        maxLines: 8,
        minLines: 8,
        keyboardType: TextInputType.text,
        controller: controllertxt,
        onChanged: (value) {
          _onChanged(controllertxt.text, id.toString());
        },
        decoration: InputDecoration(
          hintText: "Write your message here...",
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
          } else {
            selecedvalue = text;
          }
          return null;
        },
      ),
    );
  }

  Widget nextButtonWidget() {

    return buttonStatus == true || surveyQuestionList?.length == 1
        ? Material(
            child: InkWell(
                onTap: () {
                  if (type == "input") {

                    if(widget.status == "completed"||widget.status=="incomplete"&&answerInput!=null){
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LandingScreen()),
                              (Route route) => false);
                    }else{
                      if (selecedvalue==null) {
                        CommonClass().toastWidget("Enter Some Input");
                      } else {
                        final body = {
                          "user_id": userID.toString(),
                          "survey_id": widget.serveyId.toString(),
                          "status": "completed",
                          "questions": [
                            {
                              "id": questionIds.toString(),
                              "type": type,
                              "option": type == "radio"
                                  ? selectedRadioButtonOptionList
                                  : type == "checkbox"
                                  ? selectedCheckBoxOptionList
                                  : [],
                              "input": selecedvalue,
                              "dateTime": currentDateTime
                            }
                          ]
                        };
                        CommonClass().showWait(context);
                        ApiService().saveSurvey(body).then((value) {
                          print("Completed Survey $value");
                          selectedRadioButtonOptionList = [];
                          selectedCheckBoxOptionList = [];
                          selectedRadioValue = null;
                          CommonClass().dismissDialog(context);
                          CommonClass().toastWidget(value['msg']);
                          Future.delayed(const Duration(milliseconds: 1800),
                                  () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const LandingScreen()),
                                        (Route route) => false);
                              });
                        });
                      }
                    }

                    // selectedOption.add({
                    //   "id": questionIds.toString(),
                    //   "type": "input",
                    //   "option": [],
                    //   "input": selecedvalue
                    // });||widget.status=="incomplete"&&checkBoxAnswerList!.isNotEmpty
                  }

                  else if (type == "checkbox") {
                    if(widget.status == "completed"||widget.status=="incomplete"&&checkBoxAnswerList!=null){
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LandingScreen()),
                              (Route route) => false);
                    }else{
                      if (selectedCheckBoxOptionList == []||selectedCheckBoxOptionList.isEmpty) {
                        CommonClass().toastWidget("Select Minimum One Option");
                      } else {
                        final body = {
                          "user_id": userID.toString(),
                          "survey_id": widget.serveyId.toString(),
                          "status": "completed",
                          "questions": [
                            {
                              "id": questionIds.toString(),
                              "type": type,
                              "option": type == "radio"
                                  ? selectedRadioButtonOptionList
                                  : type == "checkbox"
                                  ? selectedCheckBoxOptionList
                                  : [],
                              "input": selecedvalue,
                              "dateTime": currentDateTime
                            }
                          ]
                        };
                        CommonClass().showWait(context);
                        ApiService().saveSurvey(body).then((value) {
                          print("Completed Survey $value");
                          selectedRadioButtonOptionList = [];
                          selectedCheckBoxOptionList = [];
                          selectedRadioValue = null;
                          CommonClass().dismissDialog(context);
                          CommonClass().toastWidget(value['msg']);
                          Future.delayed(const Duration(milliseconds: 1800),
                                  () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const LandingScreen()),
                                        (Route route) => false);
                              });
                        });
                      }
                    }

                    // selectedOption.add({
                    //   "id": questionIds.toString(),
                    //   "type": "checkbox",
                    //   "option": selectedCheckBoxOptionList,
                    //   "input": ""
                    // });
                  }

                  else if (type == "radio") {

                   if(widget.status == "completed"||widget.status=="incomplete"&&radioButtonAnswer!=null){
                     Navigator.of(context).pushAndRemoveUntil(
                         MaterialPageRoute(
                             builder: (context) => const LandingScreen()),
                             (Route route) => false);
                   }else{
                     if (selectedRadioButtonOptionList == []||selectedRadioButtonOptionList.isEmpty) {
                       CommonClass().toastWidget("Select Your Option");
                     } else {
                       final body = {
                         "user_id": userID.toString(),
                         "survey_id": widget.serveyId.toString(),
                         "status": "completed",
                         "questions": [
                           {
                             "id": questionIds.toString(),
                             "type": type,
                             "option": type == "radio"
                                 ? selectedRadioButtonOptionList
                                 : type == "checkbox"
                                 ? selectedCheckBoxOptionList
                                 : [],
                             "input": selecedvalue,
                             "dateTime": currentDateTime
                           }
                         ]
                       };
                       CommonClass().showWait(context);
                       ApiService().saveSurvey(body).then((value) {
                         print("Completed Survey $value");
                         selectedRadioButtonOptionList = [];
                         selectedCheckBoxOptionList = [];
                         selectedRadioValue = null;
                         CommonClass().dismissDialog(context);
                         CommonClass().toastWidget(value['msg']);
                         Future.delayed(const Duration(milliseconds: 1800),
                                 () {
                               Navigator.of(context).pushAndRemoveUntil(
                                   MaterialPageRoute(
                                       builder: (context) =>
                                       const LandingScreen()),
                                       (Route route) => false);
                             });
                       });
                     }
                   }

                    // selectedOption.add({
                    //   "id": questionIds.toString(),
                    //   "type": "radio",
                    //   "option": selectedRadioButtonOptionList,
                    //   "input": ""
                    // });
                  }

                  else {
                    // selectedOption.remove({
                    //   "id": "",
                    //   "type": "",
                    //   "option":"",
                    //   "input": ""
                    // });
                  }
                },
                child: CommonClass().customButtonWidget(
                    context,
                    45,
                    MediaQuery.of(context).size.width,
                    20.0,
                    20.0,
                    20.0,
                    20.0,
                    "Submit",
                    18.0,
                    Colors.white)

            ),
          ):
    //     :buttonStatus == true || surveyQuestionList?.length == 1
    //     ?Material(
    //   child: Row(
    //     children: [
    //
    //       previousButtonWidget(),
    //
    //       InkWell(
    //           onTap: () {
    //             if (type == "input") {
    //
    //               if(widget.status == "completed"||widget.status=="incomplete"&&answerInput!=null){
    //                 Navigator.of(context).pushAndRemoveUntil(
    //                     MaterialPageRoute(
    //                         builder: (context) => const LandingScreen()),
    //                         (Route route) => false);
    //               }else{
    //                 if (selecedvalue==null) {
    //                   CommonClass().toastWidget("Enter Some Input");
    //                 } else {
    //                   final body = {
    //                     "user_id": userID.toString(),
    //                     "survey_id": widget.serveyId.toString(),
    //                     "status": "completed",
    //                     "questions": [
    //                       {
    //                         "id": questionIds.toString(),
    //                         "type": type,
    //                         "option": type == "radio"
    //                             ? selectedRadioButtonOptionList
    //                             : type == "checkbox"
    //                             ? selectedCheckBoxOptionList
    //                             : [],
    //                         "input": selecedvalue,
    //                         "dateTime": currentDateTime
    //                       }
    //                     ]
    //                   };
    //                   CommonClass().showWait(context);
    //                   ApiService().saveSurvey(body).then((value) {
    //                     print("Completed Survey $value");
    //                     selectedRadioButtonOptionList = [];
    //                     selectedCheckBoxOptionList = [];
    //                     selectedRadioValue = null;
    //                     CommonClass().dismissDialog(context);
    //                     CommonClass().toastWidget(value['msg']);
    //                     Future.delayed(const Duration(milliseconds: 1800),
    //                             () {
    //                           Navigator.of(context).pushAndRemoveUntil(
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                   const LandingScreen()),
    //                                   (Route route) => false);
    //                         });
    //                   });
    //                 }
    //               }
    //
    //               // selectedOption.add({
    //               //   "id": questionIds.toString(),
    //               //   "type": "input",
    //               //   "option": [],
    //               //   "input": selecedvalue
    //               // });||widget.status=="incomplete"&&checkBoxAnswerList!.isNotEmpty
    //             }
    //
    //             else if (type == "checkbox") {
    //
    //               if(widget.status == "completed"||widget.status=="incomplete"&&checkBoxAnswerList!=null){
    //                 Navigator.of(context).pushAndRemoveUntil(
    //                     MaterialPageRoute(
    //                         builder: (context) => const LandingScreen()),
    //                         (Route route) => false);
    //               }else{
    //                 if (selectedCheckBoxOptionList == []||selectedCheckBoxOptionList.isEmpty) {
    //                   CommonClass().toastWidget("Select Minimum One Option");
    //                 } else {
    //                   final body = {
    //                     "user_id": userID.toString(),
    //                     "survey_id": widget.serveyId.toString(),
    //                     "status": "completed",
    //                     "questions": [
    //                       {
    //                         "id": questionIds.toString(),
    //                         "type": type,
    //                         "option": type == "radio"
    //                             ? selectedRadioButtonOptionList
    //                             : type == "checkbox"
    //                             ? selectedCheckBoxOptionList
    //                             : [],
    //                         "input": selecedvalue,
    //                         "dateTime": currentDateTime
    //                       }
    //                     ]
    //                   };
    //                   CommonClass().showWait(context);
    //                   ApiService().saveSurvey(body).then((value) {
    //                     print("Completed Survey $value");
    //                     selectedRadioButtonOptionList = [];
    //                     selectedCheckBoxOptionList = [];
    //                     selectedRadioValue = null;
    //                     CommonClass().dismissDialog(context);
    //                     CommonClass().toastWidget(value['msg']);
    //                     Future.delayed(const Duration(milliseconds: 1800),
    //                             () {
    //                           Navigator.of(context).pushAndRemoveUntil(
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                   const LandingScreen()),
    //                                   (Route route) => false);
    //                         });
    //                   });
    //                 }
    //               }
    //
    //               // selectedOption.add({
    //               //   "id": questionIds.toString(),
    //               //   "type": "checkbox",
    //               //   "option": selectedCheckBoxOptionList,
    //               //   "input": ""
    //               // });
    //             }
    //
    //             else if (type == "radio") {
    //
    //               if(widget.status == "completed"||widget.status=="incomplete"&&radioButtonAnswer!=null){
    //                 Navigator.of(context).pushAndRemoveUntil(
    //                     MaterialPageRoute(
    //                         builder: (context) => const LandingScreen()),
    //                         (Route route) => false);
    //               }else{
    //                 if (selectedRadioButtonOptionList == []||selectedRadioButtonOptionList.isEmpty) {
    //                   CommonClass().toastWidget("Select Your Option");
    //                 } else {
    //                   final body = {
    //                     "user_id": userID.toString(),
    //                     "survey_id": widget.serveyId.toString(),
    //                     "status": "completed",
    //                     "questions": [
    //                       {
    //                         "id": questionIds.toString(),
    //                         "type": type,
    //                         "option": type == "radio"
    //                             ? selectedRadioButtonOptionList
    //                             : type == "checkbox"
    //                             ? selectedCheckBoxOptionList
    //                             : [],
    //                         "input": selecedvalue,
    //                         "dateTime": currentDateTime
    //                       }
    //                     ]
    //                   };
    //                   CommonClass().showWait(context);
    //                   ApiService().saveSurvey(body).then((value) {
    //                     print("Completed Survey $value");
    //                     selectedRadioButtonOptionList = [];
    //                     selectedCheckBoxOptionList = [];
    //                     selectedRadioValue = null;
    //                     CommonClass().dismissDialog(context);
    //                     CommonClass().toastWidget(value['msg']);
    //                     Future.delayed(const Duration(milliseconds: 1800),
    //                             () {
    //                           Navigator.of(context).pushAndRemoveUntil(
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                   const LandingScreen()),
    //                                   (Route route) => false);
    //                         });
    //                   });
    //                 }
    //               }
    //
    //               // selectedOption.add({
    //               //   "id": questionIds.toString(),
    //               //   "type": "radio",
    //               //   "option": selectedRadioButtonOptionList,
    //               //   "input": ""
    //               // });
    //             }
    //
    //             else {
    //               // selectedOption.remove({
    //               //   "id": "",
    //               //   "type": "",
    //               //   "option":"",
    //               //   "input": ""
    //               // });
    //             }
    //           },
    //           child: CommonClass().customButtonWidget(
    //               context,
    //               45,
    //               MediaQuery.of(context).size.width*0.4,
    //               20.0,
    //               20.0,
    //               20.0,
    //               20.0,
    //               "Submit",
    //               18.0,
    //               Colors.white)
    //
    //       ),
    //     ],
    //   ),
    // ): currentIndex==0?


          Material(
            child: InkWell(
                onTap: () {
                  setState(() {

                    if (type == "input") {

                      if(widget.status == "completed"||widget.status=="incomplete"&&answerInput!=null){
                      setState(() {
                        buttonStatus =
                            questionNumber + 2 == surveyQuestionList?.length;
                        _pageController.jumpToPage(questionNumber += 1);
                      });
                      }else{
                        if (selecedvalue==null) {
                          CommonClass().toastWidget("Enter Your Inputs");
                        } else {
                          final body = {
                            "user_id": userID.toString(),
                            "survey_id": widget.serveyId.toString(),
                            "status": "incompleted",
                            "questions": [
                              {
                                "id": questionIds.toString(),
                                "type": type,
                                "option": type == "radio"
                                    ? selectedRadioButtonOptionList
                                    : type == "checkbox"
                                    ? selectedCheckBoxOptionList
                                    : [],
                                "input": selecedvalue,
                                "dateTime": currentDateTime
                              }
                            ]
                          };
                          CommonClass().showWait(context);
                          ApiService().saveSurvey(body).then((value) {
                            setState(() {
                              selectedRadioButtonOptionList = [];
                              selectedCheckBoxOptionList = [];
                              selectedRadioValue = null;
                              print("Next Survey $value");
                              CommonClass().dismissDialog(context);
                              buttonStatus =
                                  questionNumber + 2 == surveyQuestionList?.length;
                              _pageController.jumpToPage(questionNumber += 1);
                            });

                          });
                        }
                      }

                      // selectedOption.add({
                      //   "id": questionIds.toString(),
                      //   "type": "input",
                      //   "option": [],
                      //   "input": selecedvalue
                      // });
                    }
                    else if (type == "checkbox") {

                      if(widget.status == "completed"||widget.status=="incomplete"&&checkBoxAnswerList!=null){
                       setState(() {
                         buttonStatus =
                             questionNumber + 2 == surveyQuestionList?.length;
                         _pageController.jumpToPage(questionNumber += 1);
                       });
                      }else{
                        if (selectedCheckBoxOptionList == []||selectedCheckBoxOptionList.isEmpty) {
                          CommonClass().toastWidget("Select Minimum One Option");
                        } else {
                          final body = {
                            "user_id": userID.toString(),
                            "survey_id": widget.serveyId.toString(),
                            "status": "incompleted",
                            "questions": [
                              {
                                "id": questionIds.toString(),
                                "type": type,
                                "option": type == "radio"
                                    ? selectedRadioButtonOptionList
                                    : type == "checkbox"
                                    ? selectedCheckBoxOptionList
                                    : [],
                                "input": selecedvalue,
                                "dateTime": currentDateTime
                              }
                            ]
                          };
                          CommonClass().showWait(context);
                          ApiService().saveSurvey(body).then((value) {
                            setState(() {
                              selectedRadioButtonOptionList = [];
                              selectedCheckBoxOptionList = [];
                              selectedRadioValue = null;
                              print("Next Survey $value");
                              CommonClass().dismissDialog(context);
                              buttonStatus =
                                  questionNumber + 2 == surveyQuestionList?.length;
                              _pageController.jumpToPage(questionNumber += 1);
                            });
                          });
                        }
                      }
                      // selectedOption.add({
                      //   "id": questionIds.toString(),
                      //   "type": "checkbox",
                      //   "option": selectedCheckBoxOptionList,
                      //   "input": ""
                      // });
                    }
                    else if (type == "radio") {
                     if(widget.status == "completed"||widget.status=="incomplete"&&radioButtonAnswer!=null){

                      setState(() {
                        buttonStatus =
                            questionNumber + 2 == surveyQuestionList?.length;
                        _pageController.jumpToPage(questionNumber += 1);
                      });

                     }else{
                       if (selectedRadioButtonOptionList == []||selectedRadioButtonOptionList.isEmpty) {
                         CommonClass().toastWidget("Select Your Option");
                       } else {
                         final body = {
                           "user_id": userID.toString(),
                           "survey_id": widget.serveyId.toString(),
                           "status": "incompleted",
                           "questions": [
                             {
                               "id": questionIds.toString(),
                               "type": type,
                               "option": type == "radio"
                                   ? selectedRadioButtonOptionList
                                   : type == "checkbox"
                                   ? selectedCheckBoxOptionList
                                   : [],
                               "input": selecedvalue,
                               "dateTime": currentDateTime
                             }
                           ]
                         };
                         CommonClass().showWait(context);
                         ApiService().saveSurvey(body).then((value) {
                           setState(() {
                             selectedRadioButtonOptionList = [];
                             selectedCheckBoxOptionList = [];
                             selectedRadioValue = null;
                             print("Next Survey $value");
                             CommonClass().dismissDialog(context);
                             buttonStatus =
                                 questionNumber + 2 == surveyQuestionList?.length;
                             _pageController.jumpToPage(questionNumber += 1);
                           });
                         });
                       }
                     }





                      // selectedOption.add({
                      //   "id": questionIds.toString(),
                      //   "type": "radio",
                      //   "option": selectedRadioButtonOptionList,
                      //   "input": ""
                      // });
                    }
                    else {
                      // selectedOption.remove({
                      //   "id": "",
                      //   "type": "",
                      //   "option":"",
                      //   "input": ""
                      // });
                    }
                  });
                },
                child: CommonClass().customButtonWidget(
                    context,
                    45,
                    MediaQuery.of(context).size.width,
                    20.0,
                    20.0,
                    20.0,
                    20.0,
                    "Next",
                    18.0,
                    Colors.white))
          );
    //     : Material(
    //   child:
    //   Row(
    //     children: [
    //       previousButtonWidget(),
    //       InkWell(
    //           onTap: () {
    //             setState(() {
    //               buttonStatus =
    //                   questionNumber + 2 == surveyQuestionList?.length;
    //
    //               if (type == "input") {
    //
    //                 if(widget.status == "completed"||widget.status=="incomplete"&&answerInput!=null){
    //                   _pageController.jumpToPage(questionNumber += 1);
    //                 }else{
    //                   if (selecedvalue==null) {
    //                     CommonClass().toastWidget("Enter Your Inputs");
    //                   } else {
    //                     final body = {
    //                       "user_id": userID.toString(),
    //                       "survey_id": widget.serveyId.toString(),
    //                       "status": "incompleted",
    //                       "questions": [
    //                         {
    //                           "id": questionIds.toString(),
    //                           "type": type,
    //                           "option": type == "radio"
    //                               ? selectedRadioButtonOptionList
    //                               : type == "checkbox"
    //                               ? selectedCheckBoxOptionList
    //                               : [],
    //                           "input": selecedvalue,
    //                           "dateTime": currentDateTime
    //                         }
    //                       ]
    //                     };
    //                     CommonClass().showWait(context);
    //                     ApiService().saveSurvey(body).then((value) {
    //                       selectedRadioButtonOptionList = [];
    //                       selectedCheckBoxOptionList = [];
    //                       selectedRadioValue = null;
    //                       print("Next Survey $value");
    //                       CommonClass().dismissDialog(context);
    //                       _pageController.jumpToPage(questionNumber += 1);
    //                     });
    //                   }
    //                 }
    //
    //
    //
    //                 // selectedOption.add({
    //                 //   "id": questionIds.toString(),
    //                 //   "type": "input",
    //                 //   "option": [],
    //                 //   "input": selecedvalue
    //                 // });
    //               }
    //               else if (type == "checkbox") {
    //
    //                 if(widget.status == "completed"||widget.status=="incomplete"&&checkBoxAnswerList!=null){
    //                   _pageController.jumpToPage(questionNumber += 1);
    //                 }else{
    //                   if (selectedCheckBoxOptionList == []||selectedCheckBoxOptionList.isEmpty) {
    //                     CommonClass().toastWidget("Select Minimum One Option");
    //                   } else {
    //                     final body = {
    //                       "user_id": userID.toString(),
    //                       "survey_id": widget.serveyId.toString(),
    //                       "status": "incompleted",
    //                       "questions": [
    //                         {
    //                           "id": questionIds.toString(),
    //                           "type": type,
    //                           "option": type == "radio"
    //                               ? selectedRadioButtonOptionList
    //                               : type == "checkbox"
    //                               ? selectedCheckBoxOptionList
    //                               : [],
    //                           "input": selecedvalue,
    //                           "dateTime": currentDateTime
    //                         }
    //                       ]
    //                     };
    //                     CommonClass().showWait(context);
    //                     ApiService().saveSurvey(body).then((value) {
    //                       selectedRadioButtonOptionList = [];
    //                       selectedCheckBoxOptionList = [];
    //                       selectedRadioValue = null;
    //                       print("Next Survey $value");
    //                       CommonClass().dismissDialog(context);
    //                       _pageController.jumpToPage(questionNumber += 1);
    //                     });
    //                   }
    //                 }
    //
    //
    //                 // selectedOption.add({
    //                 //   "id": questionIds.toString(),
    //                 //   "type": "checkbox",
    //                 //   "option": selectedCheckBoxOptionList,
    //                 //   "input": ""
    //                 // });
    //               }
    //               else if (type == "radio") {
    //
    //                 if(widget.status == "completed"||widget.status=="incomplete"&&radioButtonAnswer!=null){
    //                   _pageController.jumpToPage(questionNumber += 1);
    //                 }else{
    //                   if (selectedRadioButtonOptionList == []||selectedRadioButtonOptionList.isEmpty) {
    //                     CommonClass().toastWidget("Select Your Option");
    //                   } else {
    //                     final body = {
    //                       "user_id": userID.toString(),
    //                       "survey_id": widget.serveyId.toString(),
    //                       "status": "incompleted",
    //                       "questions": [
    //                         {
    //                           "id": questionIds.toString(),
    //                           "type": type,
    //                           "option": type == "radio"
    //                               ? selectedRadioButtonOptionList
    //                               : type == "checkbox"
    //                               ? selectedCheckBoxOptionList
    //                               : [],
    //                           "input": selecedvalue,
    //                           "dateTime": currentDateTime
    //                         }
    //                       ]
    //                     };
    //                     CommonClass().showWait(context);
    //                     ApiService().saveSurvey(body).then((value) {
    //                       selectedRadioButtonOptionList = [];
    //                       selectedCheckBoxOptionList = [];
    //                       selectedRadioValue = null;
    //                       print("Next Survey $value");
    //                       CommonClass().dismissDialog(context);
    //                       _pageController.jumpToPage(questionNumber += 1);
    //                     });
    //                   }
    //                 }
    //
    //
    //
    //
    //
    //                 // selectedOption.add({
    //                 //   "id": questionIds.toString(),
    //                 //   "type": "radio",
    //                 //   "option": selectedRadioButtonOptionList,
    //                 //   "input": ""
    //                 // });
    //               }
    //               else {
    //                 // selectedOption.remove({
    //                 //   "id": "",
    //                 //   "type": "",
    //                 //   "option":"",
    //                 //   "input": ""
    //                 // });
    //               }
    //             });
    //           },
    //           child: CommonClass().customButtonWidget(
    //               context,
    //               45,
    //               MediaQuery.of(context).size.width * 0.4,
    //               20.0,
    //               20.0,
    //               20.0,
    //               20.0,
    //               "Next",
    //               18.0,
    //               Colors.white)),
    //     ],
    //   ),
    // );
  }

  Widget previousButtonWidget() {
    return
      //buttonStatus == true || surveyQuestionList?.length == 1
     //   ?
    Material(
            child: InkWell(
                onTap: () {
                  setState(() {
                    // buttonStatus =
                    //     questionNumber + 2 == surveyQuestionList?.length;
                  });

                  print("prevv   $questionNumber");
                  _pageController.jumpToPage(questionNumber -= 1);
                },
                child: CommonClass().customButtonWidget(
                    context,
                    45,
                    MediaQuery.of(context).size.width*0.4,
                    20.0,
                    20.0,
                    20.0,
                    20.0,
                    "Previous",
                    18.0,
                    Colors.white)),
          );
        // : Material(
        //     child: InkWell(
        //         onTap: () {
        //           setState(() {
        //             buttonStatus =
        //                 questionNumber + 2 == surveyQuestionList?.length;
        //           });
        //           _pageController.jumpToPage(questionNumber -= 1);
        //         },
        //         child: CommonClass().customButtonWidget(
        //             context,
        //             45,
        //             MediaQuery.of(context).size.width*0.4,
        //             20.0,
        //             20.0,
        //             20.0,
        //             20.0,
        //             "Previous",
        //             18.0,
        //             Colors.white)),
        //   );
  }
}
