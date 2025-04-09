import 'package:drift/drift.dart';

@DataClassName("MuscleGroup")
class MuscleGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 6, max: 32)();
  TextColumn get day => text()();
}