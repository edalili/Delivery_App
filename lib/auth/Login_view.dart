import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sebbar_app/auth/Login_controller.dart';
import 'package:sebbar_app/theme/constant.dart';

class Loginview extends StatefulWidget {
  Loginview({Key? key}) : super(key: key);

  @override
  _LoginviewState createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  var username = TextEditingController();
  var password = TextEditingController();

  Logincontroller logintest = Get.put(Logincontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarylight,
      body: Center(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 90, bottom: 50),
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Image.asset(
                'assets/image/app_logo.png',
                width: 100,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  GetBuilder<Logincontroller>(builder: (logintest) {
                    return Form(
                        child: Column(
                      children: [
                        TextFormField(
                          controller: username,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.perm_identity),
                            hintText: 'Username',
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ),
                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5),
                            ),
                          ),
                          obscureText: true,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                        ),
                        ElevatedButton(
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            logintest.login(username.text, password.text);
                            //Get.to(() => Homeview());
                          },
                          style: ElevatedButton.styleFrom(
                            primary: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 90, vertical: 15),
                          ),
                        ),
                      ],
                    ));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
