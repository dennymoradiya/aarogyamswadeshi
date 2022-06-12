import 'dart:convert';
import 'package:aarogyamswadeshi/Admin/product/product_controller.dart';
import 'package:aarogyamswadeshi/Screens/Home/home_controller.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyamswadeshi/Services/api_services.dart';
import 'dart:io' as Io;

ProductController productController = Get.put(ProductController());
Homecontroller homecontroller = Get.put(Homecontroller());

Future<String> addProduct(Map data) async {
  var token = await getToken();
  final bytes = Io.File(data["file"]).readAsBytesSync();
  String base64Image = base64Encode(bytes);
  // print(base64Image);
  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Product/CreatePrduct'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: data["subcategoryId"] != ""
                ? json.encode({
                    "categoryId": data["categoryId"],
                    "subcategoryId": data["subcategoryId"],
                    "englishname": data["englishname"],
                    "gujaratiname": data["gujaratiname"],
                    "productDesc": data["productDesc"],
                    "productGDesc": data["productGDesc"],
                    "productImagePath": base64Image,
                    "price": data["price"],
                  })
                : json.encode({
                    "categoryId": data["categoryId"],
                    "englishname": data["englishname"],
                    "gujaratiname": data["gujaratiname"],
                    "productDesc": data["productDesc"],
                    "productGDesc": data["productGDesc"],
                    "productImagePath": base64Image,
                    "price": data["price"],
                  }),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getAllproduct();
      print("Product add");
      return "Product created successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("Product not add");
      return "Product already exists";
    }
  } catch (e) {
    print("error");
    return "Something went wrong!";
  }
}

Future getAllproduct() async {
  productController.isalldataload.value = true;
  productController.isalldataerror.value = true;
  var token = await getToken();
  print(token);
  try {
    final response = await http.get(
      Uri.parse(baseUrl + '/api/Product/GetAllProduct'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      productController.productlist.clear();
      productController.productlist.value = data;

      if (productController.productlist.isEmpty) {
        productController.isalldataload.value = false;
      }

      print(productController.productlist);
      print("get products");
    } else {
      var data = jsonDecode(response.body);
      print(data);
      productController.isalldataerror.value = false;

      print("get not products");
    }
  } catch (e) {
    productController.isalldataerror.value = false;
  }
}

Future<String> updateProduct(Map data) async {
  var token = await getToken();
  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Product/UpdateProduct'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body:
                //  data["subcategoryId"] != ""
                //     ? json.encode({
                //         "categoryId": data["categoryId"],
                //         "subcategoryId": data["subcategoryId"],
                //         "englishname": data["englishname"],
                //         "gujaratiname": data["gujaratiname"],
                //         "productDesc": data["productDesc"],
                //         "productGDesc": data["productGDesc"],
                //         "productImagePath": data["file"],
                //         "price": data["price"],
                //       })
                //     :
                json.encode({
              // "categoryId": data["categoryId"],
              "productId": data["productId"],
              "englishname": data["englishname"],
              "gujaratiname": data["gujaratiname"],
              "productDesc": data["productDesc"],
              "productGDesc": data["productGDesc"],
              "productImagePath": data["file"],
              "price": data["price"],
            }),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getAllproduct();
      print("Product updated");
      return "Product updated successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("Product not updated");
      return "Product not updated";
    }
  } catch (e) {
    print("error");
    return "Something went wrong!";
  }
}

Future deleteProduct(int id) async {
  var token = await getToken();

  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Product/DeleteProduct/$id'),
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
      getAllproduct();
      print("Product deleted");
      return "Product deleted successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("Product delete error");
      return "Product not deleted";
    }
  } catch (e) {
    print("error");
    print(e);
    return "Something went wrong!";
  }
}

Future getProductbycategory(int id) async {
  print(id);
  var token = await getToken();
  homecontroller.categoryviseProductlist.clear();
  try {
    final response = await http.get(
      Uri.parse(
        baseUrl + '/api/Product/GetByCategoryId/$id',
      ),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      homecontroller.categoryviseProductlist.value = data["data"];
      print(homecontroller.categoryviseProductlist);
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print(" data not get");
    }
  } catch (e) {}
}

Future getProductbysubcategory(int id) async {
  var token = await getToken();
  homecontroller.subcategoryviseProductlist.clear();

  try {
    final response = await http.get(
      Uri.parse(
        baseUrl + '/api/Product/GetBySubCategoryId/$id',
      ),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      homecontroller.subcategoryviseProductlist.value = data["data"];
      print(homecontroller.subcategoryviseProductlist);
      return homecontroller.subcategoryviseProductlist;
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print(" data not get");
    }
  } catch (e) {}
}

Future getSearchProduct(String svalue) async {
  var token = await getToken();
  try {
    final response = await http.get(
      Uri.parse(baseUrl + '/api/Search/$svalue'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      homecontroller.searchlist.clear();
      homecontroller.searchlist.value = data;

      // if (homecontroller.searchlist.isEmpty) {
      //   homecontroller.isalldataload.value = false;
      // }

      print(homecontroller.searchlist);
      print("get search");
    } else {
      var data = jsonDecode(response.body);
      print(data);
      // homecontroller.isalldataerror.value = false;

      print("get no search products");
    }
  } catch (e) {
    // homecontroller.isalldataerror.value = false;
  }
}
