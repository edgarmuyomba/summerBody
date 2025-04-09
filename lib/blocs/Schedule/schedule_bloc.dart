import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:summerbody/database/database.dart';
import 'package:summerbody/services/DIService.dart';
import 'package:summerbody/services/LocalDatabaseService.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final LocalDatabaseService _localDatabaseService;

  ScheduleBloc({LocalDatabaseService? localDatabaseService})
      : _localDatabaseService =
            localDatabaseService ?? DIService().locator<LocalDatabaseService>(),
        super(ScheduleInitial()) {
    on<Initialize>(_onInitialize);
  }

  Future<void> _onInitialize(Initialize event, Emitter emit) async {
    // get the day today
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

    MuscleGroup? muscleGroup =
        await _localDatabaseService.getMuscleGroupByDay(currentDay);

    if (muscleGroup == null) {
      emit(ScheduleReady(workouts: const []));
    } else {
      List<Workout> workouts =
          await _localDatabaseService.getWorkoutsByMuscleGroup(muscleGroup.id);
      emit(ScheduleReady(workouts: workouts));
    }
  }
}
