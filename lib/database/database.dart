import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:summerbody/database/daos/SetDao.dart';
import 'package:summerbody/database/daos/MuscleGroupDao.dart';
import 'package:summerbody/database/daos/WorkoutDao.dart';
import 'package:summerbody/database/tables/Set.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
import 'package:summerbody/database/tables/Workout.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Set, MuscleGroup, Workout])
abstract class AppDatabase extends FloorDatabase {
  SetDao get setDao;
  WorkoutDao get workoutDao;
  MuscleGroupDao get muscleGroupDao;
}
