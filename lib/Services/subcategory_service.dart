import 'dart:convert';
import 'package:aarogyamswadeshi/Admin/category/category_controller.dart';
import 'package:aarogyamswadeshi/Admin/subcategory/subcategory_controller.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:aarogyamswadeshi/Services/product_services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyamswadeshi/Services/api_services.dart';
import 'dart:io' as Io;

SubcategoryController subcategoryController = Get.put(SubcategoryController());

Future<String> addsubcategory(Map data) async {
  var token = await getToken();
  final bytes = Io.File(data["file"]).readAsBytesSync();
  String base64Image = base64Encode(bytes);
  try {
    final response = await http.post(
        Uri.parse(baseUrl + '/api/SubCategory/CreateSubCategory'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "categoryId": data["categoryId"],
          "englishname": data["englishname"],
          "gujaratiname": data["gujaratiname"],
          "imagePath": base64Image,
        }),
        encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getsubategory();
      print("subcategory add");
      return "subcategory created successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("subcategory not add");
      return "subcategory already exists";
    }
  } catch (e) {
    print("error");
    // print(e);
    return "Something went wrong!";
  }
}

Future getsubategory() async {
  subcategoryController.isSubcategoryloadingoading.value = true;
  subcategoryController.issubcaterror.value = true;

  var token = await getToken();
  print(token);
  try {
    final response = await http.get(
      Uri.parse(baseUrl + '/api/SubCategory/GetAllSubCategory'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      subcategoryController.subcategorylist.clear();
      subcategoryController.subcategorylist.value = data;
      if (subcategoryController.subcategorylist.isEmpty) {
        subcategoryController.isSubcategoryloadingoading.value = false;
      }
      print(subcategoryController.subcategorylist);
    } else {
      var data = jsonDecode(response.body);
      subcategoryController.issubcaterror.value = false;

      print(data);
      print(" data not get");
    }
  } catch (e) {
    subcategoryController.issubcaterror.value = false;
  }
}

Future<String> updatesubCategory(Map data) async {
  var token = await getToken();
  try {
    final response = await http.post(
        Uri.parse(baseUrl + '/api/SubCategory/UpdateSubCategory'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "subcategoryId": data["subcategoryId"],
          "englishname": data["englishname"],
          "gujaratiname": data["gujaratiname"],
          "imagePath": data["file"],
        }),
        encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getsubategory();
      print("subcategory updated");
      return "SubCategory updated successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("subcategory already exists");
      return "SubCategory already exists";
    }
  } catch (e) {
    print("error");
    // print(e);
    return "Something went wrong!";
  }
}

Future deletesubcategory(int id) async {
  var token = await getToken();

  try {
    final response = await http.post(
        Uri.parse(baseUrl + '/api/SubCategory/DeleteSubCategory/$id'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"id": id}),
        encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getsubategory();
      print("Subcategory deleted");
      return "Subcategory deleted successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("Subcategory delete error");
      return "Subcategory not deleted";
    }
  } catch (e) {
    print("error");
    print(e);
    return "Something went wrong!";
  }
}

Future getsubcateByCategoryId(int id) async {
  var token = await getToken();
  productController.dropdownsubcategory.clear();
  try {
    final response = await http.get(
        Uri.parse(baseUrl + '/api/SubCategory/GetByCategoryId/$id'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      productController.dropdownsubcategory.value = data["data"];
      print(data["key"]);
      print(productController.dropdownsubcategory);
      // print("Subcategory available");
      return true;
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("Subcategory not found");
      return false;
    }
  } catch (e) {
    print("error");
    print(e);
    return "Something went wrong!";
  }
}
