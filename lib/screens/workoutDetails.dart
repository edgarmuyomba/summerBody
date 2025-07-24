import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:summerbody/blocs/MuscleGroup/muscleGroup_bloc.dart';
import 'package:summerbody/routing/routes.dart';
import 'package:summerbody/screens/videoPlayer.dart';
import 'package:summerbody/screens/youtubeVideoPlayer.dart';
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
  late String gender;

  @override
  void initState() {
    super.initState();
    context
        .read<MuscleGroupBloc>()
        .add(LoadWorkout(workoutId: widget.workoutId));
    widget._sharedPreferencesService.getStringValue("gender").then((value) {
      setState(() {
        gender = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          // bloc.add(SetDay(day: bloc.selectDay!));
          context.pop();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  // bloc.add(SetDay(day: bloc.selectDay!));
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back)),
            title: Text(
              "Workout Details",
              style: GoogleFonts.monda(
                  fontSize: 24.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    // bloc.add(SetDay(day: bloc.selectDay!));
                    // context.pop();
                    context.pushNamed(Routes.workout, pathParameters: {
                      "workoutId": widget.workoutId.toString(),
                      "triggerSetup": "true"
                    });
                  },
                  icon: const Icon(Icons.edit)),
            ],
          ),
          body: BlocConsumer<MuscleGroupBloc, MuscleGroupState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is WorkoutReady) {
                return Padding(
                    padding: EdgeInsets.all(16.0.h),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.workout.name!,
                            style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          if ((state.workout.equipment ?? []).isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.fitness_center,
                                  color: Colors.black87,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "Equipment Needed",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(),
                            ),
                            Text(
                              state.workout.equipment!.join(", "),
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.black87),
                            ),
                          ],
                          if ((state.workout.steps ?? []).isNotEmpty) ...[
                            SizedBox(
                              height: 20.h,
                            ),
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
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(),
                            ),
                            ...(state.workout.steps ?? []).map((step) {
                              return Text(
                                "• $step",
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.black87),
                              );
                            }),
                          ],
                          if (state.workout.gifUrl?[gender] != null ||
                              state.workout.videoUrl?[gender] != null) ...[
                            SizedBox(
                              height: 20.h,
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
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(),
                            ),
                            SizedBox(
                              height: 0.4 * MediaQuery.of(context).size.height,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  if (state.workout.gifUrl?[gender] !=
                                      null) ...[
                                    GestureDetector(
                                        onTap: () {
                                          // show video player dialog
                                          showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                              surfaceTintColor: Colors.white,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              alignment: Alignment.center,
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
                                                          Icons
                                                              .play_circle_fill,
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
                                  ],
                                  if (state.workout.videoUrl?[gender] !=
                                      null) ...[
                                    SizedBox(width: 10.w),
                                    GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                              surfaceTintColor: Colors.white,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              alignment: Alignment.center,
                                              child: AspectRatio(
                                                aspectRatio: 16 / 9,
                                                child: YoutubeVideoPlayer(
                                                    videoUrl: state.workout
                                                        .videoUrl![gender]!),
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
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                  Utilities.getYouTubeThumbnail(
                                                      state.workout
                                                          .videoUrl![gender]!),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    // Fallback to lower quality thumbnail
                                                    return Image.network(
                                                      Utilities
                                                          .getYouTubeThumbnail(
                                                              state.workout
                                                                      .videoUrl![
                                                                  gender]!,
                                                              quality:
                                                                  'hqdefault'),
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: const Icon(
                                                              Icons
                                                                  .play_circle_outline,
                                                              size: 50),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                                // Play button overlay
                                                Center(
                                                  child: Container(
                                                    height: 40.h,
                                                    width: 65.h,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: const Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ],
                              ),
                            )
                          ],
                          if (state.workout.subMuscles?.isNotEmpty == true) ...[
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 25,
                                  child: Image.asset(
                                      "assets/icons/arm-muscle.png"),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "Targeted Sub Muscles",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(),
                            ),
                            Wrap(
                                spacing: 4.0,
                                runSpacing: -5.0,
                                children: (state.workout.subMuscles ?? [])
                                    .map((muscle) {
                                  return Chip(
                                      backgroundColor: Colors.black87,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      label: Text(
                                        muscle,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ));
                                }).toList())
                          ]
                        ],
                      ),
                    ));
              } else {
                return Center(
                  child: SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child:
                        const CircularProgressIndicator(color: Colors.black87),
                  ),
                );
              }
            },
          ),
        ));
  }
}
