import 'dart:async';
import 'dart:math';
import 'package:aarogyamswadeshi/Screens/Home/home_main.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:aarogyamswadeshi/Services/signup_service.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'background.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController(text: "");
  // TextEditingController snameController = TextEditingController(text: "");
  TextEditingController lnameController = TextEditingController(text: "");
  TextEditingController adressController = TextEditingController(text: "");
  TextEditingController mobileController = TextEditingController(text: "");
  TextEditingController cityController = TextEditingController(text: "");
  TextEditingController stateController = TextEditingController(text: "");
  TextEditingController bussinessController = TextEditingController(text: "");
  Timer _timer;
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: size.height * 0.05),
                SizedBox(height: size.height * 0.05),
                Text(
                  "USER INFORMATION",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: size.height * 0.07),
                // Container(
                //     child: Image.asset(
                //   "assets/images/logo.png",
                //   height: Get.height * 0.2,
                //   width: Get.width,
                // )),

                // SizedBox(height: size.height * 0.03),

                //fist name
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
                //  Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 35),
                //   child: Column(
                //     children: [
                //       TextFormField(
                //         cursorColor: kPrimaryColor,
                //         decoration: InputDecoration(
                //           hintText: "Enter Last Name",
                //           enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //               width: 1,
                //               color: kPrimaryColor,
                //               style: BorderStyle.solid,
                //             ),
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //           focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //               width: 1,
                //               color: kPrimaryColor,
                //             ),
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //           border: OutlineInputBorder(
                //             borderSide: BorderSide(
                //               width: 1,
                //               color: kPrimaryColor,
                //             ),
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //           prefixIcon: Icon(
                //             Icons.person,
                //             color: kPrimaryColor,
                //           ),
                //         ),
                //         controller: lnameController,
                //         validator: (value) {
                //           if (value.isEmpty) {
                //             return "Last Name is Required";
                //           } else
                //             return null;
                //         },
                //       ),
                //       SizedBox(height: size.height * 0.03),
                //     ],
                //   ),
                // ),
                // //mobile numner
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
                        "Submit",
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
                            "lname": lnameController.text,
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
                              EasyLoading.showSuccess("Login Sucessfully");
                              EasyLoading.dismiss();
                              setlogin(true);
                              Get.offAll(MainScreen());
                            } else {
                              EasyLoading.dismiss();
                              Fluttertoast.showToast(
                                  msg: "Login Failed !",
                                  backgroundColor: Colors.red);
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
                SizedBox(height: size.height * 0.08),
              ],
            ),
         
          ),
        ),
      ),
    );
  }
}
