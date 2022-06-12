import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Services/category_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io' as Io;

class UpdatecategoryPage extends StatefulWidget {
  final Map data;
  final img;
  UpdatecategoryPage({Key key, this.data, this.img}) : super(key: key);

  @override
  State<UpdatecategoryPage> createState() => UpdatedcategoryPageState();
}

class UpdatedcategoryPageState extends State<UpdatecategoryPage> {
  File _image;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ImagePicker picker = ImagePicker();
  TextEditingController englishnamecontroller = TextEditingController();
  TextEditingController gujaratinamecontroller = TextEditingController();
  bool isImgUpdate = false;
  int val;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    englishnamecontroller.text = widget.data["categoryName"];
    gujaratinamecontroller.text = widget.data['categoryGName'];

    if (widget.data["isSubCategoryAllowed"]) {
      val = 1;
    } else {
      val = 2;
    }
    setState(() {});
     EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
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
        title: Text("Update Category"),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                  child: Text(
                    "SubCategory Allowed ? :",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                            activeColor: kPrimaryColor,
                            value: 1,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                val = value;
                                print(val);
                              });
                            }),
                        Text('Yes')
                      ],
                    ),
                    SizedBox(width: size.width * 0.1),
                    Row(
                      children: [
                        Radio(
                            value: 2,
                            groupValue: val,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                val = value;
                                print(val);
                              });
                            }),
                        Text('No')
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: ElevatedButton(
                child: Text(
                  "Update Category",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                onPressed: () async {
                  if (formkey.currentState.validate()) {
                    EasyLoading.show(status: 'Loading...');
                    Map updatecategorydata;
                    final dir = await path_provider.getTemporaryDirectory();
                    final targetPath = dir.absolute.path + "/temp.jpg";
                    if (isImgUpdate) {
                      await testCompressAndGetFile(_image, targetPath)
                          .then((value) {
                        final bytes = Io.File(value.path).readAsBytesSync();
                        String base64Image = base64Encode(bytes);
                        updatecategorydata = {
                          "categoryId": widget.data["categoryId"],
                          "englishname": englishnamecontroller.text,
                          "gujaratiname": gujaratinamecontroller.text,
                          "isSubCategoryAllowed": val == 1 ? true : false,
                          "file": base64Image
                        };
                      });
                    } else {
                      updatecategorydata = {
                        "categoryId": widget.data["categoryId"],
                        "englishname": englishnamecontroller.text,
                        "gujaratiname": gujaratinamecontroller.text,
                        "isSubCategoryAllowed": val == 1 ? true : false,
                        "file": widget.data["imagePath"]
                      };
                      print("-----");
                      // print(updatecategorydata);
                    }
                    updateCategory(updatecategorydata).then((value) {
                      EasyLoading.dismiss();
                      Fluttertoast.showToast(msg: value);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
