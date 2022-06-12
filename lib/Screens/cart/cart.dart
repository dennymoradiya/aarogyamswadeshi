import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/cart/cart_controller.dart';
import 'package:aarogyamswadeshi/Screens/cart/cart_model.dart';
import 'package:aarogyamswadeshi/Screens/desc/buynow_bottom.dart';
import 'package:aarogyamswadeshi/Screens/desc/mail.dart';
import 'package:aarogyamswadeshi/Screens/desc/pdf_api.dart';
import 'package:aarogyamswadeshi/Screens/desc/pdf_invoice_api.dart';
import 'package:aarogyamswadeshi/Services/cart_service.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../desc/invoice.dart';

class Cart extends StatefulWidget {
  Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartModel> cartorder = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  CartController cartController = Get.put(CartController());
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
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: Text(
            "Shopping Cart",
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (cartController.cartlist.isNotEmpty) {
            return ListView.builder(
                itemCount: cartController.cartlist.length,
                itemBuilder: (BuildContext context, int index) {
                  String imgString =
                      cartController.cartlist[index]["productImagePath"];
                  Uint8List decodedbytes = base64.decode(imgString);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 14.0, left: 14, right: 14, bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  child: Image.memory(
                                    decodedbytes,
                                    fit: BoxFit.contain,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width -
                                          120,
                                      child: Text(
                                        cartController.cartlist[index]
                                            ["productName"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "₹ ${cartController.cartlist[index]["price"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 120,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      content:
                                                          Text("Remove Product"),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          child: Text("Close"),
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                          kPrimaryColor)),
                                                          child: Text("Ok"),
                                                          onPressed: () {},
                                                        )
                                                      ],
                                                    ));
                                          },
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                        content: Text(
                                                            "Are You Sure Want to Remove This Product?"),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            child:
                                                                Text("Close"),
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                          ),
                                                          ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                            kPrimaryColor)),
                                                            child: Text("Yes"),
                                                            onPressed: () {
                                                              deleteFromcart(cartController
                                                                              .cartlist[
                                                                          index]
                                                                      [
                                                                      "productId"])
                                                                  .then(
                                                                      (value) {
                                                                cartController
                                                                    .cartlist
                                                                    .removeAt(
                                                                        index);
                                                                getCart().then(
                                                                    (value) {
                                                                  cartController
                                                                      .getCarttotal();
                                                                });

                                                                // setState(() {});
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            value);
                                                              });
                                                              cartController
                                                                  .cartlist
                                                                  .refresh();
                                                              Get.back();
                                                            },
                                                          )
                                                        ],
                                                      ));
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: Colors.grey[400])),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Obx(() {
                                          return Container(
                                            width: 110,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    cartController
                                                            .cartlist[index]
                                                        ["quantity"]--;

                                                    if (cartController
                                                                .cartlist[index]
                                                            ["quantity"] ==
                                                        0) {
                                                      var pid = cartController
                                                              .cartlist[index]
                                                          ["productId"];
                                                      cartController.cartlist
                                                          .removeAt(index);
                                                      await deleteFromcart(pid)
                                                          .then((value) {
                                                        getCart().then((value) {
                                                          cartController
                                                              .getCarttotal();
                                                        });
                                                      });
                                                      cartController.cartlist
                                                          .refresh();
                                                    } else {
                                                      cartController.carttotal
                                                              .value -=
                                                          cartController
                                                                  .cartlist[
                                                              index]["price"];
                                                      Map data = {
                                                        "productID":
                                                            cartController
                                                                        .cartlist[
                                                                    index]
                                                                ["productId"],
                                                        "quantity": cartController
                                                                .cartlist[index]
                                                            ["quantity"],
                                                      };
                                                      addTocart(data);
                                                    }
                                                    // setState(() {});
                                                    cartController.cartlist
                                                        .refresh();
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                      color: kPrimaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    cartController
                                                        .cartlist[index]
                                                            ["quantity"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    cartController
                                                            .cartlist[index]
                                                        ["quantity"]++;
                                                    cartController.carttotal
                                                        .value += cartController
                                                            .cartlist[index]
                                                        ["price"];
                                                    Map data = {
                                                      "productID":
                                                          cartController
                                                                      .cartlist[
                                                                  index]
                                                              ["productId"],
                                                      "quantity": cartController
                                                              .cartlist[index]
                                                          ["quantity"],
                                                    };
                                                    cartController.cartlist
                                                        .refresh();
                                                    addTocart(data);

                                                    // setState(() {});
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                      color: kPrimaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                });
          } else if (!cartController.iscartload.value) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                  child: Text(
                "Your Cart Is Empty !",
                style: TextStyle(color: Colors.red[300], fontSize: 16),
              )),
            );
          } else if (!cartController.iscarterror.value) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                  child: Text(
                "Somthing Went wrong , Please Try Again !",
                style: TextStyle(color: Colors.red[300], fontSize: 16),
              )),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          }
        }),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
            color: Colors.white,
          ),
          height: Get.height * 0.10,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Obx(() => Text(
                          "${cartController.carttotal.value.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        )),
                  ],
                ),
                Obx(
                  () => cartController.cartlist.isNotEmpty
                      ? FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: kPrimaryColor,
                          textColor: Colors.white,
                          child: Text('Place Order'),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      content: Text(
                                          "Are you sure want to confirm your order?"),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text("Close"),
                                          onPressed: () async {
                                            Get.back();
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      kPrimaryColor)),
                                          child: Text("Yes"),
                                          onPressed: () async {
                                            EasyLoading.show(
                                                status: "Loding...");

                                            var lastele =
                                                cartController.cartlist.last;
                                            cartController.cartlist
                                                .forEach((element) {
                                              placeOrder(element).then((value) {
                                                if (lastele == element) {
                                                  EasyLoading.dismiss();
                                                  if (value ==
                                                      "Order Placed successfully") {
                                                    Fluttertoast.showToast(
                                                        msg: value);
                                                    cartController.cartlist
                                                        .clear();
                                                    cartController
                                                        .carttotal.value = 0;
                                                    cartController.iscartload
                                                        .value = false;
                                                  }
                                                }
                                              });
                                            });

                                            Get.back();
                                          },
                                        )
                                      ],
                                    ));
                          },
                        )
                      : FlatButton(
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: kPrimaryLightColor,
                          textColor: Colors.white,
                          child: Text('Place Order'),
                        ),
                )
              ],
            ),
          ),
        ));
  }
}
