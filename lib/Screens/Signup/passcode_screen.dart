import 'package:aarogyamswadeshi/Admin/admin_home.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/email_screen.dart';
import 'package:aarogyamswadeshi/Services/controller.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:code_input/code_input.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import 'confirm_passcode.dart';

class Passcode extends StatefulWidget {
  @override
  State<Passcode> createState() => _PasscodeState();
}

class _PasscodeState extends State<Passcode> {
  String passcode = "";
  bool isForgot = false;
  OtpFieldController passcodeController = OtpFieldController();
  Controller controller = Get.put(Controller());
  void checkPasscode() async {
    if (await getPasscode() != null) {
      isForgot = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    checkPasscode();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isIntenet.value
          ? Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: kPrimaryColor,
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: Get.height * 0.1,
                  ),
                  Text(
                    "Enter your passcode",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OTPTextField(
                        controller: passcodeController,
                        obscureText: true,
                        length: 4,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 55,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 15,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        otpFieldStyle: OtpFieldStyle(
                          borderColor: Colors.white,
                          focusBorderColor: Colors.white,
                          enabledBorderColor: Colors.white,
                          disabledBorderColor: Colors.white,
                        ),
                        onChanged: (pin) {
                          setState(() {
                            passcode = pin;
                          });
                        },
                        onCompleted: (pin) {
                          setState(() {
                            passcode = pin;
                          });
                        }),
                  ),
                  // CodeInput(
                  //     length: 4,
                  //     keyboardType: TextInputType.number,
                  //     builder: CodeInputBuilders.lightCircle(),
                  //     spacing: 8,
                  //     onFilled: (value) {
                  //       print(value);
                  //       setState(() {
                  //         passcode = value;
                  //       });
                  //     },
                  //     onDone: (value) {
                  //       print(value);
                  //       setState(() {
                  //         passcode = value;
                  //       });
                  //     }),

                  SizedBox(
                    height: Get.height * 0.2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: Get.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: ElevatedButton(
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            // print(passcode);
                            if (passcode.length != 4) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter passcode");
                            } else {
                              var pass = await getPasscode();
                              if (pass != null) {
                                if (pass == passcode) {
                                  Get.offAll(AdminHomePage());
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Passcode is Wrong!",
                                      backgroundColor: Colors.red);
                                }
                              } else {
                                Get.to(ConfirmPasscode(passcode: passcode));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                  isForgot
                      ? InkWell(
                          onTap: () {
                            removepasscode();
                            Get.to(EmailScreen());
                          },
                          child: Text(
                            "Forgot passcode ?",
                            style: TextStyle(
                                color: Colors.lightBlue[900],
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                ],
              )))
          : Scaffold(
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
            ),
    );
  }
}
