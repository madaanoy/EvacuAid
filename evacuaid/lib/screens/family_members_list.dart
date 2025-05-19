/* Authored by: Raymund Joseph M. Rosco
Company: Patent Pending
Project: EvacuAid
Feature: [EVA-70] [DEV] Family Members Screen
Description: As a user, I want to be able to view the members of each family and it’s family head as 
well as their zone and contact number. It should also have a clickable button to ‘Add a Family Member.’
*/

import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:evacuaid/auth/firebase_auth_service.dart';
import 'package:evacuaid/widgets/CustomDropDown.dart';
import 'package:evacuaid/widgets/backappbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/blgunavbar.dart';

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

class BlguFamilyMembersList extends StatefulWidget {
  final id;
  // const BlguFamilyMembersList({super.key});
  const BlguFamilyMembersList({super.key, required this.id});

  @override
  State<BlguFamilyMembersList> createState() => _BlguFamilyMembersListState();
}

class _BlguFamilyMembersListState extends State<BlguFamilyMembersList> {
  bool start = true;

  List<Map<String, dynamic>> brgyMembers = [];
  List<Map<String, dynamic>> families = [];

  // v1
  // List<Map<String, dynamic>> family = [];
  
  // v2
  late Future<List<Map<String, dynamic>>> family;

  List famMembers = [];
  String? familyId;
  String? headId;
  bool? pregnant = false;
  bool? lactating = false;
  bool? wIllness = false;
  bool? pwd = false;

  final _lastnameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _zoneController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _authService= FirebaseAuthService();

  Map<String, dynamic> userDetails = {};
  User? user;
  String? _selectedFamilyType;
  String? _selectedSex;
  DateTime? _birthday;
  final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  final List<MenuEntry> sex = UnmodifiableListView<MenuEntry>(
    list1.map<MenuEntry>((String name) => MenuEntry(value: name, label: name))
  );

  @override
  void initState() {
    super.initState();
    user = _authService.currentUser;
    getUserDetails();
    family = fetchFamMembers();
  }

  @override
  void dispose() {
    _lastnameController.dispose();
    _firstNameController.dispose();
    _contactNumberController.dispose();
    _birthdayController.dispose();
    _birthday = null;
    _selectedFamilyType = null;
    _selectedSex = null;
    super.dispose();
  }

