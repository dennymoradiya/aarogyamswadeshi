import 'dart:convert';

class CartModel {
  CartModel({
     this.orderid,
     this.title,
     this.quantity,
     this.price,
     this.totalamt,
     this.imgurl,
     this.date,
  });

  final String orderid;
  final String title;
  final String quantity;
  final String price;
  final String totalamt;
  final String imgurl;
  final String date;

  factory CartModel.fromJson(String str) =>
      CartModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartModel.fromMap(Map<String, dynamic> json) =>
      CartModel(
        orderid: json["orderid"],
        title: json["title"],
        quantity: json["quantity"],
        price: json["price"],
        totalamt: json["totalamt"],
        imgurl: json["imgurl"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "orderid": orderid,
        "title": title,
        "quantity": quantity,
        "price": price,
        "totalamt": totalamt,
        "imgurl": imgurl,
        "date": date,
      };
}