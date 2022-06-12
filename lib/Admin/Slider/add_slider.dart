import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:aarogyamswadeshi/Admin/Slider/slider_controller.dart';
import 'package:aarogyamswadeshi/Admin/widget/drawer.dart';
import 'package:aarogyamswadeshi/Services/admin_services.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Admin/category/category_controller.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Services/subcategory_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AddSliderImages extends StatefulWidget {
  AddSliderImages({Key key}) : super(key: key);

  @override
  State<AddSliderImages> createState() => _AddSliderImagesState();
}

class _AddSliderImagesState extends State<AddSliderImages> {
  Timer _timer;
  List<Asset> images = <Asset>[];
  String _error = 'No Error Detected';
  List imgfiletype = [];
  SliderController sliderController = Get.put(SliderController());

  @override
  void initState() {
    super.initState();
    images = <Asset>[];
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    images = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: const MaterialOptions(
          statusBarColor: "#00a300",
          actionBarColor: "#00a300",
          actionBarTitle: "Aarogyam Swadeshi",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#FF7643",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
    EasyLoading.show(status: "Loading...");
    images.forEach((assetImage) {
      getImageFileFromAssets(assetImage);
    });

    if (images.isEmpty) {
      EasyLoading.dismiss();
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    imgfiletype.add(file);
    // testCompressAndGetFile(file, targetPath)
    final dir = await path_provider.getTemporaryDirectory();
    var id = DateTime.now().microsecondsSinceEpoch;
    final targetPath = dir.absolute.path + "/temp$id.jpg";
    await testCompressAndGetFile(file, targetPath).then((img) {
      // print(img);
      addGalleryImage(img.path).then((value) {
        if (value == "Gallery image added") {
          Fluttertoast.showToast(msg: value);
          getImages().then((value) {
            EasyLoading.dismiss();
          });
        } else {
          Fluttertoast.showToast(msg: value);
          EasyLoading.dismiss();
        }
      });
    });
    return file;
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 70, rotate: 0);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      drawer: Drawerbar(),
      body: Obx(() {
        if (sliderController.imgList.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: sliderController.imgList.length,
            itemBuilder: (BuildContext context, int index) {
              var data = sliderController.imgList[index];
              String imgString = data["galleryImage"];
              Uint8List img = base64.decode(imgString);

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Container(
                        height: Get.height * 0.26,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(17),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1.0, 6.0),
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        width: Get.width,
                        child: img != null && data["galleryImage"] != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  img,
                                  height: Get.height,
                                  width: Get.width * 0.9,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Text("imgs ")),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      content: Text(
                                          "Are You Sure Want to Delete Image?"),
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
                                            Get.back();
                                            EasyLoading.show(
                                                status: "Loading...");
                                            deletetGalleryImage(
                                                    data["galleryId"])
                                                .then((value) {
                                              if (value ==
                                                  "Deleted sucessfully!") {
                                                sliderController.imgList
                                                    .removeAt(index);
                                                // getImages().then((value) {
                                                //   EasyLoading.dismiss();
                                                // });
                                              }
                                              Fluttertoast.showToast(
                                                  msg: value);
                                              EasyLoading.dismiss();
                                            });
                                          },
                                        )
                                      ],
                                    ));
                          },
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(Icons.close),
                          ),
                        ))
                  ],
                ),
              );
            },
          );
        } else if (!sliderController.isSlidererror.value) {
          return Center(
            child: Text("Something Went Wrong!"),
          );
        } else if (!sliderController.isSliderLoading.value) {
          return Center(child: Text("Sorry ! You have not gallery Image"));
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: loadAssets,
        label: Text("Add Gallery"),
      ),
    );
  }
}
