import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leading: IconButton(
        //     onPressed: () {
        //       bloc.add(SetDay(day: bloc.selectDay!));
        //       context.pop();
        //     },
        //     icon: const Icon(Icons.arrow_back)),
        title: Text(
          "Timer",
          style: GoogleFonts.monda(
              fontSize: 24.sp,
              color: Colors.black87,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
