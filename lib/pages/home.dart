// ignore_for_file: sort_child_properties_last

import 'dart:async';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:face_recognition/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../include/navbar.dart';
import '../model/setstate.dart';
import '../model/user.dart';
import '../widget/connectivity.dart';
import 'dashboard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() {
    return _Home();
  }
}

class _Home extends State {
  final user = FirebaseAuth.instance.currentUser!;

  StreamSubscription? internetconnection;
  bool isoffline = false;

  @override
  void initState() {
    super.initState();
    getID();
    getRecord();
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isoffline = false;
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    internetconnection!.cancel();
    //cancel internent connection subscription after you are done
  }

  void getID() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: user.email)
        .get();

    setState(() {
      UserDetails.id = snap.docs[0].id;
    });
  }

  void getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Users")
          .where('email', isEqualTo: user.email)
          .get();
      // print(snap.docs[0].id);

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection('Users')
          .doc(snap.docs[0].id)
          .get();

      // print(snap2['name']);

      setState(() {
        UserDetails.name = snap2['name'];
        UserDetails.email = snap2['email'];
        UserDetails.card = snap2['card'];
        UserDetails.role = snap2['role'];
      });
      // ignore: empty_catches
    } catch (e) {}

    // print(checkIn);
    // print(checkOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bottomsheet();
        },
        child: const Icon(Icons.add),
      ),
      drawer: const Navbar(),
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      bottomNavigationBar: isoffline
          ? SizedBox(
              height: 50,
              child: BottomAppBar(
                elevation: 0,
                child: Center(
                  child: Container(
                    child: snack("You are currently Offline", isoffline),
                  ),
                ),
              ),
            )
          : const SizedBox(),
      body: Column(
        children: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.all(10),
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text('--> Complete Registration'),
            ),
          ),
        ],
      ),
      // use SizedBox to contrain the AppMenu to a fixed width
    );
  }

  Future bottomsheet() async {
    showAdaptiveActionSheet(
      context: context,
      title: const Text('Establishment and Section'),
      androidBorderRadius: 20,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: const Text(
              'Establishment',
              style: TextStyle(
                  fontSize: 18, color: Colors.black, fontFamily: "NexaBold"),
            ),
            onPressed: (context) {
              Navigator.of(context).pop(false);
            }),
        BottomSheetAction(
            title: const Text(
              'Section',
              style: TextStyle(
                  fontSize: 18, color: Colors.black, fontFamily: "NexaBold"),
            ),
            onPressed: (context) {
              Navigator.of(context).pop(false);
            }),
      ],
      // cancelAction: CancelAction(
      //     title: const Text(
      //   'CANCEL',
      //   style: TextStyle(fontSize: 18, fontFamily: "NexaBold"),
      // )), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }
}
