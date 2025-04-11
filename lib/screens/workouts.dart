import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';

class Workouts extends StatefulWidget {
  const Workouts({super.key});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  List<Map<String, dynamic>> workouts = [
    {
      "name": "Bench Press",
      "entries": [
        {"weight": 15, "sets": 8, "reps": 100}
      ]
    }
  ];

  bool newWorkout = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (BuildContext context, state) {
      if (state is ScheduleReady) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 75.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black87),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 10.w),
                    const Text(
                      "Add Muscle Group",
                      style: TextStyle(color: Colors.black87),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget entryWidget(Map<String, dynamic> entry) {
    return Container();
  }
}
