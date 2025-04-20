import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evacuaid/widgets/CustomDropDown.dart';
import 'package:evacuaid/widgets/backappbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
  List<Map<String, dynamic>> family = [];
  List famMembers = [];
  String? familyId;

  final _lastnameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _zoneController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _birthdayController = TextEditingController();
  String? _selectedFamilyType;
  DateTime? _birthday;
  final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );

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

  Future<void> _addFamilyMember() async {
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

      CollectionReference brgyMembers = FirebaseFirestore.instance.collection(
        'brgyMembers',
      );

      DocumentReference brgyMembersRef = await brgyMembers.add({
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastnameController.text.trim(),
        "contactNumber": _contactNumberController.text.trim(),
        "zone": int.parse(_zoneController.text.trim()),
        "memberType": _selectedFamilyType,
        "birthday": _birthday,
        "isHead": false,
        "dateRegistered": DateTime.now(),
      });

      FirebaseFirestore.instance.collection("families").doc(familyId).update({
        "members": FieldValue.arrayUnion([brgyMembersRef.id]),
      });

      setState(() {});
    } catch (e) {}
  }

  Future<List<Map<String, dynamic>>> fetchFamMembers() async {
    QuerySnapshot familiesSnapshot =
        await FirebaseFirestore.instance.collection('families').get();
    QuerySnapshot brgyMembersSnapshot =
        await FirebaseFirestore.instance.collection('brgyMembers').get();

    famMembers = [];
    brgyMembers.clear();
    families.clear();
    family.clear();

    famMembers.add(widget.id);

    for (var doc in brgyMembersSnapshot.docs) {
      brgyMembers.add({'id': doc.id, ...doc.data() as Map<String, dynamic>});
    }

    for (var doc in familiesSnapshot.docs) {
      if (doc['head'] == widget.id) {
        familyId = doc.id;
        for (var member in doc['members']) {
          famMembers.add(member);
        }
      }
    }

    for (var famMember in famMembers) {
      for (var brgyMember in brgyMembers) {
        if (famMember == brgyMember['id']) {
          family.add({'id': brgyMember['id'], ...brgyMember});
        }
      }
    }
    return family;
  }

  @override
  Widget build(BuildContext context) {
    fetchFamMembers();
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
                          future: fetchFamMembers(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            final data = snapshot.data!;
                            return Container(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Expanded(
                                child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap:
                                              () => {
                                                // context.go(
                                                //   '/familyMembers/' +
                                                //       snapshot.data!.docs[index]
                                                //           .data()['id'],
                                                // ),
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
                                                    data[index]['firstName']
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
