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

  SetDao? _setDaoInstance;

  WorkoutDao? _workoutDaoInstance;

  WorkoutPresetDao? _workoutPresetDaoInstance;

  MuscleGroupDao? _muscleGroupDaoInstance;

  DayDao? _dayDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Days` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Sets` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `workoutId` INTEGER, `weight1` REAL, `reps1` INTEGER, `weight2` REAL, `reps2` INTEGER, `date` INTEGER, FOREIGN KEY (`workoutId`) REFERENCES `Workouts` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MuscleGroups` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `dayId` INTEGER, `icon` TEXT, FOREIGN KEY (`dayId`) REFERENCES `Days` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Workouts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `isSuggested` INTEGER NOT NULL, `equipment` TEXT, `subMuscles` TEXT, `steps` TEXT, `videoUrl` TEXT, `gifUrl` TEXT, `muscleGroupId` INTEGER, FOREIGN KEY (`muscleGroupId`) REFERENCES `MuscleGroups` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WorkoutPresets` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `equipment` TEXT, `subMuscles` TEXT, `steps` TEXT, `videoUrl` TEXT, `gifUrl` TEXT, `muscleGroupId` INTEGER, FOREIGN KEY (`muscleGroupId`) REFERENCES `MuscleGroups` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SetDao get setDao {
    return _setDaoInstance ??= _$SetDao(database, changeListener);
  }

  @override
  WorkoutDao get workoutDao {
    return _workoutDaoInstance ??= _$WorkoutDao(database, changeListener);
  }

  @override
  WorkoutPresetDao get workoutPresetDao {
    return _workoutPresetDaoInstance ??=
        _$WorkoutPresetDao(database, changeListener);
  }

  @override
  MuscleGroupDao get muscleGroupDao {
    return _muscleGroupDaoInstance ??=
        _$MuscleGroupDao(database, changeListener);
  }

  @override
  DayDao get dayDao {
    return _dayDaoInstance ??= _$DayDao(database, changeListener);
  }
}

class _$SetDao extends SetDao {
  _$SetDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _setInsertionAdapter = InsertionAdapter(
            database,
            'Sets',
            (Set item) => <String, Object?>{
                  'id': item.id,
                  'workoutId': item.workout,
                  'weight1': item.weight1,
                  'reps1': item.reps1,
                  'weight2': item.weight2,
                  'reps2': item.reps2,
                  'date': _dateTimeConverter.encode(item.date)
                }),
        _setUpdateAdapter = UpdateAdapter(
            database,
            'Sets',
            ['id'],
            (Set item) => <String, Object?>{
                  'id': item.id,
                  'workoutId': item.workout,
                  'weight1': item.weight1,
                  'reps1': item.reps1,
                  'weight2': item.weight2,
                  'reps2': item.reps2,
                  'date': _dateTimeConverter.encode(item.date)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Set> _setInsertionAdapter;

  final UpdateAdapter<Set> _setUpdateAdapter;

  @override
  Future<List<Set>> getAllSets() async {
    return _queryAdapter.queryList('SELECT * FROM Sets',
        mapper: (Map<String, Object?> row) => Set(
            row['id'] as int?,
            row['workoutId'] as int?,
            row['weight1'] as double?,
            row['reps1'] as int?,
            row['weight2'] as double?,
            row['reps2'] as int?,
            _dateTimeConverter.decode(row['date'] as int?)));
  }

  @override
  Future<void> deleteSetById(
    int workoutId,
    int id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Sets WHERE id = ?2 AND workoutId = ?1',
        arguments: [workoutId, id]);
  }

  @override
  Future<Set?> getSetById(int id) async {
    return _queryAdapter.query('SELECT * FROM Sets WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Set(
            row['id'] as int?,
            row['workoutId'] as int?,
            row['weight1'] as double?,
            row['reps1'] as int?,
            row['weight2'] as double?,
            row['reps2'] as int?,
            _dateTimeConverter.decode(row['date'] as int?)),
        arguments: [id]);
  }

  @override
  Future<List<Set>> getSetsByWorkoutId(int workoutId) async {
    return _queryAdapter.queryList('SELECT * FROM Sets WHERE workoutId = ?1',
        mapper: (Map<String, Object?> row) => Set(
            row['id'] as int?,
            row['workoutId'] as int?,
            row['weight1'] as double?,
            row['reps1'] as int?,
            row['weight2'] as double?,
            row['reps2'] as int?,
            _dateTimeConverter.decode(row['date'] as int?)),
        arguments: [workoutId]);
  }

  @override
  Future<int> createSet(Set set) {
    return _setInsertionAdapter.insertAndReturnId(
        set, OnConflictStrategy.abort);
  }

