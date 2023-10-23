import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:some_calendar/some_calendar.dart';
import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';
import '../login_src/landing_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  int? userID;
  List? profileList;
  String? name, email, phone, dob, image;
  DateTime selectedDate = DateTime.now();

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
          dob = profileList![0]['dob'];
          phone = profileList![0]['phone'];

          /// image = profileList![0]['image'];

          fullNameController.text = name ?? "";
          emailAddressController.text = email ?? "";
          dateOfBirthController.text = dob ?? "";
          phoneNumberController.text = phone ?? "";
        }));
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
                        'Edit Profile',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: CustomColor.titleTextColor),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 480,
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
                          margin: const EdgeInsets.only(left: 20, top: 40),
                          child: CommonClass().textWidget('Full Name', context),
                        ),
                        fullNameTextFormField(),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          child: CommonClass()
                              .textWidget('Email Address', context),
                        ),
                        emailAddressTextFormField(),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          child:
                              CommonClass().textWidget('Phone Number', context),
                        ),
                        phoneNumberTextFormField(),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          child: CommonClass()
                              .textWidget('Date of Birth', context),
                        ),
                        dateOfBirthTextFormField(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: updateButtonWidget()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 110, right: 20),
                  child: Center(
                      child: Image.asset(
                    'assets/images/profile_image.png',
                    height: 90,
                  )),
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
        readOnly: true,
        keyboardType: TextInputType.emailAddress,
        controller: emailAddressController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-z0-9@. ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter email Address",
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

  // Widget dateOfBirthTextFormField() {
  //   return InkWell(
  //     onTap: (){
  //       dateOfBirthCalenderDialog(context);
  //     },
  //     child: Container(
  //       height: 55,
  //       width: MediaQuery.of(context).size.width,
  //       margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
  //       child: TextFormField(
  //         maxLines: 1,
  //         controller: dateOfBirthController,
  //         enabled: false,
  //         readOnly: true,
  //         decoration: InputDecoration(
  //           hintText: "Select Date of Birth",
  //
  //           // border: InputBorder.none,
  //           suffixIcon: IconButton(
  //             icon: Icon(Icons.calendar_month),
  //             onPressed: () {
  //             },
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(5.0),
  //             borderSide: const BorderSide(
  //               color: Colors.grey,
  //             ),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(5.0),
  //             borderSide: const BorderSide(
  //               color: Colors.grey,
  //               width: 1.0,
  //             ),
  //           ),
  //         ),
  //
  //       ),
  //     ),
  //   );
  // }

  Widget phoneNumberTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        controller: phoneNumberController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.allow(
            RegExp(r'[0-9]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter Phone Number",
          //labelText: "Enter Email",

          //  border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.phone,
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

  Widget fullNameTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        controller: fullNameController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(30),
          FilteringTextInputFormatter.allow(
            RegExp(r'[A-Za-z0-9 ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter Full Name",

          // border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.perm_identity_rounded),
            onPressed: () {},
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

  Widget updateButtonWidget() {
    return Material(
      child: InkWell(
          onTap: () {
            CommonClass().showWait(context);
            final body = {
              "user_id": userID.toString(),
              "name": fullNameController.text.toString(),
              "phone": phoneNumberController.text.toString(),
              "dob": dateOfBirthController.text.toString()
            };
            if (fullNameController.text.isEmpty) {
              CommonClass().dismissDialog(context);
              CommonClass().toastWidget("Full Name is Empty");
            } else if (phoneNumberController.text.isEmpty) {
              CommonClass().dismissDialog(context);
              CommonClass().toastWidget("Phone Number is Empty");
            } else if (phoneNumberController.text.length != 10) {
              CommonClass().dismissDialog(context);
              CommonClass().toastWidget("Invalid Phone Number");
            } else if (dateOfBirthController.text.isEmpty) {
              CommonClass().dismissDialog(context);
              CommonClass().toastWidget("Select Date of Birth");
            } else {
              ApiService().updateProfile(body).then((value) => {
                    print("update Profile data ${value.toString()}"),
                    if (value['status'] == "success")
                    {
                        CommonClass().dismissDialog(context),
                        CommonClass().toastWidget(value['msg']),
                        Future.delayed(const Duration(milliseconds: 2500), () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const LandingScreen();
                          }));
                        })
                      }
                    else
                      {
                        CommonClass().dismissDialog(context),
                        CommonClass().toastWidget(value['msg'])
                      }
                  });
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
              "Save & Update",
              18.0,
              Colors.white)),
    );
  }

  Widget dateOfBirthTextFormField() {
    return InkWell(
      onTap: () {
        dateOfBirthCalenderDialog(context);
      },
      child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black26),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              top: 5,
            ),
            child: TextField(
              enabled: false,
              readOnly: true,
              controller: dateOfBirthController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black87),
                hintText: 'Select Date of Birth',
                suffixIcon: Icon(Icons.calendar_month),
                fillColor: Colors.white,
                // filled: true
              ),
            ),
          )),
    );
  }

  dateOfBirthCalenderDialog(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1920),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18 + 4)),
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18 + 4)),
      selectableDayPredicate: (day) => day.isBefore(DateTime.now()),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (selectedDate != null) {
      setState(() {
        dateOfBirthController.text =
            DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    } else {
      dateOfBirthController.text = "";
    }

    // showDialog(
    //     context: context,
    //     builder: (_) =>
    //         SomeCalendar(
    //           primaryColor: CustomColor.yellowColor,
    //           mode: SomeMode.Single,
    //           labels: Labels(
    //             dialogDone: 'Select',
    //             dialogCancel: 'Cancel',
    //             // dialogRangeFirstDate: 'Tanggal Pertama',
    //             // dialogRangeLastDate: 'Tanggal Terakhir',
    //           ),
    //           isWithoutDialog: false,
    //            selectedDate: DateTime.now().subtract(const Duration(days: 365*18+4)),
    //          // selectedDate: selectedDate,
    //           lastDate: DateTime.now().subtract(const Duration(days: 365*18)),
    //          // lastDate: DateTime.now().subtract(const Duration(days: 0)),
    //           // lastDate: DateTime(2100),
    //           startDate: DateTime(1920),
    //           // startDate: DateTime(2020, 6, 28),
    //           // lastDate: Jiffy().add(months: 9),
    //
    //
    //           done: (date) {
    //             setState(() {
    //               var mDay, mMonth, mYear;
    //               selectedDate = date;
    //               if (selectedDate.day < 10) {
    //                 mDay = '0${selectedDate.day}';
    //               } else {
    //                 mDay = selectedDate.day;
    //               }
    //
    //               if (selectedDate.month < 10) {
    //                 mMonth = '0${selectedDate.month}';
    //               } else {
    //                 mMonth = selectedDate.month;
    //               }
    //
    //               if (selectedDate.year < 10) {
    //                 mYear = '0${selectedDate.year}';
    //               } else {
    //                 mYear = selectedDate.year;
    //               }
    //               dateOfBirthController.text = ('${mDay}-${mMonth}-${mYear}');
    //             });
    //           },
    //
    //
    //
    //         ));
  }
}
