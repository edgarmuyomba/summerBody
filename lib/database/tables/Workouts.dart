import 'package:SummerBody/database/tables/Groups.dart';
import 'package:drift/drift.dart';

class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 6, max: 32)();
  IntColumn get group => integer().references(Groups, #id)();
}