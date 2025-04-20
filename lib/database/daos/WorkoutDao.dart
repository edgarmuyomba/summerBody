import 'package:floor/floor.dart';
import 'package:summerbody/database/tables/Workout.dart';

@dao
abstract class WorkoutDao {
  @insert
  Future<void> createWorkout(Workout workout);

  @update
  Future<void> editWorkout(Workout workout);

  @delete
  Future<void> deleteWorkout(Workout workout);
  
  @Query('SELECT * FROM Workouts WHERE id = :id')
  Future<Workout?> getWorkoutById(int id);
  
  @Query('SELECT * FROM Workouts WHERE name = :name')
  Future<List<Workout>> getWorkoutsByName(String name);
    
  @Query('SELECT * FROM Workouts WHERE muscleGroup = :muscleGroupId')
  Future<List<Workout>> getWorkoutsByMuscleGroup(int muscleGroupId);
  
  @Query('SELECT * FROM Workouts')
  Future<List<Workout>> getAllWorkouts();
}