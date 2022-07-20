import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sebbar_app/home/Home_View.dart';
import 'package:sebbar_app/theme/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logincontroller extends GetxController {
  var username;
  //save data in cach
  Future savePref(String id, String username, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', id);
    prefs.setString('username', username);
    prefs.setString('useremail', email);
  }

  Future<String?> getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
    return username;
  }

  //function login
  Future login(email, pass) async {
    try {
      if (email.toString().isNotEmpty && pass.toString().isNotEmpty) {
        var response = await http.post(
            Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/login'),
            body: ({'email': email, 'password': pass}),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var userdata = jsonDecode(response.body);
          savePref(userdata[0]['users_id'], userdata[0]['users_name'],
              userdata[0]['users_email']);
          Get.offAll(() => Homeview());
          //Get.snackbar('Alert', 'login');
        } else {
          Get.snackbar('Error', 'Email Or Password Incorrect!!!',
              icon: Icon(
                Icons.error,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } else {
        Get.snackbar(
          'Alert',
          'Please Insert Your Email And password',
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.white,
          ),
          backgroundColor: Color(0xffFFCD42),
          colorText: Colors.white,
        );
      }
    } catch (exception) {
      Future.error(exception.toString());
    }
  }
}
