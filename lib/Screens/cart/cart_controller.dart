import 'package:get/get.dart';

class CartController extends GetxController {
  RxList cartlist = [].obs;
  RxDouble carttotal = 0.0.obs;

  RxBool iscartload = true.obs;
  RxBool iscarterror = true.obs;
  RxDouble temp = 0.0.obs;

  void getCarttotal() {
    temp.value = 0.0;
    carttotal.value = 0.0;
    cartlist.forEach((element) {
      temp =
          (double.parse(element["quantity"].toString()) * element["price"]).obs;
      carttotal.value += temp.value;
    });
  }
}
