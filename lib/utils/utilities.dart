import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/FirebaseService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';
import 'package:summerbody/services/SharedPreferencesService.dart';
import 'package:summerbody/state/SyncState.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Utilities {
  static Map<String, String> parseDate(String dateString) {
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

  static String dateToString(DateTime date) {
    String day = date.day.toString();
    String shortMonth = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    }[date.month]!;
    String year = date.year.toString();
    return '$day $shortMonth, $year';
  }

  static void showSnackBar(String message, BuildContext context, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  static Future<File?> getVideoThumbnail(String videoUrl, int height) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.PNG,
      maxHeight: height,
      maxWidth: height * 16 ~/ 9,
      quality: 100,
    );
    return filePath != null ? File(filePath) : null;
  }

  static String getYouTubeThumbnail(String videoUrl,
      {String quality = 'maxresdefault'}) {
    // Extract video ID from URL
    String? videoId = extractVideoId(videoUrl);
    if (videoId == null) return '';

    // Return thumbnail URL
    return 'https://img.youtube.com/vi/$videoId/$quality.jpg';
  }

  static String? extractVideoId(String url) {
    // Handle different YouTube URL formats
    RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
      caseSensitive: false,
      multiLine: false,
    );

    Match? match = regExp.firstMatch(url);
    return match?.group(1);
  }

  static Future<void> syncWorkoutPresets() async {
    final FirebaseService _firebaseService =
        DIService().locator.get<FirebaseService>();
    final LocalDatabaseService _localDatabaseService =
        DIService().locator.get<LocalDatabaseService>();
    final SyncStateModal _syncStateModal =
        DIService().locator.get<SyncStateModal>();

    // get all musclegroups
    List<MuscleGroup> muscleGroups = getAllMuscleGroups();

    List<MuscleGroup> muscleGroupsToSync = [];

    int totalCount = 0;
    double syncProgress = 0;

    _syncStateModal.update(isSyncing: true, syncProgress: 0, active: false);

    for (final muscleGroup in muscleGroups) {
      bool presetsAvailable =
          ((await _localDatabaseService.countWorkoutPresets(muscleGroup.id!) ??
                  0)) >
              0;

      if (presetsAvailable) {
        // firebase count

        int firebaseCount =
            await _firebaseService.getRecordCount(muscleGroup.name!);

        totalCount += firebaseCount;
        muscleGroupsToSync.add(muscleGroup);
      }

      syncProgress += (1 / muscleGroups.length) * 0.1;
      _syncStateModal.update(syncProgress: syncProgress);
    }

    for (final muscleGroup in muscleGroupsToSync) {
      await _localDatabaseService.deleteWorkoutPresets(muscleGroup.name!);

      StreamSubscription<List<Map<String, dynamic>>>? subscription;

      subscription =
          _firebaseService.workoutStream(muscleGroup.name!).listen((value) {
        _localDatabaseService.createWorkoutPresets(value, muscleGroup.name);
        syncProgress += (value.length / totalCount) * 0.9;
        _syncStateModal.update(syncProgress: syncProgress);
      }, onDone: () async {
        subscription?.cancel();
        if (syncProgress == 1.0) {
          _syncStateModal.update(isSyncing: false);
          await Future.delayed(const Duration(seconds: 5), () {
            _syncStateModal.update(syncProgress: 0, active: true);
          });
        }
      });
    }
  }

  static Future<void> showGenderSelector(BuildContext context,
      SharedPreferencesService sharedPreferencesService) async {
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
                                  size: 50.sp,
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
                          sharedPreferencesService.saveStringValue(
                              "gender", selected!);
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

  static String intDayToString(int day) {
    return day == DateTime.monday
        ? 'monday'
        : day == DateTime.tuesday
            ? 'tuesday'
            : day == DateTime.wednesday
                ? 'wednesday'
                : day == DateTime.thursday
                    ? 'thursday'
                    : day == DateTime.friday
                        ? 'friday'
                        : day == DateTime.saturday
                            ? 'saturday'
                            : 'sunday';
  }

  static int stringDayToInt(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      default:
        return DateTime.sunday;
    }
  }

  static List<MuscleGroup> getAllMuscleGroups() {
    List<Map<String, dynamic>> maps = [
      {
        'id': null,
        'name': 'Chest',
        'dayId': null,
        'icon': 'assets/icons/chest.png'
      },
      {'id': null, 'name': 'Arms', 'dayId': null, 'icon': 'assets/icons/arms.png'},
      {
        'id': null,
        'name': 'Shoulders',
        'dayId': null,
        'icon': 'assets/icons/shoulders.png'
      },
      {'id': null, 'name': 'Back', 'dayId': null, 'icon': 'assets/icons/back.png'},
      {'id': null, 'name': 'Legs', 'dayId': null, 'icon': 'assets/icons/legs.png'},
      {
        'id': null,
        'name': 'Cardio',
        'dayId': null,
        'icon': 'assets/icons/cardio.png'
      },
      {
        'id': null,
        'name': 'Full Body',
        'dayId': null,
        'icon': 'assets/icons/full-body.png'
      },
      {
        'id': null,
        'name': 'Rest Day',
        'dayId': null,
        'icon': 'assets/icons/rest-day.png'
      }
    ];
    return maps.map((group) => MuscleGroup.fromMap(group)).toList();
  }

  static String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
