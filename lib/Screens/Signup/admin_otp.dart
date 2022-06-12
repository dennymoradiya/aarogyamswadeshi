import 'dart:async';

import 'package:aarogyamswadeshi/Screens/Home/home_main.dart';
import 'package:aarogyamswadeshi/Screens/Signup/admin_forgot_password.dart';
import 'package:aarogyamswadeshi/Screens/Signup/passcode_screen.dart';
import 'package:aarogyamswadeshi/Screens/Signup/user_info.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:aarogyamswadeshi/Services/signup_service.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class AdminOtp extends StatefulWidget {
  final String email;
  const AdminOtp({
    Key key,
    this.email,
  }) : super(key: key);

  @override
  _AdminOtpState createState() => _AdminOtpState();
}

class _AdminOtpState extends State<AdminOtp> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  OtpFieldController otpController = OtpFieldController();
  String otp = "";
  int secondsRemaining = 60;
  bool enableResend = false;
  Timer timer;
  Timer _timer;
  bool isVisible = false;
  TextEditingController passController = TextEditingController();

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });

    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  void resendCode() {
    setState(() {
      secondsRemaining = 60;
      enableResend = false;
    });
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("isadmin");
    // print(widget.isAdmin);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.black54,
                    ),
                  ),
                ),
                // Container(
                //   width: Get.width * 0.5,
                //   height: Get.width * 0.5,
                //   decoration: BoxDecoration(
                //     // color: kPrimaryColor,
                //     shape: BoxShape.circle,
                //   ),
                //   child: Image.asset(
                //     "assets/images/otp.png",
                //   ),
                // ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Text(
                  "We will send otp to your\n${widget.email}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      OTPTextField(
                          controller: otpController,
                          length: 4,
                          width: MediaQuery.of(context).size.width,
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldWidth: 55,
                          fieldStyle: FieldStyle.box,
                          outlineBorderRadius: 15,
                          style: TextStyle(fontSize: 17),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          otpFieldStyle: OtpFieldStyle(
                            borderColor: kPrimaryColor,
                            focusBorderColor: kPrimaryColor,
                            enabledBorderColor: Colors.black38,
                            disabledBorderColor: Colors.black38,
                          ),
                          onChanged: (pin) {},
                          onCompleted: (pin) {
                            setState(() {
                              otp = pin;
                            });
                          }),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      Form(
                        key: formkey,
                        child: TextFormField(
                          cursorColor: kPrimaryColor,
                          obscureText: !isVisible,
                          decoration: InputDecoration(
                              hintText: "Password",
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
                                Icons.lock,
                                color: kPrimaryColor,
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
                              )),
                          controller: passController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Enter the Password";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            resendOtpcode(widget.email).then((value) {
                              Fluttertoast.showToast(msg: value);
                              Get.to(ForgotpasswordScreen());
                            });
                          },
                          child: Text(
                            "Forgot password ?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            var adminpass = await getAdminpassword();
                            print(adminpass);
                            print(passController.text);
                            if (otp.length != 4) {
                              scaffoldMessage(context, "Fill the OTP fields");
                            } else {
                              if (formkey.currentState.validate()) {
                                EasyLoading.show(status: 'Loading...');
                                verifyUser(
                                        widget.email.toString(), int.parse(otp))
                                    .then((value) async {
                                  if (value == "400") {
                                    EasyLoading.showInfo("OTP code is wrong!");
                                    EasyLoading.dismiss();
                                  } else if (value == "200") {
                                    if (adminpass.trim() ==
                                        passController.text) {
                                      EasyLoading.showSuccess("Success!");
                                      EasyLoading.dismiss();
                                      Get.off(Passcode());
                                    } else {
                                      EasyLoading.showInfo(
                                          "Password is wrong!");
                                      EasyLoading.dismiss();
                                    }
                                  }
                                });
                              }
                            }
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kPrimaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 18),
                            child: Text(
                              'Verify',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Text(
                  "If you didn\'t receive a code!",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                enableResend
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              resendOtpcode(widget.email).then((value) {
                                scaffoldMessage(context, value);
                              });
                              resendCode();
                            },
                            child: Text(
                              "Resend Code",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            '  $secondsRemaining seconds',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Resend Code",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[300],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '  $secondsRemaining seconds',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
