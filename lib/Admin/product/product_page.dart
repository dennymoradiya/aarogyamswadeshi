import 'dart:convert';
import 'dart:typed_data';
import 'package:aarogyamswadeshi/Admin/product/add_product.dart';
import 'package:aarogyamswadeshi/Admin/product/product_controller.dart';
import 'package:aarogyamswadeshi/Admin/product/update_product.dart';
import 'package:aarogyamswadeshi/Admin/widget/drawer.dart';
import 'package:aarogyamswadeshi/Services/category_service.dart';
import 'package:aarogyamswadeshi/Services/product_services.dart';
import 'package:aarogyamswadeshi/Services/subcategory_service.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductController productController = Get.put(ProductController());
  @override
  void initState() {
    super.initState();
    // getCategory();
    // getsubategory();
    // getAllproduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      drawer: Drawerbar(),
      body: Obx(() {
        if (productController.productlist.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: productController.productlist.length,
            itemBuilder: (BuildContext context, int index) {
              var data = productController.productlist[index];
              String imgString = data["productImagePath"];
              Uint8List img = base64.decode(imgString);
              // print("get" + img.lengthInBytes.toString());
              // print(data);
              return Container(
                height: Get.height * 0.16,
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
                      child: img != null && data["productImagePath"] != ""
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
                            Text("ProductId : ${data['productId']}"),
                            Text("Name: ${data['productName']}"),
                            Text("GName: ${data['productGName']}"),
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
                                Get.to(UpdateProductPage(
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
                                              "Are You Sure Want to Delete Product?"),
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
                                                deleteProduct(data["productId"])
                                                    .then((value) {
                                                  Fluttertoast.showToast(
                                                      msg: value);
                                                });

                                                productController.productlist
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
        } else if (!productController.isalldataerror.value) {
          return Center(
            child: Text("Something Went Wrong!"),
          );
        } else if (!productController.isalldataload.value) {
          return Center(child: Text("Sorry ! You have not any product"));
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: kPrimaryColor,
          ));
        }
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Get.to(AddProductPage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
