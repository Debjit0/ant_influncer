import 'dart:io';

import 'package:ant_influncer/add%20program/addprogram.dart';
import 'package:ant_influncer/utils/routers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  String csv = "";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hompage"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                pickCsv();
              },
              child: Text("Upload CSV")),
          ElevatedButton(
              onPressed: () {
                exportCsv();
              },
              child: Text("Export")),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){nextPage(context: context, page: AddProgram());}, child: Icon(Icons.add),) ,
    );
  }

  Future<void> pickCsv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      if (file.existsSync()) {
        csv = await file.readAsString();
        setState(() {});
      } else {
        print('File does not exist');
      }
    } else {
      print('No file picked');
    }
  }

  exportCsv() async {
    CollectionReference leads = FirebaseFirestore.instance.collection('leads').doc(FirebaseAuth.instance.currentUser!.uid).collection('leads');
    final myData = csv;
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    List<List<dynamic>> data = [];
    data = csvTable;
    print(data.length);
    for (int i = 1; i < data.length; i++) {
      var record = {
        "name": data[i][0],
        "email": data[i][1],
        "phone": data[i][2],
      };
      leads.add(record);
    }
  }
}
