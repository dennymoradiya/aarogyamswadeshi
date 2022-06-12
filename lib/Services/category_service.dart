import 'dart:convert';
import 'package:aarogyamswadeshi/Admin/category/category_controller.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyamswadeshi/Services/api_services.dart';
import 'dart:io' as Io;

CategoryController categoryController = Get.put(CategoryController());

Future<String> addcategory(Map data) async {
  var token = await getToken();
  // print(token);
  final bytes = Io.File(data["file"]).readAsBytesSync();
  String base64Image = base64Encode(bytes);
  // print(base64Image);
  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Category/CreateCategory'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              "englishname": data["englishname"],
              "gujaratiname": data["gujaratiname"],
              "imagePath": base64Image,
              "isSubCategoryAllowed": data["isSubCategoryAllowed"]
            }),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getCategory();
      print("category add");
      return "Category created successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("category not add");
      return "Category already exists";
    }
  } catch (e) {
    print("error");
    // print(e);
    return "Something went wrong!";
  }
}

Future getCategory() async {
  categoryController.iscategoryloading.value = true;
  categoryController.iscaterror.value = true;
  var token = await getToken();
  print(token);
  try {
    final response = await http.get(
      Uri.parse(baseUrl + '/api/Category/GetAllCategory'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      categoryController.categorylist.clear();
     
      categoryController.categorylist.value = data;
      if (categoryController.categorylist.isEmpty) {
        categoryController.iscategoryloading.value = false;
      }
      print(categoryController.categorylist);
    } else {
      var data = jsonDecode(response.body);
       categoryController.iscaterror.value = false;
      print(data);
      print(" data not get");
    }
  } catch (e) {
     categoryController.iscaterror.value = false;
  }
}

Future<String> updateCategory(Map data) async {
  var token = await getToken();
  print(token);

  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Category/UpdateCategory'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              "categoryId": data["categoryId"],
              "englishname": data["englishname"],
              "gujaratiname": data["gujaratiname"],
              // "isSubCategoryAllowed": data["isSubCategoryAllowed"],
              "imagePath": data["file"],
            }),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getCategory();
      print("category updated");
      return "category updated successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("category already exists");
      return "category already exists";
    }
  } catch (e) {
    print("error");
    // print(e);
    return "Something went wrong!";
  }
}

Future deleteCategory(int id) async {
  var token = await getToken();

  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Category/DeleteCategory/$id'),
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
      getCategory();
      print("category deleted");
      return "category deleted successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("category delete error");
      return "Category not deleted";
    }
  } catch (e) {
    print("error");
    print(e);
    return "Something went wrong!";
  }
}
