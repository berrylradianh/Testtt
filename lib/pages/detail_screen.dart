import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/biodata.dart';
import 'package:flutter_application_1/sql_helper.dart';
import 'package:sqflite/sqflite.dart';

class DetailScreen extends StatelessWidget {
  final int id;
  final int nim;
  final String nama;
  final String address;
  final String gender;

  static const appTitle = 'Home';

  const DetailScreen(
      {super.key,
      required this.id,
      required this.nim,
      required this.nama,
      required this.address,
      required this.gender});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Biodata Detail Page"),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 135, right: 100, top: 80),
              child: Icon(
                Icons.person,
                size: 150,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 135, right: 100, top: 20),
                child: Text(
                  nim.toString(),
                )),
            Container(
              margin: const EdgeInsets.only(left: 135, right: 100, top: 20),
              child: Text(nama),
            ),
            Container(
              margin: const EdgeInsets.only(left: 135, right: 100, top: 20),
              child: Text(address),
            ),
            Container(
              margin: const EdgeInsets.only(left: 135, right: 100, top: 20),
              child: Text(
                  gender.toString() == 'male' ? 'Laki - Laki' : 'Perempuan'),
            ),
            // button that goes to previous page
            Container(
              margin: const EdgeInsets.only(left: 135, right: 100, top: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
