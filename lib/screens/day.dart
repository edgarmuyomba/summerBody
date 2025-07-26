import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/blocs/MuscleGroup/muscleGroup_bloc.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
import 'package:summerbody/database/tables/MuscleGroupPreset.dart';
import 'package:summerbody/routing/routes.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';
import 'package:summerbody/services/SharedPreferencesService.dart';
import 'package:summerbody/utils/utilities.dart';
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
  // List<Workout> workouts = [];
  MuscleGroupPreset? selectMuscleGroupPreset;
  int muscleGroupIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    widget._sharedPreferencesService.getStringValue("gender").then((value) {
      if (value == null && mounted) {
        Utilities.showGenderSelector(context, widget._sharedPreferencesService);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Summer Body",
            style: GoogleFonts.monda(
                fontSize: 24.sp,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () => context.pushNamed(Routes.settings),
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black87,
                ))
          ],
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleReady) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                            context
                                .read<ScheduleBloc>()
                                .add(ChangeDay(next: false));
                          },
                        ),
                        Column(
                          children: [
                            Text(
                              Utilities.capitalize(
                                  Utilities.intDayToString(state.currentDay)),
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
                                .add(ChangeDay(next: true));
                          },
                        )
                      ],
                    ),
                    const Divider(),
                    if (state.muscleGroups.isEmpty) ...[
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectMuscleGroupPreset = null;
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
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CarouselSlider(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                                enableInfiniteScroll: false,
                                autoPlay: false,
                                viewportFraction: 1,
                                initialPage: muscleGroupIndex,
                                height: 400.0,
                                onPageChanged: (index, reason) async {
                                  muscleGroupIndex = index;
                                  setState(() {});
                                }),
                            items: state.muscleGroups.map((muscleGroup) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Image(
                                        height: 300.h,
                                        image: AssetImage(
                                          muscleGroup.icon!,
                                        )),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectMuscleGroupPreset = null;
                                  });
                                  handleAction("add", state.currentDay);
                                },
                                tooltip: "Add muscle group",
                                constraints: BoxConstraints(
                                    maxWidth: 10.w, maxHeight: 10.w),
                                icon: Icon(
                                  Icons.add,
                                  size: 17.sp,
                                ),
                              ),
                              IconButton(
                                onPressed: () => handleAction(
                                    "delete", state.currentDay,
                                    muscleGroupId: state
                                        .muscleGroups[muscleGroupIndex].id!),
                                tooltip: "Delete muscle group",
                                constraints: BoxConstraints(
                                    maxWidth: 10.w, maxHeight: 10.w),
                                icon: Icon(
                                  Icons.cancel,
                                  size: 17.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0.h),
                        child: const Divider(),
                      ),
                      Expanded(
                        child: BlocBuilder<MuscleGroupBloc, MuscleGroupState>(
                          bloc: context.read<MuscleGroupBloc>()
                            ..add(LoadWorkouts(
                                muscleGroupId:
                                    state.muscleGroups[muscleGroupIndex].id!)),
                          builder: (context, muscleGroupState) {
                            if (muscleGroupState is MuscleGroupReady) {
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Workouts",
                                        style: GoogleFonts.monda(
                                            fontSize: 18.sp,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (muscleGroupState
                                          .workouts.isNotEmpty) ...[
                                        IconButton(
                                            onPressed: () {
                                              context.pushNamed(Routes.workouts,
                                                  pathParameters: {
                                                    "muscleGroupId":
                                                        "${state.muscleGroups[muscleGroupIndex].id!}"
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.menu,
                                              color: Colors.black87,
                                            ))
                                      ]
                                    ],
                                  ),
                                  if (muscleGroupState.workouts.isEmpty) ...[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  "You have no workouts for the ",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.black87),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${state.muscleGroups[muscleGroupIndex].name!.toLowerCase()}.",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                    "muscleGroupId":
                                                        "${state.muscleGroups[muscleGroupIndex].id!}"
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
                                    ),
                                  ] else ...[
                                    Expanded(
                                      child: SingleChildScrollView(
                                          child: Column(
                                        children: muscleGroupState.workouts
                                            .map((workout) {
                                          return FutureBuilder(
                                              future: widget
                                                  ._localDatabaseService
                                                  .getAllSets(workout.id!),
                                              builder: (BuildContext context,
                                                  snapshot) {
                                                if (snapshot.hasData) {
                                                  Map<String, dynamic>
                                                      workoutMap = {
                                                    "id": workout.id,
                                                    "name": workout.name,
                                                    "isSuggested":
                                                        workout.isSuggested,
                                                    "sets":
                                                        (snapshot.data ?? [])
                                                            .map((set) {
                                                      return {
                                                        "weight1": set.weight1,
                                                        "reps1": set.reps1,
                                                        "weight2": set.weight2,
                                                        "reps2": set.reps2,
                                                        "date":
                                                            set.date!.toString()
                                                      };
                                                    }).toList()
                                                  };
                                                  return WorkoutWidget(
                                                    workout: workoutMap,
                                                  );
                                                } else {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                              });
                                        }).toList(),
                                      )),
                                    )
                                  ]
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ]
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ));
  }

  addMuscleGroup(int day) async {
    List<MuscleGroupPreset> muscleGroupPresets =
        await widget._localDatabaseService.getAllMuscleGroupPresets();

    List<MuscleGroup> currentMuscleGroups =
        await widget._localDatabaseService.getMuscleGroupsByDay(day);

    muscleGroupPresets = muscleGroupPresets
        .where((preset) =>
            !currentMuscleGroups.any((group) => group.name == preset.name))
        .toList();

    MuscleGroupPreset? result = await showModalBottomSheet(
        backgroundColor: Colors.white,
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
                child: Column(children: [
                  if (selectMuscleGroupPreset != null) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        context.read<ScheduleBloc>().add(AddMuscleGroup(
                            muscleGroupPreset: selectMuscleGroupPreset!));
                      },
                      child: Container(
                          width: double.infinity,
                          height: 50.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Add ${selectMuscleGroupPreset!.name!}",
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(height: 20.h)
                  ],
                  Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        children:
                            List.generate(muscleGroupPresets.length, (index) {
                          MuscleGroupPreset muscleGroupPreset =
                              muscleGroupPresets[index];
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectMuscleGroupPreset = muscleGroupPreset;
                              });
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: selectMuscleGroupPreset?.name ==
                                              muscleGroupPreset.name
                                          ? Colors.black26
                                          : Colors.transparent),
                                  color: selectMuscleGroupPreset?.name ==
                                          muscleGroupPreset.name
                                      ? Colors.black12
                                      : Colors.transparent),
                              child: Padding(
                                padding: EdgeInsets.all(24.0.h),
                                child: Image.asset(
                                  muscleGroupPreset.icon!,
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                ]));
          });
        });
    if (result != null) {
      setState(() {
        selectMuscleGroupPreset = result;
      });
    }
  }

  deleteMuscleGroup(int muscleGroupId) async {
    await showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 24.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to delete this muscle group?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.monda(
                        fontSize: 18.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(double.infinity, 50.h),
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Color(0xffe80c53)),
                                    borderRadius: BorderRadius.circular(5)),
                                foregroundColor: const Color(0xffe80c53),
                                backgroundColor: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(double.infinity, 50.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xffe80c53)),
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<ScheduleBloc>().add(
                                  DeleteMuscleGroup(
                                      muscleGroupId: muscleGroupId));
                              setState(() {
                                muscleGroupIndex = 0;
                                _carouselController
                                    .jumpToPage(muscleGroupIndex);
                              });
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  )
                ],
              ));
        });
  }

  handleAction(String action, int day, {int? muscleGroupId}) async {
    switch (action) {
      case "add":
        await addMuscleGroup(day);
        break;
      case "delete":
        deleteMuscleGroup(muscleGroupId!);
        break;
    }
  }
}
