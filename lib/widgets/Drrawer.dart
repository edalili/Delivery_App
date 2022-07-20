import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sebbar_app/auth/Login_view.dart';
import 'package:sebbar_app/home/Home_View.dart';
import 'package:sebbar_app/theme/constant.dart';
import 'package:sebbar_app/widgets/Resetpass.dart';
import 'package:sebbar_app/widgets/distribution.dart';
import 'package:sebbar_app/widgets/in_progress.dart';
import 'package:sebbar_app/widgets/paymentnote.dart';
import 'package:sebbar_app/widgets/statistique.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drrawer extends StatefulWidget {
  Drrawer({Key? key}) : super(key: key);

  @override
  _DrrawerState createState() => _DrrawerState();
}

class _DrrawerState extends State<Drrawer> {
  var email;
  var username;

  getpref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
    email = pref.getString('useremail');
    if (username != null) {
      setState(() {
        username = pref.getString('username');
        email = pref.getString('useremail');
      });
    }
  }

  @override
  void initState() {
    getpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //on load
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: primary,
            ),
            accountName: Text(username.toString()),
            accountEmail: Text(email.toString()),
            currentAccountPicture: CircleAvatar(
              child: Icon(
                Icons.account_circle,
                size: 70,
              ),
              backgroundColor: Colors.amber[50],
            ),
          ),
          ListTile(
            title: Text(
              'Colis En Distribution',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(
              Icons.inventory_2,
              size: 20,
            ),
            hoverColor: Colors.amber,
            onTap: () {
              //Get.to(() => Homeview());
              Get.to(() => Homeview());
              //Scaffold.of(context).openEndDrawer();
            },
          ),
          ListTile(
            title: Text(
              "Colis En Process",
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(
              Icons.inventory_2,
              size: 20,
            ),
            hoverColor: Colors.amber,
            onTap: () {
              Get.to(() => Colisinprocess());
            },
          ),
          ListTile(
            title: Text(
              "Statistique",
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(
              Icons.stacked_bar_chart,
              size: 20,
            ),
            hoverColor: Colors.amber,
            onTap: () {
              Get.to(() => Chart());
            },
          ),
          ListTile(
            title: Text(
              'Bons de distribution',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(
              Icons.text_snippet,
              size: 20,
            ),
            hoverColor: Colors.amber,
            onTap: () {
              Get.to(() => Distribution());
            },
          ),
          ListTile(
            title: Text(
              'Bons de Paiement',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(
              Icons.euro,
              size: 20,
            ),
            hoverColor: Colors.amber,
            onTap: () {
              Get.to(() => Paymentnote());
            },
          ),
          ListTile(
            title: Text(
              'Paramétres',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(
              Icons.settings,
              size: 20,
            ),
            hoverColor: Colors.amber,
            onTap: () {
              Get.to(() => Reset());
            },
          ),
          ListTile(
            title: Text(
              'Déconnexion',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(
              Icons.exit_to_app,
              size: 20,
            ),
            hoverColor: Colors.amber,
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Get.off(() => Loginview(),
                  transition: Transition.cupertinoDialog);
            },
          ),
        ],
      ),
    );
  }
}
