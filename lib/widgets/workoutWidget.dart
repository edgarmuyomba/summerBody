import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/blocs/MuscleGroup/muscleGroup_bloc.dart';
import 'package:summerbody/routing/routes.dart';
import 'package:summerbody/utils/utilities.dart';

class WorkoutWidget extends StatelessWidget {
  final Map<String, dynamic> workout;
  final bool editable;
  final bool canDelete;
  const WorkoutWidget(
      {super.key,
      required this.workout,
      this.editable = true,
      this.canDelete = false});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? latestSet = workout["sets"][0];

    String setString = "${latestSet?["weight1"]}Kg/${latestSet?["reps1"]} reps";

    if (latestSet?["weight2"] != null) {
      setString += ", ${latestSet?["weight2"]}Kg/${latestSet?["reps2"]} reps";
    }

    Map<String, dynamic> parsedDate = Utilities.parseDate(latestSet?["date"]);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: IntrinsicHeight(
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
            Expanded(
              child: GestureDetector(
                onTap: !editable
                    ? null
                    : () {
                        if (workout["isSuggested"] == true) {
                          context.pushNamed(Routes.workoutDetails,
                              pathParameters: {
                                "workoutId": workout["id"].toString()
                              });
                        } else {
                          context.pushNamed(Routes.workout, pathParameters: {
                            "workoutId": workout["id"].toString(),
                            "triggerSetup": 'false'
                          });
                        }
                      },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        workout["name"],
                        maxLines: 2,
                        softWrap: true,
                        style: GoogleFonts.monda(
                            fontSize: 20.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      setString,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (canDelete) ...[
              IconButton(
                  onPressed: () {
                    context
                        .read<MuscleGroupBloc>()
                        .add(DeleteWorkout(workoutId: workout["id"]));
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ))
            ]
          ],
        ),
      ),
    );
  }
}
