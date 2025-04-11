import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Workouts extends StatefulWidget {
  final String muscleGroupName;
  const Workouts({super.key, required this.muscleGroupName});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  List<Map<String, dynamic>> workouts = [
    {
      "name": "Bench Press",
      "entries": [
        {
          "weight": 15,
          "sets": 7,
          "reps": 15,
          "date": "2025-04-11 21:23:44.376237"
        }
      ]
    }
  ];

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
                                    form.control('weight').value = int.parse(
                                        (control.value ?? 0).toString());
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
                                    form.control('sets').value = int.parse(
                                        (control.value ?? 0).toString());
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
                                    form.control('reps').value = int.parse(
                                        (control.value ?? 0).toString());
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
                                    // save the workout
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
                ...workouts.map((entry) => workoutWidget(entry))
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

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

    return Row(
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
    );
  }
}
