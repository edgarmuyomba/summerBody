import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:summerbody/database/tables/Workout.dart';
import 'package:summerbody/database/tables/Set.dart';
import 'package:summerbody/database/tables/WorkoutPreset.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';
import 'package:summerbody/utils/utilities.dart';

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
    on<LoadWorkout>(_onLoadWorkout);
    on<EditWorkout>(_onEditWorkout);
    on<DeleteWorkout>(_onDeleteWorkout);
    on<CreateSet>(_onCreateSet);
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

  Future<void> _onLoadWorkout(LoadWorkout event, Emitter emit) async {
    Workout? workout =
        await _localDatabaseService.getWorkoutByKey("id", event.workoutId);

    List<Set> sets = await _localDatabaseService.getAllSets(event.workoutId);

    emit(WorkoutReady(workout: workout!, sets: sets));
  }

  Future<void> _onCreateSet(CreateSet event, Emitter emit) async {
    final state = this.state;

    if (state is WorkoutReady) {
      try {
        await _localDatabaseService.createSet(event.workoutId, event.date,
            event.weight1, event.reps1, event.weight2, event.reps2);

        List<Set> sets =
            await _localDatabaseService.getAllSets(event.workoutId);

        if (event.context.mounted) {
          Utilities.showSnackBar(
              "Successfully created the set", event.context, Colors.green);
        }

        emit(WorkoutReady(workout: state.workout, sets: sets));
      } catch (e) {
        Logger().e(e);
        if (event.context.mounted) {
          Utilities.showSnackBar(
              "Failed to create set", event.context, Colors.red);
        }
        emit(state);
      }
    }
  }

  Future<void> _onEditWorkout(EditWorkout event, Emitter emit) async {
    final state = this.state;

    if (state is WorkoutReady) {
      try {
        await _localDatabaseService.editWorkout(
            event.workoutId, event.workoutName);
        await _localDatabaseService.editSet(event.setId, event.date,
            event.weight1, event.reps1, event.weight2, event.reps2);

        Workout? workout =
            await _localDatabaseService.getWorkoutByKey("id", event.workoutId);

        List<Set> sets =
            await _localDatabaseService.getAllSets(event.workoutId);

        if (event.context.mounted) {
          Utilities.showSnackBar(
              "Successfully updated the workout", event.context, Colors.green);
        }

        emit(WorkoutReady(workout: workout!, sets: sets));
      } catch (e) {
        Logger().e(e);

        if (event.context.mounted) {
          Utilities.showSnackBar(
              "Failed to update the workout", event.context, Colors.red);
        }

        emit(state);
      }
    }
  }

  Future<void> _onDeleteWorkout(DeleteWorkout event, Emitter emit) async {
    final state = this.state;

    if (state is MuscleGroupReady) {
      try {
        List<Workout> updatedWorkouts = [];

        try {
          await _localDatabaseService.deleteWorkout(event.workoutId);
          updatedWorkouts = state.workouts
              .where((workout) => workout.id != event.workoutId)
              .toList();
        } catch (error) {
          Logger().e("Failed to delete workout:: $error");
          updatedWorkouts = state.workouts;
        }

        emit(MuscleGroupReady(
          workouts: updatedWorkouts,
        ));
      } catch (e) {
        Logger().e(e);
        emit(state);
      }
    }
  }
}
