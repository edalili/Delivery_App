import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:sebbar_app/widgets/resultscann.dart';

class barcodescan extends GetxController {
  Future<Object?> scan() async {
    try {
      var result = await FlutterBarcodeScanner.scanBarcode(
        '#000000',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      if (result != -1) {
        return Get.to(() => Resultscrenn(), arguments: result);
        // return result;
      } else {
        return Get.snackbar('Barecode :', "Colis Not Exist!",
            backgroundColor: Color(0xff2196F3));
      }
    } on PlatformException {}
  }
}
