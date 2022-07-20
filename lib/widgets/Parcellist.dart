import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sebbar_app/theme/constant.dart';
import 'package:sebbar_app/theme/urls.dart';
import 'package:sebbar_app/widgets/Status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Parcellist extends StatefulWidget {
  final parcel_id;
  final vendeur_store;
  final vendeur_phone;
  final vendeur_name;
  final parcel_status;
  final parcel_seconde_status;
  final bare_code;
  final parcel_client;
  final parcel_price;
  final parcel_phone;
  final parcel_adress;
  final parcel_city;
  final parcel_note;
  final parcel_customer;
  final Color? color_status;

  const Parcellist({
    Key? key,
    this.parcel_id,
    this.vendeur_store,
    this.vendeur_phone,
    this.vendeur_name,
    this.parcel_status,
    this.bare_code,
    this.parcel_client,
    this.parcel_price,
    this.parcel_phone,
    this.parcel_adress,
    this.parcel_city,
    this.parcel_note,
    this.parcel_customer,
    this.parcel_seconde_status,
    this.color_status,
  }) : super(key: key);

  @override
  _ParcellistState createState() => _ParcellistState();
}

String dateFormated(int timeStamp) {
  var dateFromTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  return DateFormat('dd-MM-yyyy hh:mm').format(dateFromTimeStamp);
}

class _ParcellistState extends State<Parcellist> {
  livre(idliv, parcelid, livretime) async {
    var response =
        await http.post(Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/livre'),
            body: ({
              'id_livreur': idliv.toString(),
              'id_parcel': parcelid.toString(),
              'parcel_delivery_time': livretime.toString(),
            }));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }

  var id;
  Future<String?> getid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString('user_id').toString();
    if (id != null) {
      setState(() {
        id = pref.getString('user_id').toString();
      });
    }
  }

  /*Future getcustumer(idcustomer) async {
    var response = await http.post(
        Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/GetCustum'),
        body: ({'custumer_id': idcustomer.toString()}));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }*/

  List<dynamic> lstst = [];
  Future getstatus() async {
    var response = await http.get(
      Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/getstatus'),
    );
    if (response.statusCode == 200) {
      lstst.addAll(jsonDecode(response.body));
    }
  }

  Future updtstatus(livr, parcel, status) async {
    var response = await http.post(
        Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/Status'),
        body: ({
          'livreur': livr.toString(),
          'parcel': parcel.toString(),
          'status': status.toString(),
        }));

    if (response.statusCode == 200) {
      setState(() {
        return jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    getid();
    getstatus();
    super.initState();
  }

  void whatsappmgs({@required numberphone, @required message}) async {
    String url = "whatsapp://send?phone=+212$numberphone&text=$message";
    await canLaunch(url) ? launch(url) : print('No cant');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  widget.bare_code,
                  style: TextStyle(
                      color: primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: BoxDecoration(
                    color: widget.color_status,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.parcel_seconde_status.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.5,
          ),
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.userAlt,
                size: 15,
                color: Colors.amber,
              ),
              Text('  ${widget.parcel_client}'),
              Text(
                '( ' + widget.parcel_price + 'Dh' + ' )',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0,
            color: Color(0xffE3F2FD),
          ),
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.phoneAlt,
                size: 15,
                color: Colors.amber,
              ),
              Text(
                '  ${widget.parcel_phone}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0,
            color: Color(0xffE3F2FD),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.locationArrow,
                  size: 15,
                  color: Colors.amber,
                ),
                Text(
                  '  ${widget.parcel_adress}',
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.5,
          ),
          Row(
            children: [
              Spacer(),
              IconButton(
                onPressed: () async {
                  await FlutterPhoneDirectCaller.callNumber(
                      widget.parcel_phone);
                },
                icon: FaIcon(
                  FontAwesomeIcons.phoneAlt,
                  color: Colors.blue,
                  size: 26,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text('Close'))
                            ],
                            title: Center(child: Text('Colis Information')),
                            content: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2),
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Destinataire : ',
                                                style: TextStyle(
                                                  color: primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(widget.parcel_client),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Téléphone : ',
                                                style: TextStyle(
                                                  color: primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(widget.parcel_phone),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Adresse : ',
                                                style: TextStyle(
                                                  color: primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(widget.parcel_adress),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Commentaire : ',
                                                style: TextStyle(
                                                  color: primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(widget.parcel_note),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Cbrt : ',
                                                style: TextStyle(
                                                  color: primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(widget.parcel_price),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      });
                },
                icon: FaIcon(
                  FontAwesomeIcons.eye,
                  color: primary,
                  size: 30,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actions: [
                          ElevatedButton.icon(
                            onPressed: () {
                              //print(id.toString()); //reportedDate?.seconds
                              setState(() {
                                updtstatus(
                                  id.toString(),
                                  widget.parcel_id,
                                  selectedvalue.toString(),
                                );
                                selectedvalue = '';
                                Get.back();
                              });
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.thumbsUp,
                              size: 15,
                            ),
                            label: Text('Okay'),
                            style: ElevatedButton.styleFrom(
                              primary: primary,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              selectedvalue = '';
                              Get.back();
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.times,
                              size: 15,
                            ),
                            label: Text('Close'),
                            style: ElevatedButton.styleFrom(
                              primary: primary,
                            ),
                          ),
                        ],
                        title: Center(child: Text('Colis Status')),
                        content: Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: double.maxFinite,
                            child: Status(lst: lstst)),
                      );
                    },
                  );
                },
                icon: FaIcon(
                  FontAwesomeIcons.edit,
                  color: Colors.deepPurpleAccent,
                  size: 28,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  whatsappmgs(
                      numberphone: widget.parcel_phone,
                      message:
                          "Bonjour, Je suis votre livreur Quick Livraison Je vous confirme pour livrer le colis " +
                              widget.bare_code.toString() +
                              " de " +
                              widget.parcel_price +
                              " MAD a payer a la livraison. Trés bon journée");
                },
                icon: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: primary,
                  size: 31,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  var currentDateTime = Timestamp.fromMillisecondsSinceEpoch(
                      DateTime.now().millisecondsSinceEpoch);
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Confirmation ',
                    desc: 'Cet Colis Livré Avec Success!!',
                    btnOkText: 'Oui, Colis Livré',
                    btnCancelOnPress: () {
                      Get.back();
                      //print(dateFormated(1639494362));
                    },
                    btnOkOnPress: () {
                      livre(id.toString(), widget.parcel_id.toString(),
                          currentDateTime.seconds);
                    },
                  )..show();
                },
                icon: FaIcon(
                  FontAwesomeIcons.checkCircle,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