  @override
  Future<void> editSet(Set set) async {
    await _setUpdateAdapter.update(set, OnConflictStrategy.abort);
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
                  'isSuggested': item.isSuggested ? 1 : 0,
                  'equipment': _stringListConverter.encode(item.equipment),
                  'subMuscles': _stringListConverter.encode(item.subMuscles),
                  'steps': _stringListConverter.encode(item.steps),
                  'videoUrl': _stringMapConverter.encode(item.videoUrl),
                  'gifUrl': _stringMapConverter.encode(item.gifUrl),
                  'muscleGroupId': item.muscleGroup
                }),
        _workoutUpdateAdapter = UpdateAdapter(
            database,
            'Workouts',
            ['id'],
            (Workout item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isSuggested': item.isSuggested ? 1 : 0,
                  'equipment': _stringListConverter.encode(item.equipment),
                  'subMuscles': _stringListConverter.encode(item.subMuscles),
                  'steps': _stringListConverter.encode(item.steps),
                  'videoUrl': _stringMapConverter.encode(item.videoUrl),
                  'gifUrl': _stringMapConverter.encode(item.gifUrl),
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
        mapper: (Map<String, Object?> row) => Workout(
            id: row['id'] as int?,
            name: row['name'] as String?,
            isSuggested: (row['isSuggested'] as int) != 0,
            equipment: _stringListConverter.decode(row['equipment'] as String?),
            subMuscles:
                _stringListConverter.decode(row['subMuscles'] as String?),
            steps: _stringListConverter.decode(row['steps'] as String?),
            videoUrl: _stringMapConverter.decode(row['videoUrl'] as String?),
            gifUrl: _stringMapConverter.decode(row['gifUrl'] as String?),
            muscleGroup: row['muscleGroupId'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<Workout>> getWorkoutsByName(String name) async {
    return _queryAdapter.queryList('SELECT * FROM Workouts WHERE name = ?1',
        mapper: (Map<String, Object?> row) => Workout(
            id: row['id'] as int?,
            name: row['name'] as String?,
            isSuggested: (row['isSuggested'] as int) != 0,
            equipment: _stringListConverter.decode(row['equipment'] as String?),
            subMuscles:
                _stringListConverter.decode(row['subMuscles'] as String?),
            steps: _stringListConverter.decode(row['steps'] as String?),
            videoUrl: _stringMapConverter.decode(row['videoUrl'] as String?),
            gifUrl: _stringMapConverter.decode(row['gifUrl'] as String?),
            muscleGroup: row['muscleGroupId'] as int?),
        arguments: [name]);
  }

  @override
  Future<List<Workout>> getWorkoutsByMuscleGroup(int muscleGroupId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Workouts WHERE muscleGroupId = ?1',
        mapper: (Map<String, Object?> row) => Workout(
            id: row['id'] as int?,
            name: row['name'] as String?,
            isSuggested: (row['isSuggested'] as int) != 0,
            equipment: _stringListConverter.decode(row['equipment'] as String?),
            subMuscles:
                _stringListConverter.decode(row['subMuscles'] as String?),
            steps: _stringListConverter.decode(row['steps'] as String?),
            videoUrl: _stringMapConverter.decode(row['videoUrl'] as String?),
            gifUrl: _stringMapConverter.decode(row['gifUrl'] as String?),
            muscleGroup: row['muscleGroupId'] as int?),
        arguments: [muscleGroupId]);
  }

  @override
  Future<List<Workout>> getAllWorkouts() async {
    return _queryAdapter.queryList('SELECT * FROM Workouts',
        mapper: (Map<String, Object?> row) => Workout(
            id: row['id'] as int?,
            name: row['name'] as String?,
            isSuggested: (row['isSuggested'] as int) != 0,
            equipment: _stringListConverter.decode(row['equipment'] as String?),
            subMuscles:
                _stringListConverter.decode(row['subMuscles'] as String?),
            steps: _stringListConverter.decode(row['steps'] as String?),
            videoUrl: _stringMapConverter.decode(row['videoUrl'] as String?),
            gifUrl: _stringMapConverter.decode(row['gifUrl'] as String?),
            muscleGroup: row['muscleGroupId'] as int?));
  }

  @override
  Future<int> createWorkout(Workout workout) {
    return _workoutInsertionAdapter.insertAndReturnId(
        workout, OnConflictStrategy.abort);
  }

  @override
  Future<void> editWorkout(Workout workout) async {
    await _workoutUpdateAdapter.update(workout, OnConflictStrategy.abort);
  }
}

class _$WorkoutPresetDao extends WorkoutPresetDao {
  _$WorkoutPresetDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _workoutPresetInsertionAdapter = InsertionAdapter(
            database,
            'WorkoutPresets',
            (WorkoutPreset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'equipment': _stringListConverter.encode(item.equipment),
                  'subMuscles': _stringListConverter.encode(item.subMuscles),
                  'steps': _stringListConverter.encode(item.steps),
                  'videoUrl': _stringMapConverter.encode(item.videoUrl),
                  'gifUrl': _stringMapConverter.encode(item.gifUrl),
                  'muscleGroupId': item.muscleGroup
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutPreset> _workoutPresetInsertionAdapter;

  @override
  Stream<List<WorkoutPreset>> searchWorkoutPresets(String query) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM WorkoutPresets WHERE name LIKE ?1',
        mapper: (Map<String, Object?> row) => WorkoutPreset(
            id: row['id'] as int?,
            name: row['name'] as String?,
            equipment: _stringListConverter.decode(row['equipment'] as String?),
            subMuscles:
                _stringListConverter.decode(row['subMuscles'] as String?),
            steps: _stringListConverter.decode(row['steps'] as String?),
            videoUrl: _stringMapConverter.decode(row['videoUrl'] as String?),
            gifUrl: _stringMapConverter.decode(row['gifUrl'] as String?),
            muscleGroup: row['muscleGroupId'] as int?),
        arguments: [query],
        queryableName: 'WorkoutPresets',
        isView: false);
  }

  @override
  Future<void> deleteByMuscleGroupId(int muscleGroupId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM WorkoutPresets WHERE muscleGroupId = ?1',
        arguments: [muscleGroupId]);
  }

  @override
  Future<int?> countByMuscleGroupId(int muscleGroupId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM WorkoutPresets WHERE muscleGroupId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [muscleGroupId]);
  }

  @override
  Future<void> insertWorkoutPresets(List<WorkoutPreset> presets) async {
    await _workoutPresetInsertionAdapter.insertList(
        presets, OnConflictStrategy.replace);
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
                  'dayId': item.day,
                  'icon': item.icon
                }),
        _muscleGroupUpdateAdapter = UpdateAdapter(
            database,
            'MuscleGroups',
            ['id'],
            (MuscleGroup item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'dayId': item.day,
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
            row['dayId'] as int?,
            row['icon'] as String?));
  }

  @override
  Future<MuscleGroup?> getMuscleGroupById(int id) async {
    return _queryAdapter.query('SELECT * FROM MuscleGroups WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MuscleGroup(
            row['id'] as int?,
            row['name'] as String?,
            row['dayId'] as int?,
            row['icon'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<MuscleGroup>> getMuscleGroupsByName(String name) async {
    return _queryAdapter.queryList('SELECT * FROM MuscleGroups WHERE name = ?1',
        mapper: (Map<String, Object?> row) => MuscleGroup(
            row['id'] as int?,
            row['name'] as String?,
            row['dayId'] as int?,
            row['icon'] as String?),
        arguments: [name]);
  }

  @override
  Future<List<MuscleGroup>> getMuscleGroupsByDay(int day) async {
    return _queryAdapter.queryList('SELECT * FROM MuscleGroups WHERE day = ?1',
        mapper: (Map<String, Object?> row) => MuscleGroup(
            row['id'] as int?,
            row['name'] as String?,
            row['dayId'] as int?,
            row['icon'] as String?),
        arguments: [day]);
  }

  @override
  Future<void> updateMuscleGroupDay(
    int id,
    int day,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE MuscleGroups SET day = ?2 WHERE id = ?1',
        arguments: [id, day]);
  }

  @override
  Future<void> clearMuscleGroupDay(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE MuscleGroups SET day = NULL WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int> createMuscleGroup(MuscleGroup muscleGroup) {
    return _muscleGroupInsertionAdapter.insertAndReturnId(
        muscleGroup, OnConflictStrategy.abort);
  }

  @override
  Future<void> editMuscleGroup(MuscleGroup muscleGroup) async {
    await _muscleGroupUpdateAdapter.update(
        muscleGroup, OnConflictStrategy.abort);
  }
}

class _$DayDao extends DayDao {
  _$DayDao(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<Day?> getDayById(int id) async {
    return _queryAdapter.query('SELECT * FROM Days WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Day(id: row['id'] as int?, name: row['name'] as String?),
        arguments: [id]);
  }
}

// ignore_for_file: unused_element
final _stringListConverter = StringListConverter();
final _stringMapConverter = StringMapConverter();
final _dateTimeConverter = DateTimeConverter();
