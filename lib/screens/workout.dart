import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';
import 'package:summerbody/database/tables/Set.dart';
import 'package:summerbody/database/typeConverters/datetimeConverter.dart';
import 'package:summerbody/utils/utilities.dart';

class Workout extends StatefulWidget {
  final int workoutId;
  const Workout({super.key, required this.workoutId});

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String workoutName = "";

  bool firstSetValid = false;
  bool secondSetEnabled = false;

  bool dialogFirstSetValid = false;
  bool dialogSecondSetEnabled = false;

  bool loading = false;

  final form = FormGroup({
    "name": FormControl<String>(validators: [Validators.required]),
    "date": FormControl<DateTime>(),
    "weight1": FormControl<String>(validators: [Validators.required]),
    "reps1": FormControl<String>(validators: [Validators.required]),
    "weight2": FormControl<String?>(),
    "reps2": FormControl<String?>(),
  });

  Future<void> _selectDate(
      BuildContext context, FormGroup form, StateSetter? setModalState) async {
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
      if (setModalState != null) {
        setModalState(() {
          form.control('date').value = pickedDate;
        });
      } else {
        form.control('date').value = pickedDate;
      }
    }
  }

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
                loading = false;

                workoutName = state.workout.name!;

                form.control('name').value = state.workout.name;
                form.control('date').value = state.sets.first.date;
                form.control('weight1').value =
                    state.sets[0].weight1.toString();
                form.control('reps1').value = state.sets[0].reps1.toString();
                form.control('weight2').value =
                    state.sets[0].weight2?.toString();
                form.control('reps2').value = state.sets[0].reps2?.toString();

                firstSetValid = true;

                if (form.control('weight2').value != null &&
                    form.control('weight2').value != "" &&
                    form.control('reps2').value != null &&
                    form.control('reps2').value != "") {
                  secondSetEnabled = true;
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
                            Row(
                              children: [
                                Expanded(
                                  child: ReactiveTextField(
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
                                            horizontal: 16.0.w,
                                            vertical: 12.0.h),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onChanged: (control) {
                                      form.control('name').value =
                                          control.value;
                                    },
                                    style: GoogleFonts.monda(
                                      fontSize: 20.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                GestureDetector(
                                  onTap: () => _selectDate(context, form, null),
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
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        addSetDialog(state.workout.id!),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black87,
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Colors.black87),
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    child: const Center(
                                      child: Text(
                                        "Add Set",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: ReactiveFormConsumer(
                                      builder: (context, form, child) {
                                    if (form.valid) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            loading = true;
                                          });

                                          // edit the workout
                                          bloc.add(EditWorkout(
                                              workoutId: widget.workoutId,
                                              workoutName:
                                                  form.control("name").value,
                                              setId: state.sets[0].id!,
                                              date: form.control('date').value,
                                              weight1: double.parse(form
                                                  .control("weight1")
                                                  .value),
                                              reps1: int.parse(
                                                  form.control("reps1").value),
                                              weight2: form
                                                          .control("weight2")
                                                          .value !=
                                                      null
                                                  ? double.parse(form
                                                      .control("weight2")
                                                      .value)
                                                  : null,
                                              reps2:
                                                  form.control("reps2").value !=
                                                          null
                                                      ? int.parse(form
                                                          .control("reps2")
                                                          .value)
                                                      : null,
                                              context: context));
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
                                                  "Save",
                                                ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }),
                                ),
                              ],
                            )
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.all(8.0.h),
                      child: const Divider(),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: state.sets.asMap().entries.map((entryMap) {
                          int index = entryMap.key;
                          Set set = entryMap.value;

                          bool isFirst = index == 0;

                          int lastIndex = state.sets.length - 1;

                          String setString =
                              "${set.weight1}Kg/${set.reps1} reps";

                          if (set.weight2 != null) {
                            setString += ", ${set.weight2}Kg/${set.reps2} reps";
                          }
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.0.h),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: isFirst
                                      ? Colors.green[50]
                                      : Colors.red[50],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.h),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            setString,
                                            style: GoogleFonts.monda(
                                                fontSize: 20.sp,
                                                color: isFirst
                                                    ? Colors.green[900]
                                                    : Colors.red[900]),
                                          ),
                                          Text(
                                            Utilities.dateToString(set.date!),
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: isFirst
                                                    ? Colors.green[900]
                                                    : Colors.red[900]),
                                          )
                                        ],
                                      ),
                                      if (lastIndex != 0) ...[
                                        GestureDetector(
                                          onTap: () {
                                            context.read<ScheduleBloc>().add(
                                                DeleteSet(
                                                    workoutId: widget.workoutId,
                                                    setId: set.id!,
                                                    context: context));
                                          },
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: isFirst
                                                ? Colors.green[900]
                                                : Colors.red[900],
                                          ),
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ))
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  addSetDialog(int workoutId) async {
    final form = FormGroup({
      "date": FormControl<DateTime>(value: DateTime.now()),
      "weight1": FormControl<String>(validators: [Validators.required]),
      "reps1": FormControl<String>(validators: [Validators.required]),
      "weight2": FormControl<String?>(),
      "reps2": FormControl<String?>(),
    });

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Set details?",
                        style: GoogleFonts.monda(
                            fontSize: 20.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    ReactiveForm(
                        formGroup: form,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _selectDate(context, form, setModalState);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black87,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              child: Center(
                                child: Text(form.control('date').value != null
                                    ? Utilities.dateToString(
                                        form.control('date').value)
                                    : "Select Date"),
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                                  dialogFirstSetValid && !dialogSecondSetEnabled
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: dialogFirstSetValid &&
                                          !dialogSecondSetEnabled
                                      ? 130.w
                                      : 160.w,
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
                                      if (form.control('weight1').valid &&
                                          form.control('reps1').valid) {
                                        setModalState(() {
                                          dialogFirstSetValid = true;
                                        });
                                        setState(() {});
                                      }
                                    },
                                    style: GoogleFonts.monda(
                                        fontSize: 20.sp, color: Colors.black87),
                                  ),
                                ),
                                if (dialogFirstSetValid &&
                                    !dialogSecondSetEnabled) ...[
                                  SizedBox(width: 10.w),
                                ],
                                SizedBox(
                                  width: dialogFirstSetValid &&
                                          !dialogSecondSetEnabled
                                      ? 130.w
                                      : 160.w,
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
                                      if (form.control('weight1').valid &&
                                          form.control('reps1').valid) {
                                        setModalState(() {
                                          dialogFirstSetValid = true;
                                        });
                                        setState(() {});
                                      }
                                    },
                                    style: GoogleFonts.monda(
                                        fontSize: 20.sp, color: Colors.black87),
                                  ),
                                ),
                                if (dialogFirstSetValid &&
                                    !dialogSecondSetEnabled) ...[
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          dialogSecondSetEnabled = true;
                                        });
                                        setState(() {});
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
                            if (dialogSecondSetEnabled) ...[
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 130.w,
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
                                    width: 130.w,
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
                                        setModalState(() {
                                          dialogSecondSetEnabled = false;
                                          form.control('weight2').reset();
                                          form.control('reps2').reset();
                                        });
                                        setState(() {});
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
                            ReactiveFormConsumer(
                                builder: (context, form, child) {
                              if (form.valid) {
                                return ElevatedButton(
                                  onPressed: () {
                                    // save the set
                                    context.read<ScheduleBloc>().add(CreateSet(
                                        workoutId: workoutId,
                                        date: form.control('date').value,
                                        weight1: double.parse(
                                            form.control('weight1').value),
                                        reps1: int.parse(
                                            form.control('reps1').value),
                                        weight2: form
                                                    .control('weight2')
                                                    .value !=
                                                null
                                            ? double.parse(
                                                form.control('weight2').value)
                                            : null,
                                        reps2:
                                            form.control('reps2').value != null
                                                ? int.parse(
                                                    form.control('reps2').value)
                                                : null,
                                        context: context));

                                    context.pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  child: const Center(
                                    child: Text(
                                      "Save",
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                          ],
                        ))
                  ],
                ),
              );
            }),
          );
        });
  }
}
