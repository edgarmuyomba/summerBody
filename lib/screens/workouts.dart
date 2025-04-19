import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:summerbody/widgets/workoutWidget.dart';

class Workouts extends StatefulWidget {
  final String muscleGroupName;
  const Workouts({super.key, required this.muscleGroupName});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  bool newWorkout = false;
  bool firstEntryValid = false;
  bool secondEntryEnabled = false;

  final form = FormGroup({
    "name": FormControl<String>(validators: [Validators.required]),
    "weight1": FormControl<String>(validators: [Validators.required]),
    "reps1": FormControl<String>(validators: [Validators.required]),
    "weight2": FormControl<String>(),
    "reps2": FormControl<String>(),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "${widget.muscleGroupName} Workouts",
          style: GoogleFonts.monda(
              fontSize: 24.sp,
              color: Colors.black87,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (BuildContext context, state) {
        if (state is ScheduleReady) {
          return Padding(
            padding: EdgeInsets.all(16.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      newWorkout = !newWorkout;
                      secondEntryEnabled = false;
                      firstEntryValid = false;
                    });
                    if (newWorkout == false) {
                      form.control('name').reset();
                      form.control('weight1').reset();
                      form.control('reps1').reset();
                      form.control('weight2').reset();
                      form.control('reps2').reset();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87, width: 2.0),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!newWorkout) ...[
                          const Icon(
                            Icons.add,
                            color: Colors.black87,
                          ),
                          SizedBox(width: 10.w)
                        ],
                        Text(
                          newWorkout ? "Cancel" : "Add Workout",
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: const Divider(),
                ),
                if (newWorkout) ...[
                  ReactiveForm(
                      formGroup: form,
                      child: Column(
                        children: [
                          ReactiveTextField(
                            formControlName: 'name',
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  'This field is required.',
                            },
                            decoration: InputDecoration(
                                hintText: "Workout Name",
                                fillColor: Colors.grey[100],
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0.w, vertical: 12.0.h),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(5))),
                            onChanged: (control) {
                              form.control('name').value = control.value;
                            },
                            style: GoogleFonts.monda(
                              fontSize: 20.sp,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment:
                                firstEntryValid && !secondEntryEnabled
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    (firstEntryValid && !secondEntryEnabled
                                        ? 2.75
                                        : 2.2),
                                child: ReactiveTextField(
                                  formControlName: 'weight1',
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: "Weight",
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.0.w, vertical: 12.0.h),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onChanged: (control) {
                                    form.control('weight1').value =
                                        (control.value ?? 0).toString();
                                    if (form.control('weight1').valid &&
                                        form.control('reps1').valid) {
                                      setState(() {
                                        firstEntryValid = true;
                                      });
                                    }
                                  },
                                  style: GoogleFonts.monda(
                                      fontSize: 20.sp, color: Colors.black87),
                                ),
                              ),
                              if (firstEntryValid && !secondEntryEnabled) ...[
                                SizedBox(width: 10.w),
                              ],
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    (firstEntryValid && !secondEntryEnabled
                                        ? 2.75
                                        : 2.2),
                                child: ReactiveTextField(
                                  formControlName: 'reps1',
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: "Reps",
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.0.w, vertical: 12.0.h),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onChanged: (control) {
                                    form.control('reps1').value =
                                        (control.value ?? 0).toString();
                                    if (form.control('weight1').valid &&
                                        form.control('reps1').valid) {
                                      setState(() {
                                        firstEntryValid = true;
                                      });
                                    }
                                  },
                                  style: GoogleFonts.monda(
                                      fontSize: 20.sp, color: Colors.black87),
                                ),
                              ),
                              if (firstEntryValid && !secondEntryEnabled) ...[
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        secondEntryEnabled = true;
                                      });
                                    },
                                    child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ]
                            ],
                          ),
                          if (secondEntryEnabled) ...[
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.75,
                                  child: ReactiveTextField(
                                    formControlName: 'weight2',
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "Weight",
                                        fillColor: Colors.grey[100],
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.0.w,
                                            vertical: 12.0.h),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onChanged: (control) {
                                      form.control('weight2').value =
                                          (control.value ?? 0).toString();
                                    },
                                    style: GoogleFonts.monda(
                                        fontSize: 20.sp, color: Colors.black87),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.75,
                                  child: ReactiveTextField(
                                    formControlName: 'reps2',
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "Reps",
                                        fillColor: Colors.grey[100],
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.0.w,
                                            vertical: 12.0.h),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onChanged: (control) {
                                      form.control('reps2').value =
                                          (control.value ?? 0).toString();
                                    },
                                    style: GoogleFonts.monda(
                                        fontSize: 20.sp, color: Colors.black87),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        secondEntryEnabled = false;
                                        form.control('weight2').reset();
                                        form.control('reps2').reset();
                                      });
                                    },
                                    child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                          SizedBox(height: 10.h),
                          ReactiveFormConsumer(builder: (context, form, child) {
                            if (form.valid) {
                              return ElevatedButton(
                                  onPressed: () {
                                    context.read<ScheduleBloc>().add(AddWorkout(
                                        workoutName: form.control('name').value,
                                        weight1: int.parse(
                                            form.control('weight1').value),
                                        reps1: int.parse(
                                            form.control('reps1').value),
                                        weight2: int.parse(
                                            form.control('weight2').value),
                                        reps2: int.parse(
                                            form.control('reps2').value)));
                                    setState(() {
                                      newWorkout = !newWorkout;
                                    });
                                    if (newWorkout == false) {
                                      form.control('name').reset();
                                      form.control('weight1').reset();
                                      form.control('reps1').reset();
                                      form.control('weight2').reset();
                                      form.control('reps2').reset();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Save",
                                      ),
                                    ],
                                  ));
                            } else {
                              return const SizedBox.shrink();
                            }
                          })
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.all(8.0.h),
                    child: const Divider(),
                  ),
                ],
                ...state.workouts.map((workout) {
                  Map<String, dynamic> workoutMap = {
                    "id": workout.id,
                    "name": workout.name,
                    "entries": (state.entries[workout.id] ?? []).map((entry) {
                      return {
                        "weight1": entry.weight1,
                        "reps1": entry.reps1,
                        "weight2": entry.weight2,
                        "reps2": entry.reps2,
                        "date": entry.date.toString()
                      };
                    }).toList()
                  };
                  return WorkoutWidget(workout: workoutMap);
                })
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
