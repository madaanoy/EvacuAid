import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evacuaid/auth/firebase_auth_service.dart';
import 'package:evacuaid/widgets/CampManagerNavbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/blgunavbar.dart';
import '../widgets/mainappbar.dart';

class BlguSummary extends StatefulWidget {
  const BlguSummary({super.key});

  @override
  State<BlguSummary> createState() => _BlguSummaryState();
}

class _BlguSummaryState extends State<BlguSummary> {
  final _authService = FirebaseAuthService();
  User? user;

  List<Map<String, dynamic>> users = [];
  Map<String, dynamic> userDetails = {};

  Future<void> getUserDetails() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var doc in snapshot.docs) {
      if (doc['email'] == await user?.email) {
        userDetails = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        break;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    try {
      user = _authService.currentUser;
      getUserDetails();
    } catch (e) {
      print(
        "--------------------------------------------------------------------------------",
      );
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userDetails['role'] == "blgu_user") {
      return Scaffold(
      appBar: MainAppBar(),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              _authService.signOut(context);
            },
            child: Text("logout blgu"),
          ),
          TextButton(
            onPressed: () => getUserDetails(),
            child: Text('click me'),
          ),
        ],
      ),
      bottomNavigationBar: const BlguNavbar(0),
    );
    }
    return Scaffold(
      appBar: MainAppBar(),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              _authService.signOut(context);
            },
            child: Text("logout camp manager"),
          ),
          TextButton(
            onPressed: () => getUserDetails(),
            child: Text('click me'),
          ),
        ],
      ),
      bottomNavigationBar: const CampManagerNavbar(0),
    );
  }
}
