import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loyola/login_src/register_screen.dart';
import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';
import 'landing_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgetEmailAddressController =
      TextEditingController();
  bool _isObscure = true;
  String? deviceToken;

  @override
  void initState() {
    super.initState();
    getFirebaseToken();
  }

  getFirebaseToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        deviceToken = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
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
                      //  color: Colors.white,
                    )),
                Container(
                  margin: const EdgeInsets.only(
                    left: 0,
                    top: 40,
                  ),
                  child: Row(
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
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Log in.',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: CustomColor.titleTextColor),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 460,
                  margin: const EdgeInsets.only(left: 60, top: 150, right: 60),
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
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 445,
                  margin: const EdgeInsets.only(left: 40, top: 150, right: 40),
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
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 430,
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
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 20, top: 30),
                            child: const Text(
                              'Hello Again!',
                              style: TextStyle(
                                  color: CustomColor.titleTextColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  fontFamily:
                                      'assets/fonts/poppins_regular.ttf'),
                            )),
                        Container(
                            margin: const EdgeInsets.only(left: 20, top: 10),
                            child: const Text(
                              "Welcome back you've been missed!",
                              style: TextStyle(
                                  color: CustomColor.subTitleTextColor,
                                  fontSize: 15,
                                  fontFamily:
                                      'assets/fonts/poppins_regular.ttf'),
                            )),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 15),
                          child: CommonClass()
                              .textWidget('Email Address', context),
                        ),
                        emailAddressTextFormField(),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          child: CommonClass().textWidget('Password', context),
                        ),
                        passwordTextFormField(),
                        forgetPasswordWidget(),
                        signInButtonWidget(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: signupWidget()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget emailAddressTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        controller: emailAddressController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-z0-9@. ]'),
          ),
          FilteringTextInputFormatter.deny(
            RegExp(r'[ ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter Email Address",
          //labelText: "Enter Email",

          //  border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          // ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Enter ID';
          }
          return null;
        },
      ),
    );
  }

  Widget passwordTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        controller: passwordController,
        obscureText: _isObscure,
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
          FilteringTextInputFormatter.deny(
            RegExp(r'[ ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter Password",
          // border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye_sharp,
              color: _isObscure ? Colors.grey : Colors.green,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Enter Password';
          }
          return null;
        },
      ),
    );
  }

  Widget signInButtonWidget() {
    return Material(
      color: Colors.white,
      child: InkWell(
          onTap: () {
            CommonClass().showWait(context);
            final body = {
              "email": emailAddressController.text.toString(),
              "password": passwordController.text.toString(),
              "access_token": deviceToken.toString()
            };
            // if (emailAddressController.text.isEmpty) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Email Address is Empty");
            // } else if (!emailAddressController.text.contains("@") &&
            //     !emailAddressController.text.contains(".")) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Invalid Email Address");
            // } else if (passwordController.text.isEmpty) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Password is Empty");
            // } else {
              ApiService().getLogin(body).then((value) => {
                    CommonClass().dismissDialog(context),
                    print("login data ${value.toString()}"),
                    if (value['status'] == "success"){
                        CommonClass().saveLoginData(
                            value['data']['fcm_id'],
                            value['data']['token_type'],
                            value['data']['user_Details']['id']),
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return const LandingScreen();
                          }),
                        )
                      }
                    else {
                      if(value['errors']==null){
                        CommonClass().toastWidget(value['msg'])
                      }else{
                        if(value['errors']['email']!=null){
                          CommonClass().toastWidget(value['errors']['email'][0])
                        },
                        if(value['errors']['password']!=null){
                          CommonClass().toastWidget(value['errors']['password'][0])
                        },
                      }
                    }
                  });
          //  }
          },
          child: CommonClass().customButtonWidget(
              context,
              45,
              MediaQuery.of(context).size.width,
              20.0,
              20.0,
              20.0,
              0.0,
              "Sign In",
              18.0,
              Colors.white)),
    );
  }

  Widget forgetEmailAddressTextFormField() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: true,
        keyboardType: TextInputType.emailAddress,
        controller: forgetEmailAddressController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9@.]'),
          ),
          FilteringTextInputFormatter.deny(
            RegExp(r'[ ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter Email Address",
          //labelText: "Enter Email",

          //  border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          // ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Enter ID';
          }
          return null;
        },
      ),
    );
  }

  Widget forgetButtonWidget() {
    return Material(
      child: InkWell(
          onTap: () {
            CommonClass().showWait(context);
            final body = {
              "email": forgetEmailAddressController.text.toString(),
            };
            if (forgetEmailAddressController.text.isEmpty) {
              CommonClass().dismissDialog(context);
              CommonClass().toastWidget("Email Address is Empty");
            } else if (!forgetEmailAddressController.text.contains('@') &&
                !forgetEmailAddressController.text.contains('.')) {
              CommonClass().dismissDialog(context);
              CommonClass().toastWidget("Invalid Email Address");
            } else {
              ApiService().getForgetPassword(body).then((value) => {

                    print("forget Password data ${value.toString()}"),
                    if (value['status'] == "success")
                      {
                        CommonClass().dismissDialog(context),
                        CommonClass().toastWidget(value['msg']),
            Future.delayed(const Duration(milliseconds: 2000), () {
              Navigator.of(context).pop();
            })


                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(builder: (context) {
                        //     return LoginScreen();
                        //   }),
                        // )
                      }
                    else
                      {
                        CommonClass().dismissDialog(context),
                        CommonClass().toastWidget(value['msg']??value['errors']['email'][0]),
                      }

                  });
            }
          },
          child: CommonClass().customButtonWidget(
              context,
              50,
              MediaQuery.of(context).size.width,
              20.0,
              20.0,
              20.0,
              10.0,
              "Generate Link",
              18.0,
              Colors.white)),
    );
  }

  Widget forgetPasswordWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20, right: 20),
      child: InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              // context and builder are
              // required properties in this widget
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              // clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (BuildContext context) {
                // we set up a container inside which
                // we create center column and display text

                // Returning SizedBox instead of a Container
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          'assets/images/lock_icon.png',
                          height: 45,
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                                color: CustomColor.titleTextColor,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'assets/fonts/poppins_regular.ttf'),
                            textAlign: TextAlign.center,
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 0, top: 10),
                          child: const Text(
                            'Enter your registered email address below to receive the password reset link',
                            style: TextStyle(
                                color: CustomColor.subTitleTextColor,
                                fontSize: 14,
                                height: 1.3,
                                fontFamily: 'assets/fonts/poppins_regular.ttf'),
                            textAlign: TextAlign.center,
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          child: CommonClass()
                              .textWidget('Email Address', context)),
                      forgetEmailAddressTextFormField(),
                      forgetButtonWidget(),
                    ],
                  ),
                );
              },
            );
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: CustomColor.titleTextColor, fontSize: 14),
            textAlign: TextAlign.right,
          )),
    );
  }

  Widget signupWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Don't have an account yet?",
          style: TextStyle(color: CustomColor.subTitleTextColor, fontSize: 16),
        ),
        TextButton(
          child: const Text(
            'Sign Up',
            style: TextStyle(fontSize: 16, color: CustomColor.buttonColor),
          ),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return const RegisterScreen();
            }));
          },
        )
      ],
    );
  }
}
