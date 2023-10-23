import 'package:flutter/material.dart';
import 'package:loyola/Commons/constant_class.dart';
import 'package:loyola/login_src/login_screen.dart';
import 'package:loyola/login_src/register_screen.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'landing_screen.dart';

class ChooseLoginSignupScreen extends StatefulWidget {
  const ChooseLoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<ChooseLoginSignupScreen> createState() =>
      _ChooseLoginSignupScreenState();
}

class _ChooseLoginSignupScreenState extends State<ChooseLoginSignupScreen> {
  int initialData = 0;

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
                    ///  color: Colors.white,
                    )),
                Container(
                  height: 400,
                  margin: const EdgeInsets.only(left: 60, top: 40, right: 60),
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
                ),
                Container(
                  height: 385,
                  margin: const EdgeInsets.only(left: 40, top: 40, right: 40),
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
                ),
                Container(
                  height: 370,
                  margin: const EdgeInsets.only(left: 20, top: 40, right: 20),
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
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Image.asset('assets/images/intro.png'),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: ToggleSwitch(
                        minWidth: MediaQuery.of(context).size.width * .5,
                        minHeight: 50,
                        initialLabelIndex: initialData,
                        activeBgColor: [CustomColor.buttonColor],

                        ///  activeBorders: [Border.all(color: Color(0xffFFC814))],
                        inactiveBgColor: Colors.white,
                        // borderColor: [Colors.black12],
                        radiusStyle: true,
                        fontSize: 16,
                        borderWidth: 1,
                        totalSwitches: 2,
                        labels: ['Register', 'Sign In'],
                        onToggle: (index) {
                          print('switched to: $index');
                          initialData = index!;
                          initialData == 0
                              ? Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return const RegisterScreen();
                                  }),
                                )
                              : Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }),
                                );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 130,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Learn, Unlearn, Relearn.',
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w700),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, top: 10, right: 20),
                              child: Text(
                                'Education surveys are created to get feedback from students, teachers, and other members of an educational institution.',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    height: 1.3),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
