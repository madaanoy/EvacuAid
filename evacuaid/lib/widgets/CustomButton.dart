import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final String route;
  final VoidCallback customFunction;
  const CustomButton({super.key, required this.buttonText, this.route="", required this.customFunction,});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => {
            if (route != "") {
              context.go(route)
            } else {
              customFunction()
            }
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)
            ),
          ),
          child: Text(
            '$buttonText',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.onPrimary)
            ),
          ),
      ),
    );
  }
}