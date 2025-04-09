import 'dart:io';
import 'package:summerbody/database/tables/Entries.dart';
import 'package:summerbody/database/tables/MuscleGroups.dart';
import 'package:summerbody/database/tables/Workouts.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';

part 'database.g.dart';

@DriftDatabase(tables: [MuscleGroups, Workouts, Entries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          final localDatabaseService = LocalDatabaseService(appDatabase: this);
          await localDatabaseService.seedMuscleGroups();
        },
      );

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
