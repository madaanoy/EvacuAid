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
                const Text(
                  'Family Members',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Last Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'First Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Contact No.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: const [
                  DataRow(
                    cells: [
                      DataCell(
                        Text('Daanoy', style: TextStyle(color: Colors.red)),
                      ),
                      DataCell(
                        Text(
                          'Michael Angelo',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      DataCell(
                        Text(
                          '09498014593',
                          style: TextStyle(color: Colors.red),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BlguNavbar(1),
    );
  }
}