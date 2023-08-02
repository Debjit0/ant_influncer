import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Login Screen/login_screen.dart';
import '../utils/routers.dart';

class CheckVerify extends StatefulWidget {
  const CheckVerify({super.key});

  @override
  State<CheckVerify> createState() => _CheckVerifyState();
}

class _CheckVerifyState extends State<CheckVerify> {
  String accType = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccType();
  }

  @override
  Widget build(BuildContext context) {
    return
    accType=='influncer'?
    Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Wait until u get verified",
          style: TextStyle(color: Colors.white),
        ),
        ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              nextPageOnly(context: context, page: LoginScreen());
            },
            child: Text("Logout")),
      ],
    ),):
    Scaffold(
      body: Center(child: Text("Download the $accType app")),
    );
  }

  Future getAccType() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    accType = document['accounttype'];
    print(accType);
  }
}
