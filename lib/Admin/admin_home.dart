import 'dart:async';

import 'package:aarogyamswadeshi/Admin/Slider/add_slider.dart';
import 'package:aarogyamswadeshi/Admin/category/category_page.dart';
import 'package:aarogyamswadeshi/Admin/product/product_page.dart';
import 'package:aarogyamswadeshi/Admin/subcategory/subcategory_page.dart';
import 'package:aarogyamswadeshi/Admin/widget/drawer.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/Home/home_page.dart';
import 'package:aarogyamswadeshi/Services/admin_services.dart';
import 'package:aarogyamswadeshi/Services/category_service.dart';
import 'package:aarogyamswadeshi/Services/product_services.dart';
import 'package:aarogyamswadeshi/Services/subcategory_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'category/category_controller.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    getCategory();
    getsubategory();
    getAllproduct();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: Text(
            "Admin Dashboard",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        drawer: Drawerbar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // padding: EdgeInsets.only(top: 20),
                height: Get.height * 0.26,
                width: Get.width,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // SizedBox(height: Get.height * 0.03),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Aarogyam\nSwadeshi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
                          ),
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset("assets/images/logo.png",
                                  width: 100, height: 100, fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: Get.height * 0.03),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(CategoryPage());
                      },
                      child: Container(
                        height: Get.height * 0.13,
                        width: Get.width,
                        decoration: new BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.blue[900], Colors.blue[400]]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Category",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800),
                            ),
                            // Container(
                            //   height: 50,
                            //   width: 50,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(60),
                            //   ),
                            //   child: Icon(
                            //     Icons.arrow_forward,
                            //     size: 27,
                            //     color: Colors.black,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(SubCategoryPage());
                      },
                      child: Container(
                        height: Get.height * 0.13,
                        width: Get.width,
                        decoration: new BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.orange[900], Colors.orange[400]]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Subcategory",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800),
                            ),
                            // Container(
                            //   height: 50,
                            //   width: 50,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(60),
                            //   ),
                            //   child: Icon(
                            //     Icons.arrow_forward,
                            //     size: 27,
                            //     color: Colors.black,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(ProductPage());
                      },
                      child: Container(
                        height: Get.height * 0.13,
                        width: Get.width,
                        decoration: new BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.red[900], Colors.red[400]]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Products",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800),
                            ),
                            // Container(
                            //   height: 50,
                            //   width: 50,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(60),
                            //   ),
                            //   child: Icon(
                            //     Icons.arrow_forward,
                            //     size: 27,
                            //     color: Colors.black,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(AddSliderImages());
                      },
                      child: Container(
                        height: Get.height * 0.13,
                        width: Get.width,
                        decoration: new BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.green[900], Colors.green[400]]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Gallery",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.07),
            ],
          ),
        ));
  }
}
