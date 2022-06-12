import 'dart:convert';
import 'dart:typed_data';
import 'package:aarogyamswadeshi/Admin/product/add_product.dart';
import 'package:aarogyamswadeshi/Admin/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Admin/category/update_category.dart';
import 'package:aarogyamswadeshi/Admin/subcategory/add_subcategory.dart';
import 'package:aarogyamswadeshi/Admin/subcategory/subcategory_controller.dart';
import 'package:aarogyamswadeshi/Admin/subcategory/update_subcategory.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Services/category_service.dart';
import 'package:aarogyamswadeshi/Services/subcategory_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SubCategoryPage extends StatefulWidget {
  SubCategoryPage({Key key}) : super(key: key);

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  SubcategoryController subcategoryController =
      Get.put(SubcategoryController());

  @override
  void initState() {
    super.initState();
    // getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sub Category"),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      drawer: Drawerbar(),

      body: Obx(() {
        if (subcategoryController.subcategorylist.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: subcategoryController.subcategorylist.length,
            itemBuilder: (BuildContext context, int index) {
              var data = subcategoryController.subcategorylist[index];
              String imgString = data["imagePath"];
              Uint8List img = base64.decode(imgString);
              return Container(
                height: Get.height * 0.14,
                width: Get.width,
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      15,
                    )),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: img != null && data["imagePath"] != ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                img,
                                height: Get.width * 0.25,
                                width: Get.width * 0.25,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Text("imgs "),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10),
                      child: Container(
                        width: Get.width * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   child: Text(
                            //     data["categoryId"].toString(),
                            //     style: TextStyle(
                            //         fontSize: 15,
                            //         color: Colors.black,
                            //         fontWeight: FontWeight.bold),
                            //     textAlign: TextAlign.start,
                            //   ),
                            // ),
                            Text("Eng Name: ${data['subCategoryName']}"),
                            Text("Guj Name: ${data['subCategoryGName']}"),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(Updatesubcategory(
                                  data: data,
                                  img: img,
                                ));
                              },
                              child: Icon(
                                Icons.edit,
                                size: 23,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                          content: Text(
                                              "Are You Sure Want to Delete SubCategory?"),
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
                                                      MaterialStateProperty.all(
                                                          kPrimaryColor)),
                                              child: Text("Ok"),
                                              onPressed: () {
                                                deletesubcategory(
                                                        data["subcategoryId"])
                                                    .then((value) {
                                                  Fluttertoast.showToast(
                                                      msg: value);
                                                });
                                                subcategoryController
                                                    .subcategorylist
                                                    .removeAt(index);
                                                Get.back();
                                              },
                                            )
                                          ],
                                        ));
                                // getProduct();
                              },
                              child: Icon(
                                Icons.delete,
                                size: 23,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (!subcategoryController.issubcaterror.value) {
          return Center(
            child: Text("Something Went Wrong!"),
          );
        } else if (!subcategoryController.isSubcategoryloadingoading.value) {
          return Center(child: Text("Sorry! You have not subcategory"));
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          // getCategory();
          Get.to(AddsubcategoryPage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
