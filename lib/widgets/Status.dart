import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sebbar_app/theme/constant.dart';

class Status extends StatefulWidget {
  List data = [
    "Reporte",
    "Pas de reponse",
    "Injoignable",
    "Hors-Zone",
    "Annule",
    "Refuse",
    "Retour Par Amana",
    "Numero-Errone",
    "Deuxieme Appel",
    "Troisieme Appel"
  ];
  List lst = [];
  Status({required this.lst, Key? key}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

String? selectedvalue;
Timestamp? reportedDate;

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return RadioListTile(
              activeColor: primary,
              title: Text(widget.data[index].toString()),
              value: widget.lst[index]['parcel_statut_code'].toString(),
              groupValue: selectedvalue,
              onChanged: (newvalue) {
                setState(() {
                  selectedvalue = newvalue.toString();
                  if (selectedvalue.toString() == "POSTPONED") {
                    BottomPicker.date(
                            title: "Reporte date",
                            titleStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: primary,
                            ),
                            onSubmit: (index) {
                              DateTime date = DateTime.parse(index.toString());
                              reportedDate =
                                  Timestamp.fromMillisecondsSinceEpoch(
                                      date.millisecondsSinceEpoch);
                            },
                            bottomPickerTheme: BOTTOM_PICKER_THEME.blue)
                        .show(context);
                  }
                });
              });
        });
  }
}
