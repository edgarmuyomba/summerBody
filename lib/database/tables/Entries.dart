import 'package:summerbody/database/tables/Workouts.dart';
import 'package:drift/drift.dart';

@DataClassName("Entry")
class Entries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workout => integer().references(Workouts, #id, onDelete: KeyAction.cascade)();
  IntColumn get weight1 => integer()();
  IntColumn get reps1 => integer()();
  IntColumn get weight2 => integer().nullable()();
  IntColumn get reps2 => integer().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
}