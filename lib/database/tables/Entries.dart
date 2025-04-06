import 'package:SummerBody/database/tables/Workouts.dart';
import 'package:drift/drift.dart';

@DataClassName("Entry")
class Entries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workout => integer().references(Workouts, #id)();
  IntColumn get weight => integer()();
  IntColumn get sets => integer()();
  IntColumn get reps => integer()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
}