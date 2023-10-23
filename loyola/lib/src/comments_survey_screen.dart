import 'package:flutter/material.dart';
import 'package:loyola/login_src/landing_screen.dart';

import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';

class CommentsSurveyScreen extends StatefulWidget {
  const CommentsSurveyScreen({Key? key}) : super(key: key);

  @override
  State<CommentsSurveyScreen> createState() => _CommentsSurveyScreenState();
}

class _CommentsSurveyScreenState extends State<CommentsSurveyScreen> {

  final TextEditingController commentsController = TextEditingController();

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
      body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Container(
            margin: const EdgeInsets.only(top: 20,left: 20,),
            child: Text('Question 3/15',style: TextStyle(color: CustomColor.buttonColor,fontSize: 16,fontWeight: FontWeight.w500),),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20,left: 20,),
            child: Text('Something about yourself',style: TextStyle(color: CustomColor.titleTextColor,fontSize: 24,fontWeight: FontWeight.w700),),
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

         commentsTextFormField(),
        ],
      ),

      bottomNavigationBar: signUpButtonWidget(),
    );
  }

  Widget signUpButtonWidget() {
    return GestureDetector(

        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return LandingScreen();
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
            "Submit",
            18.0,
            Colors.white));
  }

  Widget commentsTextFormField() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20.0,left: 20,right: 20),
      child: TextFormField(
        maxLines: 8,
        minLines: 8,
        keyboardType: TextInputType.text,
        controller: commentsController,
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
          }
          return null;
        },
      ),
    );
  }
}
