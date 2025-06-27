import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:summerbody/blocs/Schedule/schedule_bloc.dart';
import 'package:summerbody/screens/videoPlayer.dart';
import 'package:summerbody/services/SharedPreferencesService.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/utils/utilities.dart';

class WorkoutDetails extends StatefulWidget {
  final int workoutId;
  final SharedPreferencesService _sharedPreferencesService;
  WorkoutDetails(
      {super.key,
      required this.workoutId,
      SharedPreferencesService? sharedPreferencesService})
      : _sharedPreferencesService = sharedPreferencesService ??
            DIService().locator.get<SharedPreferencesService>();

  @override
  State<WorkoutDetails> createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  String workoutName = "";
  late String gender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._sharedPreferencesService.getStringValue("gender").then((value) {
      setState(() {
        gender = value!;
      });
    });
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
                  workoutName = state.workout.name!;
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
                        if ((state.workout.steps ?? []).isNotEmpty) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.checklist,
                                color: Colors.black87,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Steps",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ],
                          )
                        ],
                        ...(state.workout.steps ?? []).map((step) {
                          return Text(
                            "• $step",
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.black87),
                          );
                        }),
                        SizedBox(
                          height: 10.h,
                        ),
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
                        ),
                        if (state.workout.gifUrl?[gender] != null ||
                            state.workout.videoUrl?[gender] != null) ...[
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.play_circle_filled,
                                color: Colors.black87,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Guides",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            height: 0.4 * MediaQuery.of(context).size.height,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                if (state.workout.gifUrl?[gender] != null) ...[
                                  GestureDetector(
                                      onTap: () {
                                        // show video player dialog
                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            child: AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: VideoPlayerScreen(
                                                  videoUrl: state.workout
                                                      .gifUrl![gender]!),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(2, 4),
                                              blurRadius: 4,
                                              spreadRadius: 0.5,
                                            ),
                                          ],
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: double.infinity,
                                        width: 0.6 *
                                            MediaQuery.of(context).size.width,
                                        child: FutureBuilder(
                                          future: Utilities.getVideoThumbnail(
                                            state.workout.gifUrl![gender]!,
                                            (0.4 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height)
                                                .toInt(),
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.file(
                                                      snapshot.data!,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.play_circle_fill,
                                                        size: 60,
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else if (snapshot.hasError) {
                                              Logger().e(snapshot.error);
                                              return const SizedBox.shrink();
                                            } else {
                                              return Center(
                                                child: SizedBox(
                                                  height: 20.h,
                                                  width: 20.h,
                                                  child:
                                                      const CircularProgressIndicator(
                                                          color:
                                                              Colors.black87),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      )),
                                ]
                              ],
                            ),
                          )
                        ],
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
