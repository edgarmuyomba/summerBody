import 'package:drift/drift.dart';
import 'package:summerbody/database/database.dart';
import 'package:summerbody/services/DIService.dart';

class LocalDatabaseService {
  final AppDatabase _appDatabase;

  LocalDatabaseService({AppDatabase? appDatabase})
      : _appDatabase = appDatabase ?? DIService().locator.get<AppDatabase>();

  Future<List<MuscleGroup>> getAllMuscleGroups() async {
    return await _appDatabase.managers.muscleGroups.get();
  }

  Future<MuscleGroup?> getMuscleGroupByKey(String key, dynamic value) async {
    return await _appDatabase.managers.muscleGroups.filter((mg) {
      switch (key) {
        case "day":
          return mg.day.equals(value);
        case "name":
          return mg.name.equals(value);
        default:
          return mg.id.equals(value);
      }
    }).getSingleOrNull();
  }

  Future<List<Workout>> getWorkoutsByMuscleGroup(int id) async {
    return await _appDatabase.managers.workouts
        .filter((w) => w.muscleGroup.id(id))
        .get();
  }

  Future<void> addDayToMuscleGroup(int id, String day) async {
    await _appDatabase.managers.muscleGroups
        .filter((mg) => mg.id.equals(id))
        .update((mg) => mg(day: Value(day)));
  }

  Future<int> createWorkout(int muscleGroupId, String workoutName) async {
    return await _appDatabase.managers.workouts
        .create((o) => o(muscleGroup: muscleGroupId, name: workoutName));
  }

  Future<int> createEntry(int workoutId, int weight, int sets, int reps) async {
    return await _appDatabase.managers.entries.create(
        (o) => o(workout: workoutId, weight: weight, sets: sets, reps: reps));
  }

  Future<List<Entry>> getAllEntries(int workoutId) async {
    return await _appDatabase.managers.entries
        .filter((e) => e.workout.id.equals(workoutId))
        .get();
  }

  Future<void> seedMuscleGroups() async {
    try {
      await _appDatabase.managers.muscleGroups.bulkCreate((o) => [
            const MuscleGroup(
                id: 1, name: "Chest", day: "", icon: "assets/icons/chest.png"),
            const MuscleGroup(
                id: 2, name: "Arms", day: "", icon: "assets/icons/arms.png"),
            const MuscleGroup(
                id: 3,
                name: "Shoulders",
                day: "",
                icon: "assets/icons/shoulders.png"),
            const MuscleGroup(
                id: 4, name: "Back", day: "", icon: "assets/icons/back.png"),
            const MuscleGroup(
                id: 5, name: "Legs", day: "", icon: "assets/icons/legs.png")
          ]);
    } catch (e) {
      rethrow;
    }
  }
}
