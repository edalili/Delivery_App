import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sebbar_app/Services/Barcode_scan.dart';
import 'package:sebbar_app/home/Home_View.dart';

class appbarr extends StatefulWidget implements PreferredSizeWidget {
  final Color? background;
  final Widget? title;
  appbarr({
    Key? key,
    this.background,
    this.title,
  }) : super(key: key);

  @override
  _appbarrState createState() => _appbarrState();

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}

class _appbarrState extends State<appbarr> {
  barcodescan scan = Get.put(barcodescan());
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: widget.background,
        title: widget.title,
        actions: [
          IconButton(
            onPressed: () {
              scan.scan();
            },
            icon: Icon(
              Icons.qr_code_scanner,
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Get.off(() => Homeview(), transition: Transition.fade);
              });
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 35,
            ),
          ),
        ]);
  }
}
