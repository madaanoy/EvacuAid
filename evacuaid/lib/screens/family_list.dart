/* Authored by: Raymund Joseph M. Rosco
Company: Patent Pending
Project: EvacuAid
Feature: [EVA-58] [DEV] Estalbish Evacuation Screen
Description: Ticket [EVA-42]'[UI] Establish Evaciation Screen' must be coded. 
This is where you can add evacuation centers or kabarangay shelters.
*/

import 'dart:collection';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:evacuaid/auth/firebase_auth_service.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evacuaid/widgets/CustomDropDown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/blgunavbar.dart';
import '../widgets/mainappbar.dart';

const List<String> list = <String>[
  'Select Family Type',
  'Grandfather',
  'Grandmother',
  'Father',
  'Mother',
  'Daughter',
  'Son',
  'N/a',
];

const List<String> list1 = <String>[
  'Select sex',
  'Male',
  'Female'
];

class BlguFamilyList extends StatefulWidget {
  const BlguFamilyList({super.key});

  @override
  State<BlguFamilyList> createState() => _BlguFamilyListState();
}

class _BlguFamilyListState extends State<BlguFamilyList> {
  final _lastnameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _zoneController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _birthdayController = TextEditingController();
  final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  final List<MenuEntry> sex = UnmodifiableListView<MenuEntry>(
    list1.map<MenuEntry>((String name) => MenuEntry(value: name, label: name))
  );

  final _authService = FirebaseAuthService();
  bool? authenticated;
  bool? pregnant = false;
  bool? lactating = false;
  bool? wIllness = false;
  bool? pwd = false;

  User? user;
  String? _selectedFamilyType;
  String? _selectedSex;
  DateTime? _birthday;
  String? id;

  List<Map<String, dynamic>> users = [];
  Map<String, dynamic> userDetails = {};

