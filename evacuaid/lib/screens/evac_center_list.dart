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

class BlguEvacCenterList extends StatefulWidget {
  const BlguEvacCenterList({super.key});

  @override
  State<BlguEvacCenterList> createState() => _BlguEvacCenterListState();
}

class _BlguEvacCenterListState extends State<BlguEvacCenterList> {
  final _nameController = TextEditingController();
  final _zoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _zoneCMController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = FirebaseAuthService();
  int? _campManagerIndex;
  String? _campManager;
  String? _campManagerID;
  String? campManagerName;

  final _formKey = GlobalKey<FormState>();

  List<String> campManagerNames = <String>[];
  List<Map<String, dynamic>> campManagers = [];
  List<MenuEntry> menuEntries = [];

  Future<void> fetchCampManagers() async {
    Future.delayed(Duration(seconds: 2));
    QuerySnapshot campManagerSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    campManagers.clear();
    menuEntries.clear();

    for (var doc in campManagerSnapshot.docs) {
      if ((doc['role']) == "camp_manager_user") {
        if (doc['assigned'] == false) {
          campManagers.add({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          });
          campManagerNames.add(doc['firstName'] + ' ' + doc['lastName']);
        }
      }
    }

    setState(() {
      menuEntries =
          campManagers
              .map<MenuEntry>(
                (e) => MenuEntry(
                  value: e['id'],
                  label: e['firstName'] + ' ' + e['lastName'],
                ),
              )
              .toList();
    });
  }

  Future<String> getCampManagerName(cmId) async {
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(cmId).get();
    return doc['firstName'] + ' ' + doc['lastName'];
  }

  @override
  void initState() {
    super.initState();
    fetchCampManagers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _zoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _campManager = null;
    _campManagerIndex = 0;
    super.dispose();
  }

