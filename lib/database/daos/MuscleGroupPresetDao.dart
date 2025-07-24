import 'package:floor/floor.dart';
import 'package:summerbody/database/tables/MuscleGroupPreset.dart';

@dao
abstract class MuscleGroupPresetDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWorkoutPresets(List<MuscleGroupPreset> presets);

  @Query('SELECT * FROM MuscleGroupPresets')
  Future<List<MuscleGroupPreset>> getAllMuscleGroups();
}
