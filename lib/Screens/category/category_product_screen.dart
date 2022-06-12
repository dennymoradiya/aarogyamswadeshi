import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/Home/home_controller.dart';
import 'package:aarogyamswadeshi/Screens/desc/desc_screen.dart';
import 'package:get/get.dart';

class ProductCategoryScreen extends StatefulWidget {
  final title;
  ProductCategoryScreen({Key key, this.title}) : super(key: key);

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

Homecontroller homecontroller = Get.find();

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("${widget.title}"),
        ),
        body: Obx(() {
          return homecontroller.categoryviseProductlist.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: homecontroller.categoryviseProductlist.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing:
                              MediaQuery.of(context).size.width * 0.025,
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width * 0.025,
                          mainAxisExtent:
                              MediaQuery.of(context).size.height * 0.30,
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, index) {
                        String imgString = homecontroller
                            .categoryviseProductlist[index]["productimagepath"];
                        Uint8List decodedbytes = base64.decode(imgString);
                        return InkWell(
                          onTap: () async {
                            Get.to(HomeCategoryProductDescription(
                              productdatalist:
                                  homecontroller.categoryviseProductlist[index],
                            ));
                          },
                          child: Card(
                            elevation: 2,
                            shadowColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  width: Get.width,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      child: Image.memory(
                                        decodedbytes,
                                        fit: BoxFit.fitHeight,
                                      )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 2),
                                  child: Text(
                                    homecontroller
                                            .categoryviseProductlist[index]
                                        ["productName"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: Colors.black54.withOpacity(0.6)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                      left: 8,
                                    ),
                                    child: Text(
                                      "₹ ${homecontroller.categoryviseProductlist[index]["price"]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: kPrimaryColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: Container(
                                      child: Text(
                                    homecontroller
                                                .categoryviseProductlist[index]
                                            ["isProductAvailable"]
                                        ? "Available"
                                        : "Not Available",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : Center(
                  child: Text(
                    "No Product Found !",
                    style: TextStyle(color: kPrimaryColor),
                  ),
                );
        }),
      ),
    );
  }
}
