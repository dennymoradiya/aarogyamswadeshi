import 'dart:convert';
import 'dart:typed_data';

import 'package:aarogyamswadeshi/Admin/product/product_controller.dart';
import 'package:aarogyamswadeshi/Screens/Home/home_controller.dart';
import 'package:aarogyamswadeshi/Screens/desc/desc_screen.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController serachcontroller = TextEditingController(text: "");

  Homecontroller homecontroller = Get.put(Homecontroller());
  ProductController productController = Get.put(ProductController());

  RxString val = "".obs;

  @override
  void initState() {
    super.initState();
    homecontroller.searchlist.clear();
    productController.productlist.forEach((element) {
      homecontroller.searchlist.add(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          actions: [
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text('Fliter Products'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(() {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                        activeColor: kPrimaryColor,
                                        value: "as",
                                        groupValue: val.value,
                                        onChanged: (value) {
                                          val.value = value;
                                        }),
                                    Text('Price : High To Low')
                                  ],
                                ),
                                SizedBox(width: Get.width * 0.1),
                                Row(
                                  children: [
                                    Radio(
                                      value: "ds",
                                      groupValue: val.value,
                                      activeColor: kPrimaryColor,
                                      onChanged: (value) {
                                        val.value = value;
                                      },
                                    ),
                                    Text('Price : Low To High')
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),
                        actions: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (val.value == "as") {
                                  homecontroller.searchlist.sort((a, b) =>
                                      b["price"].compareTo(a["price"]));
                                } else if (val.value == "ds") {
                                  homecontroller.searchlist.sort((a, b) =>
                                      a["price"].compareTo(b["price"]));
                                }
                                Get.back();
                              },
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Done",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(MdiIcons.filter),
              ),
            )
          ],
          // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextFormField(
                cursorColor: kPrimaryColor,
                controller: serachcontroller,
                onChanged: (value) {
                  homecontroller.searchlist.clear();
                  productController.productlist.forEach((element) {
                    element["productName"]
                            .toString()
                            .toLowerCase()
                            .contains(serachcontroller.text.toLowerCase())
                        ? homecontroller.searchlist.add(element)
                        : null;
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        serachcontroller.clear();
                        setState(() {});
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return homecontroller.searchlist.isNotEmpty ||
                      !serachcontroller.isBlank
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: homecontroller.searchlist.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing:
                                        MediaQuery.of(context).size.width *
                                            0.025,
                                    crossAxisSpacing:
                                        MediaQuery.of(context).size.width *
                                            0.025,
                                    mainAxisExtent:
                                        MediaQuery.of(context).size.height *
                                            0.30,
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, index) {
                              String imgString = homecontroller
                                  .searchlist[index]["productImagePath"];
                              Uint8List decodedbytes = base64.decode(imgString);
                              return InkWell(
                                onTap: () async {
                                  Get.to(HomeCategoryProductDescription(
                                    productdatalist:
                                        homecontroller.searchlist[index],
                                  ));
                                },
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.20,
                                        width: Get.width,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                            child: Image.memory(
                                              decodedbytes,
                                              fit: BoxFit.contain,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 2),
                                        child: Text(
                                          homecontroller.searchlist[index]
                                              ["productName"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              color: Colors.black54
                                                  .withOpacity(0.6)),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: Text(
                                            "₹ ${homecontroller.searchlist[index]["price"]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: kPrimaryColor),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Container(
                                            child: Text(
                                          homecontroller.searchlist[index]
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
                      ),
                    )
                  : Center(
                      child: Text("No Product Found!"),
                    );
            })
          ],
        ),
      ),
    );
  }
}
