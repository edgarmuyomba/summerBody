import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Map<String, String> parseDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String day = date.day.toString();
  String month = date.month.toString().padLeft(2, '0');
  String shortMonth = {
    '01': 'Jan',
    '02': 'Feb',
    '03': 'Mar',
    '04': 'Apr',
    '05': 'May',
    '06': 'Jun',
    '07': 'Jul',
    '08': 'Aug',
    '09': 'Sep',
    '10': 'Oct',
    '11': 'Nov',
    '12': 'Dec',
  }[month]!;
  return {'date': day, 'month': shortMonth};
}

Widget workoutWidget(Map<String, dynamic> workout) {
  Map<String, dynamic>? latestEntry = workout["entries"][0];

  Map<String, dynamic> parsedDate = parseDate(latestEntry?["date"]);

  // make clickable to edit
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
              "${latestEntry?["weight"]}Kg, ${latestEntry?["reps"] * latestEntry?["sets"]} reps",
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
              // delete the workout
            },
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ))
      ],
    ),
  );
}
