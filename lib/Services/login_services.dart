import 'dart:convert';
import 'package:aarogyamswadeshi/Screens/account/account_controller.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'api_services.dart';

AccountController accountController = Get.put(AccountController());
Future loginUser(Map userinfo) async {
  final response = await http.post(Uri.parse(baseUrl + '/api/User/Login'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "email": userinfo["email"],
        "password": userinfo["password"],
      }),
      encoding: Encoding.getByName('utf-8'));
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var isadmin = data["data"]["isAdmin"];
      print(data);
      if (isadmin) {
        // setisAdmin(isadmin);
        return "isadmin";
      } else {
        // setlogin(true);
        setToken(data["data"]["accessToken"]);
        setuserid(data["data"]["id"].toString());
        setUserinfo(
            name: data["data"]["name"],
            email: userinfo["email"],
            password: userinfo["password"],
            lang: 1,
            phone: "");
        return "Login Sucessfully!";
      }
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("user not found");
      return "User not found";
    }
  } catch (e) {
    print(e.toString());
    return "Something went wrong!";
  }
}

Future getUserDetails() async {
  var token = await getToken();
  final response = await http
      .get(Uri.parse(baseUrl + '/api/User/GetAddressDetail'), headers: {
    "Content-Type": "application/json",
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      accountController.userdata.value = data["data"];
      print(accountController.userdata);
    } else {
      var data = jsonDecode(response.body);
      print(data);
    }
  } catch (e) {
    print(e.toString());
    return "Something went wrong!";
  }
}






// Future updateLoginUser(Map userinfo) async {
//   var token = await getToken();
//   final response = await http.post(Uri.parse(baseUrl + '/api/User/UpdateUser'),
//       headers: {
//         "Content-Type": "application/json",
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: json.encode({
//         "name": userinfo["name"],
//         "role": "User",
//         "email": userinfo["email"],
//         "password": userinfo["password"]
//       }),
//       encoding: Encoding.getByName('utf-8'));
//   try {
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       setUserinfo(
//         email: userinfo["email"],
//         name: userinfo["name"],
//         password: userinfo["password"],
//       );
//       print(data);
//       return "User Updated Successfully!";
//     } else {
//       var data = jsonDecode(response.body);
//       print(data);
//       return "User not updated";
//       // return data["Key"];
//     }
//   } catch (e) {
//     return "Something went wrong!";
//   }
// }
