import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProgramDetails extends StatefulWidget {
  const ProgramDetails({super.key, this.id, this.progName});
  final String? id;
  final String? progName;
  @override
  State<ProgramDetails> createState() => _ProgramDetailsState();
}

class _ProgramDetailsState extends State<ProgramDetails> {
  String csv = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.progName.toString()),),

      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                pickCsv();
              },
              child: const Text("Upload CSV")),
          ElevatedButton(
              onPressed: () {
                exportCsv();
              },
              child: Text("Export")),
        ],
      ),
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
    CollectionReference leads = FirebaseFirestore.instance
        .collection('leads');
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
        "program":widget.id,
        "uploader":FirebaseAuth.instance.currentUser!.uid,
      };
      leads.add(record);
    }
  }
}