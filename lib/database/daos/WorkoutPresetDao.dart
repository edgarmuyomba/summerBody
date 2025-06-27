import 'package:floor/floor.dart';
import 'package:summerbody/database/tables/WorkoutPreset.dart';

@dao
abstract class WorkoutPresetDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWorkoutPresets(List<WorkoutPreset> presets);

  @Query('SELECT * FROM WorkoutPresets WHERE name LIKE :query')
  Stream<List<WorkoutPreset>> searchWorkoutPresets(String query);
}
