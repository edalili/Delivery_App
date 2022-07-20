import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sebbar_app/theme/constant.dart';
import 'package:sebbar_app/theme/urls.dart';
import 'package:sebbar_app/widgets/Drrawer.dart';
import 'package:sebbar_app/widgets/Parcellist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Resultscrenn extends StatefulWidget {
  Resultscrenn({Key? key}) : super(key: key);

  @override
  _ResultscrennState createState() => _ResultscrennState();
}

class _ResultscrennState extends State<Resultscrenn> {
  Future _get_data(id) async {
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

  var id;
  Future<String?> getprefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString('user_id').toString();
    if (id != null) {
      setState(() {
        id = pref.getString('user_id').toString();
      });
    }
  }

  @override
  void initState() {
    getprefs();
    setState(() {
      Get.arguments;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        centerTitle: true,
        backgroundColor: primary,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      drawer: Drrawer(),
      body: FutureBuilder(
        future: _get_data(id.toString()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            );
          } else {
            return ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  if (snapshot.data[index]['parcel_code'] ==
                      Get.arguments.toString()) {
                    Color? colorstatus;
                    switch (snapshot.data[index]['parcel_status_second']) {
                      case 'POSTPONED':
                        setState(() {
                          snapshot.data[index]['parcel_status_second'] =
                              'Reporte';
                          colorstatus = Colors.purple;
                        });
                        break;
                      case 'NOANSWER':
                        snapshot.data[index]['parcel_status_second'] =
                            'Pas de reponse';
                        colorstatus = Colors.amber;

                        break;
                      case 'UNREACHABLE':
                        snapshot.data[index]['parcel_status_second'] =
                            'Injoignable';
                        colorstatus = Colors.orange;
                        break;
                      case 'OUT_OF_AREA':
                        snapshot.data[index]['parcel_status_second'] =
                            'Hors-zone';
                        colorstatus = Colors.redAccent;

                        break;
                      case 'CANCELED':
                        snapshot.data[index]['parcel_status_second'] = 'Annule';
                        colorstatus = Colors.red;

                        break;
                      case 'REFUSE':
                        snapshot.data[index]['parcel_status_second'] = 'Refuse';
                        colorstatus = Colors.red;

                        break;
                      case 'ERR':
                        snapshot.data[index]['parcel_status_second'] =
                            'Numero-Errone';
                        colorstatus = Colors.red;
                        break;
                      case 'DEUXIEME':
                        snapshot.data[index]['parcel_status_second'] =
                            'Deuxieme appel';
                        colorstatus = Colors.green;
                        break;
                      case 'TROIXIEME':
                        snapshot.data[index]['parcel_status_second'] =
                            'Troisieme appel';
                        colorstatus = Colors.green;
                        break;
                    }

                    return Parcellist(
                      color_status: colorstatus,
                      parcel_seconde_status: snapshot.data[index]
                          ['parcel_status_second'],
                      bare_code: snapshot.data[index]['parcel_code'],
                      parcel_client: snapshot.data[index]['parcel_receiver'],
                      parcel_price: snapshot.data[index]['parcel_price'],
                      parcel_phone: snapshot.data[index]['parcel_phone'],
                      parcel_adress: snapshot.data[index]['parcel_address'],
                      parcel_note: snapshot.data[index]['parcel_note'],
                      parcel_id: snapshot.data[index]['parcel_id'],
                      parcel_customer: snapshot.data[index]['parcel_customer'],
                    );
                  } else {
                    return Container();
                  }
                });
          }
        },
      ),
    );
  }
}