  Future<void> showDeleteModal(id) async {
    try {
      await showDialog(
        context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete the whole family?"),
          content: Text("You are deleting the family and family members in the system. Are you sure?"),
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
                _deleteFamily(id);
                updateFamily();
                Navigator.of(context).pop();
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

  Future<void> _deleteFamily(id) async {
    try {
      
      QuerySnapshot familiesSnapshot = await FirebaseFirestore.instance.collection('families').get();
      List members = [];
      String famId = '';

      for (var doc in familiesSnapshot.docs) {
        if (doc['members'].contains(id)) {
          members = doc['members'];
          famId = doc.id;
        }
      }

      for (var member in members) {
        await FirebaseFirestore.instance.collection('brgyMembers').doc(member).delete();
      }

      await FirebaseFirestore.instance.collection('families').doc(famId).delete();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> _deleteMember(isHead, id) async {
  try {
    if (isHead) {
      await showDialog(
        context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cannot remove family head."),
          content: Text("Please click 'Delete Family Button' instead to delete whole family."),
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
    } else {
      
      QuerySnapshot familiesSnapshot = await FirebaseFirestore.instance.collection('families').get();
      List members = [];
      String famId = '';

      for (var doc in familiesSnapshot.docs) {
        if (doc['members'].contains(id)) {
          members = doc['members'];
          print(members);
          members.remove(id);
          famId = doc.id;
        }
      }

      await FirebaseFirestore.instance.collection('families').doc(famId).update({
        "members":members
      });
      await FirebaseFirestore.instance.collection('brgyMembers').doc(id).delete();

      print('Document successfully deleted!');
    }
  } catch (e) {
    print('Error deleting document: $e');
  }
}

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
    setState(() {
      
    });
  }

  void refresh() {
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> fetchFamMembers() async {
    // v2
    List<Map<String, dynamic>> familyList = [];

    QuerySnapshot familiesSnapshot =
        await FirebaseFirestore.instance.collection('families').get();
    QuerySnapshot brgyMembersSnapshot =
        await FirebaseFirestore.instance.collection('brgyMembers').get();

    await Future.delayed(Duration(seconds: 2));
    famMembers = [];
    brgyMembers.clear();
    families.clear();
    // v1
    // family.clear();

    headId = widget.id;

    for (var doc in brgyMembersSnapshot.docs) {
      brgyMembers.add({'id': doc.id, ...doc.data() as Map<String, dynamic>});
    }

    print ('--------------------------brgyMembers-------------------------');
    print(brgyMembers);

    for (var doc in familiesSnapshot.docs) {
      if (doc['members'].contains(widget.id)) {
        familyId = doc.id;
        print ('--------------------------docMembers-------------------------');
        print(doc['members']);
        for (var member in doc['members']) {
          famMembers.add(member);
        }
      }
    }

    print ('--------------------------famMembers-------------------------');
    print (famMembers);

    for (var famMember in famMembers) {
      for (var brgyMember in brgyMembers) {
        if (famMember == brgyMember['id']) {
          // v1
          // family.add({'id': brgyMember['id'], ...brgyMember});

          // v2
          familyList.add({'id': brgyMember['id'], ...brgyMember});
        }
      }
    }

    // v1
    // return family;

    // v2
    print('----------FamilyList-----------');
    print(familyList);
    return familyList;
  }

  // v2
  void updateFamily () {
    setState(() {
      family = fetchFamMembers();
    });
  }

  Future<DocumentSnapshot> fetchFamMember(String id) async {
    DocumentSnapshot famMember = await FirebaseFirestore.instance.collection('brgyMembers').doc(id).get();
    return famMember;
  }

  Future<void> _addFamilyMember() async {
    try {
      print(_birthday);
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
        "isHead": false,
        "dateRegistered": DateTime.now(),
        "evacuee": false,
        "pregnant": pregnant,
        "lactating": lactating,
        "pwd": pwd,
        "wIllness": wIllness,
        "barangay": userDetails['barangay'],
        "municipality": userDetails['municipality'],
      });

      FirebaseFirestore.instance.collection("families").doc(familyId).update({
        "members": FieldValue.arrayUnion([brgyMembersRef.id]),
      });
      updateFamily();
      setState(() {});
    } catch (e) {}
  }

  Future<void> _updateFamMember (DocumentSnapshot data, bool? updateHead, String selectedMember) async {
    QuerySnapshot familiesSnapshot =
        await FirebaseFirestore.instance.collection('families').get();
    QuerySnapshot brgyMembersSnapshot =
        await FirebaseFirestore.instance.collection('brgyMembers').get();

    // Update the head of the family in the families collection in firebase
    // Update the isHead value of the in the brgyMembers collection in firebase
    if (updateHead != null && updateHead) {
      List newFamMembers = [];

      for (var member in famMembers) {
        newFamMembers.add(member);
      }

      // Update isHead value of Old Family Head
      FirebaseFirestore.instance.collection('brgyMembers').doc(headId).update({
        "isHead": false,
      });

      headId = selectedMember;
      
      // Check if head is updated
      print('New Head: $headId');

      // Update isHead value of New Family Head
      await FirebaseFirestore.instance.collection('brgyMembers').doc(headId).update({
        "isHead": true,
      });
    }

    print("Birthday");
    print(Timestamp.fromDate(DateTime.parse(_birthdayController.value.text)));

    // Update the other values in the brgyMembers collection in firebase
    await FirebaseFirestore.instance.collection('brgyMembers').doc(selectedMember).update({
        "birthday": Timestamp.fromDate(DateTime.parse(_birthdayController.value.text)),
        "contactNumber": _contactNumberController.text.trim(),
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastnameController.text.trim(),
        "memberType": _selectedFamilyType,
        "zone": _zoneController.text.trim(),
        "barangay": userDetails['barangay'],
        "municipality": userDetails['municipality'],
        "sex": _selectedSex,
        "pregnant": pregnant,
        "pwd": pwd,
        "lactating": lactating,
        "wIllness": wIllness
      });

      setState(() {
        
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family Members',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                  'Legend:',
                  style: TextStyle(fontSize: 16, ),
                ),
                SizedBox(width: 16),
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: Theme.of(context).colorScheme.tertiary,
                              margin: const EdgeInsets.only(right: 8),
                            ),
                            const Text('Family Head'),
                          ],
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                              margin: const EdgeInsets.only(right: 8),
                            ),
                            const Text('Family Member'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
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
                              flex: 2,
                              child: Container(
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Contact No.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          // future: family,
                          future: fetchFamMembers(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            final data = snapshot.data!;
                            return Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Expanded(
                                child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    print(family);
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () => _showEditFamilyMemberDialog(context, data[index]['id']),
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
                                                    data[index]['lastName']
                                                        .toString() + ', ' + data[index]['firstName']
                                                        .toString(),
                                                    style: TextStyle(
                                                      color:
                                                          data[index]['isHead']
                                                              ? Theme.of(
                                                                    context,
                                                                  )
                                                                  .colorScheme
                                                                  .tertiary
                                                              : Theme.of(
                                                                    context,
                                                                  )
                                                                  .colorScheme
                                                                  .onSurface,
                                                      fontWeight:
                                                          data[index]['isHead']
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    data[index]['zone']
                                                        .toString(),
                                                    style: TextStyle(
                                                      color:
                                                          data[index]['isHead']
                                                              ? Color(
                                                                0xFF49B445,
                                                              )
                                                              : Colors.black,
                                                      fontWeight:
                                                          data[index]['isHead']
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    data[index]['contactNumber']
                                                        .toString(),
                                                    style: TextStyle(
                                                      color:
                                                          data[index]['isHead']
                                                              ? Color(
                                                                0xFF49B445,
                                                              )
                                                              : Colors.black,
                                                      fontWeight:
                                                          data[index]['isHead']
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                    ),
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
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(
                //     12,
                //   ), // Ensure clipping to round corners
                //   child:
                //   SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: DataTable(
                //       columnSpacing: 24,
                //       dataRowHeight: 48,
                //       headingRowHeight: 48,
                //       headingRowColor: WidgetStateProperty.resolveWith(
                //         (states) => const Color.fromARGB(255, 4, 55, 209),
                //       ),
                //       columns: const [
                //         DataColumn(label: CenteredHeaderText('Last Name')),
                //         DataColumn(label: CenteredHeaderText('First Name')),
                //         DataColumn(label: CenteredHeaderText('Contact No.')),
                //       ],
                //       rows: [
                //         _buildDataRow(
                //           'Daanoy',
                //           'Michael Angelo',
                //           '09498014593',
                //           isHead: true,
                //         ),
                //         _buildDataRow('Daanoy', 'Juana', '0929401593'),
                //         _buildDataRow('Daanoy', 'Kevin', '...'),
                //         _buildDataRow('Daanoy', 'Erin', '...'),
                //         _buildDataRow('Daanoy', 'Angelo', '...'),
                //       ],
                //     ),
                //   ),
                // ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                              () => {
                                showDeleteModal(widget.id)
                              },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            "Delete family",
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                              () => {_showAddFamilyMemberDialog(context)},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            "Add family member",
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
          ],
        ),
      ),
      bottomNavigationBar: const BlguNavbar(1),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).colorScheme.tertiary,
      //   onPressed: () => _showAddFamilyMemberDialog(context, _birthday),
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  DataRow _buildDataRow(
    String lastName,
    String firstName,
    String contactNo, {
    bool isHead = false,
  }) {
    final textColor = isHead ? const Color(0xFF49B445) : Colors.black;
    final fontWeight = isHead ? FontWeight.bold : FontWeight.normal;

    return DataRow(
      cells: [
        DataCell(CenteredText(lastName, textColor, fontWeight)),
        DataCell(CenteredText(firstName, textColor, fontWeight)),
        DataCell(CenteredText(contactNo, textColor, fontWeight)),
      ],
    );
  }

  void _showAddFamilyMemberDialog(BuildContext context) {
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
                'Add Family Member',
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
                      _birthday = await dateTime;
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
              SizedBox(height: 8,),
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
                        () => {_addFamilyMember(), Navigator.pop(context)},
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

  void _showEditFamilyMemberDialog(BuildContext context, String id) async {
    DocumentSnapshot famMember = await fetchFamMember(id);
    int milliseconds = int.parse(famMember['birthday'].toString().substring(18,28)) * 1000;
    DateTime bdayDateTime = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    var outputDate = DateFormat('yyyy-MM-dd');
    String bday = outputDate.format(bdayDateTime);
    bool? changeToHead = false;

    _firstNameController.value = _firstNameController.value.copyWith(text: famMember['firstName']);
    _lastnameController.value = _firstNameController.value.copyWith(text: famMember['lastName']);
    _zoneController.value = _firstNameController.value.copyWith(text: famMember['zone'].toString());
    _contactNumberController.value = _firstNameController.value.copyWith(text: famMember['contactNumber']);
    _birthdayController.value = _firstNameController.value.copyWith(text: bday);
    _selectedFamilyType = famMember['memberType'];
    _selectedSex = famMember['sex'];
    pregnant = famMember['pregnant'];
    lactating = famMember['lactating'];
    pwd = famMember['pwd'];
    wIllness = famMember['wIllness'];

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
                'Update Family Member Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInputField('First Name', _firstNameController),
              _buildInputField('Last Name', _lastnameController, ),
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
                      _birthday = await dateTime;
                      print(_birthday);
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
                initialSelection: _selectedFamilyType,
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
                initialSelection: _selectedSex,
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
              SizedBox(height: 8,),
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
              Divider(
                color: Theme.of(context).colorScheme.onSurface,
                thickness: 1,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
                      child: SizedBox(
                        width: 24,
                        child: StatefulBuilder(builder: (context, setState) {
                          return Checkbox(
                            value: changeToHead,
                            onChanged: (value) {
                          setState(() {
                            changeToHead=value;
                            print(changeToHead);
                          });
                        });
                        })
                      ),
                    ),
                    Text(
                      "Assign as NEW Family Head?",
                      style: TextStyle(
                        fontSize: 16
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                        onPressed: () async {
                          await _deleteMember(famMember['isHead'], id);
                          updateFamily();
                          Navigator.pop(context);
                        },
                        child: const Text('Delete',
                        style: TextStyle(color: Color(0xffff3333)),
                      )),
                      const SizedBox(width: 8),
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
                            ()  async {
                              await _updateFamMember(famMember, changeToHead, id);
                              updateFamily();
                              Navigator.pop(context);
                            },
                        child: const Text('Update'),
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
