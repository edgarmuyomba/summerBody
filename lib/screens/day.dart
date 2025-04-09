import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Day extends StatefulWidget {
  final String currentDay;
  const Day({super.key, required this.currentDay});

  @override
  State<Day> createState() => _DayState();
}

class _DayState extends State<Day> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Summer Body"),
      ),
      body: Column(
        children: [
          Text(widget.currentDay)
        ],
      ),
    );
  }
}
