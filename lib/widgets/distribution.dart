import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sebbar_app/theme/constant.dart';
import 'package:sebbar_app/theme/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Distribution extends StatefulWidget {
  Distribution({Key? key}) : super(key: key);

  @override
  _DistributionState createState() => _DistributionState();
}

class _DistributionState extends State<Distribution> {
  var id;
  Future<String?> getidd() async {
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
    getidd();
    getpdf();
    super.initState();
  }

  Future getpdf() async {
    var response = await http.post(
        Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/GetDistibution'),
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
        title: Text('Bons De Distribution'),
        centerTitle: true,
        backgroundColor: primarylight,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: getpdf(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(
                            snapshot.data[index]['distribution_note_time']
                                .toString()) *
                        1000);
                    return ListTile(
                      title: Text(
                        snapshot.data[index]['distribution_note_ref'],
                      ),
                      subtitle: Text(date.toString()),
                      leading: FaIcon(
                        FontAwesomeIcons.fileInvoice,
                        color: Colors.black,
                      ),
                      trailing: ElevatedButton.icon(
                        onPressed: () async {
                          final url =
                              '${Urls.baseUrl}panel/pdf-distribution-note?dis-ref=${snapshot.data[index]['distribution_note_ref']}';
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
                            '${Urls.baseUrl}panel/pdf-distribution-note?dis-ref=${snapshot.data[index]['distribution_note_ref']}';
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
