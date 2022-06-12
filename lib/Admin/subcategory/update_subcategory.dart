import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Admin/category/category_controller.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Services/subcategory_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;

class Updatesubcategory extends StatefulWidget {
  final Map data;
  final img;

  Updatesubcategory({Key key, this.data, this.img}) : super(key: key);

  @override
  State<Updatesubcategory> createState() => _UpdatesubcategoryState();
}

class _UpdatesubcategoryState extends State<Updatesubcategory> {
  File _image;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ImagePicker picker = ImagePicker();
  TextEditingController englishnamecontroller = TextEditingController();
  TextEditingController gujaratinamecontroller = TextEditingController();
  CategoryController categoryController = Get.put(CategoryController());
  Map dropdownvalue;
  bool isImgUpdate = false;
  int val;
  List<Map> categoriesList = [];
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
    for (var i = 0; i < categoryController.categorylist.length; i++) {
      var issubcateAllow =
          categoryController.categorylist[i]["isSubCategoryAllowed"];
      if (issubcateAllow) {
        var categoryname = categoryController.categorylist[i]["categoryName"];
        var categoryid = categoryController.categorylist[i]["categoryId"];
        Map category = {"name": categoryname, "id": categoryid};
        categoriesList.add(category);
      }
    }
    englishnamecontroller.text = widget.data["subCategoryName"];
    gujaratinamecontroller.text = widget.data['subCategoryGName'];
    dropdownvalue = categoriesList[0];
    setState(() {});
    // print(categoriesList);
  }

  _imgFromCamera() async {
    XFile image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      try {
        _image = File(image.path);
        isImgUpdate = true;
      } catch (e) {}
    });
  }

  _imgFromGallery() async {
    XFile image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      try {
        _image = File(image.path);
        isImgUpdate = true;
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
        title: Text("Update Subcategory"),
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
                child: !isImgUpdate
                    ? CircleAvatar(
                        radius: 60,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.memory(widget.img,
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
                        ),
                      )
                    : CircleAvatar(
                        radius: 60,
                        child: Stack(
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
                    SizedBox(height: size.height * 0.02),
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
                          value: dropdownvalue,
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
                              dropdownvalue = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      " English Name",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
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
                    SizedBox(height: size.height * 0.03),
                    Text(
                      " Gujarati Name",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
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
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: ElevatedButton(
                  child: Text(
                    "Update subcategory",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  onPressed: () async {
                    if (dropdownvalue["id"] == "") {
                      Fluttertoast.showToast(msg: "Please select category");
                      // scaffoldMessage(context, "select category");
                      print(dropdownvalue["id"]);
                    } else if (formkey.currentState.validate() &&
                        dropdownvalue["id"] != "") {
                      // formkey.currentState.save();
                      EasyLoading.show(status: 'Loading...');

                      final dir = await path_provider.getTemporaryDirectory();
                      final targetPath = dir.absolute.path + "/temp.jpg";
                      Map subcategorydata;
                      if (isImgUpdate) {
                        await testCompressAndGetFile(_image, targetPath)
                            .then((value) {
                          final bytes = Io.File(value.path).readAsBytesSync();
                          String base64Image = base64Encode(bytes);
                          subcategorydata = {
                            "subcategoryId": widget.data["subcategoryId"],
                            "englishname": englishnamecontroller.text,
                            "gujaratiname": gujaratinamecontroller.text,
                            "file": base64Image
                          };
                          print(subcategorydata);
                        });
                      } else {
                        subcategorydata = {
                          "subcategoryId": widget.data["subcategoryId"],
                          "englishname": englishnamecontroller.text,
                          "gujaratiname": gujaratinamecontroller.text,
                          "file": widget.data["imagePath"]
                        };
                        print(subcategorydata);
                      }

                      updatesubCategory(subcategorydata).then((value) {
                        EasyLoading.dismiss();

                        Fluttertoast.showToast(msg: value);
                      });

                      // addsubcategory(subcategorydata).then((value) {
                      //   Fluttertoast.showToast(msg: value);
                      // });
                      // addcategory(categorydata).then((value) {
                      // });
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
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
