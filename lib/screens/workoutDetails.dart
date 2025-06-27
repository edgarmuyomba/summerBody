import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';

class WorkoutDetails extends StatefulWidget {
  final int workoutId;
  const WorkoutDetails({super.key, required this.workoutId});

  @override
  State<WorkoutDetails> createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  String workoutName = "";
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ScheduleBloc>();
    bloc.add(LoadWorkout(workoutId: widget.workoutId));

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          bloc.add(SetDay(day: bloc.selectDay!));
          context.pop();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  bloc.add(SetDay(day: bloc.selectDay!));
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back)),
            title: Text(
              workoutName,
              style: GoogleFonts.monda(
                  fontSize: 24.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocConsumer<ScheduleBloc, ScheduleState>(
            listener: (context, state) {
              if (state is WorkoutReady) {
                setState(() {
                  workoutName = state.workout.name!;
                });
              }
            },
            builder: (context, state) {
              if (state is WorkoutReady) {
                return Padding(
                    padding: EdgeInsets.all(16.0.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.fitness_center,
                              color: Colors.black87,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            if ((state.workout.equipment ?? []).isEmpty) ...[
                              Text(
                                "No Equipment",
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.black87),
                              ),
                            ] else ...[
                              Text(
                                state.workout.equipment!.join(", "),
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.black87),
                              ),
                            ]
                          ],
                        )
                      ],
                    ));
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
