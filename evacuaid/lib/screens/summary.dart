

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evacuaid/auth/firebase_auth_service.dart';
import 'package:evacuaid/widgets/CampManagerNavbar.dart';
import 'package:evacuaid/widgets/piechart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/blgunavbar.dart';
import '../widgets/mainappbar.dart';
import 'package:fl_chart/fl_chart.dart';

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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // TextButton(
              //   onPressed: () {
              //     _authService.signOut(context);
              //   },
              //   child: Text("logout blgu"),
              // ),
              // TextButton(
              //   onPressed: () => getUserDetails(),
              //   child: Text('click me'),
              // ),
              SizedBox(height: 250, child: MyPieChart()),
              const Text('Legend: ', style: TextStyle(fontSize: 24.0)),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Adult'),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Card(color: Colors.blue),
                  ),
                  Text('Children'),
                  SizedBox(width: 30, height: 30, child: Card(color: Colors.red)),
                  Text('Infant'),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Card(color: Colors.green),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Senior'),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Card(color: Colors.yellow),
                  ),
                  Text('Pregnant'),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Card(color: Color(0xff62eeff)),
                  ),
                  Text('Lactating'),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Card(color: Colors.orange),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('PWD'),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Card(color: Colors.purple),
                  ),
                  Text('With illness'),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Card(color: Color(0xffff91b6)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: const BlguNavbar(0),
      );
    }
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // TextButton(
            //   onPressed: () {
            //     _authService.signOut(context);
            //   },
            //   child: Text("logout camp manager"),
            // ),
            // TextButton(
            //   onPressed: () => {print("User Details:"), getUserDetails()},
            //   child: Text('click me'),
            // ),
            // 👇 Fix: Add fixed height to avoid infinite size error
            SizedBox(height: 250, child: MyPieChart()),
            const Text('Legend: ', style: TextStyle(fontSize: 24.0)),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Adult'),
                SizedBox(width: 30, height: 30, child: Card(color: Colors.blue)),
                Text('Children'),
                SizedBox(width: 30, height: 30, child: Card(color: Colors.red)),
                Text('Infant'),
                SizedBox(width: 30, height: 30, child: Card(color: Colors.green)),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Senior'),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Card(color: Colors.yellow),
                ),
                Text('Pregnant'),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Card(color: Color(0xff62eeff)),
                ),
                Text('Lactating'),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Card(color: Colors.orange),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('PWD'),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Card(color: Colors.purple),
                ),
                Text('With illness'),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Card(color: Color(0xffff91b6)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Submitted');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Send Report'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CampManagerNavbar(0),
    );
  }
}
