import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:summerbody/database/tables/WorkoutPreset.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';
import 'package:summerbody/widgets/workoutWidget.dart';

class Workouts extends StatefulWidget {
  final String muscleGroupName;
  final LocalDatabaseService _localDatabaseService;
  Workouts(
      {super.key,
      required this.muscleGroupName,
      LocalDatabaseService? localDatabaseService})
      : _localDatabaseService = localDatabaseService ??
            DIService().locator.get<LocalDatabaseService>();

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  bool newWorkout = false;
  bool firstSetValid = false;
  bool secondSetEnabled = false;

  final form = FormGroup({
    "name": FormControl<String>(validators: [Validators.required]),
    "date": FormControl<DateTime>(value: DateTime.now()),
    "weight1": FormControl<String>(validators: [Validators.required]),
    "reps1": FormControl<String>(validators: [Validators.required]),
    "weight2": FormControl<String?>(),
    "reps2": FormControl<String?>(),
  });

  late FocusNode nameFocusNode;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    nameFocusNode.addListener(() {
      setState(() {}); // rebuild on focus change
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    super.dispose();
  }

  Stream<List<WorkoutPreset>>? _presetStream;

  void _searchPresets(String input) {
    if (input.isNotEmpty) {
      setState(() {
        _presetStream =
            widget._localDatabaseService.searchWorkoutPresets(input);
      });
    } else {
      _presetStream = null;
    }
  }

  Future<void> _selectDate(BuildContext context, FormGroup form) async {
    DateTime initialDate = DateTime.now();
    if (form.control('date').value != null) {
      initialDate = form.control('date').value;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            dialogBackgroundColor: Colors.white,
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: Colors.white,
            ),
            colorScheme: const ColorScheme.light(
              primary: Colors.black87,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      form.control('date').value = pickedDate;
    }
  }

  WorkoutPreset? selectedWorkout;

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        newWorkout = !newWorkout;
                        secondSetEnabled = false;
                        firstSetValid = false;
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      ReactiveTextField(
                                        focusNode: nameFocusNode,
                                        formControlName: 'name',
                                        validationMessages: {
                                          ValidationMessage.required: (error) =>
                                              'This field is required.',
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Workout Name",
                                            fillColor: Colors.grey[100],
                                            filled: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16.0.w,
                                                    vertical: 12.0.h),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        onChanged: (control) {
                                          form.control('name').value =
                                              control.value;

                                          _searchPresets(
                                              (control.value as String?) ?? "");
                                        },
                                        style: GoogleFonts.monda(
                                          fontSize: 20.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (_presetStream != null &&
                                          nameFocusNode.hasFocus) ...[
                                        StreamBuilder<List<WorkoutPreset>>(
                                          stream: _presetStream,
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            final results = snapshot.data!;
                                            if (results.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10.0.h),
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxHeight: 0.4 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          offset: Offset(2, 4),
                                                          blurRadius: 4,
                                                          spreadRadius: 0.5,
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      itemCount: results.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final preset =
                                                            results[index];
                                                        return ListTile(
                                                          title: Text(
                                                            preset.name!,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                          onTap: () {
                                                            form
                                                                    .control('name')
                                                                    .value =
                                                                preset.name;
                                                            setState(() {
                                                              selectedWorkout =
                                                                  preset;
                                                            });
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                GestureDetector(
                                  onTap: () => _selectDate(context, form),
                                  child: Container(
                                    height: 50.h,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment:
                                  firstSetValid && !secondSetEnabled
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      (firstSetValid && !secondSetEnabled
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
                                            horizontal: 16.0.w,
                                            vertical: 12.0.h),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onChanged: (control) {
                                      form.control('weight1').value =
                                          (control.value ?? 0).toString();
                                    },
                                    onEditingComplete: (control) {
                                      if (form.control('weight1').valid &&
                                          form.control('reps1').valid) {
                                        setState(() {
                                          firstSetValid = true;
                                        });
                                      }
                                    },
                                    onTapOutside: (control) {
                                      if (form.control('weight1').valid &&
                                          form.control('reps1').valid) {
                                        setState(() {
                                          firstSetValid = true;
                                        });
                                      }
                                    },
                                    style: GoogleFonts.monda(
                                        fontSize: 20.sp, color: Colors.black87),
                                  ),
                                ),
                                if (firstSetValid && !secondSetEnabled) ...[
                                  SizedBox(width: 10.w),
                                ],
                                SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      (firstSetValid && !secondSetEnabled
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
                                            horizontal: 16.0.w,
                                            vertical: 12.0.h),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onChanged: (control) {
                                      form.control('reps1').value =
                                          (control.value ?? 0).toString();
                                    },
                                    onEditingComplete: (control) {
                                      if (form.control('weight1').valid &&
                                          form.control('reps1').valid) {
                                        setState(() {
                                          firstSetValid = true;
                                        });
                                      }
                                    },
                                    onTapOutside: (control) {
                                      if (form.control('weight1').valid &&
                                          form.control('reps1').valid) {
                                        setState(() {
                                          firstSetValid = true;
                                        });
                                      }
                                    },
                                    style: GoogleFonts.monda(
                                        fontSize: 20.sp, color: Colors.black87),
                                  ),
                                ),
                                if (firstSetValid && !secondSetEnabled) ...[
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          secondSetEnabled = true;
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
                            if (secondSetEnabled) ...[
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        2.75,
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
                                          fontSize: 20.sp,
                                          color: Colors.black87),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        2.75,
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
                                          fontSize: 20.sp,
                                          color: Colors.black87),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          secondSetEnabled = false;
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
                            ReactiveFormConsumer(
                                builder: (context, form, child) {
                              if (form.valid) {
                                return ElevatedButton(
                                    onPressed: () {
                                      context.read<ScheduleBloc>().add(AddWorkout(
                                          workoutPreset: selectedWorkout,
                                          workoutName:
                                              form.control('name').value,
                                          date: form.control('date').value,
                                          weight1: double.parse(
                                              form.control('weight1').value),
                                          reps1: int.parse(
                                              form.control('reps1').value),
                                          weight2: form
                                                          .control('weight2')
                                                          .value !=
                                                      null &&
                                                  form
                                                      .control('weight2')
                                                      .value
                                                      .isNotEmpty
                                              ? double.parse(
                                                  form.control('weight2').value)
                                              : null,
                                          reps2: form.control('reps2').value !=
                                                      null &&
                                                  form
                                                      .control('reps2')
                                                      .value
                                                      .isNotEmpty
                                              ? int.parse(
                                                  form.control('reps2').value)
                                              : null));
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      "isSuggested": workout.isSuggested,
                      "sets": (state.sets[workout.id] ?? []).map((set) {
                        return {
                          "weight1": set.weight1,
                          "reps1": set.reps1,
                          "weight2": set.weight2,
                          "reps2": set.reps2,
                          "date": set.date!.toString()
                        };
                      }).toList()
                    };
                    return WorkoutWidget(
                      workout: workoutMap,
                      canDelete: true,
                    );
                  })
                ],
              ),
            ),
          );
        }
        return Center(
          child: SpinKitFadingCircle(
            color: Colors.black,
            size: 40.0.h,
          ),
        );
      }),
    );
  }
}
