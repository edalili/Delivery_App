import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sebbar_app/splash/Splash_view.dart';
import 'package:sebbar_app/theme/constant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unifest Grp',
      theme: ThemeData(
        primaryColor: primary,
      ),
      home: Splashpage(),
    );
  }
}
