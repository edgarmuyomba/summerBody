import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';

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
        title: Text(
          "Summer Body",
          style: GoogleFonts.monda(
              fontSize: 24, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleReady) {
            return Padding(
              padding: EdgeInsets.all(16.0.h),
              child: Column(
                children: [
                  if (state.musclegroup == null) ...[
                    Container(
                      width: double.infinity,
                      height: 75.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            "Add Muscle Group",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )
                  ]
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