  Future<void> _addEvacCenter() async {
    try {
      if (_nameController.text.isEmpty ||
          _zoneController.text.isEmpty ||
          _campManagerID == null) {
        _dialogBuilder(context);
        throw 'Please fill in all fields';
      }
      CollectionReference evacCenter = FirebaseFirestore.instance.collection(
        'evacCenter',
      );
      // DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_campManager).get();

      DocumentReference evacCenterRef = await evacCenter.add({
        "name": _nameController.text.trim(),
        "zone": int.parse(_zoneController.text.trim()),
        "campManager": _campManagerID,
        "dateRegistered": DateTime.now(),
      });

      FirebaseFirestore.instance.collection("users").doc(_campManager).update({
        "assigned": true,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateEvacCenter(id) async {
    try {
      if (_nameController.text.isEmpty ||
          _zoneController.text.isEmpty ||
          _campManager == null) {
        _dialogBuilder(context);
        throw 'Please fill in all fields';
      }
      await FirebaseFirestore.instance.collection('evacCenter').doc(id).update({
        "name": _nameController.text.trim(),
        "zone": _zoneController.text.trim(),
        "campManager": _campManagerID
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addCampManager() async {
    try {
      if (_firstNameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _zoneCMController.text.isEmpty ||
          _contactNumberController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        _dialogBuilder(context);
        throw 'Please fill in all fields';
      }

      CollectionReference campManagerCRef = FirebaseFirestore.instance
          .collection('users');

      await _authService.registerCampManagerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      DocumentReference campManagerRef = await campManagerCRef.add({
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "zone": int.parse(_zoneCMController.text.trim()),
        "contactNumber": _contactNumberController.text.trim(),
        "dateRegistered": DateTime.now(),
        "assigned": false,
        "role": "camp_manager_user",
      });

      fetchCampManagers();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteEvacCenter(id, userID) async {
    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      'assigned': false
    });

    await FirebaseFirestore.instance.collection('evacCenter').doc(id).delete();

    setState(() {
      
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        appBar: MainAppBar(),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Evacuation Centers',
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
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Camp Manager",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
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
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future:
                            FirebaseFirestore.instance
                                .collection("evacCenter")
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
                                  '----------------------------------------------------------------------',
                                );
                                print(snapshot.data!.docs[index].data());
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap:
                                          () => {
                                            showEditEvacCenterDialog(context, snapshot.data!.docs[index].id)
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
                                                    .data()['name'],
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
                                            Expanded(
                                              flex: 2,
                                              // edit here
                                              child: FutureBuilder(
                                                future:
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                              .data()['campManager'],
                                                        )
                                                        .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return Text(
                                                      "There is no data",
                                                    );
                                                  }
                                                  return Text(
                                                    snapshot.data!['firstName'] +
                                                        ' ' +
                                                        snapshot
                                                            .data!['lastName'],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 18),
                                  ],
                                );
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
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: () => {showAddEvacCenterDialog(context)},
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          "Add Evac. Center",
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BlguNavbar(2),
      );
      // signed in
    } else {
      return Scaffold(
        appBar: MainAppBar(),
        body: Text("Please login"),
        bottomNavigationBar: const BlguNavbar(2),
      );
    }
  }

  void showAddEvacCenterDialog(BuildContext context) async {
    await fetchCampManagers;

    _nameController.clear();
    _zoneController.clear();
    Future.delayed(Duration(seconds: 2));
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
                'Add Evacuation Center',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField('Name', _nameController),
                    _buildInputField('Zone', _zoneController),
                  ],
                ),
              ),
              DropdownMenu<String>(
                initialSelection: null,
                enabled: campManagerNames.isEmpty ? false : true,
                hintText:
                    campManagerNames.isEmpty
                        ? 'Please add a Camp Manager first'
                        : 'Select Camp Manager',
                expandedInsets: EdgeInsets.zero,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor:
                      campManagerNames.isEmpty
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.surface,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  hintStyle: TextStyle(
                    color:
                        campManagerNames.isEmpty ? Colors.white : Colors.black,
                  ),
                ),
                onSelected: (String? name) {
                  setState(() {
                    _campManagerID = name;
                  });
                },
                dropdownMenuEntries: menuEntries,
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _addEvacCenter();
                        setState(() {});
                        Navigator.pop(context);
                      }
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

  Future<void> showDeleteModal(id, userID) async {
    try {
      await showDialog(
        context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete the evacuation center?"),
          content: Text("This will permanently delete it."),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                deleteEvacCenter(id, userID);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  void showEditEvacCenterDialog(BuildContext context, id) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('evacCenter').doc(id).get();
    Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
    DocumentSnapshot cmDocumentSnapshot = await FirebaseFirestore.instance.collection('users').doc(data?['campManager']).get();
    Map<String, dynamic>? cmData = cmDocumentSnapshot.data() as Map<String, dynamic>?;
    String cmName = cmData?['firstName'] + ' ' + cmData?['lastName'];
    QuerySnapshot campManagerSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<MenuEntry> newMenuEntries = List.from(menuEntries);

    newMenuEntries.add(
      MenuEntry(
      value: cmDocumentSnapshot.id,
      label: cmName));

    campManagerNames.clear();
    campManagerNames.add(cmName);

    for (var doc in campManagerSnapshot.docs) {
      print(doc);
      if ((doc['role']) == "camp_manager_user") {
        if (doc['assigned'] == false) {
          campManagers.add({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          });
          campManagerNames.add(doc['firstName'] + ' ' + doc['lastName']);
        }
      }
    }

    print(campManagerNames);

    setState(() {
      _nameController.value = _nameController.value.copyWith(text: data?['name']);
      _zoneController.value = _zoneController.value.copyWith(text: data?['zone'].toString());
      _campManager = cmName;
    });

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
                'Edit Evacuation Center',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField('Name', _nameController),
                    _buildInputField('Zone', _zoneController),
                  ],
                ),
              ),
              DropdownMenu<String>(
                initialSelection: null,
                enabled: campManagerNames.isEmpty ? false : true,
                hintText:
                    campManagerNames.isEmpty
                        ? 'Please add a Camp Manager first'
                        : _campManager,
                expandedInsets: EdgeInsets.zero,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor:
                      campManagerNames.isEmpty
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.surface,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  hintStyle: TextStyle(
                    color:
                        campManagerNames.isEmpty ? Colors.white : Colors.black,
                  ),
                ),
                onSelected: (String? name) {
                  setState(() {
                    _campManagerID = name;
                  });
                },
                dropdownMenuEntries: newMenuEntries,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                        onPressed: () async {
                          await showDeleteModal(id, data?['campManager']);
                        },
                        child: const Text('Delete',
                        style: TextStyle(color: Color(0xffff3333)),
                      )),
                      const SizedBox(width: 8),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _updateEvacCenter(id);
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save'),
                  ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // void showAddCampManagerDialog(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           left: 16.0,
  //           right: 16.0,
  //           top: 16.0,
  //           bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               'Add Camp Manager',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 16),
  //             Form(
  //               key: _formKey,
  //               child: Column(
  //                 children: [
  //                   _buildInputField('First Name', _firstNameController),
  //                   _buildInputField('Last Name', _lastNameController),
  //                   _buildInputField('Email', _emailController, isEmail: true),
  //                   _buildInputField(
  //                     'Password',
  //                     _passwordController,
  //                     isPassword: true,
  //                   ),
  //                   _buildInputField(
  //                     'Confirm Password',
  //                     _confirmPasswordController,
  //                     isPassword: true,
  //                   ),
  //                   _buildInputField('Phone Number', _contactNumberController),
  //                   _buildInputField('Zone', _zoneCMController),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: const Text('Cancel'),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     if (_formKey.currentState!.validate()) {
  //                       await _addCampManager();
  //                       Navigator.pop(context);
  //                     }
  //                   },
  //                   child: const Text('Save'),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool isPhone = false,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        obscureText: isPassword ? true : false,
        validator: (value) {
          if (isPassword) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
          }
          if (isEmail) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Enter a valid email';
            }
          }
          if (value == null || value.isEmpty) {
            return 'Please fill-up all fields.';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Complete all fields'),
          content: const Text(
            'Please fill-up all fields, you may have\n'
            'left some fields blank or have wrong inputs.',
          ),
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
