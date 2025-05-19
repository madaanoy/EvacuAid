import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evacuaid/auth/firebase_auth_service.dart';
import 'package:evacuaid/widgets/CampManagerNavbar.dart';
import 'package:evacuaid/widgets/piechart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/blgunavbar.dart';
import '../widgets/mainappbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  final _authService = FirebaseAuthService();
  User? user;

  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> brgyMembers = [];
  Map<String, dynamic> userDetails = {};

  int count = 0;
  int adultCount = 0;
  int infantCount = 0;
  int childrenCount = 0;
  int seniorCount = 0;
  int pregnantCount = 0;
  int lactatingCount = 0;
  int pwdCount = 0;
  int wIllnessCount = 0;

  Future<void> getUserDetails() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var doc in snapshot.docs) {
      if (doc['email'] == await user?.email) {
        userDetails = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        break;
      }
    }
    await getBrgyMembers();
    getSummary();
  }

  Future<void> getBrgyMembers() async {
    brgyMembers.clear();
    QuerySnapshot brgyMembersSnapshot =
        await FirebaseFirestore.instance.collection('brgyMembers').get();

    if (userDetails['role'] == "blgu_user") {
      for (var doc in brgyMembersSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['evacuee']) {
          brgyMembers.add({'id': doc.id, ...doc.data() as Map<String, dynamic>});
        }
      }
    } else {
      for (var doc in brgyMembersSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['evacCenter'] == userDetails['evacCenter']) {
          brgyMembers.add({'id': doc.id, ...doc.data() as Map<String, dynamic>});
        }
      }
    }
  }

  String getAge(timeStamp) {
    DateTime now = DateTime.now();
    DateTime birthDate = timeStamp.toDate();

    int age = now.year - birthDate.year;
    String type = "adult";

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    if (age < 1) {
      return "infant";
    } else if (age >= 1 && age < 18) {
      return "children";
    } else if (age >= 18 && age < 60) {
      return "adult";
    }
    return "senior";
  }

  void getSummary() {
    setState(() {
      
      count = brgyMembers.length;
      wIllnessCount =
          brgyMembers.where((member) => member['wIllness'] == true).length;
      pwdCount = brgyMembers.where((member) => member['pwd'] == true).length;
      lactatingCount =
          brgyMembers.where((member) => member['lactating'] == true).length;
      pregnantCount =
          brgyMembers.where((member) => member['pregnant'] == true).length;
      infantCount =
          brgyMembers
              .where((member) => getAge(member['birthday']) == "infant")
              .length;
      childrenCount =
          brgyMembers
              .where((member) => getAge(member['birthday']) == "children")
              .length;
      adultCount =
          brgyMembers
              .where((member) => getAge(member['birthday']) == "adult")
              .length;
      seniorCount =
          brgyMembers
              .where((member) => getAge(member['birthday']) == "senior")
              .length;
      print("pregnant: " + pregnantCount.toString());
      print("lactating: " + lactatingCount.toString());
      print("pwd: " + pwdCount.toString());
      print("wIlness: " + wIllnessCount.toString());
      print("adult: " + adultCount.toString());
      print("infant: " + infantCount.toString());
      print("children: " + childrenCount.toString());
      print("senior: " + seniorCount.toString());
    });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Evacuees: ${count}',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 250,
                  width: 250,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: infantCount.toDouble(),
                          color: Colors.blue, // corrected 'Color' to 'color'
                        ),
                        PieChartSectionData(
                          value: childrenCount.toDouble(),
                          color: Colors.red, // corrected 'Color' to 'color'
                        ),
                        PieChartSectionData(
                          value: adultCount.toDouble(),
                          color: Colors.green, // corrected 'Color' to 'color'
                        ),
                        PieChartSectionData(
                          value: seniorCount.toDouble(),
                          color: Colors.yellow, // corrected 'Color' to 'color'
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 80),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Legend:', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.blue,
                            margin: const EdgeInsets.only(right: 8),
                          ),
                          const Text('Infant'),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.red,
                            margin: const EdgeInsets.only(right: 8),
                          ),
                          const Text('Children'),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.green,
                            margin: const EdgeInsets.only(right: 8),
                          ),
                          const Text('Adult'),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.yellow,
                            margin: const EdgeInsets.only(right: 8),
                          ),
                          const Text('Senior Citizen'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'Other details',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "Pregnant",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Lactating",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "PWD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "W/ Illness",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                        ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        pregnantCount.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      lactatingCount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      pwdCount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      wIllnessCount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Evacuees: ${count}',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 250,
                  width: 250,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: infantCount.toDouble(),
                          color: Colors.blue, // corrected 'Color' to 'color'
                        ),
                        PieChartSectionData(
                          value: childrenCount.toDouble(),
                          color: Colors.red, // corrected 'Color' to 'color'
                        ),
                        PieChartSectionData(
                          value: adultCount.toDouble(),
                          color: Colors.green, // corrected 'Color' to 'color'
                        ),
                        PieChartSectionData(
                          value: seniorCount.toDouble(),
                          color: Colors.yellow, // corrected 'Color' to 'color'
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 80),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Legend:', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.blue,
                            margin: const EdgeInsets.only(right: 8),
                          ),
                          const Text('Infant'),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.red,
                            margin: const EdgeInsets.only(right: 8),
                          ),
                          const Text('Children'),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.green,
                            margin: const EdgeInsets.only(right: 8),
                          ),
                          const Text('Adult'),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.yellow,
                            margin: const EdgeInsets.only(right: 8),
                          ),
                          const Text('Senior Citizen'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'Other details',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "Pregnant",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Lactating",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "PWD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "W/ Illness",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                        ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        pregnantCount.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      lactatingCount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      pwdCount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      wIllnessCount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CampManagerNavbar(0),
    );
  }
}
