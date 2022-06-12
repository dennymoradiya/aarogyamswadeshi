import 'package:get/get.dart';

class ProductController extends GetxController {
  RxList productlist = [].obs;
  RxList dropdownsubcategory = [].obs;
  RxBool isalldataerror = true.obs;
  RxBool isalldataload= true.obs;
}
