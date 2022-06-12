import 'dart:async';
import 'dart:io';
import 'package:aarogyamswadeshi/Admin/product/product_controller.dart';
import 'package:aarogyamswadeshi/Admin/product/product_page.dart';
import 'package:aarogyamswadeshi/Services/category_service.dart';
import 'package:aarogyamswadeshi/Services/product_services.dart';
import 'package:aarogyamswadeshi/Services/subcategory_service.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Admin/category/category_controller.dart';
import 'package:aarogyamswadeshi/Admin/subcategory/subcategory_controller.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  File _image;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ImagePicker picker = ImagePicker();
  TextEditingController englishnamecontroller = TextEditingController(text: "");
  TextEditingController gujaratinamecontroller =
      TextEditingController(text: "");
  TextEditingController productdesc = TextEditingController(text: "");
  TextEditingController productgujdesc = TextEditingController(text: "");
  TextEditingController pricecontroller = TextEditingController(text: "");
  ProductController productController = Get.put(ProductController());

  CategoryController categoryController = Get.put(CategoryController());
  SubcategoryController subcategoryController =
      Get.put(SubcategoryController());
  Map categorydropdownvalue;
  Map subcategorydropvalue;
  int val;
  List<Map> categoriesList = [];
  List<Map> subcategoriesList = [];
  bool isSubavailable = false;
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

    categoriesList.add({"name": "Select category", "id": ""});
    categorydropdownvalue = categoriesList[0];
    subcategoriesList.add({"name": "Select subcategory", "id": ""});
    subcategorydropvalue = subcategoriesList[0];
    setState(() {});

    getCategory().then((value) {
      for (var i = 0; i < categoryController.categorylist.length; i++) {
        var categoryname = categoryController.categorylist[i]["categoryName"];
        var categoryid = categoryController.categorylist[i]["categoryId"];
        Map category = {"name": categoryname, "id": categoryid};
        categoriesList.add(category);
      }
      // getsubcategotybycategory();

      setState(() {});
    });
  }

  void getsubcategotybycategory() {
    subcategoriesList.clear();
    subcategoriesList.add({"name": "Select subcategory", "id": ""});
    subcategorydropvalue = subcategoriesList[0];
    for (var i = 0; i < productController.dropdownsubcategory.length; i++) {
      var subcategoryname =
          productController.dropdownsubcategory[i]["subCategoryName"];
      var subcategoryid =
          productController.dropdownsubcategory[i]["subcategoryId"];
      Map subcategory = {"name": subcategoryname, "id": subcategoryid};
      subcategoriesList.add(subcategory);
      print("----");
      print(subcategoriesList);
    }
    setState(() {});
  }

  _imgFromCamera() async {
    XFile image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      try {
        _image = File(image.path);
      } catch (e) {}
    });
  }

  _imgFromGallery() async {
    XFile image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      try {
        _image = File(image.path);
      } catch (e) {}
    });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 70, rotate: 0);
    // print("file" + file.lengthSync().toString());
    // print(result.lengthSync());
    return result;
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.03),
            Center(
              child: InkWell(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 60,
                  child: _image != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(_image,
                                  width: 250, height: 250, fit: BoxFit.cover),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 10,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black38,
                                )),
                          ],
                        )
                      : Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.black87,
                              )),
                          width: 250,
                          height: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "select image",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Form(
                key: formkey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " Select Category",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: Get.width * 0.80,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Map>(
                          menuMaxHeight: Get.height * 0.45,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: 35,
                          ),
                          isExpanded: true,
                          value: categorydropdownvalue,
                          elevation: 5,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 16),
                          items: categoriesList.map((Map items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items["name"]),
                            );
                          }).toList(),
                          onChanged: (Map newValue) {
                            setState(() {
                              categorydropdownvalue = newValue;
                              if (categorydropdownvalue["id"] != "") {
                                getsubcateByCategoryId(
                                        categorydropdownvalue["id"])
                                    .then((value) {
                                  isSubavailable = value;
                                  print(isSubavailable);
                                  getsubcategotybycategory();
                                });
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      " Select Subcategory",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: Get.width * 0.80,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Map>(
                          menuMaxHeight: Get.height * 0.45,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: 35,
                          ),
                          isExpanded: true,
                          value: subcategorydropvalue,
                          elevation: 5,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 16),
                          items: subcategoriesList.map((Map items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items["name"]),
                            );
                          }).toList(),
                          onChanged: (Map newValue) {
                            setState(() {
                              subcategorydropvalue = newValue;
                              // if (subcategorydropvalue["id"] != "") {
                              //   isSubavailable = false;
                              // }
                              print(subcategorydropvalue);
                              print(isSubavailable);
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      " English Name",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "English Name",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      controller: englishnamecontroller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "English Name is Required";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      " Gujarati Name",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "Gujarati Name",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      controller: gujaratinamecontroller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Gujarati Name is Required";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      " English Description)",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      maxLines: 3,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "Product Description (In English)",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      controller: productdesc,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "English Description is Required";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      " Gujarati Description",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      maxLines: 3,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "Product Description (In Gujarati)",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      controller: productgujdesc,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Gujarati Description is Required";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      " Price",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "Price",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      controller: pricecontroller,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Price is required";
                        } else
                          return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: ElevatedButton(
                  child: Text(
                    "Add Product",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  onPressed: () async {
                    // print(subcategorydropvalue["id"]);
                    if (_image == null) {
                      Fluttertoast.showToast(msg: "Please select image");
                    } else if (categorydropdownvalue["id"] == "") {
                      Fluttertoast.showToast(msg: "Please select category");
                      print(categorydropdownvalue["id"]);
                    } else if (isSubavailable &&
                        subcategorydropvalue["id"] == "") {
                      Fluttertoast.showToast(msg: "Please select subcategory");
                      // print(subcategorydropvalue["id"]);
                    } else if (formkey.currentState.validate() &&
                        _image != null &&
                        categorydropdownvalue["id"] != "") {
                      EasyLoading.show(status: 'Loading...');
                      formkey.currentState.save();
                      final dir = await path_provider.getTemporaryDirectory();
                      final targetPath = dir.absolute.path + "/temp.jpg";
                      await testCompressAndGetFile(_image, targetPath)
                          .then((value) {
                        print(subcategorydropvalue["id"]);
                        Map productData = {
                          "categoryId": categorydropdownvalue["id"],
                          "subcategoryId": subcategorydropvalue["id"],
                          "englishname": englishnamecontroller.text,
                          "gujaratiname": gujaratinamecontroller.text,
                          "productDesc": productdesc.text,
                          "productGDesc": productgujdesc.text,
                          "price": pricecontroller.text,
                          "file": value.path
                        };
                        print(productData);
                        addProduct(productData).then((value) {
                          EasyLoading.dismiss();
                          Fluttertoast.showToast(msg: value);
                          if (value == "Product created successfully") {
                            Get.off(ProductPage());
                          }
                        });
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
