import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController textController;
  const CustomTextInput({super.key, required this.textController,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: textController,
        style: TextStyle(fontSize: 16, height: 3),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          isCollapsed: true,
          hintText: 'Input here...',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.surfaceContainerLow),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainer,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface)
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.outline
            )
          )
        ),
      ),
    );
  }
}