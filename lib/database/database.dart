import 'dart:io';

import 'package:SummerBody/database/tables/Entry.dart';
import 'package:SummerBody/database/tables/Group.dart';
import 'package:SummerBody/database/tables/Workout.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [GroupTable, WorkoutTable, EntryTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbPath = await _databasePath();
      return NativeDatabase.createInBackground(File(dbPath));
    });
  }

  static Future<String> _databasePath() async {
    final directory = await getApplicationSupportDirectory();
    return '${directory.path}/summerbody.db';
  }
}