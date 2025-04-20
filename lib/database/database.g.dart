// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  EntryDao? _entryDaoInstance;

  WorkoutDao? _workoutDaoInstance;

  MuscleGroupDao? _muscleGroupDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Entries` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `workoutId` INTEGER, `weight1` REAL, `reps1` INTEGER, `weight2` REAL, `reps2` INTEGER, `date` INTEGER, FOREIGN KEY (`workoutId`) REFERENCES `Workouts` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MuscleGroups` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `day` TEXT, `icon` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Workouts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `muscleGroupId` INTEGER, FOREIGN KEY (`muscleGroupId`) REFERENCES `MuscleGroups` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EntryDao get entryDao {
    return _entryDaoInstance ??= _$EntryDao(database, changeListener);
  }

  @override
  WorkoutDao get workoutDao {
    return _workoutDaoInstance ??= _$WorkoutDao(database, changeListener);
  }

  @override
  MuscleGroupDao get muscleGroupDao {
    return _muscleGroupDaoInstance ??=
        _$MuscleGroupDao(database, changeListener);
  }
}

class _$EntryDao extends EntryDao {
  _$EntryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _entryInsertionAdapter = InsertionAdapter(
            database,
            'Entries',
            (Entry item) => <String, Object?>{
                  'id': item.id,
                  'workoutId': item.workout,
                  'weight1': item.weight1,
                  'reps1': item.reps1,
                  'weight2': item.weight2,
                  'reps2': item.reps2,
                  'date': item.date
                }),
        _entryUpdateAdapter = UpdateAdapter(
            database,
            'Entries',
            ['id'],
            (Entry item) => <String, Object?>{
                  'id': item.id,
                  'workoutId': item.workout,
                  'weight1': item.weight1,
                  'reps1': item.reps1,
                  'weight2': item.weight2,
                  'reps2': item.reps2,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Entry> _entryInsertionAdapter;

  final UpdateAdapter<Entry> _entryUpdateAdapter;

  @override
  Future<List<Entry>> getAllEntries() async {
    return _queryAdapter.queryList('SELECT * FROM Entries',
        mapper: (Map<String, Object?> row) => Entry(
            row['id'] as int?,
            row['workoutId'] as int?,
            row['weight1'] as double?,
            row['reps1'] as int?,
            row['weight2'] as double?,
            row['reps2'] as int?,
            row['date'] as int?));
  }

  @override
  Future<void> deleteEntryById(
    int workoutId,
    int id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Entries WHERE id = ?2 AND workout = ?1',
        arguments: [workoutId, id]);
  }

  @override
  Future<Entry?> getEntryById(int id) async {
    return _queryAdapter.query('SELECT * FROM Entries WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Entry(
            row['id'] as int?,
            row['workoutId'] as int?,
            row['weight1'] as double?,
            row['reps1'] as int?,
            row['weight2'] as double?,
            row['reps2'] as int?,
            row['date'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<Entry>> getEntriesByWorkoutId(int workout) async {
    return _queryAdapter.queryList('SELECT * FROM Entries WHERE workout = ?1',
        mapper: (Map<String, Object?> row) => Entry(
            row['id'] as int?,
            row['workoutId'] as int?,
            row['weight1'] as double?,
            row['reps1'] as int?,
            row['weight2'] as double?,
            row['reps2'] as int?,
            row['date'] as int?),
        arguments: [workout]);
  }

  @override
  Future<void> createEntry(Entry entry) async {
    await _entryInsertionAdapter.insert(entry, OnConflictStrategy.abort);
  }

  @override
  Future<void> editEntry(Entry entry) async {
    await _entryUpdateAdapter.update(entry, OnConflictStrategy.abort);
  }
}

class _$WorkoutDao extends WorkoutDao {
  _$WorkoutDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutInsertionAdapter = InsertionAdapter(
            database,
            'Workouts',
            (Workout item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'muscleGroupId': item.muscleGroup
                }),
        _workoutUpdateAdapter = UpdateAdapter(
            database,
            'Workouts',
            ['id'],
            (Workout item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'muscleGroupId': item.muscleGroup
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Workout> _workoutInsertionAdapter;

  final UpdateAdapter<Workout> _workoutUpdateAdapter;

  @override
  Future<void> deleteWorkoutById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Workouts WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<Workout?> getWorkoutById(int id) async {
    return _queryAdapter.query('SELECT * FROM Workouts WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Workout(row['id'] as int?,
            row['name'] as String?, row['muscleGroupId'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<Workout>> getWorkoutsByName(String name) async {
    return _queryAdapter.queryList('SELECT * FROM Workouts WHERE name = ?1',
        mapper: (Map<String, Object?> row) => Workout(row['id'] as int?,
            row['name'] as String?, row['muscleGroupId'] as int?),
        arguments: [name]);
  }

  @override
  Future<List<Workout>> getWorkoutsByMuscleGroup(int muscleGroupId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Workouts WHERE muscleGroup = ?1',
        mapper: (Map<String, Object?> row) => Workout(row['id'] as int?,
            row['name'] as String?, row['muscleGroupId'] as int?),
        arguments: [muscleGroupId]);
  }

  @override
  Future<List<Workout>> getAllWorkouts() async {
    return _queryAdapter.queryList('SELECT * FROM Workouts',
        mapper: (Map<String, Object?> row) => Workout(row['id'] as int?,
            row['name'] as String?, row['muscleGroupId'] as int?));
  }

  @override
  Future<void> createWorkout(Workout workout) async {
    await _workoutInsertionAdapter.insert(workout, OnConflictStrategy.abort);
  }

  @override
  Future<void> editWorkout(Workout workout) async {
    await _workoutUpdateAdapter.update(workout, OnConflictStrategy.abort);
  }
}

class _$MuscleGroupDao extends MuscleGroupDao {
  _$MuscleGroupDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _muscleGroupInsertionAdapter = InsertionAdapter(
            database,
            'MuscleGroups',
            (MuscleGroup item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'day': item.day,
                  'icon': item.icon
                }),
        _muscleGroupUpdateAdapter = UpdateAdapter(
            database,
            'MuscleGroups',
            ['id'],
            (MuscleGroup item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'day': item.day,
                  'icon': item.icon
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MuscleGroup> _muscleGroupInsertionAdapter;

  final UpdateAdapter<MuscleGroup> _muscleGroupUpdateAdapter;

  @override
  Future<List<MuscleGroup>> getAllMuscleGroups() async {
    return _queryAdapter.queryList('SELECT * FROM MuscleGroups',
        mapper: (Map<String, Object?> row) => MuscleGroup(
            row['id'] as int?,
            row['name'] as String?,
            row['day'] as String?,
            row['icon'] as String?));
  }

  @override
  Future<MuscleGroup?> getMuscleGroupById(int id) async {
    return _queryAdapter.query('SELECT * FROM MuscleGroups WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MuscleGroup(
            row['id'] as int?,
            row['name'] as String?,
            row['day'] as String?,
            row['icon'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<MuscleGroup>> getMuscleGroupsByName(String name) async {
    return _queryAdapter.queryList('SELECT * FROM MuscleGroups WHERE name = ?1',
        mapper: (Map<String, Object?> row) => MuscleGroup(
            row['id'] as int?,
            row['name'] as String?,
            row['day'] as String?,
            row['icon'] as String?),
        arguments: [name]);
  }

  @override
  Future<List<MuscleGroup>> getMuscleGroupsByDay(String day) async {
    return _queryAdapter.queryList('SELECT * FROM MuscleGroups WHERE day = ?1',
        mapper: (Map<String, Object?> row) => MuscleGroup(
            row['id'] as int?,
            row['name'] as String?,
            row['day'] as String?,
            row['icon'] as String?),
        arguments: [day]);
  }

  @override
  Future<void> updateMuscleGroupDay(
    int id,
    String day,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE MuscleGroups SET day = ?2 WHERE id = ?1',
        arguments: [id, day]);
  }

  @override
  Future<void> createMuscleGroup(MuscleGroup muscleGroup) async {
    await _muscleGroupInsertionAdapter.insert(
        muscleGroup, OnConflictStrategy.abort);
  }

  @override
  Future<void> editMuscleGroup(MuscleGroup muscleGroup) async {
    await _muscleGroupUpdateAdapter.update(
        muscleGroup, OnConflictStrategy.abort);
  }
}
