import 'dart:collection';
import 'package:flutter/material.dart';

const List<String> list = <String>['Add Camp Manager'];

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({super.key});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _CustomDropDownState extends State<CustomDropDown> {
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
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
      hintText: dropdownValue,
      onSelected: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: menuEntries,
    );
  }
}
