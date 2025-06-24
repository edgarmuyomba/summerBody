import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
import 'package:summerbody/routing/routes.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/FirebaseService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';
import 'package:summerbody/services/SharedPreferencesService.dart';
import 'package:summerbody/widgets/workoutWidget.dart';

class Day extends StatefulWidget {
  final LocalDatabaseService _localDatabaseService;
  final SharedPreferencesService _sharedPreferencesService;

  Day(
      {super.key,
      LocalDatabaseService? localDatabaseService,
      SharedPreferencesService? sharedPreferencesService})
      : _localDatabaseService = localDatabaseService ??
            DIService().locator.get<LocalDatabaseService>(),
        _sharedPreferencesService = sharedPreferencesService ??
            DIService().locator.get<SharedPreferencesService>();

  @override
  State<Day> createState() => _DayState();
}

class _DayState extends State<Day> {
  Future<void> _showGenderSelector() async {
    String? selected;

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return AlertDialog(
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                alignment: Alignment.center,
                title: Text(
                  "Please select your gender",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                content: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setModalState(() {
                          selected = "male";
                        });
                      },
                      child: Card(
                        color:
                            selected == "male" ? Colors.black87 : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            height: 100.h,
                            width: 100.h,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.male,
                                  size: 50..sp,
                                  color: selected == "male"
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                Text(
                                  "Male",
                                  style: TextStyle(
                                      color: selected == "male"
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 17.sp),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        setModalState(() {
                          selected = "female";
                        });
                      },
                      child: Card(
                        color: selected == "female"
                            ? Colors.black87
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            height: 100.h,
                            width: 100.h,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.female,
                                  size: 50..sp,
                                  color: selected == "female"
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                Text(
                                  "Female",
                                  style: TextStyle(
                                      color: selected == "female"
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 17.sp),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        if (selected != null) {
                          widget._sharedPreferencesService
                              .saveStringValue("gender", selected!);
                          context.pop();
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: selected != null
                                ? Colors.black87
                                : Colors.black26),
                      ))
                ],
              );
            },
          );
        });
  }

  String? selectMuscleGroupName;

  @override
  void initState() {
    super.initState();
    widget._sharedPreferencesService.getStringValue("gender").then((value) {
      if (value == null) {
        _showGenderSelector();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Summer Body",
          style: GoogleFonts.monda(
              fontSize: 24.sp,
              color: Colors.black87,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleReady) {
            return Padding(
              padding: EdgeInsets.all(16.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.chevron_left,
                          size: 50.sp,
                        ),
                        onTap: () {
                          context.read<ScheduleBloc>().add(SetDay(
                              day: getDay(state.currentDay, prev: true)));
                        },
                      ),
                      Column(
                        children: [
                          Text(
                            capitalize(state.currentDay),
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                          Text("Day of the week",
                              style: TextStyle(fontSize: 10.sp))
                        ],
                      ),
                      GestureDetector(
                        child: Icon(Icons.chevron_right, size: 50.sp),
                        onTap: () {
                          context
                              .read<ScheduleBloc>()
                              .add(SetDay(day: getDay(state.currentDay)));
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: const Divider(),
                  ),
                  if (state.musclegroup == null) ...[
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          selectMuscleGroupName = null;
                        });
                        await addMuscleGroup(state.currentDay);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 75.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.w),
                            const Text(
                              "Add Muscle Group",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ] else ...[
                    SizedBox(height: 8.0.h),
                    Center(
                      child: Image(
                          height: 300.h,
                          image: AssetImage(
                            state.musclegroup!.icon!,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.h),
                      child: const Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Workouts",
                          style: GoogleFonts.monda(
                              fontSize: 18.sp,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        if (state.workouts.isNotEmpty) ...[
                          IconButton(
                              onPressed: () {
                                context.pushNamed(Routes.workouts,
                                    pathParameters: {
                                      "muscleGroupName":
                                          state.musclegroup!.name!
                                    });
                              },
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.black87,
                              ))
                        ]
                      ],
                    ),
                    if (state.workouts.isEmpty) ...[
                      Expanded(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "You have no workouts for the ",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black87),
                                children: [
                                  TextSpan(
                                    text:
                                        "${state.musclegroup!.name!.toLowerCase()}.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pushNamed(Routes.workouts,
                                    pathParameters: {
                                      "muscleGroupName":
                                          state.musclegroup!.name!
                                    });
                              },
                              child: Text(
                                "Add Some",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ))
                    ] else ...[
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                          children: state.workouts.map((workout) {
                            Map<String, dynamic> workoutMap = {
                              "id": workout.id,
                              "name": workout.name,
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
                            );
                          }).toList(),
                        )),
                      )
                    ]
                  ]
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // context.pushNamed(Routes.timer);
      //     List<Map<String, dynamic>> results = await DIService()
      //         .locator
      //         .get<FirebaseService>()
      //         .fetchWorkoutSuggestions("Arms", "Band Bayesi");
      //     if (results.isNotEmpty) {
      //       Logger().d(results.first);
      //     } else {
      //       Logger().d("No results");
      //     }
      //   },
      //   backgroundColor: Colors.black87,
      //   foregroundColor: Colors.white,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      //   child: const Icon(Icons.timer),
      // ),
    );
  }

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  String getDay(String day, {bool prev = false}) {
    int intValue = 0;

    switch (day) {
      case "monday":
        intValue = 0;
        break;
      case "tuesday":
        intValue = 1;
        break;
      case "wednesday":
        intValue = 2;
        break;
      case "thursday":
        intValue = 3;
        break;
      case "friday":
        intValue = 4;
        break;
      case "saturday":
        intValue = 5;
        break;
      case "sunday":
        intValue = 6;
        break;
    }

    int req = prev ? intValue - 1 : intValue + 1;

    if (req < 0) {
      req = 6;
    } else if (req > 6) {
      req = 0;
    }

    switch (req) {
      case 0:
        return "monday";
      case 1:
        return "tuesday";
      case 2:
        return "wednesday";
      case 3:
        return "thursday";
      case 4:
        return "friday";
      case 5:
        return "saturday";
      case 6:
        return "sunday";
      default:
        return "monday";
    }
  }

  addMuscleGroup(String day) async {
    String? result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 24.h,
                ),
                child: FutureBuilder(
                    future: widget._localDatabaseService.getAllMuscleGroups(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        List<MuscleGroup> muscleGroups = snapshot.data!;
                        return Column(children: [
                          if (selectMuscleGroupName != null) ...[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                context.read<ScheduleBloc>().add(AddMuscleGroup(
                                    muscleGroupName: selectMuscleGroupName!,
                                    day: day));
                              },
                              child: Container(
                                  width: double.infinity,
                                  height: 50.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "Add ${selectMuscleGroupName!}",
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ),
                            SizedBox(height: 20.h)
                          ],
                          Expanded(
                            child: GridView.count(
                                crossAxisCount: 2,
                                children:
                                    List.generate(muscleGroups.length, (index) {
                                  MuscleGroup muscleGroup = muscleGroups[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        selectMuscleGroupName =
                                            muscleGroup.name;
                                      });
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: selectMuscleGroupName ==
                                                      muscleGroup.name
                                                  ? Colors.black26
                                                  : Colors.transparent),
                                          color: selectMuscleGroupName ==
                                                  muscleGroup.name
                                              ? Colors.black12
                                              : Colors.transparent),
                                      child: Padding(
                                        padding: EdgeInsets.all(24.0.h),
                                        child: Image.asset(
                                          muscleGroup.icon!,
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                          ),
                        ]);
                      }
                      return const SizedBox.shrink();
                    }));
          });
        });
    if (result != null) {
      setState(() {
        selectMuscleGroupName = result;
      });
    }
  }
}
