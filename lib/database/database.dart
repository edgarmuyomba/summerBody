import 'dart:io';
import 'package:SummerBody/database/tables/Entries.dart';
import 'package:SummerBody/database/tables/Groups.dart';
import 'package:SummerBody/database/tables/Workouts.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Groups, Workouts, Entries])
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