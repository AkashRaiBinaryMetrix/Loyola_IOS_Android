import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loyola/login_src/login_screen.dart';
import 'package:loyola/src/edit_profile_screen.dart';
import 'package:loyola/src/feedback_screen.dart';
import 'package:loyola/src/notification_screen.dart';
import 'package:loyola/src/survey_history_screen.dart';
import 'package:loyola/src/surveys_history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';
import '../login_src/change_password_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? userID;
  List? profileList;
  String? name, email, image;

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
      getProfileData();
    });
  }

  void getProfileData() {
    CommonClass().showWait(context);
    ApiService().getProfile(userID!).then((value) => setState(() {
          CommonClass().dismissDialog(context);
          profileList = value['data'];

          name = profileList![0]['name'];
          email = profileList![0]['email'];

          /// image = profileList![0]['image'];
        }));
  }

  DateTime? backbuttonpressedTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime!) >
            const Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    {
      SystemNavigator.pop();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
                        //    color: Colors.white,
                      )),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 0,
                      top: 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.of(context).pop();
                        //   },
                        //   child: Image.asset(
                        //     'assets/images/back_yellow_btn.png',
                        //     height: 40,
                        //   ),
                        // ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: CustomColor.titleTextColor),
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 370,
                    margin:
                        const EdgeInsets.only(left: 20, top: 170, right: 20),
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
                          name == null
                              ? Container(
                                  margin:
                                      const EdgeInsets.only(left: 20, top: 50),
                                )
                              : Container(
                                  margin:
                                      const EdgeInsets.only(left: 0, top: 50),
                                  child: Text(
                                    name!,
                                    //  'Carolina Terner',
                                    style: const TextStyle(
                                        color: CustomColor.titleTextColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        fontFamily:
                                            'assets/fonts/poppins_regular.ttf'),
                                  )),
                          email == null
                              ? Container(
                                  margin:
                                      const EdgeInsets.only(left: 20, top: 5),
                                )
                              : Container(
                                  margin:
                                      const EdgeInsets.only(left: 0, top: 5),
                                  child: Text(
                                    email!,
                                    // "carolina.terner124@gmail.com",
                                    style: const TextStyle(
                                        color: CustomColor.subTitleTextColor,
                                        fontSize: 13,
                                        fontFamily:
                                            'assets/fonts/poppins_regular.ttf'),
                                  )),
                          name == null && email == null
                              ? Container()
                              : Material(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return const EditProfileScreen();
                                      })).then((value) => getProfileData());
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 15, bottom: 10),
                                      decoration: BoxDecoration(
                                        color: CustomColor.buttonColor,
                                        border: Border.all(
                                            color: CustomColor.buttonColor),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0),
                                            bottomRight: Radius.circular(20.0)),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.05),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0,
                                                1), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                            top: 5.0,
                                            bottom: 5.0),
                                        child: Text(
                                          'Edit Profile',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          const Divider(
                            color: Colors.black12,
                            thickness: 2,
                            endIndent: 20,
                            indent: 20,
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, top: 15, right: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return const ChangePasswordScreen();
                                  }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/change_password_icon.png',
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Change Password',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.navigate_next)
                                  ],
                                ),
                              )),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, top: 15, right: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return const NotificationsScreen();
                                  }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/notifications_icon.png',
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Notifications',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.navigate_next)
                                  ],
                                ),
                              )),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, top: 15, right: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return const SurveysHistoryScreen();
                                  }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/survey_history_icon.png',
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Survey History',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.navigate_next)
                                  ],
                                ),
                              )),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, top: 15, right: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return const FeedbackScreen();
                                  }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/feedback.png',
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Help & Feedback',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.navigate_next)
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  name == null && email == null
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.only(
                              left: 20, top: 120, right: 20),
                          child: Center(
                              child: Image.asset(
                            'assets/images/profile_image.png',
                            height: 90,
                          )),
                        ),
                  Container(
                    margin: const EdgeInsets.only(top: 570),
                    child: Center(
                      child: signInButtonWidget(),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget signInButtonWidget() {
    return Material(
      child: InkWell(
          onTap: () {
            final body = {"user_id": userID.toString()};
            ApiService().getLogout(body).then((value) {
              CommonClass().logout(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }), (route) => false);
            });
          },
          child: CommonClass().customButtonWidget(
              context,
              45,
              MediaQuery.of(context).size.width,
              20.0,
              20.0,
              20.0,
              0.0,
              "Logout",
              18.0,
              Colors.white)),
    );
  }
}
