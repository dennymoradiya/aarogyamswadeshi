import 'dart:async';

import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/Signup/admin_otp.dart';
import 'package:aarogyamswadeshi/Services/controller.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:aarogyamswadeshi/Services/signup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'Signup/background.dart';
import 'Signup/otp_screen.dart';

class EmailScreen extends StatefulWidget {
  EmailScreen({Key key}) : super(key: key);

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  Timer _timer;
  Controller controller = Get.put(Controller());
  @override
  void initState() {
    super.initState();
    controller.getConnect();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  TextEditingController emailController = TextEditingController(text: "");
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(() =>  controller.isIntenet.value
          ? Scaffold(
          body: Background(
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: size.height * 0.05),
                    Text(
                      "ENTER YOUR EMAIL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                        child: Image.asset(
                      "assets/images/logo.png",
                      height: Get.height * 0.2,
                      width: Get.width,
                    )),
                    SizedBox(height: size.height * 0.03),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        children: [
                          TextFormField(
                              cursorColor: kPrimaryColor,
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Email",
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
                            prefixIcon: Icon(
                              Icons.email,
                              color: kPrimaryColor,
                            ),
                          ),
                          validator: (email) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(email))
                              return 'Enter Valid Email';
                            else
                              return null;
                          }),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.25),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: ElevatedButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        // removeisAdmin();
                        if (formkey.currentState.validate()) {
                          formkey.currentState.save();
                          EasyLoading.show(status: 'Loading...');
                          var email = emailController.text;
                          SentOtp(email).then((value) async {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                              msg: value,
                            );
                            if (value == "Please check your email for code") {
                              setUserinfo(
                                email: email,
                              );
                              if (await getisAdmin()) {
                                Get.to(AdminOtp(
                                  email: email,
                                ));
                              } else {
                                Get.to(Otp(
                                  email: email,
                                ));
                              }
                            }
                          });
                        }
                        // Get.to(Otp());
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
                SizedBox(height: size.height * 0.08),
              ],
            ),
          ),
        ),
      ),
    ):  Scaffold(
              backgroundColor: Colors.grey,
              body: AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.error,
                      size: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Alert"),
                  ],
                ),
                content: Text(
                  "You are not connected to the Internet",
                  style: TextStyle(fontSize: 17),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        controller.getConnect();
                        Get.offAll(context);
                      },
                      child: Text("Ok"))
                ],
              ),
            ),);
  }
}
