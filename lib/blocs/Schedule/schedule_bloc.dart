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
  }

  Future<Map<String, dynamic>> _getMuscleGroupAndWorkouts(String day) async {
    MuscleGroup? muscleGroup =
        await _localDatabaseService.getMuscleGroupByDay(day);

    if (muscleGroup == null) {
      return {"muscleGroup": null, "workouts": [].cast<Workout>()};
    } else {
      List<Workout> workouts =
          await _localDatabaseService.getWorkoutsByMuscleGroup(muscleGroup.id);

      return {"muscleGroup": muscleGroup.name, "workouts": workouts};
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
        musclegroup: muscleGroupAndWorkouts["muscleGroup"],
        workouts: muscleGroupAndWorkouts["workouts"]));
  }

  Future<void> _onSetDay(SetDay event, Emitter emit) async {
    Map<String, dynamic> muscleGroupAndWorkouts =
        await _getMuscleGroupAndWorkouts(event.day);
    emit(ScheduleReady(
        musclegroup: muscleGroupAndWorkouts["muscleGroup"],
        workouts: muscleGroupAndWorkouts["workouts"]));
  }
}
