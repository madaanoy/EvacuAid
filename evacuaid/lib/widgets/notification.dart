import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String receiver;
  final String date;
  const NotificationWidget({super.key, required this.receiver, required this.date});

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (receiver == "MSWDO") {
        return Theme.of(context).colorScheme.primary;
      } else if (receiver == "BLGU") {
        return Theme.of(context).colorScheme.secondary;
      }

      return Colors.black;
    }

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your report has been sent to the $receiver.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: getColor(),
                ),
              ),
              Text("Sent on $date"),
            ],
          ),
          IconButton(
            iconSize: 24,
            icon: const Icon(Icons.close),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
