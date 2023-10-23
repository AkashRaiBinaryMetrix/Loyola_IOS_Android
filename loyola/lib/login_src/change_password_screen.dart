import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  int?userID;
  final TextEditingController oldController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool _isOldObscure = true;
  bool _isNewObscure = true;
  bool _isConfirmObscure = true;

  @override
  void initState() {
    super.initState();
    getLoginData();
  }

  getLoginData() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    userID = prefs.getInt("userId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      'assets/images/background.png',
                      fit: BoxFit.fill,
                    )),
                Positioned(
                  bottom:-170,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: saveButtonWidget()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 0,
                    top: 40,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          'assets/images/back_yellow_btn.png',
                          height: 40,
                        ),
                      ),
                      const Text(
                        'Change Password',
                        style: TextStyle(
                            fontSize:26,
                            fontWeight: FontWeight.w700,
                            color: CustomColor.titleTextColor),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 355,
                  margin: const EdgeInsets.only(left: 20, top: 150, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 15),
                          child: CommonClass()
                              .textWidget('Old Password*', context),
                        ),
                        oldTextFormField(),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          child:
                          CommonClass().textWidget('New Password*', context),
                        ),
                        newTextFormField(),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          child:
                          CommonClass().textWidget('Confirm New Password*', context),
                        ),
                       confirmTextFormField()
                      ],
                    ),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  Widget oldTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 15.0, right: 15, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        controller: oldController,
        obscureText: _isOldObscure,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp(r'[ ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter Old Password",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.green,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.black26,
              width: 1.0,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isOldObscure
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye_sharp,
              color: _isOldObscure ? Colors.grey : Colors.green,
            ),
            onPressed: () {
              setState(() {
                _isOldObscure = !_isOldObscure;
              });
            },
          ),

        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Enter Name';
          }
          return null;
        },
      ),
    );
  }

  Widget newTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 15.0, right: 15, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        controller: newController,
        obscureText: _isNewObscure,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp(r'[ ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter New Password",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.green,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.black26,
              width: 1.0,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isNewObscure
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye_sharp,
              color: _isNewObscure ? Colors.grey : Colors.green,
            ),
            onPressed: () {
              setState(() {
                _isNewObscure = !_isNewObscure;
              });
            },
          ),
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Enter Email';
          }
          return null;
        },
      ),
    );
  }

  Widget confirmTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 15.0, right: 15, top: 5.0,bottom: 10),
      child: TextFormField(
        maxLines: 1,
        controller: confirmController,
        obscureText: _isConfirmObscure,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp(r'[ ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter Confirm Password",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.green,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.black26,
              width: 1.0,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmObscure
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye_sharp,
              color: _isConfirmObscure ? Colors.grey : Colors.green,
            ),
            onPressed: () {
              setState(() {
                _isConfirmObscure = !_isConfirmObscure;
              });
            },
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
    return Material(
      child: InkWell(
          onTap: () {
            getChangePassword();
          },
          child: CommonClass().customButtonWidget(
              context,
              50,
              MediaQuery.of(context).size.width,
              20.0,
              20.0,
              20.0,
              200.0,
              "Update Password",
              18.0,
              Colors.white)),
    );
  }

  void getChangePassword() {
    CommonClass().showWait(context);
    final body = {
      "user_id": userID.toString(),
      "old_password": oldController.text.trim().toString(),
      "new_password": newController.text.trim().toString(),
      "confirm_password": confirmController.text.trim().toString()
    };

    // if (oldController.text.isEmpty) {
    //   CommonClass().dismissDialog(context);
    //   CommonClass().toastWidget("Old Password is Empty");
    // }
    // else if (newController.text.isEmpty) {
    //   CommonClass().dismissDialog(context);
    //   CommonClass().toastWidget("New Password is Empty");
    // }
    // else if (confirmController.text.isEmpty) {
    //   CommonClass().dismissDialog(context);
    //   CommonClass().toastWidget("Confirm New Password is Empty");
    // }
    // else if (newController.text!=confirmController.text) {
    //   CommonClass().dismissDialog(context);
    //   CommonClass().toastWidget("Password does not matched");
    // }
    // else {
      ApiService().changePasswordApi(body).then((value) =>
        setState(() {
          CommonClass().dismissDialog(context);
          print(value);
         if (value['status_code']==200 ){
           CommonClass().toastWidget(value['msg']);
           Future.delayed(const Duration(milliseconds: 2500), () {
             final body = {"user_id": userID.toString()};
             ApiService().getLogout(body).then((value) {
               CommonClass().logout(context);
               Navigator.of(context).pushAndRemoveUntil(
                   MaterialPageRoute(builder: (context) {
                     return LoginScreen();
                   }), (route) => false);
             });
           });
         }else{
           if(value['passworderrors']!=null){
             CommonClass().toastWidget(value['passworderrors']);
           }else{
             if(value['errors']['old_password']!=null){
               CommonClass().toastWidget(value['errors']['old_password'][0]);
             }
             if(value['errors']['new_password']!=null){
               CommonClass().toastWidget(value['errors']['new_password'][0]);
             }
             if(value['errors']['confirm_password']!=null){
               CommonClass().toastWidget(value['errors']['confirm_password'][0]);
             }
           }
           // else{
           //   CommonClass().toastWidget(value['msg']);
           // }
         }
        }));
   // }
  }
  }
