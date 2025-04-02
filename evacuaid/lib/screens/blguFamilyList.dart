import 'package:flutter/material.dart';
import '../widgets/blgunavbar.dart';
import '../widgets/mainappbar.dart';

class BlguFamilyList extends StatelessWidget {
  const BlguFamilyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
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
            const SizedBox(height: 10),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Ensure clipping to round corners
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 24,
                      dataRowHeight: 48,
                      headingRowHeight: 48,
                      headingRowColor: WidgetStateProperty.resolveWith(
                        (states) => const Color.fromARGB(255, 4, 55, 209),
                      ),
                      columns: const [
                        DataColumn(label: CenteredHeaderText('Last Name')),
                        DataColumn(label: CenteredHeaderText('First Name')),
                        DataColumn(label: CenteredHeaderText('Contact No.')),
                      ],
                      rows: [
                        _buildDataRow(
                          'Daanoy',
                          'Michael Angelo',
                          '09498014593',
                          isHead: true,
                        ),
                        _buildDataRow('Daanoy', 'Juana', '0929401593'),
                        _buildDataRow('Daanoy', 'Kevin', '...'),
                        _buildDataRow('Daanoy', 'Erin', '...'),
                        _buildDataRow('Daanoy', 'Angelo', '...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Legend',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: const Color.fromARGB(255, 73, 180, 69),
                  margin: const EdgeInsets.only(right: 8),
                ),
                const Text('Family Head'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BlguNavbar(1),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFamilyMemberDialog(context),
        child: const Icon(Icons.add),
      ),
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
              _buildInputField('Last Name'),
              _buildInputField('First Name'),
              _buildInputField('Contact No.', isPhone: true),
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
                    onPressed: () => Navigator.pop(context),
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

  Widget _buildInputField(String label, {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      ),
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
