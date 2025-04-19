import 'package:summerbody/database/tables/Workouts.dart';
import 'package:drift/drift.dart';

@DataClassName("Entry")
class Entries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workout =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();
  RealColumn get weight1 => real()();
  IntColumn get reps1 => integer()();
  RealColumn get weight2 => real().nullable()();
  IntColumn get reps2 => integer().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
}
