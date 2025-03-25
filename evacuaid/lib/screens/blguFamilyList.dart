/* Authored by: Michael Angelo M. Daanoy
Company: Patent Pending
Project: EvacuAid
Feature: [EVA-063] [DEV] Family List Screen
Description: Screen for showing the family head and their members.
 */

import 'package:flutter/material.dart';
import '../widgets/blgunavbar.dart';
import '../widgets/mainappbar.dart';

class BlguFamilyList extends StatelessWidget {
  const BlguFamilyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Family Members',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'EVACU',
                        style: TextStyle(
                          color: Color.fromRGBO(4, 56, 209, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'AID',
                        style: TextStyle(
                          color: Color.fromRGBO(209, 4, 56, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    DataTable(
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Last Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'First Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Contact No.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      rows: const [
                        DataRow(
                          cells: [
                            DataCell(
                              Text(
                                'Daanoy',
                                style: TextStyle(color: Color.fromARGB(255, 73, 180, 69)),
                              ),
                            ),
                            DataCell(
                              Text(
                                'Michael Angelo',
                                style: TextStyle(color: Color.fromARGB(255, 73, 180, 69)),
                              ),
                            ),
                            DataCell(
                              Text(
                                '09498014593',
                                style: TextStyle(color: Color.fromARGB(255, 73, 180, 69)),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Daanoy')),
                            DataCell(Text('Juana')),
                            DataCell(Text('09498014593')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Daanoy')),
                            DataCell(Text('Michael Angelo')),
                            DataCell(Text('09498014593')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BlguNavbar(1),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFamilyMemberDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to show the overlay
  void _showAddFamilyMemberDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes it full-screen height if needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                16.0, // Adjust for keyboard
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Family Member',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Last Name Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // First Name Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Contact Number Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contact No.',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // This is where you'll handle saving data later
                      Navigator.pop(context);
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
}
