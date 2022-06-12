import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:aarogyamswadeshi/Screens/Home/home_main.dart';
import 'package:aarogyamswadeshi/Screens/Signup/background.dart';
import 'package:aarogyamswadeshi/Screens/account/account_controller.dart';
import 'package:aarogyamswadeshi/Services/login_services.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Screens/Home/home_page.dart';
import 'package:aarogyamswadeshi/Screens/Signup/otp_screen.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:aarogyamswadeshi/Services/signup_service.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AccountController accountController = Get.put(AccountController());

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController bussinessController = TextEditingController();
  Timer _timer;

  void setuserdetails() {
    fnameController.text = accountController.userdata["name"];
    adressController.text = accountController.userdata["address"];
    cityController.text = accountController.userdata["city"];
    mobileController.text = accountController.userdata["mobileNo"];
    bussinessController.text = accountController.userdata["business"];
    stateController.text = accountController.userdata["state"];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    setuserdetails();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text("Account"),
        // actions: [
        //   PopupMenuButton(
        //     itemBuilder: (_) => <PopupMenuItem<String>>[
        //       new PopupMenuItem<String>(child: Text('Logout'), value: '1'),
        //     ],
        //     onSelected: (item) {
        //       switch (item) {
        //         case "1":
        //           // Get.to(HomePage());
        //           break;
        //         default:
        //       }
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: size.height * 0.05),
              Text(
                "Account Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),

              SizedBox(height: size.height * 0.07),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "Enter First Name",
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
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                      ),
                      controller: fnameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "First Name is Required";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
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
                        hintText: "Enter Mobile Number",
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
                          Icons.phone_android_outlined,
                          color: kPrimaryColor,
                        ),
                      ),
                      controller: mobileController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Mobile Number is Required";
                        } else if (value.length != 10) {
                          return "Please Enter 10 digit Number";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),

              //address
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    TextFormField(
                      minLines: 1,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "Enter Your Address",
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
                          Icons.location_on_sharp,
                          color: kPrimaryColor,
                        ),
                      ),
                      controller: adressController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Address is Required";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),

              // city
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "Enter Your City Name",
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
                          Icons.location_city_outlined,
                          color: kPrimaryColor,
                        ),
                      ),
                      controller: cityController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "City Name is Required";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),

              //state
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "Enter Your State Name",
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
                          Icons.map_outlined,
                          color: kPrimaryColor,
                        ),
                      ),
                      controller: stateController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "State Name is Required";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),
              //bussiness
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "Enter Your Bussiness Name",
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
                          Icons.business_center_outlined,
                          color: kPrimaryColor,
                        ),
                      ),
                      controller: bussinessController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Bussiness Name is Required";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: ElevatedButton(
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      String randomString(int length) {
                        var rand = new Random();
                        var codeUnits = new List.generate(length, (index) {
                          return rand.nextInt(33) + 89;
                        });
                        return String.fromCharCodes(codeUnits);
                      }

                      // EasyLoading.show(status: 'Loading...');
                      if (formkey.currentState.validate()) {
                        EasyLoading.show(status: 'Loading...');

                        formkey.currentState.save();
                        Map userdata = {
                          "name": fnameController.text,
                          // "sname": snameController.text,
                          // "lname": lnameController.text,
                          "mobileNo": mobileController.text,
                          "city": cityController.text,
                          "address": adressController.text,
                          "state": stateController.text,
                          "business": bussinessController.text,
                          // "password": randomString(6)
                        };
                        print(userdata);
                        updateUser(userdata).then((value) {
                          print(value);
                          if (value == "User updated") {
                            EasyLoading.showSuccess("Updated Sucessfully!");
                            EasyLoading.dismiss();
                            getUserDetails().then((value) {
                              setuserdetails();
                              setState(() {});
                            });
                          } else {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: "User Not updated!",
                                backgroundColor: Colors.red);
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
