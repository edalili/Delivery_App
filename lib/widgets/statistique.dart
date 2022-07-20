import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'package:sebbar_app/theme/constant.dart';
import 'package:sebbar_app/theme/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chart extends StatefulWidget {
  Chart({Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  var id;
  var name;
  Future<String?> getpre() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString('user_id').toString();
    name = pref.getString('username').toString();
    if (id != null) {
      setState(() {
        id = pref.getString('user_id').toString();
        name = pref.getString('username').toString();
      });
      return id + name;
    }
  }

  var cnt = 0;
  getparcellivre() async {
    var response = await http.post(
        Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/count_parcels'),
        body: ({'id': id.toString()}));
    if (response.statusCode == 200) {
      setState(() {
        cnt = jsonDecode(response.body.toString());
      });
      return cnt;
    }
  }

  @override
  void initState() {
    getparcellivre();
    getpre();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Map<String, double>();
    data['Livré'] = cnt.toDouble();
    data['Distribution'] = 0;
    data['Reporte'] = 0;
    data['Annuler'] = 0;
    data['Autre'] = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
        actions: [
          IconButton(
            onPressed: () async {
              await getparcellivre();
            },
            icon: Icon(
              Icons.refresh,
              size: 35,
            ),
          ),
        ],
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
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 18,
              ),
              Expanded(
                child: Text(
                  name.toString(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  DateTime.now().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: PieChart(
                  dataMap: data,
                  chartRadius: MediaQuery.of(context).size.width / 1.8,
                  legendOptions:
                      LegendOptions(legendPosition: LegendPosition.bottom),
                  chartValuesOptions: ChartValuesOptions(
                    decimalPlaces: 0,
                    chartValueStyle:
                        TextStyle(fontSize: 20, color: Colors.black),
                    chartValueBackgroundColor: Colors.transparent,
                  ),
                  emptyColor: Colors.grey,
                  animationDuration: Duration(seconds: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
