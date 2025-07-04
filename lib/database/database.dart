import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:summerbody/database/daos/SetDao.dart';
import 'package:summerbody/database/daos/MuscleGroupDao.dart';
import 'package:summerbody/database/daos/WorkoutDao.dart';
import 'package:summerbody/database/daos/WorkoutPresetDao.dart';
import 'package:summerbody/database/tables/Day.dart';
import 'package:summerbody/database/tables/Set.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
import 'package:summerbody/database/tables/Workout.dart';
import 'package:summerbody/database/tables/WorkoutPreset.dart';
import 'package:summerbody/database/typeConverters/datetimeConverter.dart';
import 'package:summerbody/database/typeConverters/stringListConverter.dart';
import 'package:summerbody/database/typeConverters/stringMapConverter.dart';

part 'database.g.dart';

@TypeConverters([StringListConverter, StringMapConverter, DateTimeConverter])
@Database(version: 1, entities: [Day, Set, MuscleGroup, Workout, WorkoutPreset])
abstract class AppDatabase extends FloorDatabase {
  SetDao get setDao;
  WorkoutDao get workoutDao;
  WorkoutPresetDao get workoutPresetDao;
  MuscleGroupDao get muscleGroupDao;
}
