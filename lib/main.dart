import 'package:budget_tracker_app/Screens/HomePage.dart';
import 'package:budget_tracker_app/Screens/detailPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => HomePage(),
      'DetailPage': (context) => DetailPage(),
    },
  ));
}
