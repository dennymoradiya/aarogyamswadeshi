import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aarogyamswadeshi/Admin/product/product_controller.dart';
import 'package:aarogyamswadeshi/Admin/subcategory/subcategory_controller.dart';
import 'package:aarogyamswadeshi/Services/admin_services.dart';
import 'package:aarogyamswadeshi/Services/category_service.dart';
import 'package:aarogyamswadeshi/Services/product_services.dart';
import 'package:aarogyamswadeshi/Services/subcategory_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Admin/category/category_controller.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/Home/home_controller.dart';
import 'package:aarogyamswadeshi/Screens/allproduct/viewall_product.dart';
import 'package:aarogyamswadeshi/Screens/category/category_product_screen.dart';
import 'package:aarogyamswadeshi/Screens/desc/desc_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  Homecontroller homecontroller = Get.put(Homecontroller());
  CategoryController categoryController = Get.put(CategoryController());
  ProductController productController = Get.put(ProductController());

  SubcategoryController subcategoryController =
      Get.put(SubcategoryController());
  List scrollableImages = [];
  List colorlist = [
    {
      "first": Color(0xffffafbd),
      "second": Color(0xffffc3a0),
    },
    {
      "first": Color(0xff2193b0),
      "second": Color(0xff6dd5ed),
    },
    {
      "first": Color(0xffee9ca7),
      "second": Color(0xffffdde1),
    },
    {
      "first": Color(0xffcc2b5e),
      "second": Color(0xff753a88),
    },
    {
      "first": Color(0xff42275a),
      "second": Color(0xff734b6d),
    },
    {
      "first": Color(0xffbdc3c7),
      "second": Color(0xff2c3e50),
    },
    {
      "first": Color(0xffde6262),
      "second": Color(0xffffb88c),
    },
    {
      "first": Color(0xffdd5e89),
      "second": Color(0xfff7bb97),
    },
    {
      "first": Color(0xffddd6f3),
      "second": Color(0xfffaaca8),
    },
  ];
  Timer timer;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  TextEditingController searchController = TextEditingController();

  void serchPressed() async {
    homecontroller.searchlist.clear();
    await getSearchProduct(searchController.text).then((value) {
      searchController.text = "";
    });
  }

  @override
  void initState() {
    super.initState();

    getImages().then((value) {
      scrollableImages.clear();
      for (var i = 0; i < sliderController.imgList.length; i++) {
        String imgString = sliderController.imgList[i]["galleryImage"];
        Uint8List decodedbytes = base64.decode(imgString);
        scrollableImages.add(decodedbytes);
        setState(() {});
      }
    });
  }

  void _onRefresh() async {
    getAllproduct();
    getsubategory();
    getCategory();
    getImages().then((value) {
      scrollableImages.clear();
      for (var i = 0; i < sliderController.imgList.length; i++) {
        String imgString = sliderController.imgList[i]["galleryImage"];
        Uint8List decodedbytes = base64.decode(imgString);
        scrollableImages.add(decodedbytes);
        setState(() {});
      }
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Container(
          width: Get.width * 0.9,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: searchController,
                onFieldSubmitted: (Value) {
                  serchPressed();
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        serchPressed();
                      },
                    ),
                    hintText: 'Search for Category, Products...',
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => homecontroller.searchlist.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Container(
                        height: 85,
                        width: Get.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: homecontroller.searchlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            String imgString =
                                homecontroller.searchlist[index]["imagePath"];
                            Uint8List decodedbytes = base64.decode(imgString);
                            return InkWell(
                              onTap: () async {
                                if (homecontroller.searchlist[index]["type"] ==
                                    "Category") {
                                  await getProductbycategory(
                                    homecontroller.searchlist[index]["id"],
                                  ).then((value) {
                                    Get.to(ProductCategoryScreen(
                                      title: homecontroller.searchlist[index]
                                          ["name"],
                                    ));
                                  });
                                } else if (homecontroller.searchlist[index]
                                        ["type"] ==
                                    "Subcategory") {
                                  await getProductbysubcategory(
                                      homecontroller.searchlist[index]["id"]);
                                  Get.to(ViewAllProductScreen(
                                      title:
                                          "Product of ${homecontroller.searchlist[index]["name"]}",
                                      datalist: homecontroller
                                          .subcategoryviseProductlist));
                                }
                              },
                              child: Container(
                                height: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: kPrimaryColor, width: 1),
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Image.memory(
                                              decodedbytes,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                    Text(
                                      homecontroller.searchlist[index]["name"],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    )),

              sliderController.imgList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: Get.height * 0.3,
                          aspectRatio: 16 / 10,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 1100),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: scrollableImages.map((url) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                height: Get.height * 0.25,
                                width: Get.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    url,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    )
                  : Container(),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),

              //Gridview of Icons
              Obx(() {
                if (categoryController.categorylist.isNotEmpty) {
                  return Wrap(
                    children: [
                      GridView.builder(
                          padding: EdgeInsets.only(top: 5),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: categoryController.categorylist.length > 8
                              ? 8
                              : categoryController.categorylist.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 90, crossAxisCount: 4),
                          itemBuilder: (BuildContext context, index) {
                            String imgString = categoryController
                                .categorylist[index]["imagepath"];
                            Uint8List decodedbytes = base64.decode(imgString);

                            return InkWell(
                              onTap: () async {
                                await getProductbycategory(
                                  categoryController.categorylist[index]
                                      ["categoryId"],
                                ).then((value) {
                                  Get.to(ProductCategoryScreen(
                                    title: categoryController
                                        .categorylist[index]["categoryName"],
                                  ));
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: kPrimaryColor, width: 1),
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Image.memory(
                                            decodedbytes,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                  Text(
                                    categoryController.categorylist[index]
                                        ["categoryName"],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            );
                          }),
                    ],
                  );
                } else if (!categoryController.iscategoryloading.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                        child: Text(
                      "Opps, No Category available!",
                      style: TextStyle(color: Colors.red[300], fontSize: 16),
                    )),
                  );
                } else if (!categoryController.iscaterror.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                        child: Text(
                      "Somthing Went wrong, Please Try Again!",
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

              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub Categories",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     // Get.to(CategoryScreen());
                    //   },
                    //   child: Text(
                    //     "View All",
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.w500,
                    //         color: kPrimaryColor,
                    //         fontSize: 15),
                    //   ),
                    // )
                  ],
                ),
              ),

              Obx(() {
                if (subcategoryController.subcategorylist.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      // width: double.infinity,
                      height: Get.size.height * 0.13,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount:
                              subcategoryController.subcategorylist.length < 10
                                  ? subcategoryController.subcategorylist.length
                                  : 10,
                          itemBuilder: (context, index) {
                            // final _random = new Random();
                            // var element = colorlist[
                            //     _random.nextInt(colorlist.length)];
                            // print(index);
                            return InkWell(
                              onTap: () async {
                                await getProductbysubcategory(
                                    subcategoryController.subcategorylist[index]
                                        ["subcategoryId"]);
                                Get.to(ViewAllProductScreen(
                                    title:
                                        "Product of ${subcategoryController.subcategorylist[index]["subCategoryName"]}",
                                    datalist: homecontroller
                                        .subcategoryviseProductlist));
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: index == 0
                                        ? MediaQuery.of(context).size.width *
                                            0.025
                                        : 5),
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              colorlist[index]["first"],
                                              colorlist[index]["second"],
                                            ])),
                                    child: Center(
                                      child: Text(
                                        subcategoryController
                                                .subcategorylist[index]
                                            ["subCategoryName"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color:
                                                Colors.white.withOpacity(0.6)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                              ),
                            );
                          }),
                    ),
                  );
                } else if (!subcategoryController
                    .isSubcategoryloadingoading.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                        child: Text(
                      "Opps, No SubCategory available!",
                      style: TextStyle(color: Colors.red[300], fontSize: 16),
                    )),
                  );
                } else if (!subcategoryController.issubcaterror.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                        child: Text(
                      "Somthing Went wrong, Please Try Again!",
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
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Products For You",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        productController.productlist.isNotEmpty
                            ? Get.to(ViewAllProductScreen(
                                title: "All Products",
                                datalist: productController.productlist,
                              ))
                            : Fluttertoast.showToast(
                                msg: "No Products Find !",
                                backgroundColor: Colors.red[300]);
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kPrimaryColor,
                            fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),

              //Gridview of category product
              Obx(() {
                if (productController.productlist.isNotEmpty) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: productController.productlist.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing:
                                MediaQuery.of(context).size.width * 0.025,
                            crossAxisSpacing:
                                MediaQuery.of(context).size.width * 0.025,
                            mainAxisExtent:
                                MediaQuery.of(context).size.height * 0.30,
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, index) {
                          String imgString = productController
                              .productlist[index]["productimagepath"];
                          Uint8List decodedbytes = base64.decode(imgString);
                          return InkWell(
                            onTap: () async {
                              Get.to(HomeCategoryProductDescription(
                                productdatalist:
                                    productController.productlist[index],
                              ));
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
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
                                      productController.productlist[index]
                                          ["productName"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color:
                                              Colors.black54.withOpacity(0.6)),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                        left: 8,
                                      ),
                                      child: Text(
                                        "₹ ${productController.productlist[index]["price"]}",
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
                                      productController.productlist[index]
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
                  );
                } else if (!productController.isalldataload.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                        child: Text(
                      "Opps, No Product available !",
                      style: TextStyle(color: Colors.red[300], fontSize: 16),
                    )),
                  );
                } else if (!productController.isalldataerror.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                        child: Text(
                      "Somthing Went wrong, Please Try Again!",
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
              })
            ],
          ),
        ),
      ),
    );
  }
}
