import 'dart:convert';

import 'package:aarogyamswadeshi/Screens/cart/cart_controller.dart';
import 'package:aarogyamswadeshi/Services/api_services.dart';
import 'package:get/get.dart';

import 'pref_manager.dart';
import 'package:http/http.dart' as http;

Future getCart() async {
  CartController cartController = Get.put(CartController());
  cartController.iscarterror.value = true;
  cartController.iscartload.value = true;

  var token = await getToken();
  print(token);
  try {
    final response = await http.get(
      Uri.parse(baseUrl + '/api/Cart/GetCartDetail'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      cartController.cartlist.clear();
      cartController.cartlist.value = data["data"];
      if (cartController.cartlist.isEmpty) {
        cartController.iscartload.value = false;
      }
      print(cartController..cartlist);
    } else {
      var data = jsonDecode(response.body);
      print(data);
      cartController.iscarterror.value = false;

      print(" data not get");
    }
  } catch (e) {
    cartController.iscarterror.value = false;
  }
}

Future<String> addTocart(Map data) async {
  var token = await getToken();
  try {
    final response = await http.post(Uri.parse(baseUrl + '/api/Cart/AddCart'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode([
          {
            "productID": data["productID"],
            "quantity": data["quantity"],
          }
        ]),
        encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      return "Added To Cart";
    } else {
      return "Something went wrong!";
    }
  } catch (e) {
    return "Something went wrong!";
  }
}

Future<String> deleteFromcart(int id) async {
  var token = await getToken();
  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Cart/RemoveCart/$id'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({"id": id}),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      return "Product Removed from cart";
    } else {
      return "Something went wrong!";
    }
  } catch (e) {
    return "Something went wrong!";
  }
}

Future<String> clearCart() async {
  var token = await getToken();
  try {
    final response = await http.post(Uri.parse(baseUrl + '/api/Cart/ClearAll'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      return "Cart is Cleared";
    } else {
      return "Something went wrong!";
    }
  } catch (e) {
    return "Something went wrong!";
  }
}

Future<String> placeOrder(Map data) async {
  var token = await getToken();
  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Order/PlaceOrder'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode([
              {
                "productID": data["productId"],
                "quantity": data["quantity"],
                "price": data["price"],
              }
            ]),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data);
      return "Order Placed successfully";
    } else {
      var data = jsonDecode(response.body);
      // print(data);
      return "Order Not Placed";
    }
  } catch (e) {
    return "Something went wrong!";
  }
}
