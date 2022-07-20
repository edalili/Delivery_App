import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sebbar_app/theme/constant.dart';
import 'package:sebbar_app/theme/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Paymentnote extends StatefulWidget {
  Paymentnote({Key? key}) : super(key: key);

  @override
  _PaymentnoteState createState() => _PaymentnoteState();
}

class _PaymentnoteState extends State<Paymentnote> {
  var id;
  Future<String?> _getidd() async {
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
    _getidd();
    _getpdf();
    super.initState();
  }

  Future _getpdf() async {
    var response = await http.post(
        Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/Getnote'),
        body: ({
          'users_id': id.toString(),
        }));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bons De Paiement'),
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
        child: FutureBuilder(
            future: _getpdf(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(
                            snapshot.data[index]['payment_note_time']
                                .toString()) *
                        1000);
                    return ListTile(
                      title: Text(
                        snapshot.data[index]['payment_note_ref'],
                      ),
                      subtitle: Text(snapshot.data[index]['payment_note_statut']
                                  .toString() ==
                              '1'
                          ? 'Payé - ${date.toString()}'
                          : 'Non Payé - ${date.toString()}'),
                      leading: FaIcon(
                        FontAwesomeIcons.fileInvoice,
                        color: Colors.black,
                      ),
                      trailing: ElevatedButton.icon(
                        onPressed: () async {
                          final url =
                              '${Urls.baseUrl}panel/pdf-payments-note?pay-ref=${snapshot.data[index]['payment_note_ref']}';
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: primary,
                          size: 0,
                        ),
                        label: Text('Details'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(primary),
                        ),
                      ),
                      onTap: () async {
                        final url =
                            '${Urls.baseUrl}panel/pdf-payments-note?pay-ref=${snapshot.data[index]['payment_note_ref']}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
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
            }),
      ),
    );
  }
}
