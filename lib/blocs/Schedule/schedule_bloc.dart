import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:summerbody/database/database.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';
import 'package:logger/logger.dart';

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
  }

  Future<Map<String, dynamic>> _getMuscleGroupAndWorkouts(String day) async {
    MuscleGroup? muscleGroup =
        await _localDatabaseService.getMuscleGroupByDay(day);

    if (muscleGroup == null) {
      return {"muscleGroup": null, "workouts": [].cast<Workout>()};
    } else {
      List<Workout> workouts =
          await _localDatabaseService.getWorkoutsByMuscleGroup(muscleGroup.id);

      return {"muscleGroup": muscleGroup, "workouts": workouts};
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

    emit(ScheduleReady(
        currentDay: currentDay,
        musclegroup: muscleGroupAndWorkouts["muscleGroup"],
        workouts: muscleGroupAndWorkouts["workouts"]));
  }

  Future<void> _onSetDay(SetDay event, Emitter emit) async {
    Map<String, dynamic> muscleGroupAndWorkouts =
        await _getMuscleGroupAndWorkouts(event.day);
    emit(ScheduleReady(
        currentDay: event.day,
        musclegroup: muscleGroupAndWorkouts["muscleGroup"],
        workouts: muscleGroupAndWorkouts["workouts"]));
  }

  Future<void> _onAddMuscleGroup(AddMuscleGroup event, Emitter emit) async {
    final state = this.state;
    if (state is ScheduleReady) {
      try {
        await _localDatabaseService.addDayToMuscleGroup(
            state.musclegroup!.id, event.day);

        Map<String, dynamic> muscleGroupAndWorkouts =
            await _getMuscleGroupAndWorkouts(event.day);
        emit(ScheduleReady(
            currentDay: event.day,
            musclegroup: muscleGroupAndWorkouts["muscleGroup"],
            workouts: muscleGroupAndWorkouts["workouts"]));
      } catch (e) {
        Logger().e(e);
        emit(state);
      }
    }
  }
}
