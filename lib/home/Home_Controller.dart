import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sebbar_app/theme/urls.dart';

class Homecontroller extends GetxController {
  Future getdata(id) async {
    try {
      var response = await http.post(
          Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/getparcels'),
          body: ({'users_id': id.toString()}));
      if (response.statusCode == 200) {
        return jsonDecode(response.body.toString());
      }
    } catch (exeption) {
      Future.error(exeption.toString());
    }
  }
}
