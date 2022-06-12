import 'package:aarogyamswadeshi/Admin/Slider/add_slider.dart';
import 'package:aarogyamswadeshi/Admin/admin_home.dart';
import 'package:aarogyamswadeshi/Admin/category/category_page.dart';
import 'package:aarogyamswadeshi/Admin/product/product_page.dart';
import 'package:aarogyamswadeshi/Admin/subcategory/subcategory_page.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/email_screen.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

class Drawerbar extends StatelessWidget {
  const Drawerbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Center(
            child: UserAccountsDrawerHeader(
              currentAccountPictureSize: Size.square(84),
              accountName: Text(
                "Aarogyam Swadeshi",
                style: TextStyle(fontSize: 20),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(
                  "assets/images/logo.png",
                ),
              ),
              accountEmail: null,
            ),
          ),
          ListTile(
            title: Text("Dashboard"),
            onTap: () {
              Get.to(AdminHomePage());
            },
            // trailing: Icon(Icons.dashboard),
          ),
          ListTile(
            title: Text("Category"),
            // trailing: Icon(Icons.category),
            onTap: () {
              Get.to(CategoryPage());
            },
          ),
          ListTile(
            title: Text("SubCategory"),
            // trailing: Icon(Icons.),
            onTap: () {
              Get.to(SubCategoryPage());
            },
          ),
          ListTile(
            title: Text("Product"),
            // trailing: Icon(Icons.),
            onTap: () {
              Get.to(ProductPage());
            },
          ),
          ListTile(
            title: Text("Add Gallery"),
            // trailing: Icon(Icons.),
            onTap: () {
              Get.to(AddSliderImages());
            },
          ),
          ListTile(
            title: Text("Logout"),
            trailing: Icon(Icons.logout),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        content: Text("Are You Sure Want to Logout?"),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text("Close"),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kPrimaryColor)),
                            child: Text("Yes"),
                            onPressed: () {
                              removeToken();
                              removeisAdmin();
                              removelogin();
                              removepasscode();
                              Get.back();
                              Get.offAll(EmailScreen());
                            },
                          )
                        ],
                      ));
            },
          ),
        ],
      ),
    );
  }
}
