import "package:floor/floor.dart";
import "package:summerbody/database/tables/MuscleGroup.dart";

@dao
abstract class MuscleGroupDao {
  @Query('SELECT * FROM MuscleGroups')
  Future<List<MuscleGroup>> getAllMuscleGroups();

  @Query('SELECT * FROM MuscleGroups WHERE id = :id')
  Future<MuscleGroup?> getMuscleGroupById(int id);
  
  @Query('SELECT * FROM MuscleGroups WHERE name = :name')
  Future<List<MuscleGroup>> getMuscleGroupsByName(String name);
  
  @Query('SELECT * FROM MuscleGroups WHERE day = :day')
  Future<List<MuscleGroup>> getMuscleGroupsByDay(String day);

  @update
  Future<void> editMuscleGroup(MuscleGroup muscleGroup);

  @Query('UPDATE MuscleGroups SET day = :day WHERE id = :id')
  Future<void> updateMuscleGroupDay(int id, String day);

  @insert
  Future<int> createMuscleGroup(MuscleGroup muscleGroup);
}
