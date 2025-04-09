import 'package:summerbody/database/tables/MuscleGroups.dart';
import 'package:drift/drift.dart';

@DataClassName("Workout")
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 3, max: 32)();
  IntColumn get muscleGroup => integer().references(MuscleGroups, #id)();
}