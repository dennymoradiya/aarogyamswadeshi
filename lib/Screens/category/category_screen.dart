import 'dart:convert';
import 'dart:typed_data';
import 'package:aarogyamswadeshi/Admin/subcategory/subcategory_controller.dart';
import 'package:aarogyamswadeshi/Services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Admin/category/category_controller.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/Home/home_controller.dart';
import 'package:aarogyamswadeshi/Screens/allproduct/viewall_product.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({Key key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

SubcategoryController subcategoryController = Get.put(SubcategoryController());

RxInt currentIndex = 0.obs;
CategoryController categoryController = Get.find();
Homecontroller homecontroller = Get.put(Homecontroller());

RxList cuurentlist = [].obs;

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    currentIndex.value = 0;
    cuurentlist.clear();
    subcategoryController.subcategorylist.forEach((element) {
      if (categoryController.categorylist[0]["categoryId"] ==
          element["categoryId"]) {
        cuurentlist.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text("Categories"),
      ),
      body: Obx(() {
        if (categoryController.categorylist.isNotEmpty) {
          return SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width * 0.22,
                  child: ListView.builder(
                    itemCount: categoryController.categorylist.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          cuurentlist.clear();
                          currentIndex.value = index;
                          subcategoryController.subcategorylist
                              .forEach((element) {
                            if (element["categoryId"] ==
                                categoryController.categorylist[index]
                                    ["categoryId"]) {
                              cuurentlist.add(element);
                            }
                          });
                        },
                        child: Obx(() => Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: index == currentIndex.value
                                        ? Border.all(
                                            color: Colors.black87, width: 1)
                                        : null,
                                    borderRadius: BorderRadius.circular(5),
                                    color: index == currentIndex.value
                                        ? Colors.white
                                        : kPrimaryLightColor,
                                  ),
                                  height: Get.width * 0.24,
                                  child: Center(
                                    child: Text(
                                      categoryController.categorylist[index]
                                          ["categoryName"],
                                      style: TextStyle(
                                          color: index == currentIndex.value
                                              ? kPrimaryColor
                                              : Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.grey,
                                )
                              ],
                            )),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(children: <Widget>[
                          Expanded(
                              child: Divider(
                            color: Colors.grey,
                            height: 2,
                          )),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Obx(() => Text(
                                  categoryController
                                          .categorylist[currentIndex.value]
                                      ["categoryName"],
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                          Expanded(
                              child: Divider(color: Colors.grey, height: 2)),
                        ]),
                        SizedBox(
                          height: 20,
                        ),
                        cuurentlist.isNotEmpty
                            ? GridView.builder(
                                padding: EdgeInsets.only(top: 5),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cuurentlist.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent: 110, crossAxisCount: 3),
                                itemBuilder: (BuildContext context, index) {
                                  String imgString =
                                      cuurentlist[index]["imagePath"];
                                  Uint8List decodedbytes =
                                      base64.decode(imgString);

                                  return InkWell(
                                    onTap: () async {
                                      await getProductbysubcategory(
                                          cuurentlist[index]["subcategoryId"]);

                                      Get.to(ViewAllProductScreen(
                                          title:
                                              "Products Of ${cuurentlist[index]["subCategoryName"]} ",
                                          datalist: homecontroller
                                              .subcategoryviseProductlist));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kPrimaryColor, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.memory(
                                                  decodedbytes,
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                        Text(
                                          cuurentlist[index]["subCategoryName"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  );
                                })
                            : Text(
                                "No SubCategory Available!",
                                style: TextStyle(color: kPrimaryColor),
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else if (!categoryController.iscategoryloading.value) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
                child: Text(
              "Opps , No Category available !",
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
    );
  }
}
