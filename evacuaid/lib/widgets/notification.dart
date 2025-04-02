import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String date;
  const NotificationWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {

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
                "Your report has been sent.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
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
