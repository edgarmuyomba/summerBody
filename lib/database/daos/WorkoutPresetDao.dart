import 'package:floor/floor.dart';
import 'package:summerbody/database/tables/WorkoutPreset.dart';

@dao
abstract class WorkoutPresetDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWorkoutPresets(List<WorkoutPreset> presets);

  @Query('SELECT * FROM WorkoutPresets WHERE name LIKE :query')
  Stream<List<WorkoutPreset>> searchWorkoutPresets(String query);

  @Query('DELETE FROM WorkoutPresets WHERE muscleGroupId = :muscleGroupId')
  Future<void> deleteByMuscleGroupId(int muscleGroupId);

  @Query('SELECT COUNT(*) FROM WorkoutPresets WHERE muscleGroupId = :muscleGroupId')
  Future<int?> countByMuscleGroupId(int muscleGroupId);
}
