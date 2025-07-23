import "package:floor/floor.dart";
import "package:summerbody/database/tables/MuscleGroup.dart";

@dao
abstract class MuscleGroupDao {
  @Query('SELECT * FROM MuscleGroups WHERE id = :id')
  Future<MuscleGroup?> getMuscleGroupById(int id);

  @Query('SELECT * FROM MuscleGroups WHERE name = :name')
  Future<List<MuscleGroup>> getMuscleGroupsByName(String name);

  @Query('SELECT * FROM MuscleGroups WHERE dayId = :dayId')
  Future<List<MuscleGroup>> getMuscleGroupsByDay(int dayId);

  @update
  Future<void> editMuscleGroup(MuscleGroup muscleGroup);

  @Query('UPDATE MuscleGroups SET dayId = :dayId WHERE id = :id')
  Future<void> updateMuscleGroupDay(int id, int dayId);

  @Query('UPDATE MuscleGroups SET day = NULL WHERE id = :id')
  Future<void> clearMuscleGroupDay(int id);

  @insert
  Future<int> createMuscleGroup(MuscleGroup muscleGroup);
}
