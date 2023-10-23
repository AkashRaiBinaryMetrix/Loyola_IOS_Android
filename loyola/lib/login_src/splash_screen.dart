import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loyola/login_src/choose_login_signup_screen.dart';
import 'package:loyola/src/notifications_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    Timer(const Duration(seconds: 2), () => getLoginData());



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //  channel.description,
                //      color: Colors.blue,
                //  playSound: true,
                //   icon: '@mipmap/launcher_icon',

                //  sound: RawResourceAndroidNotificationSound('test')
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new messageopen app event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LandingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // CHeck for Errors
        if (snapshot.hasError) {
          print("Something went Wrong");
        }
        // once Completed, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              title: 'Loyola',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              debugShowCheckedModeBanner: false,
              home:  Image.asset(
                'assets/images/splash.png',fit: BoxFit.fill,),
              // Stack(
              //   children: [
              //     SizedBox(
              //         height: MediaQuery.of(context).size.height,
              //         child: Image.asset(
              //           'assets/images/background.png',
              //           fit: BoxFit.fill,
              //           color: Colors.transparent,
              //         )),
              //     Container(
              //       child: Center(
              //         child: Padding(
              //           padding: const EdgeInsets.all(80.0),
              //           child: Column(
              //             children: [
              //               Image.asset(
              //                 'assets/images/logo1.png',
              //               ),
              //               const SizedBox(
              //                 height: 50,
              //               ),
              //               Image.asset(
              //                 'assets/images/logo2.png',
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // )
          );
        }
        return const CircularProgressIndicator();
      },
    );


    // return GetMaterialApp(
    //     title: 'Loyola',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     debugShowCheckedModeBanner: false,
    //     home: Stack(
    //       children: [
    //         SizedBox(
    //             height: MediaQuery.of(context).size.height,
    //             child: Image.asset(
    //               'assets/images/background.png',
    //               fit: BoxFit.fill,
    //               color: Colors.transparent,
    //             )),
    //         Container(
    //           child: Center(
    //             child: Padding(
    //               padding: const EdgeInsets.all(80.0),
    //               child: Column(
    //                 children: [
    //                   Image.asset(
    //                     'assets/images/logo1.png',
    //                   ),
    //                   const SizedBox(
    //                     height: 50,
    //                   ),
    //                   Image.asset(
    //                     'assets/images/logo2.png',
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ));
  }

  getLoginData() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt("userId");
    String? userToken = prefs.getString("accessToken");
    userID == null && userToken == "" || userToken == null
        ? Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) {
              return ChooseLoginSignupScreen();
            }),
          )
        : Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) {
              return const LandingScreen();
            }),
          );
  }
}
