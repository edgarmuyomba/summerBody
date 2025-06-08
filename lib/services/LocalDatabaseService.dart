import 'package:summerbody/database/database.dart';
import 'package:summerbody/database/tables/Set.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
import 'package:summerbody/database/tables/Workout.dart';
import 'package:summerbody/database/typeConverters/datetimeConverter.dart';
import 'package:summerbody/services/DIService.dart';

class LocalDatabaseService {
  final AppDatabase _appDatabase;

  LocalDatabaseService({AppDatabase? appDatabase})
      : _appDatabase = appDatabase ?? DIService().locator.get<AppDatabase>();

  Future<List<MuscleGroup>> getAllMuscleGroups() async {
    return await _appDatabase.muscleGroupDao.getAllMuscleGroups();
  }

  Future<MuscleGroup?> getMuscleGroupByKey(String key, dynamic value) async {
    switch (key) {
      case "day":
        return (await _appDatabase.muscleGroupDao
                .getMuscleGroupsByDay(value as String))
            .firstOrNull;
      case "name":
        return (await _appDatabase.muscleGroupDao
                .getMuscleGroupsByName(value as String))
            .firstOrNull;
      default:
        return await _appDatabase.muscleGroupDao
            .getMuscleGroupById(value as int);
    }
  }

  Future<List<Workout>> getWorkoutsByMuscleGroup(int muscleGroupId) async {
    return await _appDatabase.workoutDao
        .getWorkoutsByMuscleGroup(muscleGroupId);
  }

  Future<void> addDayToMuscleGroup(int id, String day) async {
    await _appDatabase.muscleGroupDao.updateMuscleGroupDay(id, day);
  }

  Future<int> createWorkout(int muscleGroupId, String workoutName) async {
    return await _appDatabase.workoutDao
        .createWorkout(Workout(null, workoutName, muscleGroupId));
  }

  Future<Workout?> getWorkoutByKey(String key, dynamic value) async {
    switch (key) {
      case "name":
        return (await _appDatabase.workoutDao
                .getWorkoutsByName(value as String))
            .firstOrNull;
      default:
        return await _appDatabase.workoutDao.getWorkoutById(value as int);
    }
  }

  Future<int> createSet(int workoutId, int date, double weight1, int reps1,
      double? weight2, int? reps2) async {
    return await _appDatabase.setDao
        .createSet(Set(null, workoutId, weight1, reps1, weight2, reps2, date));
  }

  Future<void> editSet(int setId, int date, double weight1, int reps1,
      double? weight2, int? reps2) async {
    final originalSet = await _appDatabase.setDao.getSetById(setId);
    if (originalSet != null) {
      final updatedSet = originalSet.copyWith(
        date: date,
        weight1: weight1,
        reps1: reps1,
        weight2: weight2,
        reps2: reps2,
      );
      await _appDatabase.setDao.editSet(updatedSet);
    }
  }

  Future<List<Set>> getAllSets(int workoutId) async {
    return await _appDatabase.setDao.getSetsByWorkoutId(workoutId);
  }

  Future<void> deleteWorkout(int workoutId) async {
    await _appDatabase.workoutDao.deleteWorkoutById(workoutId);
  }

  Future<void> editWorkout(int workoutId, String name) async {
    final originalWorkout =
        await _appDatabase.workoutDao.getWorkoutById(workoutId);
    if (originalWorkout != null) {
      final updatedWorkout = originalWorkout.copyWith(name: name);
      await _appDatabase.workoutDao.editWorkout(updatedWorkout);
    }
  }

  Future<void> deleteSet(int workoutId, int setId) async {
    await _appDatabase.setDao.deleteSetById(workoutId, setId);
  }
}
