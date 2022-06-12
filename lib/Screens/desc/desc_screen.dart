import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:aarogyamswadeshi/Screens/cart/cart_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'buynow_bottom.dart';

class HomeCategoryProductDescription extends StatefulWidget {
  final Map productdatalist;

  const HomeCategoryProductDescription({Key key, this.productdatalist})
      : super(key: key);

  @override
  _HomeCategoryProductDescriptionState createState() =>
      _HomeCategoryProductDescriptionState();
}

class _HomeCategoryProductDescriptionState
    extends State<HomeCategoryProductDescription> {
  bool isAddtoCart;
  var mypath;
  Uint8List decodedbytes;
  CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
  }

  @override
  Widget build(BuildContext context) {
    // int imgid = 0;

    Future<String> createFolder() async {
      const folderName = "aarogyaswadesi";
      Directory tempDir = await getTemporaryDirectory();
      String temppath = tempDir.path + "/$folderName";
      final path = Directory(temppath);
      setState(() {
        mypath = path.path;
      });

      var status = await Permission.storage.status;

      if (!status.isGranted) {
        await Permission.storage.request();
      }
      if ((await path.exists())) {
        return path.path;
      } else {
        path.create();
        return path.path;
      }
    }

    Future<void> _saveImage(int saveindex, var imgpath) async {
      var savePath = await createFolder();
      savePath = savePath + "/aarogyaswadesi$saveindex.jpeg";

      await Dio().download(imgpath, savePath);
      final result = await ImageGallerySaver.saveFile(savePath);
    }

    String imgString = widget.productdatalist["productimagepath"];
    Uint8List decodedbytes = base64.decode(imgString);


    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: Get.height * 0.35,
                          width: Get.width,
                          child: Image.memory(
                            decodedbytes,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[350],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Icon(Icons.arrow_back),
                                    )),
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     imgid = imgid + 1;
                              //     _saveImage(imgid, decodedbytes)
                              //         .then((value) async {
                              //       var save =
                              //           "$mypath/aarogyaswadesi$imgid.jpeg";
                              //       await Share.shareFiles([save],
                              //           text: 'aarogyaswadesi');
                              //     });
                              //   },
                              //   child: Container(
                              //       height: 35,
                              //       width: 35,
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(10),
                              //         color: Colors.grey[350],
                              //       ),
                              //       child: Padding(
                              //         padding: EdgeInsets.all(5.0),
                              //         child: Icon(
                              //           MdiIcons.share,
                              //           size: 25,
                              //           color: Colors.black,
                              //         ),
                              //       )),
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //price
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "₹" + widget.productdatalist["price"].toString(),
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 21,
                                fontWeight: FontWeight.w700),
                          ),
                          // InkWell(
                          //   onTap: () {},
                          //   child: Icon(
                          //     Icons.favorite_outline,
                          //     color: Colors.black,
                          //     size: 28,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //description
                    Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: Wrap(
                          children: [
                            Text(
                              widget.productdatalist["productName"],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54.withOpacity(0.6)),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),

                    //availble in stock
                    Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05),
                        child: Text(
                          widget.productdatalist["isProductAvailable"]
                              ? "Available"
                              : "Not Available",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        )),
                    SizedBox(
                      height: 10,
                    ),

                    //devider
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    //Description section
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05),
                          child: Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: 10),
                        child: Text(
                          widget.productdatalist["productDesc"],
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[600]),
                        )),
                    SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            buyNowModelsheet(
                context,
                decodedbytes,
                widget.productdatalist["price"].toString(),
                widget.productdatalist["productName"],
                false,
                widget.productdatalist["productId"]);
          },
          child: Container(
            height: 65,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                "Add to Cart",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
