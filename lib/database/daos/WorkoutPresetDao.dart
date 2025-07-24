import 'package:floor/floor.dart';
import 'package:summerbody/database/tables/WorkoutPreset.dart';

@dao
abstract class WorkoutPresetDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWorkoutPresets(List<WorkoutPreset> presets);

  @Query('SELECT * FROM WorkoutPresets WHERE name LIKE :query')
  Stream<List<WorkoutPreset>> searchWorkoutPresets(String query);

  @Query('DELETE FROM WorkoutPresets WHERE muscleGroupName = :muscleGroupName')
  Future<void> deleteByMuscleGroupName(String muscleGroupName);

  @Query(
      'SELECT COUNT(*) FROM WorkoutPresets WHERE muscleGroupName = :muscleGroupName')
  Future<int?> countByMuscleGroupName(String muscleGroupName);
}
