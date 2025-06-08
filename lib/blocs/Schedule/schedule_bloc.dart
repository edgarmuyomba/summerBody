import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:summerbody/database/tables/Set.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
import 'package:summerbody/database/tables/Workout.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';
import 'package:logger/logger.dart';
import 'package:summerbody/utils/utilities.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final LocalDatabaseService _localDatabaseService;

  ScheduleBloc({LocalDatabaseService? localDatabaseService})
      : _localDatabaseService =
            localDatabaseService ?? DIService().locator<LocalDatabaseService>(),
        super(ScheduleInitial()) {
    on<Initialize>(_onInitialize);
    on<SetDay>(_onSetDay);
    on<AddMuscleGroup>(_onAddMuscleGroup);
    on<LoadWorkout>(_onLoadWorkout);
    on<AddWorkout>(_onAddWorkout);
    on<DeleteWorkout>(_onDeleteWorkout);
    on<EditWorkout>(_onEditWorkout);
    on<CreateSet>(_onCreateSet);
    on<DeleteSet>(_onDeleteSet);
  }

  String? selectDay;

  Future<Map<String, dynamic>> _getMuscleGroupAndWorkouts(String day) async {
    MuscleGroup? muscleGroup =
        await _localDatabaseService.getMuscleGroupByKey("day", day);

    if (muscleGroup == null) {
      return {
        "muscleGroup": null,
        "workouts": [].cast<Workout>(),
        "sets": {}.cast<int, List<Set>>()
      };
    } else {
      List<Workout> workouts =
          await _localDatabaseService.getWorkoutsByMuscleGroup(muscleGroup.id!);

      Map<int, List<Set>> sets = {};

      for (var workout in workouts) {
        List<Set> workoutSets =
            await _localDatabaseService.getAllSets(workout.id!);
        workoutSets.sort((a, b) => b.date!.compareTo(a.date!));
        sets[workout.id!] = workoutSets;
      }

      return {"muscleGroup": muscleGroup, "workouts": workouts, "sets": sets};
    }
  }

  Future<void> _onInitialize(Initialize event, Emitter emit) async {
    DateTime now = DateTime.now();
    String currentDay = now.weekday == DateTime.monday
        ? 'monday'
        : now.weekday == DateTime.tuesday
            ? 'tuesday'
            : now.weekday == DateTime.wednesday
                ? 'wednesday'
                : now.weekday == DateTime.thursday
                    ? 'thursday'
                    : now.weekday == DateTime.friday
                        ? 'friday'
                        : now.weekday == DateTime.saturday
                            ? 'saturday'
                            : 'sunday';
    Map<String, dynamic> muscleGroupAndWorkouts =
        await _getMuscleGroupAndWorkouts(currentDay);

    selectDay = currentDay;

    emit(ScheduleReady(
        currentDay: currentDay,
        musclegroup: muscleGroupAndWorkouts["muscleGroup"],
        workouts: muscleGroupAndWorkouts["workouts"],
        sets: muscleGroupAndWorkouts["sets"]));
  }

  Future<void> _onSetDay(SetDay event, Emitter emit) async {
    Map<String, dynamic> muscleGroupAndWorkouts =
        await _getMuscleGroupAndWorkouts(event.day);

    selectDay = event.day;

    emit(ScheduleReady(
        currentDay: event.day,
        musclegroup: muscleGroupAndWorkouts["muscleGroup"],
        workouts: muscleGroupAndWorkouts["workouts"],
        sets: muscleGroupAndWorkouts["sets"]));
  }

  Future<void> _onAddMuscleGroup(AddMuscleGroup event, Emitter emit) async {
    final state = this.state;
    if (state is ScheduleReady) {
      try {
        MuscleGroup? muscleGroup = await _localDatabaseService
            .getMuscleGroupByKey("name", event.muscleGroupName);

        if (muscleGroup != null) {
          await _localDatabaseService.addDayToMuscleGroup(
              muscleGroup.id!, event.day);

          Map<String, dynamic> muscleGroupAndWorkouts =
              await _getMuscleGroupAndWorkouts(event.day);
          emit(ScheduleReady(
              currentDay: event.day,
              musclegroup: muscleGroupAndWorkouts["muscleGroup"],
              workouts: muscleGroupAndWorkouts["workouts"],
              sets: muscleGroupAndWorkouts["sets"]));
        } else {
          throw Exception(
              "MuscleGroup with name ${event.muscleGroupName} not found!");
        }
      } catch (e) {
        Logger().e(e);
        emit(state);
      }
    }
  }

  Future<void> _onLoadWorkout(LoadWorkout event, Emitter emit) async {
    final state = this.state;

    if (state is ScheduleReady) {
      Workout workout =
          state.workouts.firstWhere((w) => w.id == event.workoutId);
      List<Set> sets = state.sets[workout.id] ?? [];

      emit(WorkoutReady(workout: workout, sets: sets));
    }
  }

  Future<void> _onAddWorkout(AddWorkout event, Emitter emit) async {
    final state = this.state;

    if (state is ScheduleReady) {
      try {
        int workoutId = await _localDatabaseService.createWorkout(
            state.musclegroup!.id!, event.workoutName);
        await _localDatabaseService.createSet(
            workoutId, event.weight1, event.reps1, event.weight2, event.reps2);

        Map<String, dynamic> muscleGroupAndWorkouts =
            await _getMuscleGroupAndWorkouts(state.currentDay);
        emit(ScheduleReady(
            currentDay: state.currentDay,
            musclegroup: muscleGroupAndWorkouts["muscleGroup"],
            workouts: muscleGroupAndWorkouts["workouts"],
            sets: muscleGroupAndWorkouts["sets"]));
      } catch (e) {
        Logger().e(e);
        emit(state);
      }
    }
  }

  Future<void> _onDeleteWorkout(DeleteWorkout event, Emitter emit) async {
    final state = this.state;

    if (state is ScheduleReady) {
      try {
        await _localDatabaseService.deleteWorkout(event.workoutId);

        Map<String, dynamic> muscleGroupAndWorkouts =
            await _getMuscleGroupAndWorkouts(state.currentDay);
        emit(ScheduleReady(
            currentDay: state.currentDay,
            musclegroup: muscleGroupAndWorkouts["muscleGroup"],
            workouts: muscleGroupAndWorkouts["workouts"],
            sets: muscleGroupAndWorkouts["sets"]));
      } catch (e) {
        Logger().e(e);
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

        List<Set> sets = (await _localDatabaseService
            .getAllSets(event.workoutId))
          ..sort((a, b) => b.date!.compareTo(a.date!));

        Utilities.showSnackBar(
            "Successfully updated the workout", event.context, Colors.green);

        emit(WorkoutReady(workout: workout!, sets: sets));
      } catch (e) {
        Logger().e(e);
        Utilities.showSnackBar(
            "Failed to update the workout", event.context, Colors.red);

        emit(state);
      }
    }
  }

  Future<void> _onCreateSet(CreateSet event, Emitter emit) async {
    final state = this.state;

    if (state is WorkoutReady) {
      try {
        await _localDatabaseService.createSet(event.workoutId, event.weight1,
            event.reps1, event.weight2, event.reps2);

        List<Set> sets =
            ((await _localDatabaseService.getAllSets(event.workoutId))
              ..sort((a, b) => b.date!.compareTo(a.date!)));

        Utilities.showSnackBar(
            "Successfully created the set", event.context, Colors.green);

        emit(WorkoutReady(workout: state.workout, sets: sets));
      } catch (e) {
        Logger().e(e);
        Utilities.showSnackBar(
            "Failed to create set", event.context, Colors.red);
        emit(state);
      }
    }
  }

  Future<void> _onDeleteSet(DeleteSet event, Emitter emit) async {
    final state = this.state;

    if (state is WorkoutReady) {
      try {
        await _localDatabaseService.deleteSet(event.workoutId, event.setId);

        List<Set> sets = (await _localDatabaseService
            .getAllSets(event.workoutId))
          ..sort((a, b) => b.date!.compareTo(a.date!));

        Utilities.showSnackBar(
            "Successfully deleted the set", event.context, Colors.green);

        emit(WorkoutReady(workout: state.workout, sets: sets));
      } catch (e) {
        Logger().e(e);
        Utilities.showSnackBar(
            "Failed to delete set", event.context, Colors.red);
        emit(state);
      }
    }
  }
}