  Future<void> getUserDetails() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var doc in snapshot.docs) {
      if (doc['email'] == await user?.email) {
        userDetails = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        print(userDetails['barangay']);
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
      print("----------ERROR----------");
      print("error: $e");
    }
  }

  @override
  void dispose() {
    _lastnameController.dispose();
    _firstNameController.dispose();
    _contactNumberController.dispose();
    _birthdayController.dispose();
    _birthday = null;
    _selectedFamilyType = null;
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  Future<void> _addFamily() async {
    try {
      if (_firstNameController.text.isEmpty ||
          _lastnameController.text.isEmpty ||
          _contactNumberController.text.isEmpty ||
          _birthdayController.text.isEmpty ||
          _selectedFamilyType == null) {
        _dialogBuilder(
          context,
          'Complete all fields',
          'Please fill-up all fields, you may have\n left some fields blank or have wrong inputs.',
        );
        throw 'Please fill in all fields';
      }

      setState(() {});

      CollectionReference brgyMembers = FirebaseFirestore.instance.collection(
        'brgyMembers',
      );

      DocumentReference brgyMembersRef = await brgyMembers.add({
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastnameController.text.trim(),
        "contactNumber": _contactNumberController.text.trim(),
        "zone": int.parse(_zoneController.text.trim()),
        "memberType": _selectedFamilyType,
        "sex": _selectedSex,
        "birthday": _birthday,
        "isHead": true,
        "barangay": userDetails['barangay'],
        "municipality": userDetails['municipality'],
        "dateRegistered": DateTime.now(),
        "evacuee": false,
        "pregnant": pregnant,
        "lactating": lactating,
        "pwd": pwd,
        "wIllness": wIllness
      });

      FirebaseFirestore.instance.collection("families").add({
        "dateRegistered": DateTime.now(),
        "members": [brgyMembersRef.id],
      });

      id = brgyMembersRef.id;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (userDetails['role'] == "blgu_user") {
      return Scaffold(
        appBar: MainAppBar(),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Family Heads',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Text(
                          "Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Text(
                            "Zone",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future:
                            FirebaseFirestore.instance
                                .collection("brgyMembers")
                                .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData) {
                            return Text("There is no data");
                          }
                          return (Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                print(
                                  snapshot.data!.docs[index]
                                          .data()['barangay'] ==
                                      userDetails['barangay'],
                                );
                                if (snapshot.data!.docs[index]
                                            .data()['isHead'] ==
                                        true &&
                                    snapshot.data!.docs[index]
                                            .data()['barangay'] ==
                                        userDetails['barangay'] &&
                                    snapshot.data!.docs[index]
                                            .data()['municipality'] ==
                                        userDetails['municipality']) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap:
                                            () => {
                                              context.go(
                                                '/families/familyMembers/${snapshot.data!.docs[index].id}',
                                                // '/familyMembers',
                                              ),
                                            },
                                        child: Container(
                                          height: 36,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                          .data()['lastName'] +
                                                      ', ' +
                                                      snapshot.data!.docs[index]
                                                          .data()['firstName'],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      .data()['zone']
                                                      .toString(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 18),
                                    ],
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        () => {_showAddFamilyMemberDialog(context, _birthday)},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      "Add a new family",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BlguNavbar(1),
      );
      // signed in
    } else {
      return Scaffold(
        appBar: MainAppBar(),
        body: Text("Please login"),
        bottomNavigationBar: const BlguNavbar(1),
      );
    }
  }

  void _showAddFamilyMemberDialog(BuildContext context, DateTime? bday) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Family Head Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInputField('Last Name', _lastnameController),
              _buildInputField('First Name', _firstNameController),
              _buildInputField('Zone', _zoneController),
              _buildInputField(
                'Contact No.',
                _contactNumberController,
                isPhone: true,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  readOnly: true,
                  onTap: () async {
                    DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (dateTime != null) {
                      _birthday = dateTime;
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(dateTime);

                      setState(() {
                        _birthdayController.text = formattedDate;
                      });
                    }
                  },
                  controller: _birthdayController,
                  decoration: InputDecoration(
                    labelText: "Input Birthday",
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              DropdownMenu<String>(
                expandedInsets: EdgeInsets.zero,
                initialSelection: list.first,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                  ),
                ),
                onSelected: (String? value) {
                  setState(() {
                    _selectedFamilyType = value!;
                  });
                },
                dropdownMenuEntries: menuEntries,
              ),
              SizedBox(height: 8,),
              DropdownMenu<String>(
                expandedInsets: EdgeInsets.zero,
                initialSelection: list1.first,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                  ),
                ),
                onSelected: (String? value) {
                  setState(() {
                    _selectedSex = value!;
                  });
                },
                dropdownMenuEntries: sex,
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Select all that apply:", textAlign: TextAlign.start,),
              ),
              StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) { 

                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Checkbox(
                            value: pregnant,
                            onChanged: (bool? newVal) {
                              setState(() {
                                pregnant = newVal;
                              });
                            },
                          ),
                          Text("Pregnant"),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Checkbox(
                            value: lactating,
                            onChanged: (bool? newVal) {
                              setState(() {
                                pregnant = newVal;
                              });
                            },
                          ),
                          Text("Lactating"),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Checkbox(
                            value: pwd,
                            onChanged: (bool? newVal) {
                              setState(() {
                                pwd = newVal;
                              });
                            },
                          ),
                          Text("PWD"),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Checkbox(
                            value: wIllness,
                            onChanged: (bool? newVal) {
                              setState(() {
                                wIllness = newVal;
                              });
                            },
                          ),
                          Text("Ill"),
                        ],
                      ),
                    ),
                  ],
                );
                 },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed:
                        () => {
                          _addFamily(),
                          setState(() {}),
                          Navigator.pop(context),
                        },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please fill-up all fields.';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      ),
    );
  }

  Future<void> _dialogBuilder(
    BuildContext context,
    String title,
    String content,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CenteredHeaderText extends StatelessWidget {
  final String text;
  const CenteredHeaderText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class CenteredText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  const CenteredText(this.text, this.color, this.fontWeight, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontWeight: fontWeight, fontSize: 14),
    );
  }
}
