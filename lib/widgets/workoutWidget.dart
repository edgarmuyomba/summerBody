import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';
import 'package:summerbody/utils/utilities.dart';

class WorkoutWidget extends StatelessWidget {
  final Map<String, dynamic> workout;
  const WorkoutWidget({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? latestEntry = workout["entries"][0];

    String entryString =
        "${latestEntry?["weight1"]}Kg/${latestEntry?["reps1"]} reps";

    if (latestEntry?["weight2"] != null) {
      entryString +=
          ", ${latestEntry?["weight2"]}Kg/${latestEntry?["reps2"]} reps";
    }

    Map<String, dynamic> parsedDate = Utilities.parseDate(latestEntry?["date"]);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        children: [
          Container(
            height: 75,
            width: 70,
            decoration: const BoxDecoration(color: Colors.black87),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    parsedDate["date"],
                    style: GoogleFonts.monda(
                        fontSize: 24.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    parsedDate["month"],
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workout["name"],
                style: GoogleFonts.monda(
                    fontSize: 20.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                entryString,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          IconButton(
              onPressed: () {
                context
                    .read<ScheduleBloc>()
                    .add(DeleteWorkout(workoutId: workout["id"]));
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ))
        ],
      ),
    );
  }
}
