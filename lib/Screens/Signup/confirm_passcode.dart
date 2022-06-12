import 'package:aarogyamswadeshi/Admin/admin_home.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/Signup/passcode_screen.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:code_input/code_input.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class ConfirmPasscode extends StatefulWidget {
  final passcode;
  ConfirmPasscode({Key key, this.passcode}) : super(key: key);

  @override
  State<ConfirmPasscode> createState() => _ConfirmPasscodeState();
}

class _ConfirmPasscodeState extends State<ConfirmPasscode> {
  String cpasscode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: Get.height * 0.1,
            ),
            Text(
              "Confirm your passcode",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OTPTextField(
                  length: 4,
                   obscureText: true,
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
                      cpasscode = pin;
                    });
                  },
                  onCompleted: (pin) {
                    setState(() {
                      cpasscode = pin;
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
            //         cpasscode = value;
            //       });
            //     },
            //     onDone: (value) {
            //       print(value);
            //       setState(() {
            //         cpasscode = value;
            //       });
            //     }),
            SizedBox(
              height: Get.height * 0.2,
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: Get.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: ElevatedButton(
                    child: Text(
                      "Confirm Passcode",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      
                      // print(passcode);
                      if (cpasscode.length != 4) {
                        Fluttertoast.showToast(msg: "Please Enter passcode");
                      } else {
                        if (cpasscode != widget.passcode) {
                          Fluttertoast.showToast(msg: "Passcode is not match!");
                        } else {
                          setPasscode(cpasscode);
                          setlogin(true);
                          Fluttertoast.showToast(
                              msg: "Passcode set sucessfully!");
                          Get.offAll(AdminHomePage());
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}
