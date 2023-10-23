import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_src/login_screen.dart';
import 'constant_class.dart';
import 'custome_alert_dialog.dart';

class CommonClass {
  appBarWidget(String title) {
    return AppBar(
      elevation: 1,
      shadowColor: Colors.black26,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  toastWidget(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 18.0);
  }

  textFieldWidget(String hints, var fieldId,
      {required TextInputType keyboardTypes}) {
    return Container(
        height: 50,
        margin: const EdgeInsets.only(left:0.0, right: 0.0, top: 5.0),
        child: TextField(
          controller: fieldId,
          style: const TextStyle(color: Colors.black),
          keyboardType: keyboardTypes,
          decoration: InputDecoration(
               hintStyle: const TextStyle(color: Colors.black26),
              hintText: hints,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
              fillColor: Colors.white,
              filled: true),
        ));
  }

  customButtonWidget(
      BuildContext context,
      double height,
      width,
      topMargin,
      leftMargin,
      rightMargin,
      bottomMargin,
      String name,
      double fontSize,
      Color colors) {
    return Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(
            left: leftMargin,
            right: rightMargin,
            top: topMargin,
            bottom: bottomMargin),
        // padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: CustomColor.buttonColor,
            border: Border.all(color: CustomColor.buttonColor),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7.0),
                topRight: Radius.circular(7.0),
                bottomLeft: Radius.circular(7.0),
                bottomRight: Radius.circular(7.0))),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
                color: colors,
                fontSize: fontSize,
                fontFamily: "assets/fonts/poppins_regular.ttf"),
          ),
        ));
  }

  textWidget(String name, BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 0.0, top: 15.0, right:0.0),
        child: Text(
          name,
          style: const TextStyle(color: CustomColor.subTitleTextColor, fontSize: 14.0,fontWeight: FontWeight.w500),
          textAlign: TextAlign.start,
        ));
  }

  saveLoginData(String accessToken, tokenType, int userId) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", accessToken);
    prefs.setString('tokenType', tokenType);
    prefs.setInt('userId', userId);
  }

  logout(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("accessToken");
    preferences.remove('tokenType');
    preferences.remove('userId');
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) {
    //     return LoginScreen();
    //   }),
    // );
  }

  void showWait(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                          // width: MediaQuery.of(context).size.width,
                          child: CircularProgressIndicator()),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: const Text(
                          "LOADING...",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  void alertDialogs(context, msg) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Opps!'),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void customeAlertDialog(context,description){

    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: "Alert",
          description:description,
        );
      },
    );
  }

  void dismissDialog(context) {
    Navigator.pop(context);
  }

  devLineWidget(double thickness, startMargin, endMargin) {
    return Divider(
      color: Colors.black12,
      thickness: thickness,
      indent: startMargin,
      endIndent: endMargin,
    );
  }

}
