import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';

class Workout extends StatefulWidget {
  final int workoutId;
  const Workout({super.key, required this.workoutId});

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String workoutName = "";

  bool firstEntryValid = false;
  bool secondEntryEnabled = false;

  bool loading = false;

  final form = FormGroup({
    "name": FormControl<String>(validators: [Validators.required]),
    "weight1": FormControl<String>(validators: [Validators.required]),
    "reps1": FormControl<String>(validators: [Validators.required]),
    "weight2": FormControl<String?>(),
    "reps2": FormControl<String?>(),
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ScheduleBloc>();
    bloc.add(LoadWorkout(workoutId: widget.workoutId));

    return Scaffold(
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
              loading = false;

              workoutName = state.workout.name;

              form.control('name').value = state.workout.name;
              form.control('weight1').value =
                  state.entries[0].weight1.toString();
              form.control('reps1').value = state.entries[0].reps1.toString();
              form.control('weight2').value =
                  state.entries[0].weight2?.toString();
              form.control('reps2').value = state.entries[0].reps2?.toString();

              if (form.control('weight2').value != null &&
                  form.control('weight2').value != "" &&
                  form.control('reps2').value != null &&
                  form.control('reps2').value != "") {
                firstEntryValid = true;
                secondEntryEnabled = true;
              }
            });
          }
        },
        builder: (context, state) {
          if (state is WorkoutReady) {
            return Padding(
              padding: EdgeInsets.all(16.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                  setState(() {
                                    loading = true;
                                  });

                                  // edit the workout
                                  bloc.add(EditWorkout(
                                    workoutId: widget.workoutId,
                                    workoutName: form.control("name").value,
                                    weight1: int.parse(
                                        form.control("weight1").value),
                                    reps1:
                                        int.parse(form.control("reps1").value),
                                    weight2:
                                        form.control("weight2").value != null
                                            ? int.parse(
                                                form.control("weight2").value)
                                            : null,
                                    reps2: form.control("reps2").value != null
                                        ? int.parse(form.control("reps2").value)
                                        : null,
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: Center(
                                  child: loading
                                      ? SpinKitFadingCircle(
                                          color: Colors.white,
                                          size: 20.0.h,
                                        )
                                      : const Text(
                                          "Edit",
                                        ),
                                ),
                              );
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
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
