import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loyola/login_src/login_screen.dart';
import '../Commons/common_class.dart';
import '../Commons/constant_class.dart';
import '../Services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

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
                      // color: Colors.white,
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
                        'Register',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: CustomColor.titleTextColor),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 580,
                  margin: const EdgeInsets.only(left: 60, top: 90, right: 60),
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
                  height: 565,
                  margin: const EdgeInsets.only(left: 40, top: 90, right: 40),
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
                  height: 550,
                  margin: const EdgeInsets.only(left: 20, top: 90, right: 20),
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
                          margin: const EdgeInsets.only(left: 20, top: 0),
                          child: CommonClass().textWidget('Name', context),
                        ),
                        nameTextFormField(),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 0),
                          child: CommonClass()
                              .textWidget('Email Address', context),
                        ),
                        emailAddressTextFormField(),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 0),
                          child:
                              CommonClass().textWidget('Phone Number', context),
                        ),
                        phoneNumberTextFormField(),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 0),
                          child: CommonClass().textWidget('Password', context),
                        ),
                        passwordTextFormField(),
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 0),
                          child: CommonClass()
                              .textWidget('Confirm Password', context),
                        ),
                        confirmPasswordTextFormField(),
                        signUpButtonWidget(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: signinWidget()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget nameTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        controller: nameController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[A-Za-z0-9 ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter Name",

          // border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.perm_identity, color: Colors.grey),
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

  Widget passwordTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        controller: passwordController,
        obscureText: _isObscurePassword,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp(r'[ ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter Password",

          // border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _isObscurePassword
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye_sharp,
              color: _isObscurePassword ? Colors.grey : Colors.green,
            ),
            onPressed: () {
              setState(() {
                _isObscurePassword = !_isObscurePassword;
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

  Widget phoneNumberTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.allow(
            RegExp(r'[0-9]'),
          ),
          FilteringTextInputFormatter.deny(
            RegExp(r'[ ]'),
          ),
        ],
        controller: phoneNumberController,
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

  Widget confirmPasswordTextFormField() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: TextFormField(
        maxLines: 1,
        controller: confirmPasswordController,
        obscureText: _isObscureConfirmPassword,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp(r'[ ]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: "Enter Confirm Password",

          // border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _isObscureConfirmPassword
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye_sharp,
              color: _isObscureConfirmPassword ? Colors.grey : Colors.green,
            ),
            onPressed: () {
              setState(() {
                _isObscureConfirmPassword = !_isObscureConfirmPassword;
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

  Widget signUpButtonWidget() {
    return Material(
      child: InkWell(
          onTap: () {
            CommonClass().showWait(context);
            final body = {
              "name": nameController.text.toString(),
              "email": emailAddressController.text.toString(),
              "phone": phoneNumberController.text.toString(),
              "password": passwordController.text.toString(),
              "confirm_password": confirmPasswordController.text.toString()
            };
            // if (emailAddressController.text.isEmpty) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Email Address is Empty");
            // } else if (!emailAddressController.text.contains("@")&&!emailAddressController.text.contains(".")) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Invalid Email Address");
            // } else if (phoneNumberController.text.isEmpty) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Phone Number is Empty");
            // } else if (phoneNumberController.text.length != 10) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Invalid Phone Number");
            // } else if (passwordController.text.isEmpty) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Password is Empty");
            // } else if (passwordController.text.length<8) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Password Should be 8 Character");
            // } else if (confirmPasswordController.text.isEmpty) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Confirm Password is Empty");
            // } else if (confirmPasswordController.text.length<8) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Confirm Password Should be 8 Character");
            // } else if (passwordController.text !=
            //     confirmPasswordController.text) {
            //   CommonClass().dismissDialog(context);
            //   CommonClass().toastWidget("Password does not matched");
            // } else {
            ApiService().getSignup(body).then((value) => {
                  CommonClass().dismissDialog(context),
                  print("Signup data ${value.toString()}"),
                  if (value['status'] == "success")
                    {
                      CommonClass().toastWidget(value['msg']),
                      Future.delayed(const Duration(milliseconds: 2500), () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }),
                        );
                      })
                    }
                  else
                    {
                      if (value['errors']['name'] != null)
                        {CommonClass().toastWidget(value['errors']['name'][0])},
                      if (value['errors']['email'] != null)
                        {
                          CommonClass().toastWidget(value['errors']['email'][0])
                        },
                      if (value['errors']['phone'] != null)
                        {
                          CommonClass().toastWidget(value['errors']['phone'][0])
                        },
                      if (value['errors']['password'] != null)
                        {
                          CommonClass()
                              .toastWidget(value['errors']['password'][0])
                        },
                      if (value['errors']['confirm_password'] != null)
                        {
                          CommonClass().toastWidget(
                              value['errors']['confirm_password'][0])
                        },
                    }
                });
            //  }
          },
          child: CommonClass().customButtonWidget(
              context,
              45,
              MediaQuery.of(context).size.width,
              15.0,
              20.0,
              20.0,
              10.0,
              "Submit",
              18.0,
              Colors.white)),
    );
  }

  Widget signinWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Already have an account?",
          style: TextStyle(color: CustomColor.subTitleTextColor, fontSize: 16),
        ),
        TextButton(
          child: const Text(
            'Sign In',
            style: TextStyle(fontSize: 16, color: CustomColor.buttonColor),
          ),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }));
          },
        )
      ],
    );
  }
}
