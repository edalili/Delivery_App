import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sebbar_app/auth/Login_view.dart';
import 'package:sebbar_app/home/Home_View.dart';
import 'package:sebbar_app/theme/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashpage extends StatefulWidget {
  Splashpage({Key? key}) : super(key: key);

  @override
  _SplashpageState createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  var islogin;
  Future _getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    islogin = prefs.getString('username');
    setState(() {
      islogin = prefs.getString('username');
    });
  }

  @override
  void initState() {
    _getuser().whenComplete(() async => Timer(Duration(seconds: 5), () {
          Get.off(() => islogin == null ? Loginview() : Homeview());
          print(islogin);
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primarylight,
        body: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/splash.png',
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                  ),
                  Container(
                    height: 30,
                  ),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primary),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
