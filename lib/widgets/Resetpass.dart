import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sebbar_app/auth/Login_view.dart';
import 'package:sebbar_app/theme/constant.dart';
import 'package:sebbar_app/theme/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reset extends StatefulWidget {
  Reset({Key? key}) : super(key: key);

  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  var id;

  final oldpass = TextEditingController();
  final confirmpass = TextEditingController();
  final newpass = TextEditingController();

  Future<String?> getid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString('user_id').toString();
    if (id != null) {
      setState(() {
        id = pref.getString('user_id').toString();
      });
      return id;
    }
  }

  Future resetpassword(password) async {
    await http.post(Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/ResetPass'),
        body: ({
          'id': id.toString(),
          'password': password.toString(),
        }));
  }

  chekpass(pass) async {
    if (oldpass.text == confirmpass.text) {
      await resetpassword(pass.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Get.offAll(() => Loginview(), transition: Transition.cupertinoDialog);
    } else {
      Get.snackbar(
        'Error',
        'Votre Information incorrect!',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: Duration(seconds: 1),
        backgroundColor: primary,
        colorText: Colors.white,
        borderRadius: 10,
        icon: FaIcon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.white,
          textDirection: TextDirection.rtl,
        ),
      );
    }
  }

  @override
  void initState() {
    getid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: Text('Modifier Mot de passe'),
        centerTitle: true,
        backgroundColor: primary,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08,
        ),
        child: Center(
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              Center(
                child: Text(
                  'Reset your Password',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              TextFormField(
                controller: oldpass,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  hintText: 'Old Password',
                  hintStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextFormField(
                controller: confirmpass,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextFormField(
                controller: newpass,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  hintText: 'New Password',
                  hintStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ElevatedButton(
                child: Text(
                  'Reset',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    chekpass(newpass.text);
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
