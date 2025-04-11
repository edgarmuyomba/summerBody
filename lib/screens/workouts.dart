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

  final form = FormGroup({
    "name": FormControl<String>(validators: [Validators.required]),
    "weight": FormControl<String>(validators: [Validators.required]),
    "sets": FormControl<String>(validators: [Validators.required]),
    "reps": FormControl<String>(validators: [Validators.required]),
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
                    });
                    if (newWorkout == false) {
                      form.control('name').reset();
                      form.control('weight').reset();
                      form.control('sets').reset();
                      form.control('reps').reset();
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3.5,
                                child: ReactiveTextField(
                                  formControlName: 'weight',
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
                                    form.control('weight').value =
                                        (control.value ?? 0).toString();
                                  },
                                  style: GoogleFonts.monda(
                                      fontSize: 20.sp, color: Colors.black87),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3.5,
                                child: ReactiveTextField(
                                  formControlName: 'sets',
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: "Sets",
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.0.w, vertical: 12.0.h),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onChanged: (control) {
                                    form.control('sets').value =
                                        (control.value ?? 0).toString();
                                  },
                                  style: GoogleFonts.monda(
                                      fontSize: 20.sp, color: Colors.black87),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3.5,
                                child: ReactiveTextField(
                                  formControlName: 'reps',
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
                                    form.control('reps').value =
                                        (control.value ?? 0).toString();
                                  },
                                  style: GoogleFonts.monda(
                                      fontSize: 20.sp, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          ReactiveFormConsumer(builder: (context, form, child) {
                            if (form.valid) {
                              return ElevatedButton(
                                  onPressed: () {
                                    context.read<ScheduleBloc>().add(AddWorkout(
                                        workoutName: form.control('name').value,
                                        weight: int.parse(
                                            form.control('weight').value),
                                        sets: int.parse(
                                            form.control('sets').value),
                                        reps: int.parse(
                                            form.control('reps').value)));
                                    setState(() {
                                      newWorkout = !newWorkout;
                                    });
                                    if (newWorkout == false) {
                                      form.control('name').reset();
                                      form.control('weight').reset();
                                      form.control('sets').reset();
                                      form.control('reps').reset();
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
                    "name": workout.name,
                    "entries": (state.entries[workout.id] ?? []).map((entry) {
                      return {
                        "weight": entry.weight,
                        "sets": entry.sets,
                        "reps": entry.reps,
                        "date": entry.date.toString()
                      };
                    }).toList()
                  };
                  return workoutWidget(workoutMap);
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
