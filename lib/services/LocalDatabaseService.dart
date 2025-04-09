import 'package:summerbody/database/database.dart';
import 'package:summerbody/services/DIService.dart';

class LocalDatabaseService {
  final AppDatabase _appDatabase;

  LocalDatabaseService({AppDatabase? appDatabase})
      : _appDatabase = appDatabase ?? DIService().locator.get<AppDatabase>();

  Future<List<MuscleGroup>> getAllMuscleGroups() async {
    return await _appDatabase.managers.muscleGroups.get();
  }

  Future<MuscleGroup?> getMuscleGroupByDay(String day) async {
    return await _appDatabase.managers.muscleGroups
        .filter((mg) => mg.day.equals(day))
        .getSingleOrNull();
  }

  Future<List<Workout>> getWorkoutsByMuscleGroup(int id) async {
    return await _appDatabase.managers.workouts
        .filter((w) => w.muscleGroup.id(id))
        .get();
  }

  Future<void> seedMuscleGroups() async {
    try {
      await _appDatabase.managers.muscleGroups.bulkCreate((o) => [
            const MuscleGroup(id: 1, name: "Chest", day: ""),
            const MuscleGroup(id: 2, name: "Arms", day: ""),
            const MuscleGroup(id: 3, name: "Shoulders", day: ""),
            const MuscleGroup(id: 4, name: "Back", day: ""),
            const MuscleGroup(id: 5, name: "Legs", day: "")
          ]);
    } catch (e) {
      rethrow;
    }
  }
}
