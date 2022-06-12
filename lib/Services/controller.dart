import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';

class Controller extends GetxController {

  RxBool isIntenet  = false.obs;


  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      isIntenet.value = false;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      isIntenet.value = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isIntenet.value = true;
    }
  }
}