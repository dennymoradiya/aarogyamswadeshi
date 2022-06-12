import 'dart:async';
import 'package:aarogyamswadeshi/Screens/Home/home_main.dart';
import 'package:aarogyamswadeshi/Screens/Signup/passcode_screen.dart';
import 'package:aarogyamswadeshi/Screens/Signup/user_info.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'email_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
    // removeToken();
    // removelogin();
    // removeuserid();

    Timer(const Duration(seconds: 3), () async {
      if (await getlogin() == true) {
        if (await getisAdmin() == true) {
          Get.off(Passcode());
        } else {
          Get.off(MainScreen());
        }
      } else {
        Get.off(EmailScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      body: Center(
        child: Container(
          height: Get.height * 0.35,
          width: Get.width * 0.8,
          child: Image.asset(
            "assets/images/logo.png",
            height: Get.height * 0.35,
            width: Get.width * 0.8,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
