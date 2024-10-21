import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
              letterSpacing: -0.24,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, size: 20, color: Colors.black),
              SizedBox(width: 5),
              Icon(Icons.wifi, size: 20, color: Colors.black),
              SizedBox(width: 5),
              Icon(Icons.battery_full, size: 20, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}
