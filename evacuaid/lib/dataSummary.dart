import 'package:evacuaid/piechart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('EVACUAID')),
        body: SingleChildScrollView(
          // 👈 Wrap with scroll view to avoid overflow
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const MyDropdownButton(),
                  const SizedBox(height: 16),

                  // 👇 Fix: Add fixed height to avoid infinite size error
                  SizedBox(
                    height: 250,
                    child: MyPieChart(),
                  ),
                  const Text(
                    'Legend: ',
                    style: TextStyle(fontSize: 24.0),
                  ),
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
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Card(color: Colors.red),
                      ),
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
          ),
        ),
      ),
    );
  }
}

class MyDropdownButton extends StatefulWidget {
  const MyDropdownButton({super.key});

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text('Pie Chart'),
      value: _selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          _selectedValue = newValue;
        });
      },
      items: <String>['Pie Chart', 'Bar Graph']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
