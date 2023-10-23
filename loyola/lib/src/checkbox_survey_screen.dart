import 'package:flutter/material.dart';
import 'package:loyola/src/comments_survey_screen.dart';

import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';

class CheckboxSurveyScreen extends StatefulWidget {
  const CheckboxSurveyScreen({Key? key}) : super(key: key);

  @override
  State<CheckboxSurveyScreen> createState() => _CheckboxSurveyScreenState();
}

class _CheckboxSurveyScreenState extends State<CheckboxSurveyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios,color: CustomColor.subTitleTextColor,)),
        title: const Text(
          "English for beginner",
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 20, color: CustomColor.subTitleTextColor),
        ),
        elevation: 0,
      ),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Container(
              margin: const EdgeInsets.only(top: 20,left: 20,),
              child: Text('Question 2/15',style: TextStyle(color: CustomColor.buttonColor,fontSize: 16,fontWeight: FontWeight.w500),),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20,left: 20,),
              child: Text('Motor racing is the -- sport in the world.',style: TextStyle(color: CustomColor.titleTextColor,fontSize: 24,fontWeight: FontWeight.w700),),
            ),

            Container(
              // color: Colors.yellow,
              margin:
              const EdgeInsets.only(top: 20,left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/clock_icon.png',
                    height: 20,
                  ),
                  SizedBox(width: 5,),
                  const Text(
                    'May, 10, 2023',
                    style: TextStyle(
                        color: CustomColor.subTitleTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),

                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                    offset:
                    const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Checkbox(
                         checkColor: CustomColor.buttonColor,
                          value: true,
                          hoverColor: Colors.green,

                          focusColor: Colors.orangeAccent,
                          side: BorderSide(
                            color: Colors.amber, //your desire colour here
                            width: 1.5,
                          ),
                          activeColor: Colors.white,
                          onChanged: (bool? value) {  },

                        )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Text(
                        'Most Expensive',
                        style: TextStyle(
                            color: CustomColor.titleTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                    offset:
                    const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Checkbox(
                          checkColor: CustomColor.buttonColor,
                          value: true,
                          hoverColor: Colors.green,

                          focusColor: Colors.orangeAccent,
                          side: BorderSide(
                            color: Colors.amber, //your desire colour here
                            width: 1.5,
                          ),
                          activeColor: Colors.white,
                          onChanged: (bool? value) {  },

                        )
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Text(
                        'More Expensive',
                        style: TextStyle(
                            color: CustomColor.titleTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                    offset:
                    const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Checkbox(
                          checkColor: CustomColor.buttonColor,
                          value: true,
                          hoverColor: Colors.green,

                          focusColor: Colors.orangeAccent,
                          side: BorderSide(
                            color: Colors.amber, //your desire colour here
                            width: 1.5,
                          ),
                          activeColor: Colors.white,
                          onChanged: (bool? value) {  },

                        )
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Text(
                        'Expensivest',
                        style: TextStyle(
                            color: CustomColor.titleTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                    offset:
                    const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Checkbox(
                          checkColor: CustomColor.buttonColor,
                          value: true,
                          hoverColor: Colors.green,

                          focusColor: Colors.orangeAccent,
                          side: BorderSide(
                            color: Colors.amber, //your desire colour here
                            width: 1.5,
                          ),
                          activeColor: Colors.white,
                          onChanged: (bool? value) {  },

                        )
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Text(
                        'As Expensive',
                        style: TextStyle(
                            color: CustomColor.titleTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: signUpButtonWidget(),
    );
  }

  Widget signUpButtonWidget() {
    return GestureDetector(

      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return CommentsSurveyScreen();
        }));
      },
      // onTap: () {
      //   CommonClass().showWait(context);
      //   final body = {
      //     "email": emailAddressController.text.toString(),
      //     "password": passwordController.text.toString(),
      //   };
      //   if (emailAddressController.text.isEmpty) {
      //     CommonClass().dismissDialog(context);
      //     CommonClass().toastWidget("User Emailm is Empty");
      //   } else if (passwordController.text.isEmpty) {
      //     CommonClass().dismissDialog(context);
      //     CommonClass().toastWidget("Password is Empty");
      //   } else if (emailAddressController.text.isEmpty ||
      //       passwordController.text.isEmpty) {
      //     CommonClass().dismissDialog(context);
      //     CommonClass().toastWidget("All Fields are Required");
      //   } else {
      //     ApiService().getLogin(body).then((value) => {
      //       CommonClass().dismissDialog(context),
      //       print("login data ${value.toString()}"),
      //       if (value['status'] == "success")
      //         {
      //
      //           Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(builder: (context) {
      //               return const LandingScreen();
      //             }),
      //           )
      //         }
      //       else
      //         {CommonClass().toastWidget(value['msg'])}
      //     });
      //   }
      // },
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
            Colors.white));
  }
}
