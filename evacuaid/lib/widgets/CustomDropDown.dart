import 'dart:collection';
import 'package:flutter/material.dart';

// const List<String> list = <String>['Add Camp Manager'];

class CustomDropDown extends StatefulWidget {
  final List<String> list;
  final String hint;
  const CustomDropDown({super.key, required this.list, required this.hint});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _CustomDropDownState extends State<CustomDropDown> {

  @override
  Widget build(BuildContext context) {
  String dropdownValue = "Select Family Type";
  final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    widget.list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
    return DropdownMenu<String>(
      expandedInsets: EdgeInsets.zero,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
        ),
      ),
      onSelected: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: menuEntries,
    );
  }
}
