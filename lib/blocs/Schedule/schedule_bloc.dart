import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:summerbody/database/tables/MuscleGroupPreset.dart';
import 'package:summerbody/database/tables/Set.dart';
import 'package:summerbody/database/tables/MuscleGroup.dart';
import 'package:summerbody/database/tables/Workout.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/FirebaseService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';
import 'package:logger/logger.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final LocalDatabaseService _localDatabaseService;
  final FirebaseService _firebaseService;

  ScheduleBloc(
      {LocalDatabaseService? localDatabaseService,
      FirebaseService? firebaseService})
      : _localDatabaseService =
            localDatabaseService ?? DIService().locator<LocalDatabaseService>(),
        _firebaseService =
            firebaseService ?? DIService().locator<FirebaseService>(),
        super(ScheduleInitial()) {
    on<Initialize>(_onInitialize);
    on<ChangeDay>(_onChangeDay);
    on<AddMuscleGroup>(_onAddMuscleGroup);
  }

  int? selectDay;

  Future<void> _onInitialize(Initialize event, Emitter emit) async {
    DateTime now = DateTime.now();
    selectDay = now.weekday;

    List<MuscleGroup> muscleGroups =
        await _localDatabaseService.getMuscleGroupsByDay(selectDay!);

    emit(ScheduleReady(currentDay: selectDay!, muscleGroups: muscleGroups));
  }

  Future<void> _onChangeDay(ChangeDay event, Emitter emit) async {
    selectDay = event.next ? selectDay! + 1 : selectDay! - 1;

    if (selectDay! < 1) {
      selectDay = 7;
    } else if (selectDay! > 7) {
      selectDay = 1;
    }

    List<MuscleGroup> muscleGroups =
        await _localDatabaseService.getMuscleGroupsByDay(selectDay!);

    emit(ScheduleReady(currentDay: selectDay!, muscleGroups: muscleGroups));
  }

  Future<void> _onAddMuscleGroup(AddMuscleGroup event, Emitter emit) async {
    final state = this.state;
    if (state is ScheduleReady) {
      try {
        Map<String, dynamic> presetMap = event.muscleGroupPreset.toMap();
        MuscleGroup muscleGroup = MuscleGroup.fromMap(presetMap);

        int muscleGroupId =
            await _localDatabaseService.createMuscleGroup(muscleGroup);

        await _localDatabaseService.updateMuscleGroupDay(
            muscleGroupId, selectDay!);

        MuscleGroup? newMuscleGroup = await _localDatabaseService
            .getMuscleGroupByKey("id", muscleGroupId);

        List<MuscleGroup> initialMuscleGroups = state.muscleGroups;

        if (newMuscleGroup != null) {
          emit(ScheduleReady(
              currentDay: state.currentDay,
              muscleGroups: [...initialMuscleGroups, newMuscleGroup]));

          await _localDatabaseService
              .deleteWorkoutPresets(newMuscleGroup.name!);

          StreamSubscription<List<Map<String, dynamic>>>? subscription;

          subscription = _firebaseService
              .workoutStream(newMuscleGroup.name!)
              .listen((value) {
            _localDatabaseService.createWorkoutPresets(
                value, newMuscleGroup.name);
            Logger().d("Processed ${value.length} items");
          }, onDone: () {
            Logger().i("Stream Completed");
            subscription?.cancel();
          });
        } else {
          emit(ScheduleReady(
              currentDay: state.currentDay, muscleGroups: initialMuscleGroups));
          Logger().e("Failed to create muscleGroup");
        }
      } catch (e) {
        Logger().e(e);
        emit(state);
      }
    }
  }
}
