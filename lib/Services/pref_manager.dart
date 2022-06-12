import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefManager extends GetxController {
  RxString mobileNumber = "".obs;
}

Future setlogin(bool login) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('Islogin', login);
  print(prefs.getBool('Islogin'));
}

Future<bool> getlogin() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('Islogin');
}

Future<bool> removelogin() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove('Islogin');
}

//set isAdmin
Future setisAdmin(bool isadmin) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isAdmin', isadmin);
}

Future<bool> getisAdmin() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isAdmin');
}

Future<bool> removeisAdmin() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove('isAdmin');
}

// Future<void> setEmail(String email) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('Email', email);
//   // print("add mobile to local");
// }

// Future<String> getEmail() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString("Email");
// }

// Future<void> removeEmail() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('Email');

// }

//token
Future<void> setToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('Token', token);
  // print("add mobile to local");
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getString("Token"));
  return prefs.getString("Token");
}

Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('Token');
}

//admin password
Future<void> setAdminpassword(String adminpassword) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('Adminpassword', adminpassword);
  // print("add mobile to local");
}

Future<String> getAdminpassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("Adminpassword");
}

Future<void> removeAdminpassword() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('Adminpassword');
}

//passcode
Future setPasscode(String passcode) async {
  final prefs = await SharedPreferences.getInstance();
  return await prefs.setString('passcode', passcode);
}

Future getPasscode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('passcode');
}

Future removepasscode() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('passcode');
}

//userid

Future setuserid(String userid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userid', userid);
}

Future<String> getuserid() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userid');
}

Future removeuserid() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userid');
}

Future<void> setUserinfo({name, email, password, phone, lang}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('name', name ?? "");
  prefs.setString('email', email ?? "");
  prefs.setString('password', password ?? "");
  prefs.setString('phone', phone ?? "");
  prefs.setInt('lang', lang ?? 1);
}

Future<String> getEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<String> getname() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('name');
}

Future<String> getpassword() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('password');
}

Future setadminEmail(String adminEmail) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('adminemail', adminEmail);
}

Future<String> getadminEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('adminemail');
}

Future removeadminEmail() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('adminemail');
}
