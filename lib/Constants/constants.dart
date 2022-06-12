import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff00a300);
const kPrimaryLightColor = Color(0xFFd9ffd9);

void scaffoldMessage(context, text) {
  var snackbar = SnackBar(
    content: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: kPrimaryColor,
    duration: Duration(milliseconds: 1000),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
