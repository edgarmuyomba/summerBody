import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summerbody/stateManagement/MuscleGroup/muscle_group_bloc.dart';
import 'package:summerbody/stateManagement/Schedule/schedule_bloc.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
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
  String? selectMuscleGroupName;

  int currentDay = DateTime.now().weekday;

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
        body: Column(
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
                    setState(() {
                      currentDay = getDay(currentDay, prev: true);
                    });
                  },
                ),
                Column(
                  children: [
                    Text(
                      Utilities.capitalize(
                          Utilities.intDayToString(currentDay)),
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                    ),
                    Text("Day of the week", style: TextStyle(fontSize: 10.sp))
                  ],
                ),
                GestureDetector(
                  child: Icon(Icons.chevron_right, size: 50.sp),
                  onTap: () {
                    setState(() {
                      currentDay = getDay(currentDay);
                    });
                  },
                )
              ],
            ),
            BlocConsumer<MuscleGroupBloc, MuscleGroupState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is MuscleGroupsLoaded) {
                  return Padding(
                    padding: EdgeInsets.all(16.0.h),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ));
  }

  int getDay(int day, {bool prev = false}) {
    int req = prev ? day - 1 : day + 1;

    if (req < 1) {
      req = 7;
    } else if (req > 7) {
      req = 1;
    }

    return req;
  }

  addMuscleGroup(String day) async {
    List<MuscleGroup> muscleGroups = Utilities.getAllMuscleGroups();

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
                child: Column(children: [
                  if (selectMuscleGroupName != null) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        context.read<ScheduleBloc>().add(AddMuscleGroup(
                            muscleGroupName: selectMuscleGroupName!, day: day));
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
                        children: List.generate(muscleGroups.length, (index) {
                          MuscleGroup muscleGroup = muscleGroups[index];
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectMuscleGroupName = muscleGroup.name;
                              });
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: selectMuscleGroupName ==
                                              muscleGroup.name
                                          ? Colors.black26
                                          : Colors.transparent),
                                  color:
                                      selectMuscleGroupName == muscleGroup.name
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
                ]));
          });
        });
    if (result != null) {
      setState(() {
        selectMuscleGroupName = result;
      });
    }
  }

  showActionBottomSheet(String action) {
    String title = "";

    switch (action) {
      case "add":
        title = "Add muscle group";
        break;
      case "edit":
        title = "Edit muscle group";
        break;
      case "delete":
        title = "Delete muscle group";
        break;
    }

    return showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        builder: (BuildContext context) {
          return Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.monda(
                        fontSize: 18.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ));
        });
  }
}
