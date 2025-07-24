import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/web.dart';
import 'package:summerbody/database/tables/Workout.dart';
import 'package:summerbody/database/tables/WorkoutPreset.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';

part 'muscleGroup_event.dart';
part 'muscleGroup_state.dart';

class MuscleGroupBloc extends Bloc<MuscleGroupEvent, MuscleGroupState> {
  final LocalDatabaseService _localDatabaseService;

  MuscleGroupBloc({LocalDatabaseService? localDatabaseService})
      : _localDatabaseService = localDatabaseService ??
            DIService().locator.get<LocalDatabaseService>(),
        super(MuscleGroupInitial()) {
    on<LoadWorkouts>(_onLoadWorkouts);
    on<AddWorkout>(_onAddWorkout);
  }

  Future<void> _onLoadWorkouts(LoadWorkouts event, Emitter emit) async {
    List<Workout> workouts = await _localDatabaseService
        .getWorkoutsByMuscleGroup(event.muscleGroupId);

    emit(MuscleGroupReady(workouts: workouts));
  }

  Future<void> _onAddWorkout(AddWorkout event, Emitter emit) async {
    final state = this.state;

    if (state is MuscleGroupReady) {
      try {
        int workoutId = await _localDatabaseService.createWorkout(
            event.muscleGroupId, event.workoutName, event.workoutPreset);

        await _localDatabaseService.createSet(workoutId, event.date,
            event.weight1, event.reps1, event.weight2, event.reps2);

        List<Workout> updatedWorkouts = await _localDatabaseService
            .getWorkoutsByMuscleGroup(event.muscleGroupId);

        Logger().i(updatedWorkouts);

        emit(MuscleGroupReady(workouts: updatedWorkouts));
      } catch (e) {
        Logger().e(e);
        emit(state);
      }
    }
  }
}
