import 'dart:async';

import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/email_screen.dart';
import 'package:aarogyamswadeshi/Services/admin_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'background.dart';

class ForgotpasswordScreen extends StatefulWidget {
  ForgotpasswordScreen({Key key}) : super(key: key);

  @override
  State<ForgotpasswordScreen> createState() => _ForgotpasswordScreenState();
}

GlobalKey<FormState> formkey = GlobalKey<FormState>();
TextEditingController idController = TextEditingController(text: "");
TextEditingController passController = TextEditingController(text: "");
TextEditingController otpController = TextEditingController(text: "");
bool isVisible = false;
Timer _timer;

class _ForgotpasswordScreenState extends State<ForgotpasswordScreen> {
  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: Get.height * 0.05),
                Text(
                  "FORGOT PASSWORD",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                Container(
                    child: Image.asset(
                  "assets/images/logo.png",
                  height: Get.height * 0.2,
                  width: Get.width,
                )),
                SizedBox(height: Get.height * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          hintText: "Enter Id",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kPrimaryColor,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kPrimaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kPrimaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: idController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Id is Required";
                          } else
                            return null;
                        },
                      ),
                      SizedBox(height: Get.height * 0.03),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    children: [
                      TextFormField(
                        obscureText: !isVisible,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kPrimaryColor,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              isVisible = !isVisible;
                              setState(() {});
                            },
                            child: isVisible
                                ? Icon(
                                    Icons.visibility_off,
                                    color: kPrimaryColor,
                                  )
                                : Icon(
                                    Icons.visibility,
                                    color: kPrimaryColor,
                                  ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kPrimaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kPrimaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // prefixIcon: Icon(
                          //   Icons.person,
                          //   color: kPrimaryColor,
                          // ),
                        ),
                        controller: passController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Password is Required";
                          } else if (value.length > 15 || value.length < 4) {
                            return 'Please enter 4 - 15 digit password';
                          } else
                            return null;
                        },
                      ),
                      SizedBox(height: Get.height * 0.03),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          hintText: "Enter Otp Code",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kPrimaryColor,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kPrimaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kPrimaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // prefixIcon: Icon(
                          //   Icons.person,
                          //   color: kPrimaryColor,
                          // ),
                        ),
                        controller: otpController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Otp is Required";
                          } else if (value.length > 4 || value.length < 4) {
                            return 'Please enter 4 Digit Otp';
                          } else
                            return null;
                        },
                      ),
                      SizedBox(height: Get.height * 0.03),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: Get.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: ElevatedButton(
                      child: Text(
                        "FORGOT PASSWORD",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (formkey.currentState.validate()) {
                          EasyLoading.show(status: 'Loading...');
                          formkey.currentState.save();
                          Map data = {
                            "id": idController.text,
                            "otp": otpController.text,
                            "password": passController.text,
                          };
                          forgotPassword(data).then((value) {
                            if (value == "password updated successfully") {
                              EasyLoading.dismiss();
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) => AlertDialog(
                                        content: Text(
                                          "Your Password is successfully updated",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        kPrimaryColor)),
                                            child: Text("Ok"),
                                            onPressed: () {
                                              Get.offAll(EmailScreen());
                                            },
                                          )
                                        ],
                                      ));

                              // EasyLoading.showSuccess("Password Updated");
                              // EasyLoading.dismiss();
                            } else {
                              EasyLoading.showInfo(value);
                              EasyLoading.dismiss();
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
