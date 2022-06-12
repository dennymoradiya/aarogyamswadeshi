import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/cart/cart_controller.dart';
import 'package:aarogyamswadeshi/Services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

Future<List> cartlist;
CartController cartController = Get.put(CartController());
Future buyNowModelsheet(context, imgurl, price, pname, isAddtocart, pid) {
  RxInt qnt = 1.obs;
  return showModalBottomSheet(
      context: context,
      // barrierColor: popupBackground,
      isScrollControlled: true, // only work on showModalBottomSheet function
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
                height: Get.height * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: Get.height * 0.15,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    child: Image.memory(imgurl)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    pname.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "₹ $price",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Icons.close,
                                size: 30,
                              ))
                        ],
                      ),
                    ),
                    Divider(
                      color: kPrimaryLightColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Text(
                        "Quantity :",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                if (qnt.value > 0) {
                                  qnt.value--;
                                }
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                qnt.value.toString(),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                qnt.value++;
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    Divider(
                      color: kPrimaryLightColor,
                    ),
                    InkWell(
                      onTap: () {
                        Map data = {
                          "productID": pid,
                          "quantity": qnt.value,
                        };
                        addTocart(data).then((value) {
                          if (value == "Added To Cart") {
                            Fluttertoast.showToast(
                                msg: value, backgroundColor: Colors.green);
                          } else {
                            Fluttertoast.showToast(
                                msg: value, backgroundColor: Colors.red);
                          }
                          getCart().then((value) {
                            cartController.getCarttotal();
                          });
                          Get.back();
                        });
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Add to Cart",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ));
}
