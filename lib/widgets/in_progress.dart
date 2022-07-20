import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sebbar_app/Services/Barcode_scan.dart';
import 'package:sebbar_app/theme/constant.dart';
import 'package:sebbar_app/theme/urls.dart';
import 'package:sebbar_app/widgets/Drrawer.dart';
import 'package:sebbar_app/widgets/Parcellist.dart';
import 'package:sebbar_app/widgets/resultfilter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dropdown/awesome_dropdown.dart';

class Colisinprocess extends StatefulWidget {
  Colisinprocess({Key? key}) : super(key: key);

  @override
  _ColisinprocessState createState() => _ColisinprocessState();
}

class _ColisinprocessState extends State<Colisinprocess> {
  var id;
  Future<String?> _getprefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString('user_id').toString();
    if (id != null) {
      setState(() {
        id = pref.getString('user_id').toString();
      });
      return id;
    }
  }

  Future getdata(id) async {
    try {
      var response = await http.post(
          Uri.parse(
              '${Urls.baseUrl}Api_delivery/Rest_Api/GetParcelsInProgress'),
          body: ({'users_id': id.toString()}));
      if (response.statusCode == 200) {
        return jsonDecode(response.body.toString());
      }
    } catch (exeption) {
      Future.error(exeption.toString());
    }
  }

  barcodescan scan = Get.put(barcodescan());

  @override
  void initState() {
    _getprefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _selectedItem = '';
    bool _isDropDownOpened = false;
    bool _isBackPressedOrTouchedOutSide = false;
    bool _isPanDown = false;

    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
          backgroundColor: primary,
          title: Text('Colis En Process'),
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
                  Get.off(() => Colisinprocess(), transition: Transition.fade);
                });
              },
              icon: Icon(
                Icons.refresh_rounded,
                size: 35,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(
                  () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Get.to(() => resultfilter(),
                                    arguments: _selectedItem);
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.thumbsUp,
                                size: 15,
                              ),
                              label: Text('  Go   '),
                              style: ElevatedButton.styleFrom(
                                primary: primary,
                              ),
                            ),
                          ],
                          title: Center(
                            child: Text('Filter by Status'),
                          ),
                          content: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Column(
                              children: [
                                AwesomeDropDown(
                                  isPanDown: _isPanDown,
                                  dropDownList: [
                                    'Status',
                                    'Livre',
                                    'Reporte',
                                    'Pas de reponse',
                                    'Injoignable',
                                    'Hors-zone',
                                    'Annule',
                                    'Refuse',
                                    'Numero-Errone',
                                    'Deuxieme Appel',
                                    'Troisieme Appel'
                                  ],
                                  dropDownIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                    size: 23,
                                  ),
                                  selectedItem: _selectedItem,
                                  onDropDownItemClick: (selectedItem) {
                                    _selectedItem = selectedItem;
                                  },
                                  dropStateChanged: (isOpened) {
                                    _isDropDownOpened = isOpened;
                                    if (!isOpened) {
                                      _isBackPressedOrTouchedOutSide = false;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              icon: Icon(
                Icons.filter_alt_outlined,
                size: 35,
              ),
            ),
          ]),
      drawer: Drrawer(),
      body: id == null
          ? Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  getdata(id.toString());
                });
              },
              backgroundColor: primary,
              color: Colors.white,
              child: FutureBuilder(
                future: getdata(id.toString()),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(20),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var date = DateTime.fromMillisecondsSinceEpoch(
                                int.parse(snapshot.data[index]
                                        ['parcel_last_update']) *
                                    1000)
                            .toString();
                        Color? colorstatus;
                        switch (snapshot.data[index]['parcel_status_second']) {
                          case 'POSTPONED':
                            snapshot.data[index]['parcel_status_second'] =
                                'Réporte';
                            colorstatus = Colors.purple;
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
                            snapshot.data[index]['parcel_status_second'] =
                                'Annule';
                            colorstatus = Colors.red;
                            break;
                          case 'REFUSE':
                            snapshot.data[index]['parcel_status_second'] =
                                'Refuse';
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
                                      ['parcel_status_second'] ==
                                  null
                              ? snapshot.data[index]['parcel_status']
                              : snapshot.data[index]['parcel_status_second'],
                          bare_code: snapshot.data[index]['parcel_code'],
                          parcel_client: snapshot.data[index]
                              ['parcel_receiver'],
                          parcel_price: snapshot.data[index]['parcel_price'],
                          parcel_phone: snapshot.data[index]['parcel_phone'],
                          parcel_adress: snapshot.data[index]['parcel_address'],
                          parcel_note: snapshot.data[index]['parcel_note'],
                          parcel_id: snapshot.data[index]['parcel_id'],
                          parcel_customer: snapshot.data[index]
                              ['parcel_customer'],
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: primary,
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
