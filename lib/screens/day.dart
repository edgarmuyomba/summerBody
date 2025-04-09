import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';

class Day extends StatefulWidget {
  const Day({super.key});

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
              fontSize: 24.sp,
              color: Colors.black87,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleReady) {
            return Padding(
              padding: EdgeInsets.all(16.0.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.chevron_left,
                          size: 50.sp,
                        ),
                        onTap: () {
                          context.read<ScheduleBloc>().add(SetDay(
                              day: getDay(state.currentDay, prev: true)));
                        },
                      ),
                      Column(
                        children: [
                          Text(
                            capitalize(state.currentDay),
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                          Text("Day of the week",
                              style: TextStyle(fontSize: 10.sp))
                        ],
                      ),
                      GestureDetector(
                        child: Icon(Icons.chevron_right, size: 50.sp),
                        onTap: () {
                          context
                              .read<ScheduleBloc>()
                              .add(SetDay(day: getDay(state.currentDay)));
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: const Divider(),
                  ),
                  if (state.musclegroup == null) ...[
                    Container(
                      width: double.infinity,
                      height: 75.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10.w),
                          const Text(
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

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  String getDay(String day, {bool prev = false}) {
    int intValue = 0;

    switch (day) {
      case "monday":
        intValue = 0;
        break;
      case "tuesday":
        intValue = 1;
        break;
      case "wednesday":
        intValue = 2;
        break;
      case "thursday":
        intValue = 3;
        break;
      case "friday":
        intValue = 4;
        break;
      case "saturday":
        intValue = 5;
        break;
      case "sunday":
        intValue = 6;
        break;
    }

    int req = prev ? intValue - 1 : intValue + 1;

    if (req < 0) {
      req = 6;
    } else if (req > 6) {
      req = 0;
    }

    switch (req) {
      case 0:
        return "monday";
      case 1:
        return "tuesday";
      case 2:
        return "wednesday";
      case 3:
        return "thursday";
      case 4:
        return "friday";
      case 5:
        return "saturday";
      case 6:
        return "sunday";
      default:
        return "monday";
    }
  }
}
