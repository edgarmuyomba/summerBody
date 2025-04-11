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
