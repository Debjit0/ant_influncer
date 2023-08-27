import 'package:ant_influncer/buttomnavbar/buttomNavBar.dart';
import 'package:ant_influncer/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/routers.dart';

class AddProgram extends StatefulWidget {
  const AddProgram({super.key});

  @override
  State<AddProgram> createState() => _AddProgramState();
}

class _AddProgramState extends State<AddProgram> {
  TextEditingController programNameController = TextEditingController();
  TextEditingController programDescController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Program"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: TextField(
                decoration: InputDecoration(
                  hintText: "Program Name",
                  hintStyle: TextStyle(color: Colors.white),
                ),
                controller: programNameController,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextField(
                decoration: InputDecoration(
                  hintText: "Program Description",
                  hintStyle: TextStyle(color: Colors.white),
                ),
                controller: programDescController,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  createProgram();
                },
                child: Text("Create!"))
          ],
        ),
      ),
    );
  }

  createProgram() {
    CollectionReference program =
        FirebaseFirestore.instance.collection('Programs');
    final data = {
      "program name": programNameController.text,
      "program description": programDescController.text,
      "uploader": FirebaseAuth.instance.currentUser!.uid
    };
    program
        .add(data)
        .whenComplete(() => nextPageOnly(context: context, page: NavBar()));
  }
}
