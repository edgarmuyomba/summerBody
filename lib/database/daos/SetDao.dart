import 'package:floor/floor.dart';
import 'package:summerbody/database/tables/Set.dart';

@dao
abstract class SetDao {
  @insert
  Future<int> createSet(Set set);

  @update
  Future<void> editSet(Set set);

  @Query('SELECT * FROM Sets')
  Future<List<Set>> getAllSets();

  @Query('DELETE FROM Sets WHERE id = :id AND workoutId = :workoutId')
  Future<void> deleteSetById(int workoutId, int id);

  @Query('SELECT * FROM Sets WHERE id = :id')
  Future<Set?> getSetById(int id);

  @Query('SELECT * FROM Sets WHERE workoutId = :workoutId ORDER BY date DESC')
  Future<List<Set>> getSetsByWorkoutId(int workoutId);
}
