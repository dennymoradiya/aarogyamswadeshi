import 'dart:convert';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:http/http.dart' as http;

import 'api_services.dart';

Future addUser(Map userinfo) async {
  final response = await http.post(Uri.parse(baseUrl + '/api/User/CreateUser'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "name": userinfo["name"],
        "role": "User",
        "email": userinfo["email"],
        "password": userinfo["password"]
      }),
      encoding: Encoding.getByName('utf-8'));
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      setuserid(data["id"].toString());
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("user data not add");
      return data["Key"];
    }
  } catch (e) {
    return e.toString();
  }
}

Future updateUser(Map userinfo) async {
  var token = await getToken();

  final response = await http.post(Uri.parse(baseUrl + '/api/User/UpdateUser'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "name": userinfo["name"],
        "address": userinfo["address"],
        "mobileNo": userinfo["mobileNo"],
        "city": userinfo["city"],
        "state": userinfo["state"],
        "business": userinfo["business"]
      }),
      encoding: Encoding.getByName('utf-8'));
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return data["message"];
    } else {
      var data = jsonDecode(response.body);
      print(data);
      return "User Not Created !";
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> verifyUser(email, code) async {
  final response = await http.post(Uri.parse(baseUrl + '/api/User/VerifyEmail'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({"emailID": email, "code": code}),
      encoding: Encoding.getByName('utf-8'));
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      var token = data["data"]["accessToken"];
      setUserinfo(
        name: data["data"]["name"],
        email: data["data"]["email"],
      );
      setuserid(data["data"]["id"].toString());
      setToken(token);
      return data["key"].toString();
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("verify not");

      return data["Key"].toString();
    }
  } catch (e) {
    return "Something went wrong!";
  }
}

Future<String> verifyAdmin(int code) async {
  var email = await getadminEmail();

  final response =
      await http.post(Uri.parse(baseUrl + '/api/User/VerifyOtpForAdmin'),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({"emailID": email, "code": code}),
          encoding: Encoding.getByName('utf-8'));
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var token = data["data"]["accessToken"];
      setToken(token);
      print(data);
      return data["key"].toString();
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("verify not");
      return data["Key"].toString();
    }
  } catch (e) {
    return "Something went wrong!";
  }
}

Future<String> resendOtpcode(email) async {
  // var userid = int.parse(await getuserid());

  final response = await http.get(
    Uri.parse(baseUrl + '/api/User/SendUserVerificationEmail/$email'),
    headers: {
      "Content-Type": "application/json",
    },
  );

  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["message"].toString();
    } else {
      var data = jsonDecode(response.body);
      print("$data");
      return data["Message"].toString();
    }
  } catch (e) {
    return "Something went wrong!";
  }
}

Future<String> SentOtp(email) async {
  // var userid = int.parse(await getuserid());
  final response = await http.get(
    Uri.parse(baseUrl + '/api/User/LoginByEmailID?emailID=$email'),
    headers: {
      "Content-Type": "application/json",
    },
  );

  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setisAdmin(data["data"]["isAdmin"]);
      setAdminpassword(data["data"]["password"]);
      return "Please check your email for code";
    } else {
      var data = jsonDecode(response.body);
      print("$data");
      return "Something went wrong!";
    }
  } catch (e) {
    return "Something went wrong!";
  }
}
